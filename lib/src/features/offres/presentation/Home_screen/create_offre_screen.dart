import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_share/src/common_widgets/app_bar_widget.dart';
import 'package:local_share/src/common_widgets/styled_forms.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/theme/theme.dart';

class CreateOffreScreen extends StatefulWidget {
  const CreateOffreScreen({super.key});

  @override
  State<CreateOffreScreen> createState() => _CreateOffreScreenState();
}

class _CreateOffreScreenState extends State<CreateOffreScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> createOffer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = nameController.text.trim();
    final description = descriptionController.text.trim();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/offres'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'description': description,
          'user': '6a84554f1b1382e66b754fc2',
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offre créée avec succès !')),
        );

        context.pop();
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'] ?? 'Une erreur est survenue')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible de contacter le serveur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBarWidget(title: "Créer une offre"),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Sizes.p52),
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
                              Icons.local_offer_outlined,
                              color: AppColors.lightPurple,
                              size: Sizes.p36,
                            ),
                          ),
                        ),
                        gapH20,
                        Text(
                          'Nouvelle offre',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Sizes.p24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.lightwhite,
                          ),
                        ),
                        gapH8,
                        Text(
                          'Partagez une ressource ou un service localement',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Sizes.p14,
                            color: AppColors.grey,
                          ),
                        ),
                        gapH32,
                        StyledForms(
                          hintText: 'Ex : Perçeuse Bosch / Cours de guitare',
                          labelText: 'Titre de l\'offre',
                          typeForm: TextInputType.text,
                          textController: nameController,
                          prefixIcon: Icons.title_rounded,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                        ),
                        gapH20,
                        TextFormField(
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(color: AppColors.lightwhite),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Description',
                            hintText:
                                'Décrivez ce que vous proposez en quelques mots...',
                            alignLabelWithHint: true,
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: Sizes.p60),
                              child: Icon(Icons.description_outlined),
                            ),
                            filled: true,
                            fillColor: AppColors.lightBrown,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: Sizes.p18,
                              vertical: Sizes.p18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Sizes.p12),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Sizes.p12),
                              borderSide: BorderSide(
                                color: AppColors.lightPurple.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Sizes.p12),
                              borderSide: BorderSide(
                                color: AppColors.lightPurple,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Sizes.p12),
                              borderSide: BorderSide(color: AppColors.lightRed),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Sizes.p12),
                              borderSide: BorderSide(color: AppColors.lightRed),
                            ),
                            labelStyle: TextStyle(color: AppColors.grey),
                            hintStyle: TextStyle(
                              color: AppColors.grey.withValues(alpha: 0.5),
                            ),
                            prefixIconColor: AppColors.lightPurple,
                          ),
                        ),
                        gapH32,
                        SizedBox(
                          height: Sizes.p52,
                          child: ElevatedButton(
                            onPressed: createOffer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.lightPurple,
                              foregroundColor: AppColors.lightwhite,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Sizes.p12),
                              ),
                            ),
                            child: const Text(
                              'Publier l\'offre',
                              style: TextStyle(
                                fontSize: Sizes.p16,
                                fontWeight: FontWeight.bold,
                              ),
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
