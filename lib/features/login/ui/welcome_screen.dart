import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdgocms/features/login/ui/login_screen.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';
import 'package:gdgocms/core/theme/app_theme.dart';
import 'package:gdgocms/core/theme/app_images.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late SharedPreferences prefs;
  final PageController _controller = PageController();
  Alignment alignFrame = Alignment(0, -0.75);
  bool onLastPage = true;
  int pageIndex = 0;
  List<Color> indicatorColor = AppColors.activeIndicatorColors;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', true);
  }

  double responsiveFontSize(BuildContext context, double baseSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 375) {
      return baseSize * 0.9;
    } else if (screenWidth > 600) {
      return baseSize * 1.1;
    }
    return baseSize;
  }

  double responsiveIndicatorSize(
    BuildContext context,
    double baseSize, {
    bool isWidth = false,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 375) {
      return baseSize * 0.85;
    } else if (screenWidth > 600) {
      return baseSize * 1.15;
    }
    return baseSize;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: AppColors.backgroundLight,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Banner Google HUST
              Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.04,
                  bottom: size.height * 0.01,
                ),
                child: SizedBox(
                  height: size.height * 0.06,
                  width: size.width * 0.7,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SvgPicture.asset(AppImages.googleHustBanner),
                  ),
                ),
              ),

              // 2. Cụm PageView và Indicator
              // [FIX] Bọc Stack trong SizedBox để giới hạn chiều cao và đưa nó lên trên
              SizedBox(
                height: size.height * 0.4, // Cấp chiều cao khoảng 60% màn hình
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView(
                      onPageChanged: (value) {
                        setState(() {
                          onLastPage = (value != 3);
                          pageIndex = value;
                        });
                      },
                      controller: _controller,
                      children: [
                        _buildResponsivePageFrame(
                          context: context,
                          child: SvgPicture.asset(AppImages.welcomeFrame1),
                        ),
                        _buildResponsivePageFrame(
                          context: context,
                          child: SvgPicture.asset(AppImages.welcomeFrame2),
                        ),
                        _buildResponsivePageFrame(
                          context: context,
                          child: Image.asset(AppImages.welcomeFrame3),
                        ),
                        _buildResponsivePageFrame(
                          context: context,
                          child: Image.asset(AppImages.welcomeFrame4),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.015),
                      child: SmoothPageIndicator(
                        controller: _controller,
                        count: 4,
                        effect: WormEffect(
                          dotHeight: responsiveIndicatorSize(context, 10.0),
                          dotWidth: responsiveIndicatorSize(
                            context,
                            25.0,
                            isWidth: true,
                          ),
                          activeDotColor: indicatorColor[pageIndex],
                          dotColor: AppColors.inactiveIndicator,
                          spacing: responsiveIndicatorSize(context, 8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // [FIX] Thêm Spacer để đẩy nút xuống dưới cùng
              const Spacer(),

              // 3. Nút Continue / Start
              Padding(
                padding: EdgeInsets.only(
                  bottom: size.height * 0.05,
                  top: size.height * 0.01,
                ),
                child: SizedBox(
                  width: size.width * 0.85,
                  height: size.height * 0.065,
                  child: ElevatedButton(
                    onPressed: () {
                      if (onLastPage) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const LoginScreen();
                            },
                          ),
                        );
                      }
                    },
                    style: AppButtonStyles.primary.copyWith(
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(vertical: size.height * 0.015),
                      ),
                    ),
                    child: Text(
                      onLastPage ? "Continue" : "Start",
                      style: AppFonts.customText(
                        fontSize: responsiveFontSize(context, 18),
                        fontWeight: AppFonts.semiBold,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponsivePageFrame({
    required BuildContext context,
    required Widget child,
    Alignment alignment = Alignment.bottomCenter,
  }) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Container(
        padding: EdgeInsets.only(bottom: size.height * 0.04),
        alignment: alignment,
        child: FittedBox(fit: BoxFit.contain, child: child),
      ),
    );
  }
}
