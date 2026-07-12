import 'package:flutter/material.dart';
import 'package:flowva_school/app_localizations.dart';

import '../../../../cubit/supervisor/submit_teacher/teacher_attendance_state.dart';

class TeacherAttendanceSummaryBar extends StatelessWidget {
  final Map<int, TeacherAttendanceStatus> attendanceMap;

  const TeacherAttendanceSummaryBar({super.key, required this.attendanceMap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int active = 0, inactive = 0, vacation = 0,transferred = 0;
    for (final s in attendanceMap.values) {
      switch (s) {
        case TeacherAttendanceStatus.active:  active++;  break;
        case TeacherAttendanceStatus.inactive:   inactive++;   break;
        case TeacherAttendanceStatus.vacation:    vacation++;     break;
        case TeacherAttendanceStatus.transferred:  transferred++;  break;
      }
    }

    final items = [
      (label: context.tr('attendance_active'), count: active,
      color: const Color(0xFF0F766E),
      bg: isDark ? const Color(0xFF134E4A) : const Color(0xFFCCFBF1)),
      (label: context.tr('attendance_inactive'), count: inactive,
      color: const Color(0xFFDC2626),
      bg: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2)),
      (label: context.tr('attendance_vacation'), count: vacation,
      color: const Color(0xFFD97706),
      bg: isDark ? const Color(0xFF78350F) : const Color(0xFFFEF3C7)),
      (label: context.tr('attendance_transferred'), count: transferred,
      color: const Color(0xFF7C3AED),
      bg: isDark ? const Color(0xFF4C1D95) : const Color(0xFFEDE9FE)),
    ];

    return Row(
      children: items.map((item) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: item.bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: item.color.withOpacity(isDark ? 0.3 : 0.15),
                width: 0.8,
              ),
            ),
            child: Column(
              children: [
                Text('${item.count}',
                    style: TextStyle(
                      fontFamily: 'Cairo', fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: item.color, height: 1,
                    )),
                const SizedBox(height: 3),
                Text(item.label,
                    style: TextStyle(
                      fontFamily: 'Cairo', fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: item.color.withOpacity(0.85),
                    )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}