import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_share/src/common_widgets/button_cyan.dart';
import 'package:local_share/src/common_widgets/button_purple.dart';
import 'package:local_share/src/common_widgets/styled_forms.dart';
import 'package:local_share/src/common_widgets/styled_forms_password.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_share/src/theme/theme.dart';

class LoginPageScreen extends ConsumerStatefulWidget {
  const LoginPageScreen({super.key});

  @override
  ConsumerState<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends ConsumerState<LoginPageScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameUserController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameUserController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = nameUserController.text.trim();
    final password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (!mounted) return;

        ref.read(userProvider.notifier).setUser(data['user']);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login successful!')));

        context.goNamed(AppRoute.home.name);
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'An error has occurred')),
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
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Sizes.p24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Card(
                elevation: Sizes.p8,
                shadowColor: AppColors.black,
                color: AppColors.darkBrown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.p20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.p32),
                  child: Form(
                    key: _formKey,
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
                        Text(
                          'Connexion',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Sizes.p24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightwhite,
                          ),
                        ),
                        gapH8,
                        Text(
                          'Connectez-vous à votre compte',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Sizes.p14,
                            color: AppColors.grey,
                          ),
                        ),
                        gapH32,
                        StyledForms(
                          hintText: 'hugo.curty@bookly.ch',
                          labelText: 'Adresse mail',
                          typeForm: TextInputType.emailAddress,
                          textController: nameUserController,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                        ),
                        gapH20,
                        StyledFormsPassword(
                          hintText: 'Votre mot de passe',
                          labelText: 'Mot de passe',
                          typeForm: TextInputType.visiblePassword,
                          textController: passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                        ),
                        gapH32,
                        ButtonPurple(onPressed: login, title: "Se connecter"),
                        gapH24,
                        Row(
                          children: [
                            Expanded(child: Divider(color: AppColors.grey)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.p12,
                              ),
                              child: Text(
                                'OU',
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: Sizes.p12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: AppColors.grey)),
                          ],
                        ),
                        gapH16,
                        ButtonCyan(
                          onPressed: () {
                            context.goNamed(AppRoute.signup.name);
                          },
                          title: 'Pas encore de compte ? Inscrivez-vous',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
