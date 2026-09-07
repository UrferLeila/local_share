import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:local_share/src/common_widgets/styled_text.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/domain/offer.dart';
import 'package:local_share/src/theme/theme.dart';

class SuggestionCard extends StatelessWidget {
  const SuggestionCard({
    super.key,
    required this.offer,
    required this.index,
    required this.onDelete,
  });

  final Offer offer;
  final int index;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final prop = offer.suggestions[index];
    final bool isOwner = prop.userId == offer.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: Sizes.p16,
            backgroundColor: isOwner ? AppColors.cyan : AppColors.lightBrown,
            backgroundImage:
                prop.userPhoto != null && prop.userPhoto!.isNotEmpty
                ? MemoryImage(base64Decode(prop.userPhoto!))
                : null,
            child: prop.userPhoto == null || prop.userPhoto!.isEmpty
                ? Icon(
                    Icons.person,
                    size: Sizes.p16,
                    color: AppColors.lightwhite,
                  )
                : null,
          ),
          gapW12,
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(Sizes.p8),
              decoration: BoxDecoration(
                color: isOwner
                    ? AppColors.cyan.withValues(alpha: 0.15)
                    : AppColors.lightPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Sizes.p8),
                border: isOwner
                    ? Border.all(
                        color: AppColors.cyan.withValues(alpha: 0.4),
                        width: 1,
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          StyledLink(prop.username),
                          if (isOwner) ...[
                            gapW4,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Sizes.p4,
                                vertical: Sizes.p4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.cyan,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: StyledBase("Auteur"),
                            ),
                          ],
                        ],
                      ),
                      StyledBase(
                        "${prop.date.hour.toString().padLeft(2, "0")}:${prop.date.minute.toString().padLeft(2, "0")}",
                      ),
                    ],
                  ),
                  gapH4,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StyledBase(prop.description),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onDelete,
                        child: Icon(
                          Icons.delete,
                          size: Sizes.p20,
                          color: AppColors.lightRed,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
