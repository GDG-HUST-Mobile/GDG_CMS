import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gdgocms/features/login/ui/onboarding_screen.dart';
import 'package:gdgocms/features/main/ui/home/ui/home_screen.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';

/// main.dart
/// Layer: Root (Entry Point)
/// Description: Điểm khởi đầu của ứng dụng GDG CMS.
/// Thực hiện cấu hình hệ thống, kiểm tra trạng thái đăng nhập và thiết lập Theme chung.
/// Quản lý vòng đời khởi tạo và cấu hình [MaterialApp].

/// Hàm khởi chạy ứng dụng [main].
///
/// Thực hiện các tác vụ chuẩn bị:
/// 1. Khởi tạo binding cho Flutter Framework.
/// 2. Truy xuất [SharedPreferences] để kiểm tra `accessToken`.
/// 3. Quyết định [initialScreen] (Màn hình khởi đầu) dựa trên trạng thái xác thực.
void main() async {
  // Đảm bảo các dịch vụ của Flutter (như MethodChannel) đã sẵn sàng trước khi gọi async khác.
  WidgetsFlutterBinding.ensureInitialized();

  // Kiểm tra phiên đăng nhập hiện tại từ bộ nhớ cục bộ.
  final prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('accessToken');

  // Điều hướng thông minh:
  // - Đã có token: Chuyển thẳng vào [HomeScreen].
  // - Chưa có/Token rỗng: Hiển thị giới thiệu [OnboardingScreen].
  Widget initialScreen = (accessToken != null && accessToken.isNotEmpty)
      ? const HomeScreen()
      : const OnboardingScreen();

  runApp(CMSApp(initialScreen: initialScreen));
}

/// [CMSApp] là Widget gốc cấu hình toàn bộ ứng dụng.
///
/// Tại đây thiết lập:
/// - [ThemeData]: Định nghĩa Style Guide (Màu sắc, Font chữ, Button Style).
/// - [initialScreen]: Xác định màn hình hiển thị đầu tiên sau khi Splash kết thúc.
class CMSApp extends StatelessWidget {
  /// Màn hình đầu tiên được truyền vào từ hàm [main].
  final Widget initialScreen;

  const CMSApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google x HUST CMS',
      debugShowCheckedModeBanner: false,

      /// Cấu hình giao diện đồng bộ (Style Guide) dựa trên Core Layer.
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),

        /// [inputDecorationTheme] quy định hình dáng đồng nhất cho các ô nhập liệu (TextField).
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          hintStyle: AppTextStyles.subtitle2,
        ),

        /// [textTheme] tích hợp Google Fonts (Inter) và ánh xạ các style từ [AppTextStyles].
        textTheme: GoogleFonts.interTextTheme().copyWith(
          displayLarge: AppTextStyles.h1,
          displayMedium: AppTextStyles.h2,
          displaySmall: AppTextStyles.h3,
          titleMedium: AppTextStyles.title2,
          bodyLarge: AppTextStyles.subtitle1,
          labelLarge: AppTextStyles.body1,
        ),

        /// [elevatedButtonTheme] định nghĩa giao diện mặc định cho các nút bấm chính.
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: const StadiumBorder(),
          ),
        ),
      ),

      home: initialScreen,
    );
  }
}