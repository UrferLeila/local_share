import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_share/common_widgets/styled_forms.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:http/http.dart' as http;

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
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Card(
                elevation: 8,
                shadowColor: Colors.black54,
                color: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Icône décorative aux couleurs de l'application
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C63FF).withValues(alpha :0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.person_add_outlined,
                              color: Color(0xFF6C63FF),
                              size: 36,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Inscription',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF5F6FA),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Créez votre compte pour commencer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFA4B0BE),
                          ),
                        ),
                        const SizedBox(height: 32),

                        StyledForms(
                          hintText: 'Ex : PaulBrunel23',
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
                        const SizedBox(height: 20),

                        StyledForms(
                          hintText: 'Ex : hugo.curty@bookly.ch',
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
                        const SizedBox(height: 20),

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
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              foregroundColor: const Color(0xFFF5F6FA),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Créer mon compte',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(color: Colors.grey.shade800),
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
                              child: Divider(color: Colors.grey.shade800),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            context.goNamed(AppRoute.login.name);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color.fromARGB(
                              255,
                              0,
                              223,
                              212,
                            ),
                          ),
                          child: const Text(
                            'Vous avez déjà un compte ? Connectez-vous',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
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
