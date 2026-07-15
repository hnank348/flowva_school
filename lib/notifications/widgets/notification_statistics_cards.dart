import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';

class NotificationStatisticsCards extends StatelessWidget {
  final int total;
  final int important;
  final int read;
  final int unread;

  const NotificationStatisticsCards({
    super.key,
    required this.total,
    required this.important,
    required this.read,
    required this.unread,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: AppSizes.paddingSmall,
          mainAxisSpacing: AppSizes.paddingSmall,
          childAspectRatio: constraints.maxWidth > 600 ? 2.5 : 2.1,
          children: [
            _buildStatCard(context, title: 'إجمالي الإشعارات', value: total.toString(), icon: Icons.notifications_rounded, baseColor: Colors.blue),
            _buildStatCard(context, title: 'تنبيهات مهمة', value: important.toString(), icon: Icons.warning_amber_rounded, baseColor: AppColors.errorRed),
            _buildStatCard(context, title: 'غير مقروءة', value: unread.toString(), icon: Icons.mark_chat_unread_rounded, baseColor: Colors.orange),
            _buildStatCard(context, title: 'مقروءة', value: read.toString(), icon: Icons.mark_chat_read_rounded, baseColor: Colors.green),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, {required String title, required String value, required IconData icon, required Color baseColor}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        border: Border.all(
          color: isDark ? AppColors.darkOutlineColor : AppColors.outlineColor.withOpacity(0.85),
          width: 1.2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: baseColor.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, color: baseColor, size: 25),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontSizeLabel -1.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: AppSizes.fontSizeSubtitle - 1.0,
                    fontWeight: FontWeight.bold,
                    color: baseColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}