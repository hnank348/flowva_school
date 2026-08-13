import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';

class NotificationsEmptyView extends StatelessWidget {
  const NotificationsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingExtraLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined, size: 64, color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
            const SizedBox(height: 16),
            const Text(
              'صندوق الإشعارات فارغ',
              style: TextStyle(fontFamily: 'Cairo', fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'ستظهر هنا كافة الإشعارات فور إرسالها من إدارة المدرسة',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
            ),
          ],
        ),
      ),
    );
  }
}