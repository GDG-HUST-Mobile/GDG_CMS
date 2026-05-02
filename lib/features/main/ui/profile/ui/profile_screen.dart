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
                    TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email'),
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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double safeHeight =
        MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

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
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: safeHeight * 0.05),
                          CircleAvatar(
                            radius: safeHeight * 0.07,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.person,
                              size: safeHeight * 0.08,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: safeHeight * 0.03),
                          Text(
                            _displayName(),
                            style: AppTextStyles.h3.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          Text(_username(), style: AppTextStyles.subtitle2),
                          SizedBox(height: safeHeight * 0.06),
                          _buildProfileItem(
                            icon: Icons.badge,
                            title: "Chuyên môn",
                            value: _role(),
                            safeHeight: safeHeight,
                          ),
                          _buildProfileItem(
                            icon: Icons.email,
                            title: "Email",
                            value: _email(),
                            safeHeight: safeHeight,
                            onTap: _openEditProfileDialog,
                          ),
                          _buildProfileItem(
                            icon: Icons.edit_note,
                            title: "Cập nhật hồ sơ",
                            value: "Sửa họ tên và email",
                            safeHeight: safeHeight,
                            onTap: _openEditProfileDialog,
                          ),
                          SizedBox(height: safeHeight * 0.05),
                          SizedBox(
                            width: double.infinity,
                            height: safeHeight * 0.07,
                            child: OutlinedButton.icon(
                              onPressed: _isSaving
                                  ? null
                                  : () => _handleLogout(context),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.red),
                                shape: const StadiumBorder(),
                              ),
                              icon: const Icon(
                                Icons.logout,
                                color: AppColors.red,
                              ),
                              label: Text(
                                "Đăng xuất",
                                style: TextStyle(
                                  color: AppColors.red,
                                  fontSize: safeHeight * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
    required double safeHeight,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.grey, size: safeHeight * 0.03),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.subtitle3),
                      Text(
                        value,
                        style: AppTextStyles.title2.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  onTap != null ? Icons.edit : Icons.chevron_right,
                  color: Colors.grey,
                ),
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
