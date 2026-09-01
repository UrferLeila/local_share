import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_share/src/common_widgets/scaffold_with_nav_bar.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';
import 'package:local_share/src/features/offres/domain/user.dart';
import 'package:local_share/src/features/offres/presentation/home_screen/edit_offer_screen.dart';
import 'package:local_share/src/features/offres/presentation/home_screen/home_screen.dart';
import 'package:local_share/src/features/offres/presentation/account_screen/login_page_screen.dart';
import 'package:local_share/src/features/offres/presentation/home_screen/create_offer_screen.dart';
import 'package:local_share/src/features/offres/presentation/offers_screen/offers_screen.dart';
import 'package:local_share/src/features/offres/presentation/profile_screen/edit_user_screen.dart';
import 'package:local_share/src/features/offres/presentation/profile_screen/profile_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

enum AppRoute { home, create, login, profil, offres, edit, editOffre }

final goRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/login',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/login',
      name: AppRoute.login.name,
      builder: (context, state) => const LoginPageScreen(),
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
          builder: (context, state) => const OffersScreen(),
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
        final user = state.extra as User;
        return CreateOfferScreen(user: user);
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
        final offer = state.extra as Offre;
        return EditOfferScreen(offer: offer);
      },
    ),
  ],
);
