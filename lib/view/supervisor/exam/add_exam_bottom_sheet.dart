import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/subjects/subjects_cubit.dart';
import 'package:flowva_school/cubit/supervisor/teachers/teachers_cubit.dart';
import 'package:flowva_school/cubit/current_year/current_year_cubit.dart';
import 'package:flowva_school/cubit/current_year/current_year_state.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_cubit.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_state.dart';
import 'package:flowva_school/models/supervisor/add_exam_request_model.dart';
import 'package:flowva_school/models/supervisor/update_exam_request_model.dart';
import 'package:flowva_school/models/supervisor/exam_model.dart';
import '../../../cubit/supervisor/exam_schedule/add_exam_cubit.dart';
import '../../../cubit/supervisor/exam_schedule/add_exam_state.dart';
import '../../../cubit/supervisor/exam_schedule/exam_schedule_cubit.dart';
import '../../../cubit/supervisor/exam_schedule/manage_exam_cubit.dart';
import '../../../cubit/supervisor/exam_schedule/manage_exam_state.dart';
import '../../../app_localizations.dart';
import 'add_exam_form_fields.dart';
import '../../../models/supervisor/exam_type_option.dart';

class AddExamBottomSheet {
  static void show(BuildContext context, {required int sectionId, ExamModel? examToEdit}) {
    final subjectsCubit = context.read<SubjectsCubit>();
    final teachersCubit = context.read<TeachersCubit>();
    final examCubit     = context.read<ExamScheduleCubit>();
    final manageCubit   = context.read<ManageExamCubit>();
    final yearCubit      = context.read<CurrentYearCubit>();
    final semesterCubit  = context.read<CurrentSemesterCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: subjectsCubit),
          BlocProvider.value(value: teachersCubit),
          BlocProvider.value(value: examCubit),
          BlocProvider.value(value: manageCubit),
          BlocProvider.value(value: yearCubit),
          BlocProvider.value(value: semesterCubit),
          BlocProvider<AddExamCubit>(
            create: (_) {
              final cubit = AddExamCubit(examCubit.service);
              if (examToEdit != null) {
                cubit.updateTextData(
                  nameEn: examToEdit.name,
                  nameAr: examToEdit.nameAr,
                  room: examToEdit.room,
                  totalMarks: examToEdit.totalMarks.toStringAsFixed(0),
                  passMarks: examToEdit.passMarks.toStringAsFixed(0),
                  instructions: examToEdit.instructions,
                );
              }
              return cubit;
            },
          ),
        ],
        child: _AddExamForm(
          sectionId: sectionId,
          sheetContext: sheetCtx,
          examToEdit: examToEdit,
        ),
      ),
    );
  }
}

class _AddExamForm extends StatelessWidget {
  final int sectionId;
  final BuildContext sheetContext;
  final ExamModel? examToEdit;

  const _AddExamForm({
    required this.sectionId,
    required this.sheetContext,
    this.examToEdit,
  });

  Future<void> _pickDate(BuildContext context) async {
    final addCubit = context.read<AddExamCubit>();
    final picked = await showDatePicker(
      context: context,
      initialDate: addCubit.state.examDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) addCubit.setExamDate(picked);
  }

  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final addCubit = context.read<AddExamCubit>();
    final current = isStart ? addCubit.state.startTime : addCubit.state.endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: current ?? TimeOfDay.now(),
    );
    if (picked != null) {
      if (isStart) {
        addCubit.setStartTime(picked);
      } else {
        addCubit.setEndTime(picked);
      }
    }
  }

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _submit(BuildContext context) {
    final isEdit = examToEdit != null;
    final addState = context.read<AddExamCubit>().state;

    if (!isEdit) {
      if (addState.nameEn.trim().isEmpty ||
          addState.examType == null ||
          addState.subjectId == null ||
          addState.teacherId == null ||
          addState.examDate == null ||
          addState.startTime == null ||
          addState.endTime == null ||
          addState.room.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.tr('exam_error_required'), style: const TextStyle(fontFamily: 'Cairo')),
        ));
        return;
      }
    }

    final yearState     = context.read<CurrentYearCubit>().state;
    final semesterState = context.read<CurrentSemesterCubit>().state;

    if (yearState is! CurrentYearSuccess || semesterState is! CurrentSemesterSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.tr('exam_error_year_semester'), style: const TextStyle(fontFamily: 'Cairo')),
      ));
      return;
    }

    if (isEdit) {
      final updateReq = UpdateExamRequest(
        name:           addState.nameEn.trim().isNotEmpty ? addState.nameEn.trim() : null,
        nameAr:         addState.nameAr.trim().isNotEmpty ? addState.nameAr.trim() : null,
        examTypeId:     addState.examType?.id,
        subjectId:      addState.subjectId,
        sectionId:      sectionId,
        academicYearId: yearState.currentYear.id,
        semesterId:     semesterState.currentSemester.id,
        teacherId:      addState.teacherId,
        examDate:       addState.examDate != null ? '${addState.examDate!.year}-${addState.examDate!.month.toString().padLeft(2, '0')}-${addState.examDate!.day.toString().padLeft(2, '0')}' : null,
        startTime:      addState.startTime != null ? _fmtTime(addState.startTime!) : null,
        endTime:        addState.endTime != null ? _fmtTime(addState.endTime!) : null,
        room:           addState.room.trim().isNotEmpty ? addState.room.trim() : null,
        totalMarks:     double.tryParse(addState.totalMarks),
        passMarks:      double.tryParse(addState.passMarks),
        instructions:   addState.instructions.trim().isNotEmpty ? addState.instructions.trim() : null,
      );

      context.read<ManageExamCubit>().updateExam(
        examId: examToEdit!.id,
        request: updateReq,
        tr: context.tr,
      );
    } else {
      final addReq = AddExamRequest(
        name:           addState.nameEn.trim(),
        nameAr:         addState.nameAr.trim().isEmpty ? addState.nameEn.trim() : addState.nameAr.trim(),
        examTypeId:     addState.examType!.id,
        subjectId:      addState.subjectId!,
        sectionId:      sectionId,
        academicYearId: yearState.currentYear.id,
        semesterId:     semesterState.currentSemester.id,
        teacherId:      addState.teacherId!,
        examDate:       '${addState.examDate!.year}-${addState.examDate!.month.toString().padLeft(2, '0')}-${addState.examDate!.day.toString().padLeft(2, '0')}',
        startTime:      _fmtTime(addState.startTime!),
        endTime:        _fmtTime(addState.endTime!),
        room:           addState.room.trim(),
        totalMarks:     double.tryParse(addState.totalMarks) ?? 100,
        passMarks:      double.tryParse(addState.passMarks) ?? 50,
        instructions:   addState.instructions.trim(),
      );

      context.read<AddExamCubit>().submit(
        request: addReq,
        tr: context.tr,
      );
    }
  }

  void _refreshList(BuildContext context) {
    final semesterState = context.read<CurrentSemesterCubit>().state;
    final semId = semesterState is CurrentSemesterSuccess ? semesterState.currentSemester.id : 1;
    context.read<ExamScheduleCubit>().fetchExams(sectionId: sectionId, semesterId: semId);
  }

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = examToEdit != null;

    return MultiBlocListener(
      listeners: [
        BlocListener<AddExamCubit, AddExamState>(
          listener: (context, state) {
            if (state is AddExamSuccess) {
              Navigator.pop(sheetContext);
              _refreshList(context);
              context.read<AddExamCubit>().reset();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(context.tr('exam_success_add'), style: const TextStyle(fontFamily: 'Cairo')),
                backgroundColor: const Color(0xFF0F766E),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ));
            }
            if (state is AddExamError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message, style: const TextStyle(fontFamily: 'Cairo')),
                backgroundColor: cs.error,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ));
            }
          },
        ),
        BlocListener<ManageExamCubit, ManageExamState>(
          listener: (context, state) {
            if (state is UpdateExamSuccess) {
              Navigator.pop(sheetContext);
              _refreshList(context);
              context.read<ManageExamCubit>().reset();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(context.tr('exam_success_update'), style: const TextStyle(fontFamily: 'Cairo')),
                backgroundColor: const Color(0xFF0F766E),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ));
            }
            if (state is ManageExamError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message, style: const TextStyle(fontFamily: 'Cairo')),
                backgroundColor: cs.error,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
              ));
            }
          },
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return Center(
            child: Container(
              width: isWide ? 600 : double.infinity,
              margin: isWide ? EdgeInsets.symmetric(horizontal: (constraints.maxWidth - 600) / 2) : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
              ),
              padding: EdgeInsets.only(
                top: 16, left: 24, right: 24,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(child: Container(
                        width: 45, height: 4.5,
                        decoration: BoxDecoration(color: cs.outlineVariant, borderRadius: BorderRadius.circular(10)),
                      )),
                      const SizedBox(height: 20),
                      Text(
                        isEdit ? context.tr('exam_edit_title') : context.tr('exam_add_title'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: isDark ? cs.primary : const Color(0xFF234E52),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      Row(children: [
                        Expanded(
                          child: ExamTextField(
                            initialValue: context.read<AddExamCubit>().state.nameEn,
                            onChanged: (v) => context.read<AddExamCubit>().updateTextData(nameEn: v),
                            label: context.tr('exam_name_en'),
                            icon: Icons.badge_outlined,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ExamTextField(
                            initialValue: context.read<AddExamCubit>().state.nameAr,
                            onChanged: (v) => context.read<AddExamCubit>().updateTextData(nameAr: v),
                            label: context.tr('exam_name_ar'),
                            icon: Icons.badge_outlined,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 14),

                      BlocBuilder<AddExamCubit, AddExamState>(
                        builder: (context, state) {
                          return ExamTypeDropdownField(
                            value: state.examType,
                            onChanged: (v) => context.read<AddExamCubit>().setExamType(v),
                          );
                        },
                      ),
                      const SizedBox(height: 14),

                      BlocBuilder<AddExamCubit, AddExamState>(
                        builder: (context, state) {
                          return ExamSubjectDropdownField(
                            selectedSubjectId: state.subjectId,
                            onChanged: (v) => context.read<AddExamCubit>().setSubjectId(v),
                          );
                        },
                      ),
                      const SizedBox(height: 14),

                      BlocBuilder<AddExamCubit, AddExamState>(
                        builder: (context, state) {
                          return ExamTeacherDropdownField(
                            selectedTeacherId: state.teacherId,
                            onChanged: (v) => context.read<AddExamCubit>().setTeacherId(v),
                          );
                        },
                      ),
                      const SizedBox(height: 14),

                      BlocBuilder<AddExamCubit, AddExamState>(
                        builder: (context, state) {
                          return Row(children: [
                            Expanded(
                              child: _pickerTile(
                                context,
                                icon: Icons.calendar_month_outlined,
                                label: state.examDate == null
                                    ? context.tr('exam_date')
                                    : '${state.examDate!.year}-${state.examDate!.month.toString().padLeft(2, '0')}-${state.examDate!.day.toString().padLeft(2, '0')}',
                                onTap: () => _pickDate(context),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _pickerTile(
                                context,
                                icon: Icons.play_circle_outline_rounded,
                                label: state.startTime == null ? context.tr('exam_start_time') : _fmtTime(state.startTime!),
                                onTap: () => _pickTime(context, true),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _pickerTile(
                                context,
                                icon: Icons.stop_circle_outlined,
                                label: state.endTime == null ? context.tr('exam_end_time') : _fmtTime(state.endTime!),
                                onTap: () => _pickTime(context, false),
                              ),
                            ),
                          ]);
                        },
                      ),
                      const SizedBox(height: 14),

                      ExamTextField(
                        initialValue: context.read<AddExamCubit>().state.room,
                        onChanged: (v) => context.read<AddExamCubit>().updateTextData(room: v),
                        label: context.tr('exam_room'),
                        icon: Icons.meeting_room_outlined,
                      ),
                      const SizedBox(height: 14),

                      Row(children: [
                        Expanded(
                          child: ExamTextField(
                            initialValue: context.read<AddExamCubit>().state.totalMarks,
                            onChanged: (v) => context.read<AddExamCubit>().updateTextData(totalMarks: v),
                            label: context.tr('exam_total_marks'),
                            icon: Icons.grade_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ExamTextField(
                            initialValue: context.read<AddExamCubit>().state.passMarks,
                            onChanged: (v) => context.read<AddExamCubit>().updateTextData(passMarks: v),
                            label: context.tr('exam_pass_marks'),
                            icon: Icons.check_circle_outline_rounded,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 14),

                      ExamTextField(
                        initialValue: context.read<AddExamCubit>().state.instructions,
                        onChanged: (v) => context.read<AddExamCubit>().updateTextData(instructions: v),
                        label: context.tr('exam_instructions'),
                        icon: Icons.info_outline_rounded,
                      ),
                      const SizedBox(height: 24),

                      Builder(
                        builder: (context) {
                          final addState    = context.watch<AddExamCubit>().state;
                          final manageState = context.watch<ManageExamCubit>().state;
                          final isLoading   = addState is AddExamLoading || manageState is ManageExamLoading;

                          return Row(children: [
                            Expanded(flex: 2, child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark ? cs.primary : const Color(0xFF234E52),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: isLoading ? null : () => _submit(context),
                              child: isLoading
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : Text(isEdit ? context.tr('session_btn_save') : context.tr('session_btn_add'), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                            )),
                            const SizedBox(width: 12),
                            Expanded(child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: cs.outlineVariant),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => Navigator.pop(sheetContext),
                              child: Text(context.tr('session_btn_cancel'), style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14, fontFamily: 'Cairo')),
                            )),
                          ]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _pickerTile(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.6), width: 1.5),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: cs.primary),
          const SizedBox(width: 6),
          Flexible(child: Text(label, style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: cs.onSurfaceVariant, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
        ]),
      ),
    );
  }
}