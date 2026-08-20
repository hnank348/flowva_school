import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_cubit.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_state.dart';
import 'package:flowva_school/cubit/current_year/current_year_cubit.dart';
import 'package:flowva_school/cubit/current_year/current_year_state.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_cubit.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_state.dart';
import 'package:flowva_school/cubit/supervisor/submit_student/submit_attendance_cubit.dart';
import 'package:flowva_school/cubit/supervisor/submit_student/submit_attendance_state.dart';
import 'package:flowva_school/app_localizations.dart';

import '../../../../cubit/supervisor/student_attendance/section_students_cubit.dart';
import '../../../../cubit/supervisor/student_attendance/section_students_stats.dart';
import '../../../../cubit/supervisor/student_attendance/student_attendance_cubit.dart';
import '../../../../cubit/supervisor/student_attendance/student_attendance_state.dart';
import '../../../../widget/supervisor/attendance_edit_mode_badge.dart';
import '../../../../widget/supervisor/attendance_error_view.dart';
import '../../../../widget/supervisor/attendance_loading_indicator.dart';
import '../../../../widget/supervisor/attendance_page_app_bar.dart';
import '../../../../widget/supervisor/attendance_save_all_button.dart';
import '../../../../widget/supervisor/attendance_snack.dart';
import 'section_selector_header.dart';
import 'students_attendance_grid.dart';
import 'attendance_summary_bar.dart';
import 'section_students_stats_bar.dart';

class StudentAttendanceView extends StatelessWidget {
  final ClassesCubit? classesCubit;

  const StudentAttendanceView({super.key, this.classesCubit});

  void _fetchAttendance(BuildContext context, int sectionId) {
    final semesterState = context.read<CurrentSemesterCubit>().state;
    final semesterId = semesterState is CurrentSemesterSuccess
        ? semesterState.currentSemester.id
        : 1;

    context.read<StudentAttendanceCubit>().fetchAttendance(
      sectionId,
      semesterId: semesterId,
      tr: context.tr,
    );

    context.read<SectionStudentsStatsCubit>().fetchStats(
      sectionId: sectionId,
      tr: context.tr,
    );
  }

  void _submitNewAttendance(BuildContext context) {
    final attendanceState = context.read<StudentAttendanceCubit>().state;
    final classState = context.read<ClassesCubit>().state;
    final yearState = context.read<CurrentYearCubit>().state;
    final semesterState = context.read<CurrentSemesterCubit>().state;

    if (attendanceState is! StudentAttendanceSuccess) return;
    if (classState is! ClassesLoaded) return;
    if (yearState is! CurrentYearSuccess) return;
    if (semesterState is! CurrentSemesterSuccess) return;

    final section = classState.selectedSection;
    if (section == null) return;

    context.read<SubmitAttendanceCubit>().submitAttendance(
      students: attendanceState.students,
      attendanceMap: attendanceState.attendanceMap,
      sectionId: section.id,
      academicYearId: yearState.currentYear.id,
      semesterId: semesterState.currentSemester.id,
      noteMap: attendanceState.noteMap,
      tr: context.tr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 650;
    final hPad = isTablet ? 20.0 : 14.0;
    final cs = Theme.of(context).colorScheme;

    final semesterState = context.watch<CurrentSemesterCubit>().state;
    final semesterName = semesterState is CurrentSemesterSuccess
        ? semesterState.currentSemester.name
        : context.tr('attendance_loading_text');

    return BlocProvider<ClassesCubit>.value(
      value: classesCubit ?? context.read<ClassesCubit>(),
      child: BlocListener<SubmitAttendanceCubit, SubmitAttendanceState>(
        listener: (context, state) {
          if (state is SubmitAttendanceSuccess) {
            showAttendanceSnack(context, state.message, const Color(0xFF0F766E));
            context.read<SubmitAttendanceCubit>().reset();
            final classState = context.read<ClassesCubit>().state;
            if (classState is ClassesLoaded && classState.selectedSection != null) {
              _fetchAttendance(context, classState.selectedSection!.id);
            }
          }
          if (state is SubmitAttendanceError) {
            showAttendanceSnack(context, state.errorMessage, cs.error);
          }
        },
        child: BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            return Directionality(
              textDirection: localeState.textDirection,
              child: BlocBuilder<ClassesCubit, ClassesState>(
                builder: (context, classState) {
                  return BlocBuilder<StudentAttendanceCubit, StudentAttendanceState>(
                    builder: (context, attendanceState) {
                      if (classState is ClassesLoaded &&
                          classState.selectedSection != null &&
                          attendanceState is StudentAttendanceInitial) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _fetchAttendance(context, classState.selectedSection!.id);
                        });
                      }

                      final isRecordMode = attendanceState is StudentAttendanceSuccess;
                      final isViewMode = attendanceState is StudentAttendanceViewMode;
                      final hasData = isRecordMode || isViewMode;

                      return Scaffold(
                        backgroundColor: cs.surface,
                        appBar: AttendancePageAppBar(
                          title: isViewMode
                              ? context.tr('attendance_view_title_edit')
                              : context.tr('attendance_view_title'),
                          trailing: isRecordMode
                              ? BlocBuilder<SubmitAttendanceCubit, SubmitAttendanceState>(
                            builder: (context, submitState) {
                              return AttendanceSaveAllButton(
                                isLoading: submitState is SubmitAttendanceLoading,
                                onTap: () => _submitNewAttendance(context),
                              );
                            },
                          )
                              : isViewMode
                              ? const AttendanceEditModeBadge()
                              : null,
                        ),
                        body: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 14),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: hPad),
                                child: SectionSelectorHeader(
                                  classState: classState,
                                  semesterName: semesterName,
                                  onSectionChanged: (id) => _fetchAttendance(context, id),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: hPad),
                                child: SectionStudentsStatsBar(isTablet: isTablet),
                              ),

                              const SizedBox(height: 10),

                              if (hasData) ...[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: hPad),
                                  child: AttendanceSummaryBar(
                                    attendanceMap: isViewMode
                                        ? (attendanceState).attendanceMap
                                        : (attendanceState as StudentAttendanceSuccess).attendanceMap,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],

                              Expanded(
                                child: _buildBody(attendanceState, cs, isTablet),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
      StudentAttendanceState state,
      ColorScheme cs,
      bool isTablet,
      ) {
    if (state is StudentAttendanceLoading) {
      return const AttendanceLoadingIndicator();
    }

    if (state is StudentAttendanceError) {
      return AttendanceErrorView(message: state.errorMessage);
    }

    if (state is StudentAttendanceSuccess) {
      return StudentsAttendanceGrid.record(
        key: ValueKey('record_${state.students.isNotEmpty ? state.students.first.id : 0}'),
        students: state.students,
        attendanceMap: state.attendanceMap,
        noteMap: state.noteMap,
        isTablet: isTablet,
      );
    }

    if (state is StudentAttendanceViewMode) {
      return StudentsAttendanceGrid.view(
        key: ValueKey('view_${state.records.isNotEmpty ? state.records.first.id : 0}'),
        records: state.records,
        editMap: state.editMap,
        isTablet: isTablet,
      );
    }

    return const SizedBox.shrink();
  }
}