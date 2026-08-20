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
import '../../../models/supervisor/exam_type_option.dart';
import '../../../widget/button.dart';
import '../../../app_localizations.dart';
import 'add_exam_form_fields.dart';

class AddExamBottomSheet {
  static void show(BuildContext context, {required int sectionId, ExamModel? examToEdit}) {
    final subjectsCubit = context.read<SubjectsCubit>();
    final teachersCubit = context.read<TeachersCubit>();
    final examCubit     = context.read<ExamScheduleCubit>();
    final manageCubit   = context.read<ManageExamCubit>();
    final yearCubit     = context.read<CurrentYearCubit>();
    final semesterCubit = context.read<CurrentSemesterCubit>();

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

                if (examToEdit.subject != null) {
                  cubit.setSubjectId(examToEdit.subject!.id);
                }
                if (examToEdit.teacher != null) {
                  cubit.setTeacherId(examToEdit.teacher!.id);
                }

                if (examToEdit.examType != null) {
                  try {
                    final matchedType = ExamTypeOption.values.firstWhere(
                          (t) =>
                      t.id == examToEdit.examType!.id ||
                          t.nameEn.toLowerCase() == examToEdit.examType!.name.toLowerCase(),
                    );
                    cubit.setExamType(matchedType);
                  } catch (_) {}
                }

                try {
                  final parsedDate = DateTime.parse(examToEdit.examDate);
                  cubit.setExamDate(parsedDate);
                } catch (_) {}

                if (examToEdit.startTime != null && examToEdit.startTime!.isNotEmpty) {
                  final parts = examToEdit.startTime!.split(':');
                  if (parts.length >= 2) {
                    cubit.setStartTime(TimeOfDay(
                      hour: int.tryParse(parts[0]) ?? 0,
                      minute: int.tryParse(parts[1]) ?? 0,
                    ));
                  }
                }

                if (examToEdit.endTime != null && examToEdit.endTime!.isNotEmpty) {
                  final parts = examToEdit.endTime!.split(':');
                  if (parts.length >= 2) {
                    cubit.setEndTime(TimeOfDay(
                      hour: int.tryParse(parts[0]) ?? 0,
                      minute: int.tryParse(parts[1]) ?? 0,
                    ));
                  }
                }
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

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _submit(BuildContext context) {
    final isEdit = examToEdit != null;
    final addState = context.read<AddExamCubit>().state;

    final nameEn = addState.nameEn.trim();
    final nameAr = addState.nameAr.trim();
    final room = addState.room.trim();
    final totalMarks = addState.totalMarks.trim();
    final passMarks = addState.passMarks.trim();
    final instructions = addState.instructions.trim();

    if (!isEdit) {
      if (nameEn.isEmpty ||
          addState.examType == null ||
          addState.subjectId == null ||
          addState.teacherId == null ||
          addState.examDate == null ||
          addState.startTime == null ||
          addState.endTime == null ||
          room.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(context.tr('exam_error_required'), style: const TextStyle(fontFamily: 'Cairo')),
        ));
        return;
      }
    }

    final yearState = context.read<CurrentYearCubit>().state;
    final semesterState = context.read<CurrentSemesterCubit>().state;

    if (yearState is! CurrentYearSuccess || semesterState is! CurrentSemesterSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.tr('exam_error_year_semester'), style: const TextStyle(fontFamily: 'Cairo')),
      ));
      return;
    }

    if (isEdit) {
      final updateReq = UpdateExamRequest(
        name:           nameEn.isNotEmpty ? nameEn : null,
        nameAr:         nameAr.isNotEmpty ? nameAr : null,
        examTypeId:     addState.examType?.id,
        subjectId:      addState.subjectId,
        sectionId:      sectionId,
        academicYearId: yearState.currentYear.id,
        semesterId:     semesterState.currentSemester.id,
        teacherId:      addState.teacherId,
        examDate:       addState.examDate != null
            ? '${addState.examDate!.year}-${addState.examDate!.month.toString().padLeft(2, '0')}-${addState.examDate!.day.toString().padLeft(2, '0')}'
            : null,
        startTime:      addState.startTime != null ? _fmtTime(addState.startTime!) : null,
        endTime:        addState.endTime != null ? _fmtTime(addState.endTime!) : null,
        room:           room.isNotEmpty ? room : null,
        totalMarks:     double.tryParse(totalMarks),
        passMarks:      double.tryParse(passMarks),
        instructions:   instructions.isNotEmpty ? instructions : null,
      );

      context.read<ManageExamCubit>().updateExam(
        examId: examToEdit!.id,
        request: updateReq,
        tr: context.tr,
      );
    } else {
      final addReq = AddExamRequest(
        name:           nameEn,
        nameAr:         nameAr.isEmpty ? nameEn : nameAr,
        examTypeId:     addState.examType!.id,
        subjectId:      addState.subjectId!,
        sectionId:      sectionId,
        academicYearId: yearState.currentYear.id,
        semesterId:     semesterState.currentSemester.id,
        teacherId:      addState.teacherId!,
        examDate:       '${addState.examDate!.year}-${addState.examDate!.month.toString().padLeft(2, '0')}-${addState.examDate!.day.toString().padLeft(2, '0')}',
        startTime:      _fmtTime(addState.startTime!),
        endTime:        _fmtTime(addState.endTime!),
        room:           room,
        totalMarks:     double.tryParse(totalMarks) ?? 100,
        passMarks:      double.tryParse(passMarks) ?? 50,
        instructions:   instructions,
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
    final cs = Theme.of(context).colorScheme;
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
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
              ));
            }
            if (state is AddExamError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message, style: const TextStyle(fontFamily: 'Cairo')),
                backgroundColor: cs.error,
                behavior: SnackBarBehavior.floating,
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
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
              ));
            }
            if (state is ManageExamError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message, style: const TextStyle(fontFamily: 'Cairo')),
                backgroundColor: cs.error,
                behavior: SnackBarBehavior.floating,
              ));
            }
          },
        ),
      ],
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        decoration: BoxDecoration(
          color: isDark ? cs.surfaceContainer : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.only(
          top: 14,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: cs.outlineVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isEdit ? context.tr('exam_edit_title') : context.tr('exam_add_title'),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: cs.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: ExamCustomInputField(
                        initialValue: context.read<AddExamCubit>().state.nameEn,
                        label: context.tr('exam_name_en'),
                        icon: Icons.badge_outlined,
                        onChanged: (v) => context.read<AddExamCubit>().updateTextData(nameEn: v),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ExamCustomInputField(
                        initialValue: context.read<AddExamCubit>().state.nameAr,
                        label: context.tr('exam_name_ar'),
                        icon: Icons.badge_outlined,
                        onChanged: (v) => context.read<AddExamCubit>().updateTextData(nameAr: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                BlocBuilder<AddExamCubit, AddExamState>(
                  builder: (context, state) {
                    return ExamTypeDropdownField(
                      value: state.examType,
                      onChanged: (v) => context.read<AddExamCubit>().setExamType(v),
                    );
                  },
                ),
                const SizedBox(height: 12),

                BlocBuilder<AddExamCubit, AddExamState>(
                  builder: (context, state) {
                    return ExamSubjectDropdownField(
                      selectedSubjectId: state.subjectId,
                      onChanged: (v) => context.read<AddExamCubit>().setSubjectId(v),
                    );
                  },
                ),
                const SizedBox(height: 12),

                BlocBuilder<AddExamCubit, AddExamState>(
                  builder: (context, state) {
                    return ExamTeacherDropdownField(
                      selectedTeacherId: state.teacherId,
                      onChanged: (v) => context.read<AddExamCubit>().setTeacherId(v),
                    );
                  },
                ),
                const SizedBox(height: 12),

                const ExamDateTimePickers(),
                const SizedBox(height: 12),

                ExamCustomInputField(
                  initialValue: context.read<AddExamCubit>().state.room,
                  label: context.tr('exam_room'),
                  icon: Icons.meeting_room_outlined,
                  onChanged: (v) => context.read<AddExamCubit>().updateTextData(room: v),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: ExamCustomInputField(
                        initialValue: context.read<AddExamCubit>().state.totalMarks,
                        label: context.tr('exam_total_marks'),
                        icon: Icons.grade_outlined,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => context.read<AddExamCubit>().updateTextData(totalMarks: v),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ExamCustomInputField(
                        initialValue: context.read<AddExamCubit>().state.passMarks,
                        label: context.tr('exam_pass_marks'),
                        icon: Icons.check_circle_outline_rounded,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => context.read<AddExamCubit>().updateTextData(passMarks: v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ExamCustomInputField(
                  initialValue: context.read<AddExamCubit>().state.instructions,
                  label: context.tr('exam_instructions'),
                  icon: Icons.info_outline_rounded,
                  onChanged: (v) => context.read<AddExamCubit>().updateTextData(instructions: v),
                ),
                const SizedBox(height: 20),

                Builder(
                  builder: (context) {
                    final addState = context.watch<AddExamCubit>().state;
                    final manageState = context.watch<ManageExamCubit>().state;
                    final isLoading = addState is AddExamLoading || manageState is ManageExamLoading;

                    return Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Button(
                            text: isEdit
                                ? context.tr('session_btn_save')
                                : context.tr('session_btn_add'),
                            icon: isEdit ? Icons.save_rounded : Icons.add_rounded,
                            color: cs.primary,
                            colorText: Colors.white,
                            height: 48,
                            onPressed: isLoading ? () {} : () => _submit(context),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Button(
                            text: context.tr('session_btn_cancel'),
                            color: Colors.transparent,
                            colorOutline: cs.outlineVariant,
                            colorText: cs.onSurfaceVariant,
                            height: 48,
                            onPressed: () => Navigator.pop(sheetContext),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}