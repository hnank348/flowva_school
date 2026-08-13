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
            create: (_) => AddExamCubit(examCubit.service),
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

class _AddExamForm extends StatefulWidget {
  final int sectionId;
  final BuildContext sheetContext;
  final ExamModel? examToEdit;

  const _AddExamForm({
    required this.sectionId,
    required this.sheetContext,
    this.examToEdit,
  });

  @override
  State<_AddExamForm> createState() => _AddExamFormState();
}

class _AddExamFormState extends State<_AddExamForm> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _roomCtrl;
  late final TextEditingController _totalMarksCtrl;
  late final TextEditingController _passMarksCtrl;
  late final TextEditingController _instructionsCtrl;

  ExamTypeOption? _examType;
  int? _subjectId;
  int? _teacherId;
  DateTime? _examDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    final edit = widget.examToEdit;

    _nameCtrl         = TextEditingController(text: edit?.name ?? '');
    _nameArCtrl       = TextEditingController(text: edit?.nameAr ?? edit?.name ?? '');
    _roomCtrl         = TextEditingController(text: edit?.room ?? '');
    _totalMarksCtrl   = TextEditingController(text: edit?.totalMarks.toStringAsFixed(0) ?? '100');
    _passMarksCtrl    = TextEditingController(text: edit?.passMarks.toStringAsFixed(0) ?? '50');
    _instructionsCtrl = TextEditingController(text: edit?.instructions ?? '');

    if (edit != null) {
      _subjectId = edit.subject.id;
      _teacherId = edit.teacher.id;
      _examDate  = DateTime.tryParse(edit.examDate);

      if (edit.startTime.isNotEmpty) {
        final parts = edit.startTime.split(':');
        if (parts.length >= 2) {
          _startTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
      }
      if (edit.endTime.isNotEmpty) {
        final parts = edit.endTime.split(':');
        if (parts.length >= 2) {
          _endTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
        }
      }

      try {
        _examType = ExamTypeOption.values.firstWhere(
              (element) => element.id == edit.examType.id || element.nameEn.toLowerCase() == edit.examType.name.toLowerCase(),
        );
      } catch (_) {
        _examType = ExamTypeOption.values.first;
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _roomCtrl.dispose();
    _totalMarksCtrl.dispose();
    _passMarksCtrl.dispose();
    _instructionsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _examDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _examDate = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? (_startTime ?? TimeOfDay.now()) : (_endTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() => isStart ? _startTime = picked : _endTime = picked);
    }
  }

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _submit() {
    final isEdit = widget.examToEdit != null;

    if (!isEdit) {
      if (_nameCtrl.text.trim().isEmpty ||
          _examType == null ||
          _subjectId == null ||
          _teacherId == null ||
          _examDate == null ||
          _startTime == null ||
          _endTime == null ||
          _roomCtrl.text.trim().isEmpty) {
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
        name:           _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : null,
        nameAr:         _nameArCtrl.text.trim().isNotEmpty ? _nameArCtrl.text.trim() : null,
        examTypeId:     _examType?.id,
        subjectId:      _subjectId,
        sectionId:      widget.sectionId,
        academicYearId: yearState.currentYear.id,
        semesterId:     semesterState.currentSemester.id,
        teacherId:      _teacherId,
        examDate:       _examDate != null ? '${_examDate!.year}-${_examDate!.month.toString().padLeft(2, '0')}-${_examDate!.day.toString().padLeft(2, '0')}' : null,
        startTime:      _startTime != null ? _fmtTime(_startTime!) : null,
        endTime:        _endTime != null ? _fmtTime(_endTime!) : null,
        room:           _roomCtrl.text.trim().isNotEmpty ? _roomCtrl.text.trim() : null,
        totalMarks:     double.tryParse(_totalMarksCtrl.text),
        passMarks:      double.tryParse(_passMarksCtrl.text),
        instructions:   _instructionsCtrl.text.trim().isNotEmpty ? _instructionsCtrl.text.trim() : null,
      );

      context.read<ManageExamCubit>().updateExam(widget.examToEdit!.id, updateReq);
    } else {
      final addReq = AddExamRequest(
        name:           _nameCtrl.text.trim(),
        nameAr:         _nameArCtrl.text.trim().isEmpty ? _nameCtrl.text.trim() : _nameArCtrl.text.trim(),
        examTypeId:     _examType!.id,
        subjectId:      _subjectId!,
        sectionId:      widget.sectionId,
        academicYearId: yearState.currentYear.id,
        semesterId:     semesterState.currentSemester.id,
        teacherId:      _teacherId!,
        examDate:       '${_examDate!.year}-${_examDate!.month.toString().padLeft(2, '0')}-${_examDate!.day.toString().padLeft(2, '0')}',
        startTime:      _fmtTime(_startTime!),
        endTime:        _fmtTime(_endTime!),
        room:           _roomCtrl.text.trim(),
        totalMarks:     double.tryParse(_totalMarksCtrl.text) ?? 100,
        passMarks:      double.tryParse(_passMarksCtrl.text) ?? 50,
        instructions:   _instructionsCtrl.text.trim(),
      );

      context.read<AddExamCubit>().submit(addReq);
    }
  }

  void _refreshList() {
    final semesterState = context.read<CurrentSemesterCubit>().state;
    final semId = semesterState is CurrentSemesterSuccess ? semesterState.currentSemester.id : 1;
    context.read<ExamScheduleCubit>().fetchExams(sectionId: widget.sectionId, semesterId: semId);
  }

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = widget.examToEdit != null;

    return MultiBlocListener(
      listeners: [
        BlocListener<AddExamCubit, AddExamState>(
          listener: (context, state) {
            if (state is AddExamSuccess) {
              Navigator.pop(widget.sheetContext);
              _refreshList();
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
              Navigator.pop(widget.sheetContext);
              _refreshList();
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
                bottom: MediaQuery.of(widget.sheetContext).viewInsets.bottom + 24,
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
                        Expanded(child: ExamTextField(controller: _nameCtrl, label: context.tr('exam_name_en'), icon: Icons.badge_outlined)),
                        const SizedBox(width: 10),
                        Expanded(child: ExamTextField(controller: _nameArCtrl, label: context.tr('exam_name_ar'), icon: Icons.badge_outlined)),
                      ]),
                      const SizedBox(height: 14),

                      ExamTypeDropdownField(value: _examType, onChanged: (v) => setState(() => _examType = v)),
                      const SizedBox(height: 14),

                      ExamSubjectDropdownField(selectedSubjectId: _subjectId, onChanged: (v) => setState(() => _subjectId = v)),
                      const SizedBox(height: 14),

                      ExamTeacherDropdownField(selectedTeacherId: _teacherId, onChanged: (v) => setState(() => _teacherId = v)),
                      const SizedBox(height: 14),

                      Row(children: [
                        Expanded(child: _pickerTile(context, icon: Icons.calendar_month_outlined,
                            label: _examDate == null ? context.tr('exam_date') : '${_examDate!.year}-${_examDate!.month}-${_examDate!.day}',
                            onTap: _pickDate)),
                        const SizedBox(width: 10),
                        Expanded(child: _pickerTile(context, icon: Icons.play_circle_outline_rounded,
                            label: _startTime == null ? context.tr('exam_start_time') : _fmtTime(_startTime!),
                            onTap: () => _pickTime(true))),
                        const SizedBox(width: 10),
                        Expanded(child: _pickerTile(context, icon: Icons.stop_circle_outlined,
                            label: _endTime == null ? context.tr('exam_end_time') : _fmtTime(_endTime!),
                            onTap: () => _pickTime(false))),
                      ]),
                      const SizedBox(height: 14),

                      ExamTextField(controller: _roomCtrl, label: context.tr('exam_room'), icon: Icons.meeting_room_outlined),
                      const SizedBox(height: 14),

                      Row(children: [
                        Expanded(child: ExamTextField(controller: _totalMarksCtrl, label: context.tr('exam_total_marks'), icon: Icons.grade_outlined, keyboardType: TextInputType.number)),
                        const SizedBox(width: 10),
                        Expanded(child: ExamTextField(controller: _passMarksCtrl, label: context.tr('exam_pass_marks'), icon: Icons.check_circle_outline_rounded, keyboardType: TextInputType.number)),
                      ]),
                      const SizedBox(height: 14),

                      ExamTextField(controller: _instructionsCtrl, label: context.tr('exam_instructions'), icon: Icons.info_outline_rounded),
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
                              onPressed: isLoading ? null : _submit,
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
                              onPressed: () => Navigator.pop(widget.sheetContext),
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