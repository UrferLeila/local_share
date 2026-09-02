import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_share/src/common_widgets/button.dart';
import 'package:local_share/src/common_widgets/styled_text.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/controller/microsoft_login_cubit.dart';
import 'package:local_share/src/controller/microsoft_login_state.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:local_share/src/theme/theme.dart';

class LoginPageScreen extends ConsumerWidget {
  const LoginPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ref
                .read(userProvider.notifier)
                .setMicrosoftUser(
                  id: state.email,
                  username: state.name,
                  email: state.email,
                  role: 'user',
                  photo: state.photo,
                );
            context.goNamed(AppRoute.home.name);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Sizes.p24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: Sizes.p448),
                  child: Card(
                    elevation: Sizes.p8,
                    shadowColor: AppColors.black,
                    color: AppColors.darkBrown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Sizes.p20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.p32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(Sizes.p12),
                              decoration: BoxDecoration(
                                color: AppColors.lightPurple.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(Sizes.p16),
                              ),
                              child: Icon(
                                Icons.hub,
                                color: AppColors.lightPurple,
                                size: Sizes.p32,
                              ),
                            ),
                          ),
                          gapH20,
                          const StyledTitle("Connexion"),
                          gapH8,
                          const StyledText(
                            "Connectez-vous à votre compte Microsoft",
                          ),
                          gapH32,
                          Button(
                            onPressed: isLoading
                                ? () {}
                                : () => context.read<AuthCubit>().login(),
                            title: isLoading
                                ? "Connexion en cours..."
                                : "Se connecter avec Microsoft",
                            color: AppColors.lightPurple,
                          ),
                          if (isLoading) ...[
                            gapH20,
                            Center(
                              child: CircularProgressIndicator(
                                color: AppColors.lightPurple,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
