// lib/core/factories/widget_factory.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../../core/theme/app_theme.dart';


abstract class IWidgetFactory {
  Widget createButton({
    required VoidCallback onPressed,
    required Widget child,
    double height = 24.0
  });

  Widget createIconButton({
    required VoidCallback onPressed,
    required Widget icon,
    double? iconSize,
  });
}

// --- 2. CONCRETE FACTORY CHO MATERIAL (ANDROID) ---
class MaterialWidgetFactory implements IWidgetFactory {
  @override
  Widget createButton({required VoidCallback onPressed, required Widget child, double height = 24.0}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: AppButtonStyles.primary.copyWith(
          padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(
              vertical: height,
              horizontal: 24,
            ),
          ),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget createIconButton({required VoidCallback onPressed, required Widget icon, double? iconSize}) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: iconSize,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}

// --- 3. CONCRETE FACTORY CHO CUPERTINO (iOS) ---
class CupertinoWidgetFactory implements IWidgetFactory {
  @override
  Widget createButton({required VoidCallback onPressed, required Widget child, double height = 24.0}) {
    // CupertinoButton.filled có giao diện tương tự ElevatedButton
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton.filled(
        onPressed: onPressed,
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: DefaultTextStyle(
          style: AppFonts.buttonLarge().copyWith(color: Colors.white),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget createIconButton({required VoidCallback onPressed, required Widget icon, double? iconSize}) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: iconSize,
        height: iconSize,
        child: icon,
      ),
    );
  }
}

// --- 4. LỚP TRUY CẬP FACTORY ---
class PlatformWidgetFactory {
  static late IWidgetFactory _instance;

  static IWidgetFactory get instance => _instance;

  static void init() {
    if (kIsWeb) {
      // Trên web, luôn dùng giao diện Material
      _instance = MaterialWidgetFactory();
    } else {
      if (Platform.isIOS) {
        _instance = CupertinoWidgetFactory();
      } else {
        _instance = MaterialWidgetFactory();
      }
    }
  }
}