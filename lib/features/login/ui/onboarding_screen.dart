import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/features/login/ui/login_screen.dart';

/// onboarding_screen.dart
/// Layer: Presentation
/// Feature: Login/Onboarding
/// Description: Quản lý màn hình giới thiệu (Onboarding) dành cho người dùng mới.
/// Sử dụng PageView để trình diễn các tính năng cốt lõi của ứng dụng thông qua hình ảnh minh họa SVG.

/// [_OnboardingPage] là Widget thành phần hiển thị một trang minh họa riêng lẻ.
///
/// Thành phần này được thiết kế để tối ưu hóa việc hiển thị các tài nguyên [SvgPicture]
/// với trạng thái chờ (loading) trong khi tải dữ liệu.
class _OnboardingPage extends StatelessWidget {
  /// Đường dẫn đến tệp tin SVG trong Assets.
  final String assetPath;

  const _OnboardingPage({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetPath,
            height: 250,
            fit: BoxFit.contain,
            placeholderBuilder: (context) => const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

/// [OnboardingScreen] là màn hình chính điều phối luồng giới thiệu sản phẩm.
///
/// Màn hình bao gồm một Logo ở đầu, một [PageView] ở giữa kèm Indicator động,
/// và một nút điều hướng ở cuối để chuyển trang hoặc bắt đầu sử dụng ứng dụng.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  /// Bộ điều khiển luồng trượt của [PageView].
  final PageController _pageController = PageController();

  /// Chỉ số trang hiện tại để cập nhật UI Indicator và Label của nút bấm.
  int _currentIndex = 0;

  /// Danh sách các tài nguyên minh họa cho từng trang Onboarding.
  final List<String> _pageAssets = [
    'assets/images/task.svg',
    'assets/images/event.svg',
    'assets/images/profile.svg',
    'assets/images/team.svg',
  ];

  @override
  Widget build(BuildContext context) {
    // Thu thập thông số kích thước màn hình để tính toán Responsive UI.
    double screenWidth = MediaQuery.of(context).size.width;

    // Tính toán chiều cao khả dụng sau khi loại bỏ các vùng Safe Area (Tai thỏ, Home Indicator).
    double screenHeight =
        MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Phần Header: Hiển thị Logo thương hiệu theo tỷ lệ chiều cao màn hình.
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.1),
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                height: screenHeight * 0.05,
                fit: BoxFit.contain,
              ),
            ),

            // Phần Content: Chứa PageView minh họa và Indicator.
            Flexible(
              flex: 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: screenHeight * 0.35,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) =>
                          setState(() => _currentIndex = index),
                      itemCount: _pageAssets.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SvgPicture.asset(
                              _pageAssets[index],
                              width: screenWidth * 0.85,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  /// [INDICATOR] - Hiển thị vị trí trang hiện tại.
                  /// Sử dụng [AnimatedContainer] để tạo hiệu ứng chuyển đổi mượt mà khi đổi trang.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pageAssets.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentIndex == i ? 24 : 8,
                        decoration: BoxDecoration(
                          // Màu sắc thay đổi theo định nghĩa trong Core Layer (AppColors).
                          color: _currentIndex == i
                              ? AppColors.pageColors[i]
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Phần Footer: Nút bấm điều hướng (Continue/Start).
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Xử lý logic chuyển trang hoặc kết thúc Onboarding.
                    if (_currentIndex < _pageAssets.length - 1) {
                      // Chuyển sang trang kế tiếp với hiệu ứng trượt.
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Nếu là trang cuối, điều hướng sang màn hình đăng nhập [SignInScreen].
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInScreen()
                        ),
                      );
                    }
                  },
                  child: Text(
                    _currentIndex == _pageAssets.length - 1
                        ? "Start"
                        : "Continue",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}