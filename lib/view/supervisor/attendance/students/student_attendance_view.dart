import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/student/student_attendance_cubit.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_cubit.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_state.dart';
import 'package:flowva_school/cubit/supervisor/submit/submit_attendance_cubit.dart';
import 'package:flowva_school/cubit/current_year/current_year_cubit.dart';
import 'package:flowva_school/cubit/current_year/current_year_state.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';

import '../../../../app_localizations.dart';
import '../../../../cubit/current_semester/current_semester_cubit.dart';
import '../../../../cubit/current_semester/current_semester_state.dart';
import 'section_selector_header.dart';
import 'students_attendance_grid.dart';
import 'attendance_summary_bar.dart';

class StudentAttendanceView extends StatelessWidget {
  final ClassesCubit? classesCubit;

  const StudentAttendanceView({super.key, this.classesCubit});

  void _fetchAttendance(BuildContext context, int sectionId) {
    final semesterState = context.read<CurrentSemesterCubit>().state;
    int semesterId = 1;

    if (semesterState is CurrentSemesterSuccess) {
      semesterId = semesterState.currentSemester.id;
    }

    context.read<StudentAttendanceCubit>().fetchAttendance(
      sectionId,
      semesterId: semesterId,
    );
  }

  void _submitAttendance(BuildContext context) {
    final attendanceState = context.read<StudentAttendanceCubit>().state;
    final classState      = context.read<ClassesCubit>().state;
    final yearState       = context.read<CurrentYearCubit>().state;
    final semesterState   = context.read<CurrentSemesterCubit>().state;

    if (attendanceState is! StudentAttendanceSuccess) return;
    if (classState is! ClassesLoaded) return;
    if (yearState is! CurrentYearSuccess) return;
    if (semesterState is! CurrentSemesterSuccess) return;

    final section = classState.selectedSection;
    if (section == null) return;

    final academicYearId = yearState.currentYear.id;
    final semesterId     = semesterState.currentSemester.id;

    context.read<SubmitAttendanceCubit>().submitAttendance(
      students:       attendanceState.students,
      attendanceMap:  attendanceState.attendanceMap,
      sectionId:      section.id,
      academicYearId: academicYearId,
      semesterId:     semesterId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet    = screenWidth > 650;
    final hPad        = isTablet ? 20.0 : 14.0;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark      = Theme.of(context).brightness == Brightness.dark;

    final semesterState = context.watch<CurrentSemesterCubit>().state;
    String semesterName = context.tr('attendance_loading_text');
    if (semesterState is CurrentSemesterSuccess) {
      semesterName = semesterState.currentSemester.name;
    }

    return BlocProvider<ClassesCubit>.value(
      value: classesCubit ?? context.read<ClassesCubit>(),
      child: BlocListener<SubmitAttendanceCubit, SubmitAttendanceState>(
        listener: (context, submitState) {
          if (submitState is SubmitAttendanceSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(submitState.message, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13)),
                  ],
                ),
                backgroundColor: const Color(0xFF0F766E),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 3),
              ),
            );
            context.read<SubmitAttendanceCubit>().reset();
          }

          if (submitState is SubmitAttendanceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(submitState.errorMessage, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13)),
                    ),
                  ],
                ),
                backgroundColor: const Color(0xFFDC2626),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 4),
              ),
            );
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

                      final hasStudents = attendanceState is StudentAttendanceSuccess;

                      return Scaffold(
                        backgroundColor: isDark ? colorScheme.surface : const Color(0xFFF8FAFC),
                        appBar: AppBar(
                          title: Text(
                            context.tr('attendance_view_title'),
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          centerTitle: true,
                          elevation: 0,
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                            onPressed: () => Navigator.pop(context),
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft:  Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                          ),
                          actions: [
                            if (hasStudents)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: BlocBuilder<SubmitAttendanceCubit, SubmitAttendanceState>(
                                  builder: (context, submitState) {
                                    final isLoading = submitState is SubmitAttendanceLoading;
                                    return GestureDetector(
                                      onTap: isLoading ? null : () => _submitAttendance(context),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: isLoading ? colorScheme.primary.withOpacity(0.5) : colorScheme.primary,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: isLoading
                                            ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                        )
                                            : const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.check_rounded, color: Colors.white, size: 15),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                        body: SafeArea(
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: hPad),
                                child: SectionSelectorHeader(
                                  classState:        classState,
                                  semesterName:      semesterName,
                                  onSectionChanged:  (id) => _fetchAttendance(context, id),
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (hasStudents) ...[
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: hPad),
                                  child: AttendanceSummaryBar(
                                    attendanceMap: (attendanceState).attendanceMap,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                              Expanded(
                                child: _buildBody(attendanceState, colorScheme, isTablet),
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

  Widget _buildBody(StudentAttendanceState state, ColorScheme colorScheme, bool isTablet) {
    if (state is StudentAttendanceLoading) {
      return Center(
        child: CircularProgressIndicator(color: colorScheme.primary, strokeWidth: 2.5),
      );
    }

    if (state is StudentAttendanceError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 40, color: colorScheme.error.withOpacity(0.5)),
              const SizedBox(height: 12),
              Text(
                state.errorMessage,
                style: TextStyle(fontFamily: 'Cairo', color: colorScheme.error, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (state is StudentAttendanceSuccess) {
      return StudentsAttendanceGrid(
        key: ValueKey(state.students.isNotEmpty ? state.students.first.id : 0),
        students:      state.students,
        attendanceMap: state.attendanceMap,
        isTablet:      isTablet,
      );
    }

    return const SizedBox();
  }
}