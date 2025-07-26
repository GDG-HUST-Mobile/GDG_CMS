// main.dart
import 'package:flutter/material.dart';
import 'package:gdgocms/core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'package:gdgocms/core/utils/shared_prefs_service.dart';
import 'features/login/ui/factories/widget_factory.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsService.init();
  PlatformWidgetFactory.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GDG-CMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: AppRouter.router,
    );
  }
}
