import 'package:flutter/material.dart';
import 'package:flowva_school/app_localizations.dart';

/// بادج "تعديل" اللي يظهر بالـ AppBar بوضع العرض/التعديل
class AttendanceEditModeBadge extends StatelessWidget {
  const AttendanceEditModeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.edit_rounded, size: 13, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              context.tr('attendance_edit_mode'),
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}