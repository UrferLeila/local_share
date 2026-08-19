import 'package:flutter/material.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';

class OffreCard extends StatelessWidget {
  const OffreCard({super.key, required this.offre, required this.isAdmin});

  final Offre offre;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.p8),
                border: Border.all(
                  color: const Color(0xFF6C63FF).withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.5),
                child: Container(
                  width: 70,
                  height: 70,
                  color: const Color(0xFF2C2C2C),
                  child: const Icon(
                    Icons.image_outlined,
                    color: Color(0xFF6C63FF),
                    size: 30,
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF5F6FA),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            0,
                            223,
                            212,
                          ).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Dispo',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 223, 212),
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
                    style: const TextStyle(
                      color: Color(0xFFA4B0BE),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            gapW12,
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 150, 145, 250),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
