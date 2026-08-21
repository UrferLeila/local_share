import 'package:flutter/material.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/theme/theme.dart';

class ButtonCyan extends StatelessWidget {
  const ButtonCyan({super.key, required this.onPressed, required this.title});

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: AppColors.cyan),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: Sizes.p14, fontWeight: FontWeight.w600),
      ),
    );
  }
}
