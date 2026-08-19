import 'package:flutter/material.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';
import 'package:local_share/src/theme/theme.dart';

class OffreCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Sizes.p16,
        vertical: Sizes.p8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizes.p12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: Icon(
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
                          offre.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
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
                  Text(
                    offre.description ?? 'Aucune description',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: Sizes.p14,
                    ),
                  ),
                ],
              ),
            ),
            gapW12,
            if (isAdmin)
              InkWell(
                onTap: () => onDelete(offre.id),
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
                    color: AppColors.white,
                    size: Sizes.p20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
