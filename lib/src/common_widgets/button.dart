import 'package:flutter/material.dart';
import 'package:local_share/src/common_widgets/styled_text.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/theme/theme.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    this.icon,
    required this.onPressed,
    required this.title,
    required this.color,
  });

  final VoidCallback onPressed;
  final String title;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.p52,
      width: Sizes.p240,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.lightwhite,
          elevation: Sizes.p0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.p12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[Icon(icon), gapW8],
            StyledBase(title),
          ],
        ),
      ),
    );
  }
}
