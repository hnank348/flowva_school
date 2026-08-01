import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';

class MessagesEmptyWidget extends StatelessWidget {
  const MessagesEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: primaryColor.withOpacity(0.08), shape: BoxShape.circle),
            child: Icon(Icons.chat_bubble_outline_rounded, size: 36, color: primaryColor),
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          Text(
            'لا توجد محادثات تطابق بحثك',
            style: AppStyles.labelStyle.copyWith(
              color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}