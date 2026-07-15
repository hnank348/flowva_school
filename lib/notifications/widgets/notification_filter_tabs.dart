import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';
import '../cubit/notifications_state.dart';

class NotificationFilterTabs extends StatelessWidget {
  final FilterType selectedFilter;
  final Function(FilterType) onFilterChanged;

  const NotificationFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;

    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.grey[100],
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
      ),
      child: Row(
        children: [
          _buildTab(FilterType.read, 'المقروءة', isDark, activeColor),
          _buildTab(FilterType.unread, 'غير المقروءة', isDark, activeColor),
          _buildTab(FilterType.all, 'الكل', isDark, activeColor),
        ],
      ),
    );
  }

  Widget _buildTab(FilterType type, String label, bool isDark, Color activeColor) {
    final isSelected = selectedFilter == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => onFilterChanged(type),
        child: Container(
          margin: const EdgeInsets.all(4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w900,
              color: isSelected ? Colors.white : (isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
            ),
          ),
        ),
      ),
    );
  }
}