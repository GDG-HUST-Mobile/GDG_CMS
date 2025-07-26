// lib/features/login/ui/signup_popup.dart
import 'package:flutter/material.dart';
import 'package:gdgocms/features/login/ui/components/textfield.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';
import 'package:gdgocms/core/theme/app_images.dart';
import 'factories/widget_factory.dart';

// Function to show the custom dialog
Future<void> showSignUpDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth > 720 ? 500 : 400;
          return _SignUpDialogContent(maxWidth: maxWidth);
        },
      );
    },
  );
}

class _SignUpDialogContent extends StatefulWidget {
  final double maxWidth;
  const _SignUpDialogContent({required this.maxWidth});

  @override
  State<_SignUpDialogContent> createState() => _SignUpDialogContentState();
}

class _SignUpDialogContentState extends State<_SignUpDialogContent> {
  late final TextEditingController idController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController passwordConfirmController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    idController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy "nhà máy" widget phù hợp với platform hiện tại
    final factory = PlatformWidgetFactory.instance;

    return Dialog(
      backgroundColor: AppColors.backgroundLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 5,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(AppImages.appLogo, height: 60),
              const SizedBox(height: 16),
              Text(
                'Be a part of something great!',
                style: AppFonts.headlineMediumText(color: AppColors.secondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildFormField(label: "ID", controller: idController, hintText: "Your ID"),
              const SizedBox(height: 16),
              _buildFormField(label: "Email", controller: emailController, hintText: "Your email"),
              const SizedBox(height: 16),
              _buildFormField(label: "Password", controller: passwordController, hintText: "Enter your password", obscureText: true),
              const SizedBox(height: 16),
              _buildFormField(label: "Confirm your password", controller: passwordConfirmController, hintText: "Confirm your password", obscureText: true),
              const SizedBox(height: 24),

              // SỬ DỤNG FACTORY ĐỂ TẠO NÚT BẤM
              PlatformWidgetFactory.instance.createButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Sign Up', style: AppFonts.buttonLarge()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppFonts.titleLargeText()),
        const SizedBox(height: 8),
        MyTextField(controller: controller, hintText: hintText, obscureText: obscureText),
      ],
    );
  }
}