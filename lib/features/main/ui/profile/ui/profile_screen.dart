import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gdgocms/core/network/api_service.dart';
import 'package:gdgocms/core/router/app_router.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  Map<String, dynamic> _profile = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final Map<String, dynamic>? user = await _userService.fetchCurrentUser();
      if (!mounted) {
        return;
      }
      if (user == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Không thể tải thông tin tài khoản.';
        });
        return;
      }

      setState(() {
        _profile = user;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'Mất kết nối hoặc có lỗi xảy ra. Vui lòng thử lại.';
      });
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận đăng xuất"),
        content: const Text("Bạn có chắc chắn muốn rời khỏi hệ thống GDG CMS?"),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text(
              "Đăng xuất",
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
      if (context.mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  Future<void> _openEditProfileDialog() async {
    final TextEditingController firstNameController = TextEditingController(
      text: (_profile['firstName'] ?? '').toString(),
    );
    final TextEditingController lastNameController = TextEditingController(
      text: (_profile['lastName'] ?? '').toString(),
    );
    final TextEditingController emailController = TextEditingController(
      text: (_profile['email'] ?? '').toString(),
    );
    String? dialogError;
    const OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: AppColors.lightGrey),
    );

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Cập nhật hồ sơ'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: border,
                        enabledBorder: border,
                        focusedBorder: border,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: border,
                        enabledBorder: border,
                        focusedBorder: border,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: border,
                        enabledBorder: border,
                        focusedBorder: border,
                      ),
                    ),
                    if (dialogError != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        dialogError!,
                        style: const TextStyle(color: AppColors.red),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: _isSaving ? null : () => context.pop(false),
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : () {
                          final String email = emailController.text.trim();
                          if (email.isEmpty || !email.contains('@')) {
                            setDialogState(() {
                              dialogError = 'Email không hợp lệ.';
                            });
                            return;
                          }
                          context.pop(true);
                        },
                  child: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Lưu'),
                ),
              ],
            );
          },
        );
      },
    );

    if (shouldSave != true) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final Map<String, dynamic>? updated = await _userService.updateCurrentUser(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    if (updated == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể cập nhật thông tin.'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    setState(() {
      _profile = <String, dynamic>{..._profile, ...updated};
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cập nhật hồ sơ thành công.')));
  }

  String _displayName() {
    final String first = (_profile['firstName'] ?? '').toString().trim();
    final String last = (_profile['lastName'] ?? '').toString().trim();
    final String fullName = '$first $last'.trim();
    if (fullName.isNotEmpty) {
      return fullName;
    }
    final String username = (_profile['username'] ?? '').toString().trim();
    if (username.isNotEmpty) {
      return username;
    }
    return 'GDG Member';
  }

  String _username() {
    final String username = (_profile['username'] ?? '').toString().trim();
    return username.isNotEmpty ? '@$username' : '@member';
  }

  String _email() {
    final String email = (_profile['email'] ?? '').toString().trim();
    return email.isNotEmpty ? email : 'Chưa cập nhật';
  }

  String _role() {
    final String role = (_profile['role'] ?? '').toString().trim();
    return role.isNotEmpty ? role : 'Member';
  }

  String? _avatarUrl() {
    final String value =
        (_profile['avatarUrl'] ??
                _profile['avatar'] ??
                _profile['photoUrl'] ??
                '')
            .toString()
            .trim();
    return value.isEmpty ? null : value;
  }

  String? _coverPhotoUrl() {
    final String value =
        (_profile['coverUrl'] ??
                _profile['coverPhoto'] ??
                _profile['coverPhotoUrl'] ??
                '')
            .toString()
            .trim();
    return value.isEmpty ? null : value;
  }

  void _showImageEditHint(String target) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tính năng đổi $target sẽ được cập nhật sớm.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Thông tin thành viên"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? _buildErrorState()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(screenHeight),
                    _buildInfoSection(),
                    _buildProfileContent(),
                    _buildActionButtons(),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader(double screenHeight) {
    final double coverHeight = screenHeight * 0.25;
    const double avatarRadius = 54;
    final String? coverUrl = _coverPhotoUrl();
    final String? avatarUrl = _avatarUrl();

    return SizedBox(
      height: coverHeight + avatarRadius + 18,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: coverHeight,
            width: double.infinity,
            child: coverUrl != null
                ? Image.network(
                    coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildCoverFallback(),
                  )
                : _buildCoverFallback(),
          ),
          Positioned(
            right: 12,
            bottom: 10,
            child: Material(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _showImageEditHint('ảnh bìa'),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Sửa ảnh bìa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: coverHeight - avatarRadius,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: Colors.white,
                      backgroundImage: avatarUrl != null
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: avatarUrl == null
                          ? Icon(
                              Icons.person,
                              size: avatarRadius,
                              color: AppColors.primary,
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Material(
                      color: AppColors.primary,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => _showImageEditHint('ảnh đại diện'),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF34A853), Color(0xFF1F87FC)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.landscape_rounded, color: Colors.white70, size: 64),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: Column(
        children: [
          Text(
            _displayName(),
            style: AppTextStyles.h3.copyWith(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(_username(), style: AppTextStyles.subtitle2),
          const SizedBox(height: 10),
          _buildRoleBadge(),
        ],
      ),
    );
  }

  Widget _buildRoleBadge() {
    final bool isLeader = _role().toLowerCase() == 'leader';
    final Color backgroundColor = isLeader
        ? const Color(0xFFFFF4CC)
        : const Color(0xFFEAF8EE);
    final Color textColor = isLeader ? AppColors.yellow : AppColors.primary;
    final IconData icon = isLeader
        ? Icons.workspace_premium
        : Icons.verified_user;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(_role(), style: AppTextStyles.title3.copyWith(color: textColor)),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        children: [
          _buildProfileItem(
            icon: Icons.email_outlined,
            title: "Email",
            value: _email(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _openEditProfileDialog,
              icon: const Icon(Icons.edit_outlined, color: Colors.white),
              label: Text(
                "Chỉnh sửa thông tin",
                style: AppTextStyles.title1.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: const StadiumBorder(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: _isSaving ? null : () => _handleLogout(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.red),
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.logout, color: AppColors.red),
              label: Text(
                "Đăng xuất",
                style: AppTextStyles.title1.copyWith(
                  color: AppColors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black12,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F5F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: AppColors.blue, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.subtitle3),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: AppTextStyles.title2.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onTap != null)
                  const Icon(Icons.chevron_right, color: Colors.grey)
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.red, size: 72),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Có lỗi xảy ra khi tải hồ sơ.',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitle1.copyWith(color: Colors.black87),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadProfile,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
