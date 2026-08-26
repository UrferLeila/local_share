import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_share/src/common_widgets/app_bar_widget.dart';
import 'package:local_share/src/common_widgets/button.dart';
import 'package:local_share/src/common_widgets/styled_text.dart';
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
        Uri.parse("http://localhost:3000/users/$userId"),
        headers: {'Content-Type': 'application/json'},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User successfully removed!")),
        );
        context.pop();
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["error"] ?? "Error whilst deleting")),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to contact the server : $e")),
      );
    }
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    String userId,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.p16),
          ),
          title: const StyledBase("Supprimer le compte"),
          content: const Text(
            "Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.",
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Annuler", style: TextStyle(color: AppColors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                "Supprimer",
                style: TextStyle(color: AppColors.lightRed),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteUser(userId);
                ref.read(userProvider.notifier).logout();
                if (!context.mounted) return;
                context.goNamed(AppRoute.login.name);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBarWidget(title: "Mon profil"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p24,
            vertical: Sizes.p32,
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(Sizes.p8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.lightPurple.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: Sizes.p48,
                    backgroundColor: AppColors.lightPurple.withValues(
                      alpha: 0.2,
                    ),
                    child: Icon(
                      Icons.person,
                      size: Sizes.p48,
                      color: AppColors.lightPurple,
                    ),
                  ),
                ),
              ),
              gapH20,
              StyledBase(user?.username ?? "Utilisateur"),
              gapH8,
              Text(
                user?.email ?? "",
                style: TextStyle(color: AppColors.grey, fontSize: Sizes.p14),
              ),
              gapH32,

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Sizes.p20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Sizes.p16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.1),
                      blurRadius: Sizes.p12,
                      offset: const Offset(0, Sizes.p4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Informations personnelles",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Divider(height: Sizes.p32),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: Sizes.p20,
                          color: AppColors.lightPurple,
                        ),
                        gapW16,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StyledText("Nom d'utilisateur"),
                            gapH4,
                            StyledBase(user?.username ?? "-"),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: Sizes.p32),
                    Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: Sizes.p20,
                          color: AppColors.lightPurple,
                        ),
                        gapW16,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StyledText("Adresse email"),
                            gapH4,
                            StyledBase(user?.email ?? "-"),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: Sizes.p32),
                    Row(
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: Sizes.p20,
                          color: AppColors.cyan,
                        ),
                        gapW16,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StyledText("Rôle"),
                            gapH4,
                            StyledBase(user?.role ?? "Membre"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              gapH64,
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        onPressed: () {
                          context.pushNamed(AppRoute.edit.name);
                        },
                        icon: Icons.edit,
                        title: "Modifier le profil",
                        color: AppColors.lightPurple,
                      ),
                    ),
                    gapH16,
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        onPressed: () {
                          ref.read(userProvider.notifier).logout();
                          context.goNamed(AppRoute.login.name);
                        },
                        icon: Icons.logout,
                        title: "Se déconnecter",
                        color: AppColors.darkBrown,
                      ),
                    ),
                    gapH16,
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        onPressed: () async {
                          final currentUser = ref.read(userProvider);
                          if (currentUser == null) return;
                          await _showDeleteConfirmation(
                            context,
                            currentUser.id,
                          );
                        },
                        icon: Icons.delete_outline,
                        title: "Supprimer le compte",
                        color: AppColors.lightRed,
                      ),
                    ),
                  ],
                ),
              ),
              gapH32,
            ],
          ),
        ),
      ),
    );
  }
}
