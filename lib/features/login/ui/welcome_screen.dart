import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdgocms/features/login/ui/login_screen.dart';
import 'package:gdgocms/features/login/ui/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late SharedPreferences prefs;
  final PageController _controller = PageController();
  Alignment alignFrame = Alignment(0, -0.75);
  bool onLastPage = true;
  int pageIndex = 0;
  List<Color> indicatorColor = AppColor.activeIndicatorColors;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: AppColor.backgroundColorLight,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                alignment: Alignment(0, 0.1),
                height: 50,
                child: SvgPicture.asset("assets/welcome_screen/Name.svg"),
              ),
              PageView(
                onPageChanged: (value) {
                  setState(() {
                    onLastPage = (value != 3);
                    pageIndex = value;
                  });
                },
                controller: _controller,
                children: [
                  SvgPicture.asset(
                    alignment: alignFrame,
                    "assets/welcome_screen/Frame_1.svg",
                    height: 200,
                  ),
                  SvgPicture.asset(
                    alignment: alignFrame,
                    "assets/welcome_screen/Frame_2.svg",
                    height: 200,
                  ),
                  Image.asset(
                    alignment: alignFrame,
                    "assets/welcome_screen/Frame_3.png",
                    height: 200,
                  ),
                  Image.asset(
                    alignment: alignFrame,
                    "assets/welcome_screen/Frame_4.png",
                    height: 200,
                  ),
                ],
              ),

              Container(
                alignment: Alignment(0, 0),
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: WormEffect(
                    // Use ExpandingDotsEffect
                    dotHeight: 10.0, // Height of the indicators
                    dotWidth: 30.0,
                    activeDotColor:
                        indicatorColor[pageIndex], // Active color from image
                    dotColor: AppColor.inactiveIndicatorGrey,
                    // expansionFactor:
                    //     2,
                  ),
                ),
              ),

              Container(
                alignment: Alignment(0, 0.85),
                child: SizedBox(
                  width: size.width * 0.9,
                  child:
                      onLastPage
                          ? ElevatedButton(
                            onPressed: () {
                              _controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve:
                                    (pageIndex == 0)
                                        ? Curves.easeOutBack
                                        : Curves.easeInOutBack,
                              );
                            },
                            style: myHeadButton,
                            child: Text(
                              "Continue",
                              style: MyFamilyFont(fontsize: 20).boldTextStyle,
                            ),
                          )
                          : ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LoginScreen();
                                  },
                                ),
                              );
                            },
                            style: myHeadButton,
                            child: Text(
                              "Start",
                              style: MyFamilyFont(fontsize: 20).boldTextStyle,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
