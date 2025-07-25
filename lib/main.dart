// main.dart
import 'package:flutter/material.dart';
import 'package:gdgocms/features/login/ui/login_screen.dart';
import 'package:gdgocms/features/login/ui/welcome_screen.dart';

import 'core/utils/shared_prefs_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefsService.init();

  bool hasSeenWelcome = SharedPrefsService.getSeenState();

  Widget initialScreen =
      hasSeenWelcome ? const LoginScreen() : const WelcomeScreen();

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: initialScreen,
    );
  }
}
