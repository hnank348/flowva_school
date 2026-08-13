import 'package:flutter/material.dart';
import 'package:flowva_school/cubit/supervisor/student/student_attendance_cubit.dart';
import 'package:flowva_school/app_localizations.dart';

import '../../../../widget/supervisor/attendance_summary_bar.dart';
import '../../../../widget/supervisor/attendance_types.dart';

class AttendanceSummaryBar extends StatelessWidget {
  final Map<String, StudentAttendanceStatus> attendanceMap;

  const AttendanceSummaryBar({super.key, required this.attendanceMap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int present = 0, absent = 0, late = 0, excused = 0;
    for (final s in attendanceMap.values) {
      switch (s) {
        case StudentAttendanceStatus.present: present++; break;
        case StudentAttendanceStatus.absent:  absent++;  break;
        case StudentAttendanceStatus.late:    late++;    break;
        case StudentAttendanceStatus.excused: excused++; break;
      }
    }

    final items = <AttendanceSummaryItem>[
      (label: context.tr('attendance_present'), count: present,
      color: const Color(0xFF0F766E),
      bg: isDark ? const Color(0xFF134E4A) : const Color(0xFFCCFBF1)),
      (label: context.tr('attendance_absent'), count: absent,
      color: const Color(0xFFDC2626),
      bg: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2)),
      (label: context.tr('attendance_late'), count: late,
      color: const Color(0xFFD97706),
      bg: isDark ? const Color(0xFF78350F) : const Color(0xFFFEF3C7)),
      (label: context.tr('attendance_excused'), count: excused,
      color: const Color(0xFF7C3AED),
      bg: isDark ? const Color(0xFF4C1D95) : const Color(0xFFEDE9FE)),
    ];

    return GenericAttendanceSummaryBar(items: items);
  }
}