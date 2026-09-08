import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:local_share/src/common_widgets/app_bar_widget.dart';
import 'package:local_share/src/common_widgets/button.dart';
import 'package:local_share/src/common_widgets/styled_forms.dart';
import 'package:local_share/src/common_widgets/styled_text.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/domain/offer.dart';
import 'package:local_share/src/theme/theme.dart';

class EditOfferScreen extends ConsumerStatefulWidget {
  const EditOfferScreen({super.key, required this.offer});

  final Offer offer;

  @override
  ConsumerState<EditOfferScreen> createState() => _EditOfferScreenState();
}

class _EditOfferScreenState extends ConsumerState<EditOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;

  late String _selectedType;
  final List<String> _offerTypes = ["achat", "service", "pret"];

  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.offer.name);
    descriptionController = TextEditingController(
      text: widget.offer.description ?? '',
    );

    // Map existing offer type enum/string to match dropdown items
    _selectedType = widget.offer.type.toShortString().toLowerCase();
    if (!_offerTypes.contains(_selectedType)) {
      _selectedType = "achat";
    }

    // Decode existing base64 image if available
    if (widget.offer.image != null && widget.offer.image!.isNotEmpty) {
      try {
        _imageBytes = base64Decode(widget.offer.image!);
      } catch (_) {
        _imageBytes = null;
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: Sizes.p70.toInt(),
      maxWidth: 1200,
      maxHeight: 1200,
    );

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  Future<void> updateOffer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = nameController.text.trim();
    final description = descriptionController.text.trim();

    String? base64Image;
    if (_imageBytes != null) {
      base64Image = base64Encode(_imageBytes!);
    }

    int typeIndex;
    switch (_selectedType) {
      case 'achat':
        typeIndex = 1;
        break;
      case 'service':
        typeIndex = 2;
        break;
      case 'pret':
      default:
        typeIndex = 0;
        break;
    }

    try {
      String baseUrl = kIsWeb
          ? "https://localhost:7024"
          : "https://155.69.160.32:7024";

      final response = await http.put(
        Uri.parse("$baseUrl/api/offer/${widget.offer.id}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "offerId": int.tryParse(widget.offer.id) ?? widget.offer.id,
          "name": name,
          "description": description,
          "image": base64Image ?? widget.offer.image ?? "url_de_image",
          "type": typeIndex,
          "userId": int.tryParse(widget.offer.user) ?? 1,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Offer successfully amended!")),
        );
        context.pop(true);
      } else {
        if (!mounted) return;
        String errorMessage = "An error has occurred (${response.statusCode})";
        try {
          final data = jsonDecode(response.body);
          if (data is Map && data.containsKey("error")) {
            errorMessage = data["error"];
          }
        } catch (_) {
          errorMessage = response.body.isNotEmpty
              ? response.body
              : errorMessage;
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
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
                        StyledTitle("Modifier l'offre"),
                        gapH8,
                        StyledText(
                          "Modifier l'image, le titre, ou encore la description",
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
                            height: Sizes.p160,
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
                                        "Appuyez pour modifier l'image",
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        gapH20,
                        StyledForms(
                          labelText: "Titre de l'offre",
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
                        gapH20,
                        DropdownButtonFormField<String>(
                          initialValue: _selectedType,
                          dropdownColor: AppColors.darkBrown,
                          style: TextStyle(
                            color: AppColors.lightwhite,
                            fontSize: Sizes.p16,
                          ),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: AppColors.lightPurple),
                            prefixIcon: Icon(
                              Icons.category_outlined,
                              color: AppColors.lightPurple,
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
                          ),
                          items: _offerTypes.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedType = newValue;
                              });
                            }
                          },
                        ),
                        gapH32,
                        Button(
                          onPressed: updateOffer,
                          title: "Modifier l'offre",
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
