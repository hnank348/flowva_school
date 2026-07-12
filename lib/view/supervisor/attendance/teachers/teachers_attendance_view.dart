import 'package:flowva_school/view/supervisor/attendance/teachers/teacher_attendance_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import 'package:flowva_school/app_localizations.dart';
import '../../../../cubit/supervisor/submit_teacher/teacher_attendance_state.dart';
import '../../../../cubit/supervisor/submit_teacher/teachers_attendance_cubit.dart';
import 'teacher_attendance_summary_bar.dart';

class TeachersAttendanceView extends StatelessWidget {
  const TeachersAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TeachersAttendanceBody();
  }
}

class _TeachersAttendanceBody extends StatelessWidget {
  const _TeachersAttendanceBody();

  void _submit(BuildContext context) {
    final state = context.read<TeacherAttendanceCubit>().state;
    if (state is! TeacherAttendanceSuccess) return;

    context.read<SubmitTeacherAttendanceCubit>().submitAttendance(
      teachers:      state.teachers,
      attendanceMap: state.attendanceMap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<SubmitTeacherAttendanceCubit, SubmitTeacherAttendanceState>(
      listener: (context, state) {
        if (state is SubmitTeacherAttendanceSuccess) {
          _showSnack(context, state.message, const Color(0xFF0F766E));
          context.read<SubmitTeacherAttendanceCubit>().reset();
        }
        if (state is SubmitTeacherAttendanceError) {
          _showSnack(context, state.errorMessage, cs.error);
        }
      },
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return Directionality(
            textDirection: localeState.textDirection,
            child: BlocBuilder<TeacherAttendanceCubit, TeacherAttendanceState>(
              builder: (context, attendanceState) {
                final hasTeachers = attendanceState is TeacherAttendanceSuccess;
                final isTablet    = MediaQuery.of(context).size.width > 650;
                final hPad        = isTablet ? 20.0 : 14.0;

                return Scaffold(
                  backgroundColor:
                  isDark ? cs.surface : const Color(0xFFF8FAFC),
                  appBar: AppBar(
                    title: Text(
                      context.tr('teachers_attendance_title'),
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(
                          Icons.arrow_back_ios_new_rounded, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft:  Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    actions: [
                      if (hasTeachers)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 12),
                          child: BlocBuilder<SubmitTeacherAttendanceCubit,
                              SubmitTeacherAttendanceState>(
                            builder: (context, submitState) {
                              final isLoading =
                              submitState is SubmitTeacherAttendanceLoading;
                              return GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () => _submit(context),
                                child: AnimatedContainer(
                                  duration:
                                  const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: isLoading
                                        ? cs.primary.withOpacity(0.5)
                                        : cs.primary,
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                    width: 16, height: 16,
                                    child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2),
                                  )
                                      : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check_rounded,
                                          color: Colors.white,
                                          size: 15),
                                      const SizedBox(width: 5),
                                      Text(
                                        context.tr('attendance_save'),
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
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
                        if (hasTeachers) ...[
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: hPad),
                            child: TeacherAttendanceSummaryBar(
                              attendanceMap: (attendanceState)
                                  .attendanceMap,
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Expanded(
                          child: _buildBody(
                            context,
                            attendanceState,
                            cs,
                            isTablet,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      TeacherAttendanceState state,
      ColorScheme cs,
      bool isTablet,
      ) {
    if (state is TeacherAttendanceLoading) {
      return Center(
        child: CircularProgressIndicator(
            color: cs.primary, strokeWidth: 2.5),
      );
    }

    if (state is TeacherAttendanceError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 40, color: cs.error.withOpacity(0.5)),
              const SizedBox(height: 12),
              Text(
                state.errorMessage,
                style: TextStyle(
                    fontFamily: 'Cairo',
                    color: cs.error,
                    fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () =>
                    context.read<TeacherAttendanceCubit>().fetchTeachers(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(context.tr('btn_retry'),
                    style:
                    const TextStyle(fontFamily: 'Cairo')),
                style: TextButton.styleFrom(
                  foregroundColor: cs.primary,
                  side:
                  BorderSide(color: cs.primary.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state is TeacherAttendanceSuccess) {
      return TeachersAttendanceGrid(
        key: ValueKey(
            state.teachers.isNotEmpty ? state.teachers.first.id : 0),
        teachers:      state.teachers,
        attendanceMap: state.attendanceMap,
        isTablet:      isTablet,
      );
    }

    return const SizedBox();
  }

  void _showSnack(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(
          color == const Color(0xFF0F766E)
              ? Icons.check_circle_rounded
              : Icons.error_outline_rounded,
          color: Colors.white, size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(msg,
              style: const TextStyle(
                  fontFamily: 'Cairo', fontSize: 13)),
        ),
      ]),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ));
  }
}