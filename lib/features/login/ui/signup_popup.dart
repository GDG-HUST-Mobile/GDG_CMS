import 'package:flutter/material.dart';
import 'package:gdgocms/features/login/model/components/textfield.dart';
import 'package:gdgocms/features/login/ui/styles.dart';

// Function to show the custom dialog
Future<void> showSignUpDialog(BuildContext context) async {
  // Controller for the email TextField
  final TextEditingController idController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  Size size = MediaQuery.of(context).size;

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
          constraints: const BoxConstraints(maxWidth: 350, maxHeight: 650),
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/signup_screen/Logo.png", scale: 2),
                const SizedBox(height: 20),

                // 2. Title
                Text(
                  'Be a part of something great!',
                  style:
                      MyFamilyFont(
                        fontsize: 17,
                        fontcolor: Color(0xFF1F87FC),
                      ).boldTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),

                // 4. Info TextField
                SizedBox(
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // info field
                      Text(
                        "ID",
                        style:
                            MyFamilyFont(
                              fontsize: 16,
                              fontcolor: Colors.black,
                            ).boldTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      MyTextField(
                        controller: idController,
                        hintText: "Your ID",
                        obscureText: false,
                      ),

                      SizedBox(height: 25),

                      // email field
                      Text(
                        "Email",
                        style:
                            MyFamilyFont(
                              fontsize: 16,
                              fontcolor: Colors.black,
                            ).boldTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      MyTextField(
                        controller: emailController,
                        hintText: "Your email",
                        obscureText: false,
                      ),
                      SizedBox(height: 25),

                      // password field
                      Text(
                        "Password",
                        style:
                            MyFamilyFont(
                              fontsize: 16,
                              fontcolor: Colors.black,
                            ).boldTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      MyTextField(
                        controller: passwordController,
                        hintText: "Enter your password",
                        obscureText: true,
                      ),
                      SizedBox(height: 25),

                      // password field
                      Text(
                        "Confirm your password",
                        style:
                            MyFamilyFont(
                              fontsize: 16,
                              fontcolor: Colors.black,
                            ).boldTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
                      MyTextField(
                        controller: passwordConfirmController,
                        hintText: "Confirm your password",
                        obscureText: true,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 25),

                // 5. Reset Button
                SizedBox(
                  width: double.infinity, // Make button fill width
                  child: ElevatedButton(
                    style: myHeadButton,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text(
                      'Sign Up',
                      style: MyFamilyFont(fontsize: 20).boldTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
