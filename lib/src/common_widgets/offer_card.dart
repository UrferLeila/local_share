import 'dart:convert'; 
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_share/src/common_widgets/styled_text.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';
import 'package:local_share/src/features/offres/routing/app_router.dart';
import 'package:local_share/src/theme/theme.dart';

class OfferCard extends StatefulWidget {
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
  State<OfferCard> createState() => OffreCardState();
}

class OffreCardState extends State<OfferCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasImage =
        widget.offer.image != null && widget.offer.image!.isNotEmpty;

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.p8),
                  border: Border.all(color: AppColors.lightPurple, width: 1.5),
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
                        Expanded(child: StyledSmallTitle(widget.offer.name)),
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
                          child: StyledLink("Disponible"),
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
                      onTap: () => widget.onDelete(widget.offer.id),
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
                      onTap: () => context.pushNamed(
                        AppRoute.editOffre.name,
                        extra: widget.offer,
                      ),
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
        ),
      ),
    );
  }
}
