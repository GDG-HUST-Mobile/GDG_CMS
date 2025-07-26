// lib/features/login/ui/components/login_form.dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';
import 'package:gdgocms/core/theme/app_images.dart';
import 'package:gdgocms/features/login/ui/components/textfield.dart';
import 'package:gdgocms/features/login/ui/forgotpass_popup.dart';
import 'package:gdgocms/features/login/ui/signup_popup.dart';

import '../../../../core/theme/app_theme.dart';
import '../factories/widget_factory.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isPasswordObscured;
  final bool checkAccount;
  final VoidCallback onPasswordToggle;
  final VoidCallback onSignIn;
  final double screenWidth;

  const LoginForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.isPasswordObscured,
    required this.checkAccount,
    required this.onPasswordToggle,
    required this.onSignIn,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Sign in", style: AppFonts.displayLargeText()),
        const SizedBox(height: 24),
        Text("ID", style: AppFonts.titleLargeText()),
        const SizedBox(height: 8),
        MyTextField(
          controller: usernameController,
          hintText: "Your ID",
          obscureText: false,
        ),
        const SizedBox(height: 24),
        Text("Password", style: AppFonts.titleLargeText()),
        const SizedBox(height: 8),
        MyTextField(
          controller: passwordController,
          hintText: "Enter your password",
          obscureText: isPasswordObscured,
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordObscured ? Icons.visibility : Icons.visibility_off,
              color: AppColors.textSecondary,
            ),
            onPressed: onPasswordToggle,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => showForgotPasswordDialog(context),
            child: Text("Forgot Password?", style: AppFonts.titleLargeText(color: AppColors.textLink)),
          ),
        ),
        const SizedBox(height: 16),
        if (!checkAccount)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              "Oops! Incorrect password. Try again!",
              textAlign: TextAlign.center,
              style: AppFonts.errorMediumText(color: AppColors.textError),
            ),
          ),

            PlatformWidgetFactory.instance.createButton(onPressed: onSignIn,
    child: Text("Sign In", style: AppFonts.buttonLarge()), height: (screenWidth < 500) ? 14 : 20),

        const SizedBox(height: 32),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("Or continue with", style: AppFonts.headlineSmallText(color: AppColors.textSecondary)),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        Center(
          child: PlatformWidgetFactory.instance.createIconButton(onPressed: () {},
              icon: ClipOval(child: Image.asset(AppImages.googleIcon,
                width: 48.0,
                height: 48.0,
                fit: BoxFit.cover,))),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Not a member?", style: AppFonts.headlineSmallText(color: AppColors.textSecondary)),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => showSignUpDialog(context),
              child: Text("Create an account", style: AppFonts.headlineSmallText(color: AppColors.textLink)),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}