import 'package:flutter/material.dart';
import '../../../../app_theme.dart';
import '../models/child_model.dart';

class ChildDashboardCard extends StatelessWidget {
  final ChildModel child;
  final VoidCallback onViewDetails;

  const ChildDashboardCard({
    super.key,
    required this.child,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        border: Border.all(
          color: isDark ? AppColors.darkOutlineColor : AppColors.outlineColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03), 
            blurRadius: 10, 
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.paddingMedium - 4.0,
              horizontal: AppSizes.paddingMedium,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                    ? [AppColors.darkPrimaryTeal, const Color(0xFF2C5E5F)]
                    : [AppColors.primaryTeal, const Color(0xFF00595A)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppSizes.borderRadiusLarge - 1.0),
                topLeft: Radius.circular(AppSizes.borderRadiusLarge - 1.0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: AppSizes.paddingExtraLarge - 6.0,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: const Icon(Icons.person, color: Colors.white, size: AppSizes.paddingLarge + 2.0),
                    ),
                    const SizedBox(height: 6), 
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'نشط',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSizes.paddingMedium - 4.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        child.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppSizes.fontSizeSubtitle - 2.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        child.grade,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: AppSizes.fontSizeLabel - 2.0,
                          fontFamily: 'Cairo',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium - 4.0),
            child: Row(
              children: [
                Expanded(
                  child: _buildSquareMetricTile(
                    context, 
                    'الحضور', 
                    child.attendanceRate, 
                    Icons.trending_up_rounded,
                    Colors.blue, 
                  ),
                ),
                const SizedBox(width: AppSizes.paddingMedium), 
                Expanded(
                  child: _buildSquareMetricTile(
                    context, 
                    'المعدل', 
                    child.gpa, 
                    Icons.emoji_events_outlined,
                    Colors.green, 
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium,
              vertical: AppSizes.paddingSmall - 2.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_rounded, 
                      color: (isDark ? Colors.white : AppColors.primaryText).withValues(alpha: 0.85), 
                      size: 16
                    ),
                    const SizedBox(width: 6), 
                    Text(
                      '${child.totalMaterials} مواد', 
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.primaryText, 
                        fontSize: AppSizes.fontSizeLabel - 1.0, 
                        fontFamily: 'Cairo', 
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_rounded, 
                      color: (isDark ? Colors.white : AppColors.primaryText).withValues(alpha: 0.85), 
                      size: 16
                    ),
                    const SizedBox(width: 6),
                    Text(
                      child.currentTerm, 
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.primaryText, 
                        fontSize: AppSizes.fontSizeLabel - 1.0, 
                        fontFamily: 'Cairo', 
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.paddingMedium, 
              AppSizes.paddingSmall - 2.0, 
              AppSizes.paddingMedium, 
              AppSizes.paddingMedium - 4.0
            ),
            child: SizedBox(
              width: double.infinity,
              height: AppSizes.buttonHeight - 10.0,
              child: ElevatedButton(
                onPressed: onViewDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
                  ),
                ),
                child: const Text(
                  'عرض التفاصيل', 
                  style: TextStyle(
                    fontSize: AppSizes.fontSizeLabel, 
                    fontWeight: FontWeight.bold, 
                    fontFamily: 'Cairo', 
                    color: Colors.white
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareMetricTile(BuildContext context, String title, String value, IconData icon, Color highlightColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AspectRatio(
      aspectRatio: 2.0, 
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingSmall + 2.0),
        decoration: BoxDecoration(
          color: highlightColor.withValues(alpha: 0.08), 
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge - 6.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, 
          mainAxisAlignment: MainAxisAlignment.spaceBetween, 
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              textDirection: TextDirection.rtl,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: highlightColor.withValues(alpha: 0.2), 
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: highlightColor, size: 14),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: TextStyle(
                        color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText, 
                        fontSize: AppSizes.fontSizeLabel - 1.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight, 
              child: Text(
                value,
                style: TextStyle(
                  color: highlightColor, 
                  fontSize: AppSizes.fontSizeSubtitle, 
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
