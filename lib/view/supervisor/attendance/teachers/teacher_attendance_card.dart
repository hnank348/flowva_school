import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/models/supervisor/teacher_attendance_model.dart';
import 'package:flowva_school/cubit/supervisor/submit_teacher/teacher_attendance_state.dart';
import 'package:flowva_school/cubit/supervisor/submit_teacher/teachers_attendance_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import 'package:flowva_school/app_localizations.dart';
import '../../../../widget/supervisor/attendance_types.dart';
import '../../../../widget/supervisor/attendance_entity_card.dart';

class TeacherAttendanceCard extends StatelessWidget {
  final TeacherModel teacher;
  final TeacherAttendanceStatus currentStatus;
  final String? note;

  const TeacherAttendanceCard({
    super.key,
    required this.teacher,
    required this.currentStatus,
    this.note,
  });

  static const AttendanceStatusStyle _present = (
  accent: Color(0xFF0F766E),
  bg: Color(0xFFCCFBF1),
  bgDark: Color(0xFF134E4A),
  icon: Icons.check_circle_rounded,
  );
  static const AttendanceStatusStyle _absent = (
  accent: Color(0xFFDC2626),
  bg: Color(0xFFFEE2E2),
  bgDark: Color(0xFF7F1D1D),
  icon: Icons.cancel_rounded,
  );
  static const AttendanceStatusStyle _late = (
  accent: Color(0xFFD97706),
  bg: Color(0xFFFEF3C7),
  bgDark: Color(0xFF78350F),
  icon: Icons.access_time_filled_rounded,
  );
  static const AttendanceStatusStyle _excused = (
  accent: Color(0xFF7C3AED),
  bg: Color(0xFFEDE9FE),
  bgDark: Color(0xFF4C1D95),
  icon: Icons.info_rounded,
  );

  AttendanceStatusStyle _styleOf(TeacherAttendanceStatus s) {
    switch (s) {
      case TeacherAttendanceStatus.active:
        return _present;
      case TeacherAttendanceStatus.inactive:
        return _absent;
      case TeacherAttendanceStatus.vacation:
        return _late;
      case TeacherAttendanceStatus.transferred:
        return _excused;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TeacherAttendanceCubit>();

    return BlocBuilder<TeacherAttendanceCubit, TeacherAttendanceState>(
      builder: (context, attendanceState) {
        final expanded = attendanceState is TeacherAttendanceSuccess
            ? (attendanceState.expandedMap[teacher.id] ?? true)
            : true;

        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            final isArabic = localeState.currentLanguage.toUpperCase() == 'AR' ||
                Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';

            final displayName = isArabic
                ? (teacher.fullNameAr.isNotEmpty ? teacher.fullNameAr : teacher.fullName)
                : (teacher.fullName.isNotEmpty ? teacher.fullName : teacher.fullNameAr);

            final options = <AttendanceOption<TeacherAttendanceStatus>>[
              AttendanceOption(
                label: context.tr('attendance_active'),
                status: TeacherAttendanceStatus.active,
                accent: _present.accent,
                bg: _present.bg,
              ),
              AttendanceOption(
                label: context.tr('attendance_inactive'),
                status: TeacherAttendanceStatus.inactive,
                accent: _absent.accent,
                bg: _absent.bg,
              ),
              AttendanceOption(
                label: context.tr('attendance_vacation'),
                status: TeacherAttendanceStatus.vacation,
                accent: _late.accent,
                bg: _late.bg,
              ),
              AttendanceOption(
                label: context.tr('attendance_transferred'),
                status: TeacherAttendanceStatus.transferred,
                accent: _excused.accent,
                bg: _excused.bg,
              ),
            ];

            return AttendanceEntityCard<TeacherAttendanceStatus>(
              name: displayName,
              subtitle: teacher.employeeId,
              imageUrl: teacher.avatar,
              currentStatus: currentStatus,
              styleOf: _styleOf,
              options: options,
              expanded: expanded,
              onExpandedChanged: (value) =>
                  cubit.toggleExpanded(teacher.id, value),
              onSelect: (status) => cubit.updateAttendance(teacher.id, status),
              note: note,
              onNoteChanged: (newNote) => cubit.updateNote(teacher.id, newNote),
            );
          },
        );
      },
    );
  }
}