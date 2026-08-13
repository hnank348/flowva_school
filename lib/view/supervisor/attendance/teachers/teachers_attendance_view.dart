import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import 'package:flowva_school/app_localizations.dart';
import 'package:flowva_school/cubit/supervisor/submit_teacher/teacher_attendance_state.dart';
import 'package:flowva_school/cubit/supervisor/submit_teacher/teachers_attendance_cubit.dart';
import '../../../../widget/supervisor/attendance_edit_mode_badge.dart';
import '../../../../widget/supervisor/attendance_error_view.dart';
import '../../../../widget/supervisor/attendance_loading_indicator.dart';
import '../../../../widget/supervisor/attendance_page_app_bar.dart';
import '../../../../widget/supervisor/attendance_save_all_button.dart';
import '../../../../widget/supervisor/attendance_snack.dart';
import 'teacher_attendance_grid.dart';
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
      teachers: state.teachers,
      attendanceMap: state.attendanceMap,
      noteMap:       state.noteMap,
      tr: context.tr,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cubit = context.read<TeacherAttendanceCubit>();

    // ✅ إعادة الجلب التلقائي عند بداية الشاشة إذا كانت الحالة Initial
    if (cubit.state is TeacherAttendanceInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        cubit.fetchTeachers(tr: context.tr,);
      });
    }

    return BlocListener<SubmitTeacherAttendanceCubit,
        SubmitTeacherAttendanceState>(
      listener: (context, state) {
        if (state is SubmitTeacherAttendanceSuccess) {
          showAttendanceSnack(context, state.message, const Color(0xFF0F766E));
          context.read<SubmitTeacherAttendanceCubit>().reset();
          cubit.fetchTeachers(tr: context.tr,);
        }
        if (state is SubmitTeacherAttendanceError) {
          showAttendanceSnack(context, state.errorMessage, cs.error);
        }
      },
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return Directionality(
            textDirection: localeState.textDirection,
            child: BlocBuilder<TeacherAttendanceCubit, TeacherAttendanceState>(
              builder: (context, attendanceState) {
                final isRecordMode = attendanceState is TeacherAttendanceSuccess;
                final isViewMode = attendanceState is TeacherAttendanceViewMode;
                final hasData = isRecordMode || isViewMode;
                final isTablet = MediaQuery.of(context).size.width > 650;
                final hPad = isTablet ? 20.0 : 14.0;

                return Scaffold(
                  backgroundColor: cs.surface,
                  appBar: AttendancePageAppBar(
                    title: isViewMode
                        ? context.tr('attendance_view_title_edit')
                        : context.tr('teachers_attendance_title'),
                    trailing: isRecordMode
                        ? BlocBuilder<SubmitTeacherAttendanceCubit,
                        SubmitTeacherAttendanceState>(
                      builder: (context, submitState) {
                        return AttendanceSaveAllButton(
                          isLoading: submitState
                          is SubmitTeacherAttendanceLoading,
                          onTap: () => _submit(context),
                        );
                      },
                    )
                        : isViewMode
                        ? const AttendanceEditModeBadge()
                        : null,
                  ),
                  body: SafeArea(
                    // 🔴 ميزة السحب للتحديث الشاملة
                    child: RefreshIndicator.adaptive(
                      onRefresh: () => cubit.fetchTeachers(tr: context.tr,),
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          if (hasData)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(hPad, 16, hPad, 10),
                                child: TeacherAttendanceSummaryBar(
                                  attendanceMap: isViewMode
                                      ? (attendanceState).attendanceMap
                                      : (attendanceState as TeacherAttendanceSuccess).attendanceMap,
                                ),
                              ),
                            ),
                          SliverFillRemaining(
                            hasScrollBody: true,
                            child: _buildBody(context, attendanceState, cs, isTablet),
                          ),
                        ],
                      ),
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
    if (state is TeacherAttendanceLoading || state is TeacherAttendanceInitial) {
      return const AttendanceLoadingIndicator();
    }

    if (state is TeacherAttendanceError) {
      return Center(
        child: AttendanceErrorView(
          message: state.errorMessage,
          onRetry: () => context.read<TeacherAttendanceCubit>().fetchTeachers(tr: context.tr,),
        ),
      );
    }

    if (state is TeacherAttendanceSuccess) {
      return TeachersAttendanceGrid.record(
        key: ValueKey(
            'record_${state.teachers.isNotEmpty ? state.teachers.first.id : 0}'),
        teachers: state.teachers,
        attendanceMap: state.attendanceMap,
        noteMap: state.noteMap,
        isTablet: isTablet,
      );
    }

    if (state is TeacherAttendanceViewMode) {
      return TeachersAttendanceGrid.view(
        key: ValueKey(
            'view_${state.records.isNotEmpty ? state.records.first.id : 0}'),
        records: state.records,
        editMap: state.editMap,
        isTablet: isTablet,
      );
    }

    return const SizedBox();
  }
}