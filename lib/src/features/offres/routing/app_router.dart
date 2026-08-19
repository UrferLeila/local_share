import 'package:go_router/go_router.dart';
import 'package:local_share/src/features/offres/presentation/home_screen/home_screen.dart';
import 'package:local_share/src/features/offres/presentation/offre_account/login_page_screen.dart';
import 'package:local_share/src/features/offres/presentation/offre_account/signup_page_screen.dart';

enum AppRoute { home, login, signup }

final goRouter = GoRouter(
  initialLocation: '/login',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/home',
      name: AppRoute.home.name,
      builder: (context, state) {
        final isAdmin = state.extra as bool;
        return HomeScreen(isAdmin: isAdmin);
      },
    ),
    GoRoute(
      path: '/login',
      name: AppRoute.login.name,
      builder: (context, state) => const LoginPageScreen(),
      routes: [
        GoRoute(
          path: '/signup',
          name: AppRoute.signup.name,
          builder: (context, state) => const SignupPageScreen(),
        ),
      ],
    ),
  ],
);
