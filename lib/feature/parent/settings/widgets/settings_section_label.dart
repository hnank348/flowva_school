import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';

class SettingsSectionLabel extends StatelessWidget {
  final String label;

  const SettingsSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.only(right: 6.0, bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: AppSizes.fontSizeLabel,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText.withOpacity(0.85),
        ),
      ),
    );
  }
}