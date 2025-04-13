import 'package:flutter/material.dart';
import 'package:gdgocms/features/login/model/components/textfield.dart';
import 'package:gdgocms/features/login/ui/forgotpass_popup.dart';
import 'package:gdgocms/features/login/ui/signup_popup.dart';
import 'package:gdgocms/features/login/ui/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // text editting controller
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  bool checkAccount = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.backgroundColorLight,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.03),
                      // logo
                      Image.asset(
                        "assets/login_screen/logo_GDG.png",
                        scale: 2.8,
                      ),

                      SizedBox(height: size.height * 0.07),

                      SizedBox(
                        width: size.width * 0.9,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // login text
                            Text(
                              "Sign in",
                              style:
                                  MyFamilyFont(
                                    fontsize: 34,
                                    fontcolor: Colors.black,
                                  ).thinTextStyle,
                            ),

                            SizedBox(height: 25),

                            // username field
                            Text(
                              "ID",
                              style:
                                  MyFamilyFont(
                                    fontsize: 16,
                                    fontcolor: Colors.black,
                                  ).boldTextStyle,
                            ),
                            SizedBox(height: 5),
                            MyTextField(
                              controller: usernameController,
                              hintText: "Your ID",
                              obscureText: false,
                            ),

                            SizedBox(height: 30),

                            // password field
                            Text(
                              "Password",
                              style:
                                  MyFamilyFont(
                                    fontsize: 16,
                                    fontcolor: Colors.black,
                                  ).boldTextStyle,
                            ),
                            SizedBox(height: 5),
                            MyTextField(
                              controller: passwordController,
                              hintText: "Enter your password",
                              obscureText: true,
                            ),

                            SizedBox(height: 5),
                            // forgot password
                            SizedBox(
                              width: size.width * 0.9,
                              child: GestureDetector(
                                onTap: () {
                                  showForgotPasswordDialog(context);
                                },
                                child: Text(
                                  "Forgot Password?",
                                  textAlign: TextAlign.right,
                                  style:
                                      MyFamilyFont(
                                        fontsize: 16,
                                        fontcolor: Color(0xFF1F87FC),
                                      ).boldTextStyle,
                                ),
                              ),
                            ),

                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                      Text(
                        checkAccount
                            ? ""
                            : "Oops! Incorrect password. Try again!",
                        textAlign: TextAlign.center,
                        style:
                            MyFamilyFont(
                              fontsize: 14,
                              fontcolor: Colors.red,
                            ).thinTextStyle,
                      ),

                      SizedBox(height: 10),

                      // signin button
                      SizedBox(
                        width: size.width * 0.75,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            checkAccount = false;
                          },
                          style: myHeadButton,
                          child: Text(
                            "Sign In",
                            style: MyFamilyFont(fontsize: 22).boldTextStyle,
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // others signin
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25.0,
                              ),
                              child: Text(
                                "Or continue with",
                                style:
                                    MyFamilyFont(
                                      fontsize: 18,
                                      fontcolor: Color(0xFF666C73),
                                    ).boldTextStyle,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 25),

                      Image.asset(
                        "assets/login_screen/google_icon.png",
                        scale: 2,
                      ),

                      const SizedBox(height: 25),
                      // register
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Not a member?",
                            style:
                                MyFamilyFont(
                                  fontsize: 18,
                                  fontcolor: Color(0xFF666C73),
                                ).regularTextStyle,
                          ),
                          SizedBox(width: 4),
                          GestureDetector(
                            onTap: () {
                              showSignUpDialog(context);
                            },
                            child: Text(
                              "Create an account",
                              style:
                                  MyFamilyFont(
                                    fontsize: 18,
                                    fontcolor: Color(0xFF1F87FC),
                                  ).regularTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Image.asset("assets/login_screen/footer.png"),
            ],
          ),
        ),
      ),
    );
  }
}
