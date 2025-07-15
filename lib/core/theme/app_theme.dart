import 'package:flutter/material.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';

class AppTheme {
  AppTheme._();

  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.backgroundLight,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textOnPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: AppFonts.displayLargeText(),
        displayMedium: AppFonts.displayMediumText(),
        displaySmall: AppFonts.displaySmallText(),
        headlineLarge: AppFonts.headlineLargeText(),
        headlineMedium: AppFonts.headlineMediumText(),
        headlineSmall: AppFonts.headlineSmallText(),
        titleLarge: AppFonts.titleLargeText(),
        titleMedium: AppFonts.titleMediumText(),
        titleSmall: AppFonts.titleSmallText(),
        bodyLarge: AppFonts.bodyLargeText(),
        bodyMedium: AppFonts.bodyMediumText(),
        bodySmall: AppFonts.bodySmallText(),
        labelLarge: AppFonts.labelLargeText(),
        labelMedium: AppFonts.labelMediumText(),
        labelSmall: AppFonts.labelSmallText(),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonStyles.primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: AppButtonStyles.outlined,
      ),
    );
  }

  // Dark theme (for future use)
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      // Add dark theme configuration here when needed
    );
  }
}

class AppButtonStyles {
  AppButtonStyles._();

  static ButtonStyle _baseStyle({
    required Color backgroundColor,
    required Color foregroundColor,
    Color? shadowColor,
    double? elevation,
    TextStyle? textStyle,
    BorderSide? side,
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(backgroundColor),
      foregroundColor: WidgetStateProperty.all(foregroundColor),
      shadowColor: WidgetStateProperty.all(shadowColor ?? Colors.black.withOpacity(0.2)),
      elevation: WidgetStateProperty.all(elevation ?? 2),
      // Dùng padding thay cho minimumSize để button responsive hơn
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      textStyle: WidgetStateProperty.all(
        textStyle ?? AppFonts.buttonMedium(),
      ),
      side: WidgetStateProperty.all(side),
    );
  }

  // 2. Các style public giờ sẽ gọi đến _baseStyle
  static ButtonStyle get primary => _baseStyle(
    backgroundColor: AppColors.buttonPrimary,
    foregroundColor: AppColors.textOnPrimary,
  );

  static ButtonStyle get secondary => _baseStyle(
    backgroundColor: AppColors.buttonSecondary,
    foregroundColor: AppColors.textOnPrimary,
  );

  static ButtonStyle get outlined => _baseStyle(
    backgroundColor: Colors.transparent, // Nền trong suốt
    foregroundColor: AppColors.primary,
    elevation: 0, // Không đổ bóng
    side: const BorderSide(color: AppColors.primary, width: 2),
    textStyle: AppFonts.buttonMedium(color: AppColors.primary),
  );

  // 3. Phương thức responsive có thể giữ lại hoặc không tuỳ nhu cầu.
  // Nếu giữ lại, nó cũng nên gọi _baseStyle để đảm bảo tính nhất quán.
  static ButtonStyle custom({
    Color? backgroundColor,
    Color? foregroundColor,
  }) => _baseStyle(
    backgroundColor: backgroundColor ?? AppColors.buttonPrimary,
    foregroundColor: foregroundColor ?? AppColors.textOnPrimary,
  );
}