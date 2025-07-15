import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gdgocms/core/theme/app_colors.dart';

class AppFonts {
  AppFonts._();

  // Font family
  static const String primaryFont = 'Alexandria';

  // Font sizes
  static const double displayLarge = 34.0;
  static const double displayMedium = 28.0;
  static const double displaySmall = 24.0;

  static const double headlineLarge = 22.0;
  static const double headlineMedium = 20.0;
  static const double headlineSmall = 18.0;

  static const double titleLarge = 16.0;
  static const double titleMedium = 14.0;
  static const double titleSmall = 12.0;

  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;

  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 10.0;

  static const double errorLarge = 16.0;
  static const double errorMedium = 14.0;
  static const double errorSmall = 12.0;

  // Font weights
  static const FontWeight thin = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Text styles
  static TextStyle displayLargeText({Color? color}) => GoogleFonts.alexandria(
    fontSize: displayLarge,
    fontWeight: thin,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle displayMediumText({Color? color}) => GoogleFonts.alexandria(
    fontSize: displayMedium,
    fontWeight: regular,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle displaySmallText({Color? color}) => GoogleFonts.alexandria(
    fontSize: displaySmall,
    fontWeight: regular,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle headlineLargeText({Color? color}) => GoogleFonts.alexandria(
    fontSize: headlineLarge,
    fontWeight: semiBold,
    color: color ?? AppColors.textOnPrimary,
  );

  static TextStyle headlineMediumText({Color? color}) => GoogleFonts.alexandria(
    fontSize: headlineMedium,
    fontWeight: semiBold,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle headlineSmallText({Color? color}) => GoogleFonts.alexandria(
    fontSize: headlineSmall,
    fontWeight: semiBold,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle titleLargeText({Color? color}) => GoogleFonts.alexandria(
    fontSize: titleLarge,
    fontWeight: semiBold,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle titleMediumText({Color? color}) => GoogleFonts.alexandria(
    fontSize: titleMedium,
    fontWeight: regular,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle titleSmallText({Color? color}) => GoogleFonts.alexandria(
    fontSize: titleSmall,
    fontWeight: regular,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle bodyLargeText({Color? color}) => GoogleFonts.alexandria(
    fontSize: bodyLarge,
    fontWeight: regular,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle bodyMediumText({Color? color}) => GoogleFonts.alexandria(
    fontSize: bodyMedium,
    fontWeight: regular,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle bodySmallText({Color? color}) => GoogleFonts.alexandria(
    fontSize: bodySmall,
    fontWeight: regular,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle labelLargeText({Color? color}) => GoogleFonts.alexandria(
    fontSize: labelLarge,
    fontWeight: medium,
    color: color ?? AppColors.textSecondary,
  );

  static TextStyle labelMediumText({Color? color}) => GoogleFonts.alexandria(
    fontSize: labelMedium,
    fontWeight: medium,
    color: color ?? AppColors.textSecondary,
  );

  static TextStyle labelSmallText({Color? color}) => GoogleFonts.alexandria(
    fontSize: labelSmall,
    fontWeight: medium,
    color: color ?? AppColors.textSecondary,
  );

  static TextStyle errorSmallText({Color? color}) => GoogleFonts.alexandria(
    fontSize: errorSmall,
    fontWeight: bold,
    fontStyle: FontStyle.italic,
    letterSpacing: 0.5,
    color: color ?? AppColors.textSecondary,
  );

  static TextStyle errorMediumText({Color? color}) => GoogleFonts.alexandria(
    fontSize: errorMedium,
    fontWeight: bold,
    fontStyle: FontStyle.italic,
    letterSpacing: 0.5,
    color: color ?? AppColors.textSecondary,
  );

  static TextStyle errorLargeText({Color? color}) => GoogleFonts.alexandria(
    fontSize: errorLarge,
    fontWeight: bold,
    fontStyle: FontStyle.italic,
    letterSpacing: 0.5,
    color: color ?? AppColors.textSecondary,
  );

  // Custom text styles
  static TextStyle customText({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) => GoogleFonts.alexandria(
    fontSize: fontSize,
    fontWeight: fontWeight ?? regular,
    color: color ?? AppColors.textPrimary,
  );

  // Button text styles
  static TextStyle buttonLarge({Color? color}) => GoogleFonts.alexandria(
    fontSize: headlineLarge,
    fontWeight: semiBold,
    color: color ?? AppColors.textOnPrimary,
  );

  static TextStyle buttonMedium({Color? color}) => GoogleFonts.alexandria(
    fontSize: headlineMedium,
    fontWeight: semiBold,
    color: color ?? AppColors.textOnPrimary,
  );

  static TextStyle buttonSmall({Color? color}) => GoogleFonts.alexandria(
    fontSize: headlineSmall,
    fontWeight: semiBold,
    color: color ?? AppColors.textOnPrimary,
  );
}
