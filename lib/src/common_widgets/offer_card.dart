import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:local_share/src/common_widgets/styled_text.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/data/offre_list_provider.dart';
import 'package:local_share/src/features/offres/data/user_provider.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';
import 'package:local_share/src/features/offres/domain/user.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:local_share/src/theme/theme.dart';

class OfferCard extends ConsumerStatefulWidget {
  const OfferCard({
    super.key,
    required this.offer,
    required this.isAdmin,
    required this.onDelete,
  });

  final Offre offer;
  final bool isAdmin;
  final Future<void> Function(String) onDelete;

  @override
  ConsumerState<OfferCard> createState() => OffreCardState();
}

class OffreCardState extends ConsumerState<OfferCard> {
  bool isExpanded = false;
  final TextEditingController _propositionController = TextEditingController();

  @override
  void dispose() {
    _propositionController.dispose();
    super.dispose();
  }

  Future<void> _sendProposition(User? currentUser) async {
    final text = _propositionController.text.trim();
    if (text.isEmpty || currentUser == null) return;

    try {
      final response = await http.post(
        Uri.parse(
          "http://localhost:3000/offres/${widget.offer.id}/propositions",
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': currentUser.id,
          'username': currentUser.username,
          'userPhoto': currentUser.photo != null
              ? base64Encode(currentUser.photo!)
              : null,
          'name': text,
          'Date': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _propositionController.clear();
        ref.invalidate(offerListNotifierProvider);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send proposition")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage =
        widget.offer.image != null && widget.offer.image!.isNotEmpty;
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
                        width: Sizes.p72,
                        height: Sizes.p72,
                        color: AppColors.lightBrown,
                        child: hasImage
                            ? (() {
                                try {
                                  Uint8List decodedBytes = base64Decode(
                                    widget.offer.image!,
                                  );
                                  return Image.memory(
                                    decodedBytes,
                                    fit: BoxFit.cover,
                                    width: Sizes.p72,
                                    height: Sizes.p72,
                                  );
                                } catch (e) {
                                  return Icon(
                                    Icons.broken_image_outlined,
                                    color: AppColors.lightPurple,
                                    size: Sizes.p32,
                                  );
                                }
                              })()
                            : Icon(
                                Icons.image_outlined,
                                color: AppColors.lightPurple,
                                size: Sizes.p32,
                              ),
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
                  gapW12,
                  Column(
                    children: [
                      if (widget.isAdmin) ...[
                        InkWell(
                          onTap: () async {
                            final bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const StyledSmallTitle(
                                    "Confirmer la suppression",
                                  ),
                                  content: const StyledBase(
                                    "Voulez-vous vraiment supprimer cet offres ?",
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
                        gapH8,
                      ],
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
                const StyledSmallTitle("Propositions / Chat"),
                gapH8,
                if (widget.offer.propositions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: Sizes.p8),
                    child: StyledBase("Aucune proposition pour le moment."),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.offer.propositions.length,
                    itemBuilder: (context, index) {
                      final prop = widget.offer.propositions[index];

                      final bool isOwner = prop.userId == widget.offer.user;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: Sizes.p4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: Sizes.p16,
                              backgroundColor: isOwner
                                  ? AppColors.cyan
                                  : AppColors
                                        .lightBrown, // Distinct color for owner avatar
                              backgroundImage:
                                  prop.userPhoto != null &&
                                      prop.userPhoto!.isNotEmpty
                                  ? MemoryImage(base64Decode(prop.userPhoto!))
                                  : null,
                              child:
                                  prop.userPhoto == null ||
                                      prop.userPhoto!.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: Sizes.p16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            gapW12,
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(Sizes.p8),
                                decoration: BoxDecoration(
                                  // Give the owner a different background tint (e.g., cyan/purple variation)
                                  color: isOwner
                                      ? AppColors.cyan.withValues(alpha: 0.15)
                                      : AppColors.lightPurple.withValues(
                                          alpha: 0.1,
                                        ),
                                  borderRadius: BorderRadius.circular(Sizes.p8),
                                  border: isOwner
                                      ? Border.all(
                                          color: AppColors.cyan.withValues(
                                            alpha: 0.4,
                                          ),
                                          width: 1,
                                        )
                                      : null, // Optional border highlight for owner
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            StyledLink(prop.username),
                                            if (isOwner) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.cyan,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  "Auteur", // Or "Owner"
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        Text(
                                          "${prop.date.hour.toString().padLeft(2, '0')}:${prop.date.minute.toString().padLeft(2, '0')}",
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.lightwhite
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                    gapH4,
                                    StyledBase(prop.description),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                gapH12,
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _propositionController,
                        decoration: const InputDecoration(
                          hintText: "Écrire une proposition...",
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: AppColors.lightPurple),
                      onPressed: () => _sendProposition(currentUser),
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
}
