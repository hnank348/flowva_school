import 'package:flutter/material.dart';
import '../../../../app_theme.dart';

class AttendanceProgressIndicators extends StatelessWidget {
  const AttendanceProgressIndicators({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        border: Border.all(
          color: isDark ? AppColors.darkOutlineColor : AppColors.outlineColor, 
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          _buildBar(
            context, 
           'نسبة الحضور الملتزم', 
            20, 
            30, 
            '89.1%', 
            isDark ? AppColors.darkAttendancePresent : AppColors.attendancePresent
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          _buildBar(
            context, 
            'نسبة الغياب المبرر', 
            10, 
            30, 
            '10.5%', 
            isDark ? AppColors.darkAttendanceLateOrExcused : AppColors.attendanceLateOrExcused
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          _buildBar(
            context, 
            'نسبة الغياب غير المبرر', 
            8, 
            30, 
            '8.8%', 
            AppColors.errorRed
          ),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context, String label, int current, int total, String percentage, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: AppSizes.fontSizeLabel ,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: isDark ? Colors.white : AppColors.primaryText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSizes.paddingSmall),
            Text(
              '$current/$total ($percentage)',
              style: TextStyle(
                fontSize: AppSizes.fontSizeLabel - 3.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingSmall),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall / 2),
          child: LinearProgressIndicator(
            value: total > 0 ? (current / total) : 0,
            minHeight: 7,
            backgroundColor: color.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
