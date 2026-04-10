import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';
import 'package:gdgocms/core/network/api_service.dart';
import 'package:gdgocms/features/login/ui/login_screen.dart';

/// profile_screen.dart
/// Layer: Presentation
/// Feature: Main | Profile
/// Description: Quản lý giao diện thông tin cá nhân của người dùng.
/// Cung cấp các thông tin định danh thành viên và chức năng đăng xuất an toàn khỏi hệ thống.

/// [ProfileScreen] hiển thị hồ sơ người dùng và các tùy chọn thiết lập tài khoản.
///
/// Lớp này là một [StatelessWidget] vì dữ liệu hiện tại đang được load tĩnh hoặc
/// lấy từ bộ nhớ cục bộ, không yêu cầu quản lý trạng thái phức tạp tại màn hình này.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  /// [_handleLogout] thực hiện quy trình đăng xuất bảo mật.
  ///
  /// Quy trình thực hiện:
  /// 1. Hiển thị [AlertDialog] để xác nhận ý định của người dùng.
  /// 2. Gọi [AuthService.logout] để hủy session trên Server và xóa Local Data.
  /// 3. Sử dụng [Navigator.pushAndRemoveUntil] để dọn dẹp Stack và quay về [SignInScreen].
  Future<void> _handleLogout(BuildContext context) async {
    // 1. Hiển thị thông báo xác nhận (Dialog)
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận đăng xuất"),
        content: const Text("Bạn có chắc chắn muốn rời khỏi hệ thống GDG CMS?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Đăng xuất", style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // 2. Gọi API Logout từ Core Layer
      final authService = AuthService();
      await authService.logout();

      if (context.mounted) {
        // 3. Quay lại màn hình Login và xóa hết lịch sử các trang trước đó để đảm bảo bảo mật
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tính toán các thông số Responsive dựa trên kích thước màn hình
    final double screenWidth = MediaQuery.of(context).size.width;
    final double safeHeight = MediaQuery.of(context).size.height -
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  children: [
                    SizedBox(height: safeHeight * 0.05),

                    // Avatar đại diện: Placeholder với phong cách GDG
                    CircleAvatar(
                      radius: safeHeight * 0.07,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(Icons.person, size: safeHeight * 0.08, color: AppColors.primary),
                    ),

                    SizedBox(height: safeHeight * 0.03),

                    // Thông tin cơ bản của thành viên
                    Text("GDG Member", style: AppTextStyles.h3.copyWith(color: Colors.black)),
                    Text("@hust_member", style: AppTextStyles.subtitle2),

                    SizedBox(height: safeHeight * 0.06),

                    // Danh sách các mục thông tin (Menu Items)
                    _buildProfileItem(context, Icons.badge, "Chuyên môn", "Mobile Developer", safeHeight),
                    _buildProfileItem(context, Icons.email, "Email", "member@hust.edu.vn", safeHeight),
                    _buildProfileItem(context, Icons.info_outline, "Về ứng dụng", "", safeHeight),

                    SizedBox(height: safeHeight * 0.05),

                    // Nút Đăng xuất với phong cách Outlined Red cảnh báo
                    SizedBox(
                      width: double.infinity,
                      height: safeHeight * 0.07,
                      child: OutlinedButton.icon(
                        onPressed: () => _handleLogout(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.red),
                          shape: const StadiumBorder(),
                        ),
                        icon: const Icon(Icons.logout, color: AppColors.red),
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

            // Chân trang hiển thị thương hiệu GDG
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                height: 20,
                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [_buildProfileItem] khởi tạo một dòng thông tin trong hồ sơ.
  ///
  /// Giải thích "Why": Tách biệt thành hàm riêng để tái sử dụng giao diện (reusability)
  /// và dễ dàng tùy chỉnh style đồng bộ cho toàn bộ danh sách menu.
  Widget _buildProfileItem(BuildContext context, IconData icon, String title, String value, double safeHeight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.grey, size: safeHeight * 0.03),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.subtitle3),
              if (value.isNotEmpty)
                Text(value, style: AppTextStyles.title2.copyWith(color: Colors.black)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}