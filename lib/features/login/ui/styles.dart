import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColor extends Color {
  AppColor(super.value);

  static const backgroundColorLight = Colors.white;

  static const defaulFontColorLight = Colors.white;

  static const buttonColor = Color(0xFF00A050);

  static const List<Color> activeIndicatorColors = [
    Color(0xFFFE2B25),
    Color(0xFF1F87FC),
    Color(0xFF00A050),
    Color(0xFFFFB900),
  ];
  static const Color inactiveIndicatorGrey = Color(0xFFE0E0E0);
}

ButtonStyle myHeadButton = ElevatedButton.styleFrom(
  backgroundColor: AppColor.buttonColor,
  foregroundColor: Colors.white,

  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),

  minimumSize: Size(300, 50),
);

class MyFamilyFont {
  final double fontsize;
  final Color fontcolor;

  // Constructor to receive the font size
  MyFamilyFont({
    required this.fontsize,
    this.fontcolor = AppColor.defaulFontColorLight,
  });

  // Getter for bold style
  TextStyle get boldTextStyle => GoogleFonts.alexandria(
    textStyle: TextStyle(
      color: fontcolor,
      fontSize: fontsize, // Accesses the stored fontsize instance member
      fontWeight: FontWeight.w600,
    ),
  );

  // Getter for regular style
  TextStyle get regularTextStyle => GoogleFonts.alexandria(
    textStyle: TextStyle(
      color: fontcolor,
      fontSize: fontsize,
      fontWeight: FontWeight.w400,
    ),
  );

  // Getter for thin style
  TextStyle get thinTextStyle => GoogleFonts.alexandria(
    textStyle: TextStyle(
      color: fontcolor,
      fontSize: fontsize,
      fontWeight: FontWeight.w200,
    ),
  );
}
