import 'package:go_router/go_router.dart';
import 'package:local_share/src/common_widgets/scaffold_with_nav_bar.dart';
import 'package:local_share/src/features/offres/domain/user.dart';
import 'package:local_share/src/features/offres/presentation/home_screen/edit_offre_screen.dart';
import 'package:local_share/src/features/offres/presentation/home_screen/home_screen.dart';
import 'package:local_share/src/features/offres/presentation/account_screen/login_page_screen.dart';
import 'package:local_share/src/features/offres/presentation/account_screen/signup_page_screen.dart';
import 'package:local_share/src/features/offres/presentation/home_screen/create_offre_screen.dart';
import 'package:local_share/src/features/offres/presentation/offres_screen/offres_screen.dart';
import 'package:local_share/src/features/offres/presentation/profile_screen/edit_user_screen.dart';
import 'package:local_share/src/features/offres/presentation/profile_screen/profile_screen.dart';

enum AppRoute { home, create, login, signup, profil, offres, edit, editOffre }

final goRouter = GoRouter(
  initialLocation: '/login',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/login',
      name: AppRoute.login.name,
      builder: (context, state) => const LoginPageScreen(),
      routes: [
        GoRoute(
          path: 'signup',
          name: AppRoute.signup.name,
          builder: (context, state) => const SignupPageScreen(),
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          name: AppRoute.home.name,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/offres',
          name: AppRoute.offres.name,
          builder: (context, state) => const OffresScreen(),
        ),
        GoRoute(
          path: '/profil',
          name: AppRoute.profil.name,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/create',
      name: AppRoute.create.name,
      builder: (context, state) {
        final currentUser = state.extra as User;
        return CreateOffreScreen(currentUser: currentUser);
      },
    ),
    GoRoute(
      path: '/edit',
      name: AppRoute.edit.name,
      builder: (context, state) {
        return EditUserScreen();
      },
    ),
    GoRoute(
      path: '/editOffre',
      name: AppRoute.editOffre.name,
      builder: (context, state) {
        return EditOffreScreen();
      },
    ),
  ],
);
