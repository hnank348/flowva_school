import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';

class ChatDateChipWidget extends StatelessWidget {
  const ChatDateChipWidget({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppSizes.paddingSmall),
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppStyles.labelStyle.copyWith(
            fontSize: AppSizes.fontSizeLabel - 2.0,
            color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
          ),
        ),
      ),
    );
  }
}