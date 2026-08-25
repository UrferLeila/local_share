import 'dart:convert'; // Added for base64Decode
import 'package:flutter/foundation.dart'; // Added for Uint8List
import 'package:flutter/material.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';
import 'package:local_share/src/theme/theme.dart';

class OffreCard extends StatefulWidget {
  const OffreCard({
    super.key,
    required this.offre,
    required this.isAdmin,
    required this.onDelete,
  });

  final Offre offre;
  final bool isAdmin;
  final Future<void> Function(String) onDelete;

  @override
  State<OffreCard> createState() => OffreCardState();
}

class OffreCardState extends State<OffreCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasImage =
        widget.offre.image != null && widget.offre.image!.isNotEmpty;

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
                                widget.offre.image!,
                              );
                              return Image.memory(
                                decodedBytes,
                                fit: BoxFit.cover,
                                width: Sizes.p72,
                                height: Sizes.p72,
                              );
                            } catch (e) {
                              // Fallback if base64 decoding fails
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
                          child: Text(
                            widget.offre.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.lightwhite,
                              fontSize: Sizes.p16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.p8,
                            vertical: Sizes.p4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cyan.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(Sizes.p8),
                          ),
                          child: Text(
                            'Dispo',
                            style: TextStyle(
                              color: AppColors.cyan,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    gapH4,
                    AnimatedCrossFade(
                      firstChild: Text(
                        widget.offre.description ?? 'Aucune description',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.lightwhite,
                          fontSize: Sizes.p14,
                        ),
                      ),
                      secondChild: Text(
                        widget.offre.description ?? 'Aucune description',
                        style: TextStyle(
                          color: AppColors.lightwhite,
                          fontSize: Sizes.p14,
                        ),
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
                      onTap: () => widget.onDelete(widget.offre.id),
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
