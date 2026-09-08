import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_share/src/common_widgets/styled_text.dart';
import 'package:local_share/src/common_widgets/suggestion_card.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/data/offer_list_provider.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/features/offres/domain/offer.dart';
import 'package:local_share/src/features/offres/domain/user.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:local_share/src/theme/theme.dart';

class OfferCard extends ConsumerStatefulWidget {
  const OfferCard({
    super.key,
    required this.isAdmin,
    required this.offer,
    required this.onDelete,
    required this.user,
  });

  final bool isAdmin;
  final Offer offer;
  final Future<void> Function(String) onDelete;
  final User user;

  @override
  ConsumerState<OfferCard> createState() => OfferCardState();
}

class OfferCardState extends ConsumerState<OfferCard> {
  bool isExpanded = false;
  final TextEditingController suggestionController = TextEditingController();

  @override
  void dispose() {
    suggestionController.dispose();
    super.dispose();
  }

  String getBaseUrl() {
    return kIsWeb ? "https://localhost:7024" : "https://10.0.2.2:7024";
  }

  Future<void> deleteSuggestion(dynamic suggestionId) async {
    final baseUrl = getBaseUrl();
    final response = await http.delete(
      Uri.parse("$baseUrl/api/Suggestion/$suggestionId"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      ref.invalidate(offerListNotifierProvider);
    } else {
      throw Exception("Failed to delete the suggestion: ${response.body}");
    }
  }

  Future<void> editSuggestion(
    dynamic suggestionId,
    String newText,
    dynamic suggestion,
  ) async {
    final baseUrl = getBaseUrl();
    final response = await http.put(
      Uri.parse("$baseUrl/api/Suggestion/$suggestionId"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "suggestionId": suggestionId,
        "offerId": widget.offer.id,
        "name": newText,
        "username": suggestion.username,
        "userPhoto": suggestion.userPhoto ?? 0,
        "userId": suggestion.userId,
        "room": "DefaultRoom",
        "date": suggestion.date.toIso8601String(),
      }),
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      ref.invalidate(offerListNotifierProvider);
    } else {
      throw Exception("Failed to edit the suggestion: ${response.body}");
    }
  }

  Future<void> sendSuggestion(User? currentUser) async {
    final text = suggestionController.text.trim();
    final azureId = widget.user.id.toString();
    if (text.isEmpty || currentUser == null) return;

    try {
      final baseUrl = getBaseUrl();
      final url = Uri.parse("$baseUrl/api/Suggestion");

      final bodyData = {
        "offerId": widget.offer.id,
        "name": text,
        "username": currentUser.username,
        "userPhoto": 0,
        "userId": azureId,
        "room": "DefaultRoom",
        "date": DateTime.now().toIso8601String(),
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        suggestionController.clear();
        ref.invalidate(offerListNotifierProvider);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erreur serveur (${response.statusCode}) : ${response.body}",
            ),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) print("Exception attrapée : $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur de connexion : $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // final hasImage = widget.offer.image != null && widget.offer.image!.isNotEmpty;
    final currentUser = ref.watch(userProvider);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Sizes.p16,
        vertical: Sizes.p8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(Sizes.p12),
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.p8),
                      border: Border.all(
                        color: AppColors.lightPurple,
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Sizes.p8),
                      child: Container(
                        width: Sizes.p70,
                        height: Sizes.p70,
                        color: AppColors.lightBrown,
                        child: buildOfferImage(),
                      ),
                    ),
                  ),
                  gapW16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: StyledSmallTitle(widget.offer.name),
                            ),
                            gapW12,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.p8,
                                vertical: Sizes.p4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cyan.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(Sizes.p8),
                              ),
                              child: StyledLink(
                                widget.offer.type.toShortString(),
                              ),
                            ),
                          ],
                        ),
                        gapH4,
                        AnimatedCrossFade(
                          firstChild: StyledBase(
                            widget.offer.description ?? "",
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                          secondChild: StyledBase(
                            widget.offer.description ?? "",
                            textAlign: TextAlign.left,
                          ),
                          crossFadeState: isExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 200),
                        ),
                      ],
                    ),
                  ),
                  gapW8,
                  Row(
                    children: [
                      if (widget.isAdmin) ...[
                        gapH8,
                        InkWell(
                          onTap: () async {
                            final result = await context.pushNamed<bool>(
                              AppRoute.editOffre.name,
                              extra: widget.offer,
                            );
                            if (result == true && mounted) {
                              ref.invalidate(offerListNotifierProvider);
                            }
                          },
                          borderRadius: BorderRadius.circular(Sizes.p8),
                          child: Container(
                            width: Sizes.p40,
                            height: Sizes.p40,
                            decoration: BoxDecoration(
                              color: AppColors.lightPurple,
                              borderRadius: BorderRadius.circular(Sizes.p8),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: AppColors.lightwhite,
                              size: Sizes.p20,
                            ),
                          ),
                        ),
                        gapW8,
                        InkWell(
                          onTap: () async {
                            final bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const StyledSmallTitle(
                                    "Confirmer la suppression",
                                  ),
                                  content: StyledBase(
                                    "Voulez-vous vraiment supprimer cet offre ?",
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const StyledText("Annuler"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const StyledText("Supprimer"),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirm == true) {
                              widget.onDelete(widget.offer.id);
                            }
                          },
                          borderRadius: BorderRadius.circular(Sizes.p8),
                          child: Container(
                            width: Sizes.p40,
                            height: Sizes.p40,
                            decoration: BoxDecoration(
                              color: AppColors.lightPurple,
                              borderRadius: BorderRadius.circular(Sizes.p8),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: AppColors.lightwhite,
                              size: Sizes.p20,
                            ),
                          ),
                        ),
                      ],
                      gapW8,
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.lightwhite.withValues(alpha: 0.5),
                        size: Sizes.p20,
                      ),
                    ],
                  ),
                ],
              ),
              if (isExpanded) ...[
                const Divider(height: Sizes.p24),
                const StyledSmallTitle("Suggestion"),
                gapH8,
                if (widget.offer.suggestions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.p8),
                    child: Center(
                      child: StyledBase("Aucune suggestion pour le moment."),
                    ),
                  )
                else
                  SizedBox(
                    height: Sizes.p236,
                    child: ListView.builder(
                      shrinkWrap: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: widget.offer.suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = widget.offer.suggestions[index];
                        return SuggestionCard(
                          offer: widget.offer,
                          index: index,
                          onDelete: () => deleteSuggestion(suggestion.id),
                          onEdit: () async {
                            final textController = TextEditingController(
                              text: suggestion.description,
                            );

                            final bool? confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const StyledSmallTitle(
                                    "Modifier la suggestion",
                                  ),
                                  content: TextField(
                                    controller: textController,
                                    decoration: const InputDecoration(
                                      hintText: "Nouveau texte...",
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const StyledText("Annuler"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const StyledText("Enregistrer"),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirmed == true &&
                                textController.text.trim().isNotEmpty) {
                              await editSuggestion(
                                suggestion.id,
                                textController.text.trim(),
                                suggestion,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                gapH12,
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: suggestionController,
                        decoration: const InputDecoration(
                          hintText: "Écrire une suggestion...",
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: AppColors.lightPurple),
                      onPressed: () => sendSuggestion(currentUser),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOfferImage() {
    final imgStr = widget.offer.image;

    if (imgStr == null || imgStr.isEmpty || imgStr.toLowerCase() == "null") {
      return Icon(
        Icons.image_outlined,
        color: AppColors.lightPurple,
        size: Sizes.p32,
      );
    }

    try {
      String cleanBase64 = imgStr;
      if (imgStr.contains(",")) {
        cleanBase64 = imgStr.split(",").last;
      }

      Uint8List decodedBytes = base64Decode(cleanBase64);

      if (decodedBytes.isEmpty) {
        return Icon(
          Icons.image_outlined,
          color: AppColors.lightPurple,
          size: Sizes.p32,
        );
      }

      return Image.memory(
        decodedBytes,
        fit: BoxFit.cover,
        width: Sizes.p70,
        height: Sizes.p70,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.broken_image_outlined,
            color: AppColors.lightPurple,
            size: Sizes.p32,
          );
        },
      );
    } catch (e) {
      return Icon(
        Icons.broken_image_outlined,
        color: AppColors.lightPurple,
        size: Sizes.p32,
      );
    }
  }
}
