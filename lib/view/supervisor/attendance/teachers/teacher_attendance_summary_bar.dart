import 'package:flutter/material.dart';
import 'package:flowva_school/app_localizations.dart';
import '../../../../cubit/supervisor/submit_teacher/teacher_attendance_state.dart';
import '../../../../widget/supervisor/attendance_summary_bar.dart';
import '../../../../widget/supervisor/attendance_types.dart';

class TeacherAttendanceSummaryBar extends StatelessWidget {
  final Map<int, TeacherAttendanceStatus> attendanceMap;

  const TeacherAttendanceSummaryBar({super.key, required this.attendanceMap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int active = 0, inactive = 0, vacation = 0, transferred = 0;
    for (final s in attendanceMap.values) {
      switch (s) {
        case TeacherAttendanceStatus.active:      active++;      break;
        case TeacherAttendanceStatus.inactive:    inactive++;    break;
        case TeacherAttendanceStatus.vacation:    vacation++;    break;
        case TeacherAttendanceStatus.transferred: transferred++; break;
      }
    }

    final items = <AttendanceSummaryItem>[
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

    return GenericAttendanceSummaryBar(items: items);
  }
}