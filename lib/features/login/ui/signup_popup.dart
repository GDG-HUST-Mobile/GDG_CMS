import 'package:flutter/material.dart';
import 'package:gdgocms/features/login/ui/components/textfield.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';
import 'package:gdgocms/core/theme/app_theme.dart';
import 'package:gdgocms/core/theme/app_images.dart';

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

    // Responsive values
    final dialogWidth =
        isTablet
            ? size.width *
                0.4 // 40% of screen width on tablet
            : isMobile
            ? size.width *
                0.9 // 90% of screen width on mobile
            : 350.0;

    final dialogMaxHeight =
        isTablet
            ? size.height *
                0.8 // 80% of screen height on tablet
            : size.height * 0.9; // 90% of screen height on mobile

    final horizontalPadding = isSmallMobile ? 16.0 : 24.0;
    final verticalPadding = isSmallMobile ? 16.0 : 24.0;

    final titleFontSize =
        isTablet
            ? 20.0
            : isSmallMobile
            ? 15.0
            : 17.0;
    final labelFontSize =
        isTablet
            ? 18.0
            : isSmallMobile
            ? 14.0
            : 16.0;
    final buttonFontSize =
        isTablet
            ? 22.0
            : isSmallMobile
            ? 18.0
            : 20.0;

    final logoScale =
        isTablet
            ? 1.5
            : isSmallMobile
            ? 2.5
            : 2.0;
    final spacing = isSmallMobile ? 15.0 : 20.0;
    final fieldSpacing = isSmallMobile ? 20.0 : 25.0;
    final smallSpacing = isSmallMobile ? 3.0 : 5.0;

    return Dialog(
      backgroundColor: AppColors.backgroundLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isSmallMobile ? 16.0 : 20.0),
      ),
      elevation: 5,
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(
          maxWidth: isTablet ? 500 : 400,
          maxHeight: dialogMaxHeight,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Logo with responsive scaling
              Image.asset(AppImages.appLogo, scale: logoScale),
              SizedBox(height: spacing),

              // Title with responsive font size
              Text(
                'Be a part of something great!',
                style: AppFonts.customText(
                  fontSize: titleFontSize,
                  fontWeight: AppFonts.semiBold,
                  color: AppColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: fieldSpacing),

              // Form fields with responsive layout
              _buildFormFields(
                context: context,
                labelFontSize: labelFontSize,
                fieldSpacing: fieldSpacing,
                smallSpacing: smallSpacing,
              ),

              SizedBox(height: fieldSpacing),

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
