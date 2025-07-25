import 'package:flutter/material.dart';

class DialogResponsiveConfig {
  final BuildContext context;
  final Size size;
  final bool isTablet;
  final bool isSmallMobile;

  DialogResponsiveConfig(this.context)
      : size = MediaQuery.of(context).size,
        isTablet = MediaQuery.of(context).size.width > 600,
        isSmallMobile = MediaQuery.of(context).size.width <= 360;

  // --- Dimensions ---
  double get dialogWidth => isTablet ? size.width * 0.4 : size.width * 0.9;
  double get dialogMaxHeight => isTablet ? size.height * 0.8 : size.height * 0.9;
  double get dialogBorderRadius => isSmallMobile ? 16.0 : 20.0;
  double get maxWidth => isTablet ? 500 : 400;

  // --- Padding & Spacing ---
  double get horizontalPadding => isSmallMobile ? 16.0 : 24.0;
  double get verticalPadding => isSmallMobile ? 16.0 : 24.0;
  double get spacing => isSmallMobile ? 15.0 : 20.0;
  double get fieldSpacing => isSmallMobile ? 20.0 : 25.0;
  double get smallSpacing => isSmallMobile ? 3.0 : 5.0;
  double get buttonVerticalPadding => isSmallMobile ? 14.0 : 18.0;

  // --- Font Sizes & Scales ---
  double get titleFontSize => isTablet ? 20.0 : (isSmallMobile ? 15.0 : 17.0);
  double get labelFontSize => isTablet ? 18.0 : (isSmallMobile ? 14.0 : 16.0);
  double get logoScale => isTablet ? 1.5 : (isSmallMobile ? 2.5 : 2.0);
}