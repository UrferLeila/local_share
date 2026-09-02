import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_share/src/common_widgets/app_bar_widget.dart';
import 'package:local_share/src/common_widgets/button.dart';
import 'package:local_share/src/common_widgets/styled_text.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/controller/microsoft_login_cubit.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:local_share/src/theme/theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _handleLogout() async {
    try {
      context.read<AuthCubit>().logout();

      await ref.read(userProvider.notifier).logout();

      if (!mounted) return;

      context.goNamed(AppRoute.login.name);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la déconnexion : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final userPhoto = user?.photo;

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
                    backgroundImage: userPhoto != null
                        ? MemoryImage(userPhoto)
                        : null,
                    child: userPhoto == null
                        ? Icon(
                            Icons.person,
                            size: Sizes.p48,
                            color: AppColors.lightPurple,
                          )
                        : null,
                  ),
                ),
              ),
              gapH20,
              StyledBase(user?.username ?? "Utilisateur"),
              gapH8,
              Text(
                user?.email ?? "",
                style: TextStyle(color: AppColors.grey, fontSize: Sizes.p16),
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
                      color: AppColors.darkBrown,
                      blurRadius: Sizes.p12,
                      offset: const Offset(0, Sizes.p4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StyledSmallTitle("Informations personnelles"),
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
                    gapH32,
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
                    gapH32,
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
                child: Button(
                  onPressed: _handleLogout,
                  icon: Icons.logout,
                  title: "Se déconnecter",
                  color: AppColors.darkBrown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
