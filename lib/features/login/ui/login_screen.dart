// lib/features/login/ui/login_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/features/login/ui/factories/login_layout_factory.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool checkAccount = true;
  bool _isPasswordObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  void _handleSignIn() {
    setState(() {
      checkAccount = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const double minLayoutWidth = 370.0;

            final double layoutWidth = max(minLayoutWidth, constraints.maxWidth);

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: layoutWidth,
                child: LoginLayoutFactory.build(
                  context: context,
                  usernameController: usernameController,
                  passwordController: passwordController,
                  isPasswordObscured: _isPasswordObscured,
                  checkAccount: checkAccount,
                  onPasswordToggle: _togglePasswordVisibility,
                  onSignIn: _handleSignIn,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}