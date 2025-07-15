import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background colors
  static const Color backgroundLight = Colors.white;
  static const Color backgroundDark = Color(0xFF121212);

  // Primary colors
  static const Color primary = Color(0xFF00A050);
  static const Color primaryLight = Color(0xFF4DB380);
  static const Color primaryDark = Color(0xFF007A3D);

  // Secondary colors
  static const Color secondary = Color(0xFF1F87FC);
  static const Color secondaryLight = Color(0xFF5BA3FD);
  static const Color secondaryDark = Color(0xFF1566C9);

  // Text colors
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF666C73);
  static const Color textOnPrimary = Colors.white;
  static const Color textError = Colors.red;
  static const Color textLink = Color(0xFF1F87FC);

  // Button colors
  static const Color buttonPrimary = Color(0xFF00A050);
  static const Color buttonSecondary = Color(0xFF1F87FC);

  // Indicator colors for welcome screen
  static const List<Color> activeIndicatorColors = [
    Color(0xFFFE2B25), // Red
    Color(0xFF1F87FC), // Blue
    Color(0xFF00A050), // Green
    Color(0xFFFFB900), // Yellow
  ];
  static const Color inactiveIndicator = Color(0xFFE0E0E0);

  // Utility colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
}
