import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_share/common_widgets/styled_forms.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Inscription', textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text(
                          'Créez votre compte pour commencer',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        Text('Nom d\'utilisateur'),
                        const SizedBox(height: 8),
                        StyledForms(
                          hintText: 'Ex : PaulBrunel23',
                          labelText: 'Nom d\'utilisateur',
                          typeForm: TextInputType.text,
                          textController: nameUserController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text('Adresse mail'),
                        const SizedBox(height: 8),
                        StyledForms(
                          hintText: 'Ex : hugo.curty@bookly.ch',
                          labelText: 'Adresse mail',
                          typeForm: TextInputType.emailAddress,
                          textController: adressEmailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Text('Mot de passe'),
                        const SizedBox(height: 8),
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
                        const SizedBox(height: 28),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {}
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Créer mon compte',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(color: Colors.grey.shade300),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'OU',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: Colors.grey.shade300),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            context.goNamed(AppRoute.login.name);
                          },
                          child: const Text(
                            'Vous avez déjà un compte ? Connectez-vous',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
