import 'package:flutter/material.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/theme/theme.dart';

class ButtonPurple extends StatelessWidget {
  const ButtonPurple({super.key, required this.onPressed, required this.title});

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.p52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPurple,
          foregroundColor: AppColors.lightPurple,
          elevation: Sizes.p0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.p12),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: Sizes.p16,
            fontWeight: FontWeight.bold,
            color: AppColors.lightwhite,
          ),
        ),
      ),
    );
  }
}
