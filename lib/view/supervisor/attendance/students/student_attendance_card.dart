import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import 'package:flowva_school/models/supervisor/student_attendance_model.dart';
import 'package:flowva_school/app_localizations.dart';
import '../../../../cubit/supervisor/student_attendance/student_attendance_cubit.dart';
import '../../../../cubit/supervisor/student_attendance/student_attendance_state.dart';
import '../../../../widget/supervisor/attendance_types.dart';
import '../../../../widget/supervisor/attendance_entity_card.dart';

class StudentAttendanceCard extends StatelessWidget {
  final StudentAttendanceModel student;
  final StudentAttendanceStatus currentStatus;
  final String? note;

  const StudentAttendanceCard({
    super.key,
    required this.student,
    required this.currentStatus,
    this.note,
  });

  static const AttendanceStatusStyle _present = (
  accent: Color(0xFF0F766E), bg: Color(0xFFCCFBF1),
  bgDark: Color(0xFF134E4A), icon: Icons.check_circle_rounded,
  );
  static const AttendanceStatusStyle _absent = (
  accent: Color(0xFFDC2626), bg: Color(0xFFFEE2E2),
  bgDark: Color(0xFF7F1D1D), icon: Icons.cancel_rounded,
  );
  static const AttendanceStatusStyle _late = (
  accent: Color(0xFFD97706), bg: Color(0xFFFEF3C7),
  bgDark: Color(0xFF78350F), icon: Icons.access_time_filled_rounded,
  );
  static const AttendanceStatusStyle _excused = (
  accent: Color(0xFF7C3AED), bg: Color(0xFFEDE9FE),
  bgDark: Color(0xFF4C1D95), icon: Icons.info_rounded,
  );

  AttendanceStatusStyle _styleOf(StudentAttendanceStatus s) {
    switch (s) {
      case StudentAttendanceStatus.present: return _present;
      case StudentAttendanceStatus.absent:  return _absent;
      case StudentAttendanceStatus.late:    return _late;
      case StudentAttendanceStatus.excused: return _excused;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StudentAttendanceCubit>();

    return BlocBuilder<StudentAttendanceCubit, StudentAttendanceState>(
      builder: (context, attendanceState) {
        final expanded = attendanceState is StudentAttendanceSuccess
            ? (attendanceState.expandedMap[student.id.toString()] ?? true)
            : true;

        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            final isArabic = localeState.currentLanguage.toUpperCase() == 'AR' ||
                Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';

            final displayName = isArabic
                ? (student.fullNameAr.isNotEmpty ? student.fullNameAr : student.fullName)
                : (student.fullName.isNotEmpty ? student.fullName : student.fullNameAr);

            final options = <AttendanceOption<StudentAttendanceStatus>>[
              AttendanceOption(label: context.tr('attendance_present'), status: StudentAttendanceStatus.present, accent: _present.accent, bg: _present.bg),
              AttendanceOption(label: context.tr('attendance_absent'),  status: StudentAttendanceStatus.absent,  accent: _absent.accent,  bg: _absent.bg),
              AttendanceOption(label: context.tr('attendance_late'),    status: StudentAttendanceStatus.late,    accent: _late.accent,    bg: _late.bg),
              AttendanceOption(label: context.tr('attendance_excused'), status: StudentAttendanceStatus.excused, accent: _excused.accent, bg: _excused.bg),
            ];

            return AttendanceEntityCard<StudentAttendanceStatus>(
              name: displayName,
              subtitle: 'ID: ${student.id}',
              imageUrl: student.photo,
              currentStatus: currentStatus,
              styleOf: _styleOf,
              options: options,
              expanded: expanded,
              onExpandedChanged: (value) =>
                  cubit.toggleExpanded(student.id.toString(), value),
              onSelect: (status) =>
                  cubit.updateAttendance(student.id.toString(), status),
              note: note,
              onNoteChanged: (newNote) =>
                  cubit.updateNote(student.id.toString(), newNote),
            );
          },
        );
      },
    );
  }
}