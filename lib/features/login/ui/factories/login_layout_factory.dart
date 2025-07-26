import 'package:flutter/material.dart';
import 'package:gdgocms/features/login/ui/layouts/mobile_login_layout.dart';
import 'package:gdgocms/features/login/ui/layouts/tablet_login_layout.dart';

class LoginLayoutFactory {
  static Widget build({
    required BuildContext context,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
    required bool isPasswordObscured,
    required bool checkAccount,
    required VoidCallback onPasswordToggle,
    required VoidCallback onSignIn,
  }) {
    const double tabletBreakpoint = 720.0;
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > tabletBreakpoint) {
      return TabletLoginLayout(
        usernameController: usernameController,
        passwordController: passwordController,
        isPasswordObscured: isPasswordObscured,
        checkAccount: checkAccount,
        onPasswordToggle: onPasswordToggle,
        onSignIn: onSignIn,
      );
    } else {
      return MobileLoginLayout(
        usernameController: usernameController,
        passwordController: passwordController,
        isPasswordObscured: isPasswordObscured,
        checkAccount: checkAccount,
        onPasswordToggle: onPasswordToggle,
        onSignIn: onSignIn,
      );
    }
  }
}