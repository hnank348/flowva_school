import 'package:flutter/material.dart';
import '../../../../app_theme.dart';

class AttendanceKpiCards extends StatelessWidget {
  const AttendanceKpiCards({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: _buildKpiCard(
            context, 
            'حضور', 
            '13 يوم', 
            Icons.check_circle_outline, 
            isDark ? AppColors.darkAttendancePresent : AppColors.attendancePresent
          ),
        ),
        const SizedBox(width: AppSizes.paddingSmall),
        Expanded(
          child: _buildKpiCard(
            context, 
            'بعذر مبرر', 
            '2 يوم', 
            Icons.info_outline, 
            isDark ? AppColors.darkAttendanceLateOrExcused : AppColors.attendanceLateOrExcused
          ),
        ),
        const SizedBox(width: AppSizes.paddingSmall),
        Expanded(
          child: _buildKpiCard(
            context, 
            'غير مبرر', 
            '1 يوم', 
            Icons.cancel_outlined, 
            AppColors.errorRed
          ),
        ),
        const SizedBox(width: AppSizes.paddingSmall),
        Expanded(
          child: _buildKpiCard(
            context, 
            'النسبة', 
            '93.3%', 
            Icons.trending_up, 
            AppColors.getAttendanceRateColor(context)
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingMedium, horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        border: Border.all(
          color: isDark ? AppColors.darkOutlineColor : AppColors.outlineColor,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingSmall),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: AppSizes.paddingSmall),
          Text(
            title,
            style: TextStyle(
              fontSize: AppSizes.fontSizeLabel ,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: AppSizes.fontSizeLabel - 2.0, 
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: isDark ? Colors.white : AppColors.primaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
