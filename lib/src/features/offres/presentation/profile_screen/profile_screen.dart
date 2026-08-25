import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_share/src/common_widgets/app_bar_widget.dart';
import 'package:local_share/src/common_widgets/button.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:local_share/src/theme/theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> deleteUser(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/users/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User successfully removed!')),
        );
        context.pop();
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'Error whilst deleting')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to contact the server : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBarWidget(title: "Mon profil"),
      body: Column(
        children: [
          gapH16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: Sizes.p36,
                  backgroundColor: AppColors.lightPurple.withValues(alpha: 0.2),
                  child: Icon(
                    Icons.person,
                    size: Sizes.p36,
                    color: AppColors.lightPurple,
                  ),
                ),
                gapH24,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Sizes.p16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Sizes.p12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.05),
                        blurRadius: Sizes.p12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: Sizes.p20,
                            color: AppColors.grey,
                          ),
                          gapW12,
                          Text(
                            user?.username ?? "Nom d'utilisateur",
                            style: const TextStyle(
                              fontSize: Sizes.p16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: Sizes.p24),
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: Sizes.p20,
                            color: AppColors.grey,
                          ),
                          gapW12,
                          Text(
                            user?.email ?? "email@exemple.com",
                            style: TextStyle(
                              fontSize: Sizes.p14,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                  onPressed: () async {
                    final user = ref.read(userProvider);
                    if (user == null) return;
                    await deleteUser(user.id);
                    ref.read(userProvider.notifier).logout();
                    if (!context.mounted) return;
                    context.goNamed(AppRoute.login.name);
                  },
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
