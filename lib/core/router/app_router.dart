// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import '../../features/login/ui/login_screen.dart';
import '../../features/login/ui/welcome_screen.dart';
import 'package:gdgocms/core/utils/shared_prefs_service.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',

    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],

    redirect: (context, state) {
    final hasSeenWelcome = SharedPrefsService.getSeenState();
    final isGoingToWelcome = state.matchedLocation == '/';

    if (isGoingToWelcome && hasSeenWelcome) {
    return '/login';
    }
    return null;
  },

    errorBuilder: (context, state) {
      return const WelcomeScreen();
    },
  );
}