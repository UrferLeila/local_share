import 'package:flutter/material.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/domain/offer.dart';
import 'package:local_share/src/theme/theme.dart';

class InlineFilter extends StatefulWidget {
  final Function(List<OfferType>) onFilterChanged;

  const InlineFilter({super.key, required this.onFilterChanged});

  @override
  State<InlineFilter> createState() => InlineFilterState();
}

class InlineFilterState extends State<InlineFilter> {
  final List<OfferType> selectedFilters = [];

  void _toggleFilter(OfferType type) {
    setState(() {
      if (selectedFilters.contains(type)) {
        selectedFilters.remove(type);
      } else {
        selectedFilters.add(type);
      }
    });
    widget.onFilterChanged(selectedFilters);
  }

  static const Map<OfferType, String> typeOffers = {
    OfferType.achat: "Achat",
    OfferType.service: "Service",
    OfferType.pret: "Prêt",
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
      child: Row(
        children: typeOffers.entries.map((entry) {
          final type = entry.key;
          final label = entry.value;
          final isSelected = selectedFilters.contains(type);

          return Padding(
            padding: const EdgeInsets.only(right: Sizes.p8),
            child: ChoiceChip(
              label: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.lightwhite
                      : AppColors.lightwhite,
                  fontWeight: FontWeight.w600,
                  fontSize: Sizes.p16,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.lightPurple,
              backgroundColor: AppColors.lightBrown,
              side: BorderSide(
                color: isSelected
                    ? AppColors.transparent
                    : AppColors.lightwhite,
                width: Sizes.p0,
              ),
              showCheckmark: false,
              onSelected: (_) => _toggleFilter(type),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.p16),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p12,
                vertical: Sizes.p8,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
