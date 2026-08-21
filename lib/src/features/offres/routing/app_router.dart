import 'package:go_router/go_router.dart';
import 'package:local_share/src/common_widgets/scaffold_with_nav_bar.dart';
import 'package:local_share/src/features/offres/domain/user.dart';
import 'package:local_share/src/features/offres/presentation/Home_screen/home_screen.dart';
import 'package:local_share/src/features/offres/presentation/account_screen/login_page_screen.dart';
import 'package:local_share/src/features/offres/presentation/account_screen/signup_page_screen.dart';
import 'package:local_share/src/features/offres/presentation/home_screen/create_offre_screen.dart';
import 'package:local_share/src/features/offres/presentation/my_offers_screen/my_offers_screen.dart';
import 'package:local_share/src/features/offres/presentation/profile_screen/profile_screen.dart';

enum AppRoute { home, creatOffer, login, signup, profil, myOffers }

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
          path: '/signup',
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
          routes: [
            GoRoute(
              path: '/create',
              name: AppRoute.creatOffer.name,
              builder: (context, state) {
                final currentUser = state.extra as User;
                return CreateOffreScreen(currentUser: currentUser);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/myOffers',
          name: AppRoute.myOffers.name,
          builder: (context, state) => const MyOffersScreen(),
        ),
        GoRoute(
          path: '/profil',
          name: AppRoute.profil.name,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
