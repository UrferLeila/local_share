import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_share/src/common_widgets/button_cyan.dart';
import 'package:local_share/src/common_widgets/button.dart';
import 'package:local_share/src/common_widgets/styled_forms.dart';
import 'package:local_share/src/common_widgets/styled_forms_password.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_share/src/theme/theme.dart';

class SignupPageScreen extends StatefulWidget {
  const SignupPageScreen({super.key});

  @override
  State<SignupPageScreen> createState() => _SignupPageScreenState();
}

class _SignupPageScreenState extends State<SignupPageScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameUserController = TextEditingController();
  final adressEmailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameUserController.dispose();
    adressEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = nameUserController.text.trim();
    final email = adressEmailController.text.trim();
    final password = passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );

        context.goNamed(AppRoute.login.name);
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
                              Icons.person_add_outlined,
                              color: AppColors.lightPurple,
                              size: Sizes.p32,
                            ),
                          ),
                        ),
                        gapH20,
                        Text(
                          'Inscription',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Sizes.p24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightwhite,
                          ),
                        ),
                        gapH8,
                        Text(
                          'Créez votre compte pour commencer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Sizes.p14,
                            color: AppColors.grey,
                          ),
                        ),
                        gapH32,
                        StyledForms(
                          hintText: 'PaulBrunel23',
                          labelText: 'Nom d\'utilisateur',
                          typeForm: TextInputType.text,
                          textController: nameUserController,
                          prefixIcon: Icons.person_outline_rounded,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                        ),
                        gapH20,
                        StyledForms(
                          hintText: 'hugo.curty@bookly.ch',
                          labelText: 'Adresse mail',
                          typeForm: TextInputType.emailAddress,
                          textController: adressEmailController,
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
                            if (value.length < 8) {
                              return 'Le mot de passe doit contenir au moins 8 caractères';
                            }
                            return null;
                          },
                        ),
                        gapH32,
                        Button(
                          onPressed: signup,
                          title: "Créer mon compte",
                          color: AppColors.lightPurple,
                        ),
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
                            context.goNamed(AppRoute.login.name);
                          },
                          title: 'Vous avez déjà un compte ? Connectez-vous',
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
