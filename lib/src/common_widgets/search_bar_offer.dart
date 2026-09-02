import 'package:flutter/material.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/theme/theme.dart';

class SearchBarOffer extends StatefulWidget {
  const SearchBarOffer({
    required this.hintText,
    required this.onSearch,
    super.key,
  });

  final String hintText;
  final ValueChanged<String> onSearch;

  @override
  State<SearchBarOffer> createState() => _SearchBarOffer();
}

class _SearchBarOffer extends State<SearchBarOffer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Sizes.p312,
      child: TextField(
        style: TextStyle(color: AppColors.lightwhite),
        onChanged: widget.onSearch,
        cursorColor: AppColors.lightwhite,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: AppColors.lightwhite),
          prefixIcon: Icon(Icons.search, color: AppColors.lightwhite),
          filled: true,
          fillColor: AppColors.lightPurple,
          contentPadding: const EdgeInsets.symmetric(vertical: 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.p16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
