import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_share/src/common_widgets/app_bar_widget.dart';
import 'package:local_share/src/common_widgets/button_purple.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBarWidget(title: "Mon profil"),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: ButtonPurple(
              onPressed: () {
                ref.read(userProvider.notifier).logout();
                context.goNamed(AppRoute.login.name);
              },
              title: "Se déconnecter",
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
