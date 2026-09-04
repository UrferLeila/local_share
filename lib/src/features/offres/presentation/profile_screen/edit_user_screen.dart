import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_share/src/common_widgets/app_bar_widget.dart';
import 'package:local_share/src/common_widgets/button.dart';
import 'package:local_share/src/common_widgets/styled_forms.dart';
import 'package:local_share/src/common_widgets/styled_text.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/theme/theme.dart';

class EditUserScreen extends ConsumerStatefulWidget {
  const EditUserScreen({super.key});

  @override
  ConsumerState<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController usernameController;
  late final TextEditingController emailController;

  @override
  void initState() {
    super.initState();

    usernameController = TextEditingController();
    emailController = TextEditingController();

    ref.listenManual(userProvider, (previous, next) {
      if (next != null && usernameController.text.isEmpty) {
        usernameController.text = next.username;
        emailController.text = next.email;
      }
    });

    final user = ref.read(userProvider);

    if (user != null) {
      usernameController.text = user.username;
      emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> updateUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = ref.read(userProvider);

    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not found")));
      return;
    }

    final username = usernameController.text.trim();
    final email = emailController.text.trim();

    try {
      String baseUrl = kIsWeb
          ? "https://localhost:7024"
          : "https://10.0.2.2:7024";
      final response = await http.put(
        Uri.parse("$baseUrl/api/users/${user.id}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"username": username, "email": email}),
      );

      final contentType = response.headers["content-type"] ?? "";
      if (!contentType.contains("application/json")) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erreur serveur (Code ${response.statusCode}) : Le serveur n'a pas renvoyé du JSON.",
            ),
          ),
        );
        return;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == Sizes.p200) {
        if (data is Map<String, dynamic> && data['user'] != null) {
          await ref
              .read(userProvider.notifier)
              .setUser(Map<String, dynamic>.from(data["user"]));
        } else {
          await ref.read(userProvider.notifier).setUser({
            "id": user.id,
            "username": username,
            "email": email,
            "role": user.role,
          });
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account successfully updated!")),
        );

        context.pop(true);
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["error"] ?? "An error has occurred")),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to contact the server: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBarWidget(title: "Modifier"),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Sizes.p62),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: Sizes.p500),
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
                              Icons.edit,
                              color: AppColors.lightPurple,
                              size: Sizes.p36,
                            ),
                          ),
                        ),
                        gapH20,
                        StyledTitle("Modifier votre compte"),
                        gapH8,
                        StyledText(
                          "Modifier votre nom d'utilisateur ou votre email",
                        ),
                        gapH32,
                        StyledForms(
                          typeForm: TextInputType.text,
                          textController: usernameController,
                          prefixIcon: Icons.person_rounded,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Veuillez remplir ce champ";
                            }
                            return null;
                          },
                        ),
                        gapH20,
                        StyledForms(
                          typeForm: TextInputType.text,
                          textController: emailController,
                          prefixIcon: Icons.email,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Veuillez remplir ce champ";
                            }
                            return null;
                          },
                        ),
                        gapH32,
                        Button(
                          onPressed: updateUser,
                          title: "Modifier mon compte",
                          color: AppColors.lightPurple,
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
