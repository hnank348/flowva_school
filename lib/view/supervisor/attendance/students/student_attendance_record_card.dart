import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/student/student_attendance_cubit.dart';
import 'package:flowva_school/cubit/supervisor/student/student_attendance_state.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import 'package:flowva_school/models/supervisor/student_attendance_record_model.dart';
import 'package:flowva_school/app_localizations.dart';
import '../../../../widget/supervisor/attendance_types.dart';
import '../../../../widget/supervisor/attendance_record_entity_card.dart';

class StudentAttendanceRecordCard extends StatelessWidget {
  final StudentAttendanceRecord record;

  const StudentAttendanceRecordCard({
    super.key,
    required this.record,
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
      builder: (context, state) {
        if (state is! StudentAttendanceViewMode) {
          return const SizedBox.shrink();
        }

        final currentStatus = state.editMap[record.id] ?? _recordToStatus(record);
        final note = state.noteEditMap[record.id] ?? record.notes;
        final expanded = state.expandedMap[record.id] ?? false;
        final isSaving = state.savingMap[record.id] ?? false;
        final isSaved = state.savedMap[record.id] ?? false;

        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            final displayName = record.studentFullName;

            final options = <AttendanceOption<StudentAttendanceStatus>>[
              AttendanceOption(label: context.tr('attendance_present'), status: StudentAttendanceStatus.present, accent: _present.accent, bg: _present.bg),
              AttendanceOption(label: context.tr('attendance_absent'),  status: StudentAttendanceStatus.absent,  accent: _absent.accent,  bg: _absent.bg),
              AttendanceOption(label: context.tr('attendance_late'),    status: StudentAttendanceStatus.late,    accent: _late.accent,    bg: _late.bg),
              AttendanceOption(label: context.tr('attendance_excused'), status: StudentAttendanceStatus.excused, accent: _excused.accent, bg: _excused.bg),
            ];

            return AttendanceRecordEntityCard<StudentAttendanceStatus>(
              name: displayName,
              subtitle: 'ID: ${record.studentId}',
              currentStatus: currentStatus,
              styleOf: _styleOf,
              options: options,
              expanded: expanded,
              onExpandedChanged: (value) =>
                  cubit.toggleEditExpanded(record.id, value),
              isSaving: isSaving,
              isSaved: isSaved,
              onSelect: (status) => cubit.updateEditStatus(record.id, status),
              onSave: () => cubit.submitSingleUpdate(record.id),
              note: note,
              onNoteChanged: (newNote) => cubit.updateEditNote(record.id, newNote),
            );
          },
        );
      },
    );
  }

  StudentAttendanceStatus _recordToStatus(StudentAttendanceRecord r) {
    switch (r.statusId) {
      case 2: return StudentAttendanceStatus.absent;
      case 3: return StudentAttendanceStatus.late;
      case 4: return StudentAttendanceStatus.excused;
      default: return StudentAttendanceStatus.present;
    }
  }
}