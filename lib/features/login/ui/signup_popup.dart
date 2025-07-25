import 'package:flutter/material.dart';
import 'package:gdgocms/features/login/ui/components/textfield.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';
import 'package:gdgocms/core/theme/app_theme.dart';
import 'package:gdgocms/core/theme/app_images.dart';

import 'components/dialog_responsive_config.dart';

// Function to show the custom dialog
Future<void> showSignUpDialog(BuildContext context) async {
  // Controller for the email TextField
  final TextEditingController idController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return _SignUpDialogContent(
        idController: idController,
        emailController: emailController,
        passwordController: passwordController,
        passwordConfirmController: passwordConfirmController,
      );
    },
  );
}

class _SignUpDialogContent extends StatelessWidget {
  final TextEditingController idController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;

  const _SignUpDialogContent({
    required this.idController,
    required this.emailController,
    required this.passwordController,
    required this.passwordConfirmController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isMobile = size.width <= 600;
    final isSmallMobile = size.width <= 360;

    final config = DialogResponsiveConfig(context);

    return Dialog(
      backgroundColor: AppColors.backgroundLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isSmallMobile ? 16.0 : 20.0),
      ),
      elevation: 5,
      child: Container(
        width: config.dialogWidth,
        constraints: BoxConstraints(
          maxWidth: isTablet ? 500 : 400,
          maxHeight: config.dialogMaxHeight,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: config.horizontalPadding,
          vertical: config.verticalPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Logo with responsive scaling
              Image.asset(AppImages.appLogo, scale: config.logoScale),
              SizedBox(height: config.spacing),

              // Title with responsive font size
              Text(
                'Be a part of something great!',
                style: AppFonts.customText(
                  fontSize: config.titleFontSize,
                  fontWeight: AppFonts.semiBold,
                  color: AppColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: config.fieldSpacing),

              // Form fields with responsive layout
              _buildFormFields(
                context: context,
                labelFontSize: config.labelFontSize,
                fieldSpacing: config.fieldSpacing,
                smallSpacing: config.smallSpacing,
              ),

              SizedBox(height: config.fieldSpacing),

              // Sign Up Button with responsive styling
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: AppButtonStyles.primary.copyWith(
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(
                        vertical: isSmallMobile ? 14 : 18,
                        horizontal: 24,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Sign Up',
                    style: AppFonts.buttonLarge(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields({
    required BuildContext context,
    required double labelFontSize,
    required double fieldSpacing,
    required double smallSpacing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ID field
        _buildFormField(
          label: "ID",
          controller: idController,
          hintText: "Your ID",
          obscureText: false,
          labelFontSize: labelFontSize,
          smallSpacing: smallSpacing,
        ),
        SizedBox(height: fieldSpacing),

        // Email field
        _buildFormField(
          label: "Email",
          controller: emailController,
          hintText: "Your email",
          obscureText: false,
          labelFontSize: labelFontSize,
          smallSpacing: smallSpacing,
        ),
        SizedBox(height: fieldSpacing),

        // Password field
        _buildFormField(
          label: "Password",
          controller: passwordController,
          hintText: "Enter your password",
          obscureText: true,
          labelFontSize: labelFontSize,
          smallSpacing: smallSpacing,
        ),
        SizedBox(height: fieldSpacing),

        // Confirm password field
        _buildFormField(
          label: "Confirm your password",
          controller: passwordConfirmController,
          hintText: "Confirm your password",
          obscureText: true,
          labelFontSize: labelFontSize,
          smallSpacing: smallSpacing,
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required double labelFontSize,
    required double smallSpacing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.customText(
            fontSize: labelFontSize,
            fontWeight: AppFonts.semiBold,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: smallSpacing),
        MyTextField(
          controller: controller,
          hintText: hintText,
          obscureText: obscureText,
        ),
      ],
    );
  }
}
