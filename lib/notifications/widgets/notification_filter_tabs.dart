import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';

// ✅ FilterType معرّف داخل الـ state، لازم يُستورد وإلا الملف ما يترجم
import '../cubit/notifications_state.dart';

class NotificationFilterTabs extends StatelessWidget {
  final FilterType selectedFilter;
  final ValueChanged<FilterType> onFilterChanged;

  const NotificationFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor =
        isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;

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

  Widget _buildTab(
    FilterType type,
    String label,
    bool isDark,
    Color activeColor,
  ) {
    final isSelected = selectedFilter == type;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            // ✅ InkWell بدل GestureDetector => فيه تأثير لمس + وصولية
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall),
            onTap: isSelected ? null : () => onFilterChanged(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              margin: const EdgeInsets.all(4),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? activeColor : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(AppSizes.borderRadiusSmall),
              ),
              child: FittedBox(
                // ✅ يمنع overflow في "غير المقروءة" على الشاشات الصغيرة
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    label,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      // ✅ تصحيح: المحدد أثقل من غير المحدد (كان معكوساً)
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                              ? AppColors.darkSecondaryText
                              : AppColors.secondaryText),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
