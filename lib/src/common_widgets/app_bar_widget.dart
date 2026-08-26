import 'package:flutter/material.dart';
import 'package:local_share/src/common_widgets/styled_text.dart';
import 'package:local_share/src/constant/app_size.dart';
import 'package:local_share/src/theme/theme.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(Sizes.p80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: Sizes.p80,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hub, color: AppColors.lightPurple, size: Sizes.p20),
          gapW8,
          StyledAppBar(title),
        ],
      ),
    );
  }
}
