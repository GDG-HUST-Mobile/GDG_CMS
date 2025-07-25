import 'package:flutter/material.dart';
import 'package:gdgocms/features/login/ui/components/textfield.dart';
import 'package:gdgocms/features/login/ui/forgotpass_popup.dart';
import 'package:gdgocms/features/login/ui/signup_popup.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';
import 'package:gdgocms/core/theme/app_theme.dart';
import 'package:gdgocms/core/theme/app_images.dart';

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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenHeight = size.height;
    final double screenWidth = size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.03),

                    SizedBox(
                      width: screenWidth * 0.9,
                      child: Image.asset(AppImages.logoGdg, fit: BoxFit.contain),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // login text
                        Text("Sign in", style: AppFonts.displayLargeText()),

                        SizedBox(height: screenHeight * 0.03),

                        // username field
                        Text("ID", style: AppFonts.titleLargeText()),
                        SizedBox(height: screenHeight * 0.01),
                        MyTextField(
                          controller: usernameController,
                          hintText: "Your ID",
                          obscureText: false,
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // password field
                        Text("Password", style: AppFonts.titleLargeText()),
                        SizedBox(height: screenHeight * 0.01),
                        MyTextField(
                          controller: passwordController,
                          hintText: "Enter your password",
                          obscureText: _isPasswordObscured,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordObscured = !_isPasswordObscured;
                              });
                            },
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        // forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              showForgotPasswordDialog(context);
                            },
                            child: Text(
                              "Forgot Password?",
                              style: AppFonts.titleLargeText(
                                color: AppColors.textLink,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),

                    if (!checkAccount)
                      Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                        child: Text(
                          "Oops! Incorrect password. Try again!",
                          textAlign: TextAlign.center,
                          style: AppFonts.errorMediumText(
                            color: AppColors.textError,
                          )
                        ),
                      ),

                    // signin button
                    SizedBox(
                      width: screenWidth * 0.75,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            checkAccount = false;
                          });
                        },
                        style: AppButtonStyles.primary.copyWith(
                          padding: WidgetStateProperty.all(
                            EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                          ),
                        ),
                        child: Text("Sign In", style: AppFonts.buttonLarge()),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    // others signin
                    Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 0.5, color: Colors.grey[400]),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: Text(
                            "Or continue with",
                            style: AppFonts.headlineSmallText(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(thickness: 0.5, color: Colors.grey[400]),
                        ),
                      ],
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    IconButton(
                      onPressed: () {},
                      icon: ClipOval(
                        child: Image.asset(
                          AppImages.googleIcon,
                          width: screenWidth * 0.15,
                          height: screenWidth * 0.15,
                          fit: BoxFit.cover,),
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // register
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Not a member?",
                          style: AppFonts.headlineSmallText(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            showSignUpDialog(context);
                          },
                          child: Text(
                            "Create an account",
                            style: AppFonts.headlineSmallText(
                              color: AppColors.textLink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
            Image.asset(AppImages.loginFooter),
          ],
        ),
      ),
    );
  }
}