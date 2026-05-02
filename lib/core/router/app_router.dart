import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gdgocms/features/events/upcommingevents.dart';
import 'package:gdgocms/features/login/ui/login_screen.dart';
import 'package:gdgocms/features/login/ui/onboarding_screen.dart';
import 'package:gdgocms/features/login/ui/register_screen.dart';
import 'package:gdgocms/features/main/ui/home/ui/home_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String events = '/events';
  static const String eventDetail = '/events/detail';
}

class AppRouter {
  static GoRouter createRouter({required String initialLocation}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.events,
          builder: (context, state) => const UpcomingEventsScreen(),
        ),
        GoRoute(
          path: AppRoutes.eventDetail,
          pageBuilder: (context, state) {
            final extra = state.extra;
            if (extra is! Map<String, dynamic>) {
              throw ArgumentError(
                'Expected Map<String, dynamic> in state.extra for event detail route.',
              );
            }

            return CustomTransitionPage<void>(
              key: state.pageKey,
              transitionDuration: const Duration(milliseconds: 600),
              reverseTransitionDuration: const Duration(milliseconds: 500),
              child: EventDetailScreen(data: extra),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            );
          },
        ),
      ],
    );
  }
}
