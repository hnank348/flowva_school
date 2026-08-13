import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';

class SettingsGroupContainer extends StatelessWidget {
  final List<Widget> children;

  const SettingsGroupContainer({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final outline = isDark ? AppColors.darkOutlineColor : AppColors.outlineColor.withOpacity(0.5);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge * 1.5),
        border: Border.all(color: outline, width: 1.2),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}