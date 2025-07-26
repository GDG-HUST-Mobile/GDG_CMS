// lib/features/login/ui/layouts/mobile_login_layout.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gdgocms/core/theme/app_images.dart';
import 'package:gdgocms/features/login/ui/components/login_form.dart';

class MobileLoginLayout extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isPasswordObscured;
  final bool checkAccount;
  final VoidCallback onPasswordToggle;
  final VoidCallback onSignIn;


  const MobileLoginLayout({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.isPasswordObscured,
    required this.checkAccount,
    required this.onPasswordToggle,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    const double minWidth = 370;
    const double maxWidth = 720;
    const double minSpacing = 0;
    const double maxSpacing = -40;

    final t = ((screenWidth - minWidth) / (maxWidth - minWidth)).clamp(0.0, 1.0);

    final double footerOffset = lerpDouble(minSpacing, maxSpacing, t)!;
    return Stack(
      children: [Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      AppImages.logoGdg,
                      fit: BoxFit.contain,
                      height: 60,
                    )),
                  const SizedBox(height: 24),
                  LoginForm(
                    usernameController: usernameController,
                    passwordController: passwordController,
                    isPasswordObscured: isPasswordObscured,
                    checkAccount: checkAccount,
                    onPasswordToggle: onPasswordToggle,
                    onSignIn: onSignIn,
                    screenWidth: screenWidth,
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
        Positioned(
          bottom: footerOffset,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  spreadRadius: 2,
                  blurRadius: 15,
                  offset: const Offset(0, -7),
                ),
              ],
            ),
            child: Image.asset(AppImages.loginFooter),
          ),
        ),
    ]
    );
  }
}