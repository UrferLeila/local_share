import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:local_share/src/common_widgets/app_bar_widget.dart';
import 'package:local_share/src/common_widgets/button.dart';
import 'package:local_share/src/common_widgets/styled_forms.dart';
import 'package:local_share/src/common_widgets/styled_text.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/theme/theme.dart';
import 'package:local_share/src/features/offres/domain/user.dart';

class CreateOffreScreen extends StatefulWidget {
  const CreateOffreScreen({super.key, required this.currentUser});

  final User currentUser;

  @override
  State<CreateOffreScreen> createState() => _CreateOffreScreenState();
}

class _CreateOffreScreenState extends State<CreateOffreScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  Uint8List? _imageBytes;

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> createOffer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = nameController.text.trim();
    final description = descriptionController.text.trim();

    String? base64Image;
    if (_imageBytes != null) {
      base64Image = base64Encode(_imageBytes!);
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/offres'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'description': description,
          'user': widget.currentUser.id,
          'image': base64Image,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offre créée avec succès !')),
        );

        context.pop(true);
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
                        StyledTitle("Nouvelle offre"),
                        gapH8,
                        StyledText(
                          "Partagez une ressource ou un service localement",
                        ),
                        gapH32,
                        StyledBase(
                          "Image de l'offre",
                          textAlign: TextAlign.left,
                        ),
                        gapH8,
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 160,
                            decoration: BoxDecoration(
                              color: AppColors.lightBrown,
                              borderRadius: BorderRadius.circular(Sizes.p12),
                              border: Border.all(
                                color: AppColors.lightPurple.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: _imageBytes != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Sizes.p12,
                                    ),
                                    child: Image.memory(
                                      _imageBytes!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_a_photo_outlined,
                                        color: AppColors.lightPurple,
                                        size: Sizes.p36,
                                      ),
                                      gapH8,
                                      StyledText(
                                        "Appuyez pour ajouter une image",
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        gapH20,
                        StyledForms(
                          hintText: 'Perçeuse Bosch / Cours de guitare',
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
                        StyledForms(
                          labelText: "Description",
                          typeForm: TextInputType.text,
                          textController: descriptionController,
                          prefixIcon: Icons.description_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            return null;
                          },
                        ),
                        gapH32,
                        Button(
                          onPressed: createOffer,
                          title: "Publier l'offre",
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
