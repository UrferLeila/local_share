import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_share/src/common_widgets/app_bar_widget.dart';
import 'package:local_share/src/common_widgets/button.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:local_share/src/theme/theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBarWidget(title: "Mon profil"),
      body: Column(
        children: [
          Text("Nom d'utilisateur : ${user?.username}"),
          const Spacer(),
          Center(
            child: Column(
              children: [
                gapH12,
                Button(
                  onPressed: () {
                    ref.read(userProvider.notifier).logout();
                    context.goNamed(AppRoute.login.name);
                  },
                  icon: Icons.logout,
                  title: "Se déconnecter",
                  color: AppColors.lightPurple,
                ),
                gapH12,
                Button(
                  onPressed: () {},
                  icon: Icons.edit,
                  title: "Modifier",
                  color: AppColors.lightPurple,
                ),
                gapH12,
                Button(
                  onPressed: () {},
                  icon: Icons.delete,
                  title: "Supprimer",
                  color: AppColors.lightRed,
                ),
              ],
            ),
          ),
          gapH24,
        ],
      ),
    );
  }
}
