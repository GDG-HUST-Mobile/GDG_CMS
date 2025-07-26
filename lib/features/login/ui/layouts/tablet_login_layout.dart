// lib/features/login/ui/layouts/tablet_login_layout.dart
import 'package:flutter/material.dart';
import 'package:gdgocms/core/theme/app_images.dart';
import 'package:gdgocms/features/login/ui/components/login_form.dart';

class TabletLoginLayout extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isPasswordObscured;
  final bool checkAccount;
  final VoidCallback onPasswordToggle;
  final VoidCallback onSignIn;

  const TabletLoginLayout({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.isPasswordObscured,
    required this.checkAccount,
    required this.onPasswordToggle,
    required this.onSignIn,
  });

  // Tính lăng tương lai nên a Sâm đừng soi file này nhé ;)
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: SingleChildScrollView(
              child: LoginForm(
                usernameController: usernameController,
                passwordController: passwordController,
                isPasswordObscured: isPasswordObscured,
                checkAccount: checkAccount,
                onPasswordToggle: onPasswordToggle,
                onSignIn: onSignIn,
                screenWidth: screenWidth,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.grey[200],
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Image.asset(AppImages.logoGdg, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ],
    );
  }
}