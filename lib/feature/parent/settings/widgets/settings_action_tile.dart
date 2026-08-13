import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';

class SettingsActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;
  final Color? customColor;

  const SettingsActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingText,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = customColor ?? (isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: baseColor.withOpacity(0.2), 
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
              ),
              child: Icon(icon, size: 20, color: baseColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontSizeLabel + 1.0,
                  fontWeight: FontWeight.w600,
                  color: customColor ?? (isDark ? Colors.white : AppColors.primaryText),
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: AppSizes.fontSizeLabel,
                  color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 14,
              color: isDark ? AppColors.darkSecondaryText.withOpacity(0.5) : AppColors.secondaryText.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}