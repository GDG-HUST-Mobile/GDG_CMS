import 'package:flutter/material.dart';
import 'package:gdgocms/features/login/model/components/textfield.dart';
import 'package:gdgocms/features/login/ui/styles.dart';

// Function to show the custom dialog
Future<void> showForgotPasswordDialog(BuildContext context) async {
  // Controller for the email TextField
  final TextEditingController emailController = TextEditingController();

  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        backgroundColor: AppColor.backgroundColorLight,
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
              Image.asset("assets/forgotpass_screen/key.png", scale: 2),
              const SizedBox(height: 20),

              // 2. Title
              Text(
                'Forget password?',
                style:
                    MyFamilyFont(
                      fontsize: 20,
                      fontcolor: Colors.black,
                    ).boldTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // 3. Subtitle
              Text(
                'We will email you\na link to reset your password.',
                textAlign: TextAlign.center,
                style:
                    MyFamilyFont(
                      fontsize: 16,
                      fontcolor: Colors.black,
                    ).regularTextStyle,
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
                width: double.infinity, // Make button fill width
                child: ElevatedButton(
                  style: myHeadButton,
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Reset password'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
