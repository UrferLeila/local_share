import 'package:flutter/material.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/features/offres/domain/offre.dart';

class InlineFilter extends StatefulWidget {
  final Function(List<OfferType>) onFilterChanged;
  final Map<OfferType, String> typeOffers;
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color borderColor;
  final double borderWidth;

  const InlineFilter({
    super.key,
    required this.onFilterChanged,
    required this.typeOffers,
    required this.selectedColor,
    required this.unselectedColor,
    required this.selectedTextColor,
    required this.unselectedTextColor,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  State<InlineFilter> createState() => _InlineFilterState();
}

class _InlineFilterState extends State<InlineFilter> {
  final List<OfferType> _selectedFilters = [];

  void _toggleFilter(OfferType type) {
    setState(() {
      if (_selectedFilters.contains(type)) {
        _selectedFilters.remove(type);
      } else {
        _selectedFilters.add(type);
      }
    });
    widget.onFilterChanged(_selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
      child: Row(
        children: widget.typeOffers.entries.map((entry) {
          final type = entry.key;
          final label = entry.value;
          final isSelected = _selectedFilters.contains(type);

          return Padding(
            padding: const EdgeInsets.only(right: Sizes.p8),
            child: ChoiceChip(
              label: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? widget.selectedTextColor
                      : widget.unselectedTextColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              selected: isSelected,
              selectedColor: widget.selectedColor,
              backgroundColor: widget.unselectedColor,
              side: BorderSide(
                color: isSelected ? Colors.transparent : widget.borderColor,
                width: widget.borderWidth,
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
