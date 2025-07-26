import 'package:flutter/material.dart';
import 'package:gdgocms/features/login/ui/components/textfield.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';
import 'package:gdgocms/core/theme/app_theme.dart';

import 'factories/widget_factory.dart';

// Function to show the custom dialog
Future<void> showForgotPasswordDialog(BuildContext context) async {
  // Controller for the email TextField
  final TextEditingController emailController = TextEditingController();
  final Size size = MediaQuery.of(context).size;
  final double screenHeight = size.height;
  final double screenWidth = size.width;

  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350, maxHeight: 400),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/forgotpass_screen/forgot_pass_key.png",
                scale: 2,
              ),
              const SizedBox(height: 20),

              // 2. Title
              Text(
                'Forget password?',
                style: AppFonts.headlineMediumText(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // 3. Subtitle
              Text(
                'We will email you\na link to reset your password.',
                textAlign: TextAlign.center,
                style: AppFonts.bodyLargeText(),
              ),
              const SizedBox(height: 25),

              // 4. Email TextField
              MyTextField(
                controller: emailController,
                hintText: "Enter your email",
                obscureText: false,
              ),
              const SizedBox(height: 25),

              // 5. Reset Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: PlatformWidgetFactory.instance.createButton(
                    onPressed: () {Navigator.of(dialogContext).pop();},
                    child: Text('Reset password', style: AppFonts.buttonLarge())),
              ),
            ],
          ),
        ),
      );
    },
  );
}
