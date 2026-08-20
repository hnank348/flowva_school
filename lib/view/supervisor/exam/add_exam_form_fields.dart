import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/subjects/subjects_cubit.dart';
import 'package:flowva_school/cubit/supervisor/subjects/subjects_state.dart';
import 'package:flowva_school/cubit/supervisor/teachers/teachers_cubit.dart';
import 'package:flowva_school/cubit/supervisor/teachers/teachers_state.dart';
import 'package:flowva_school/cubit/supervisor/exam_schedule/add_exam_cubit.dart';
import 'package:flowva_school/cubit/supervisor/exam_schedule/add_exam_state.dart';
import '../../../app_localizations.dart';
import '../../../models/supervisor/exam_type_option.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/field_styles.dart';

class ExamCustomInputField extends StatelessWidget {
  final String? initialValue;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;

  const ExamCustomInputField({
    super.key,
    this.initialValue,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13.5,
        color: cs.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: FieldStyles.authInputDecoration(label: label, icon: icon).copyWith(
        fillColor: cs.surfaceContainerLow,
        filled: true,
      ),
    );
  }
}

class ExamTypeDropdownField extends StatelessWidget {
  final ExamTypeOption? value;
  final ValueChanged<ExamTypeOption?> onChanged;

  const ExamTypeDropdownField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _ModernDropdown<ExamTypeOption>(
      value: value,
      label: context.tr('exam_select_type'),
      icon: Icons.category_outlined,
      items: ExamTypeOption.values.map((t) {
        return DropdownMenuItem(
          value: t,
          child: Text(
            t.nameAr.isNotEmpty ? t.nameAr : t.nameEn,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class ExamSubjectDropdownField extends StatelessWidget {
  final int? selectedSubjectId;
  final ValueChanged<int?> onChanged;

  const ExamSubjectDropdownField({
    super.key,
    required this.selectedSubjectId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectsCubit, SubjectsState>(
      builder: (context, state) {
        if (state is SubjectsLoading) return const _FieldLoading();
        if (state is SubjectsError) return _FieldError(message: state.errorMessage);
        if (state is SubjectsSuccess) {
          final hasSubject = state.subjects.any((s) => s.id == selectedSubjectId);
          return _ModernDropdown<int>(
            value: hasSubject ? selectedSubjectId : null,
            label: context.tr('exam_select_subject'),
            icon: Icons.auto_stories_rounded,
            items: state.subjects.map((s) {
              return DropdownMenuItem(
                value: s.id,
                child: Text(
                  s.nameAr.isNotEmpty ? s.nameAr : s.name,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          );
        }
        return const _FieldLoading();
      },
    );
  }
}

class ExamTeacherDropdownField extends StatelessWidget {
  final int? selectedTeacherId;
  final ValueChanged<int?> onChanged;

  const ExamTeacherDropdownField({
    super.key,
    required this.selectedTeacherId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeachersCubit, TeachersState>(
      builder: (context, state) {
        if (state is TeachersLoading) return const _FieldLoading();
        if (state is TeachersError) return _FieldError(message: state.errorMessage);
        if (state is TeachersSuccess) {
          final hasTeacher = state.teachers.any((t) => t.id == selectedTeacherId);
          return _ModernDropdown<int>(
            value: hasTeacher ? selectedTeacherId : null,
            label: context.tr('exam_select_teacher'),
            icon: Icons.supervisor_account_rounded,
            items: state.teachers.map((t) {
              return DropdownMenuItem(
                value: t.id,
                child: Text(
                  t.fullNameAr.isNotEmpty ? t.fullNameAr : t.fullName,
                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          );
        }
        return const _FieldLoading();
      },
    );
  }
}

class ExamDateTimePickers extends StatelessWidget {
  const ExamDateTimePickers({super.key});

  String _fmtTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExamCubit, AddExamState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: _PickerTile(
                icon: Icons.calendar_month_outlined,
                label: state.examDate == null
                    ? context.tr('exam_date')
                    : '${state.examDate!.year}-${state.examDate!.month.toString().padLeft(2, '0')}-${state.examDate!.day.toString().padLeft(2, '0')}',
                onTap: () => _pickDate(context),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PickerTile(
                icon: Icons.play_circle_outline_rounded,
                label: state.startTime == null
                    ? context.tr('exam_start_time')
                    : _fmtTime(state.startTime!),
                onTap: () => _pickTime(context, true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PickerTile(
                icon: Icons.stop_circle_outlined,
                label: state.endTime == null
                    ? context.tr('exam_end_time')
                    : _fmtTime(state.endTime!),
                onTap: () => _pickTime(context, false),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: cs.primary),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernDropdown<T> extends StatelessWidget {
  final T? value;
  final String label;
  final IconData icon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _ModernDropdown({
    required this.value,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DropdownButtonFormField<T>(
      value: value,
      dropdownColor: cs.surfaceContainerHigh,
      isExpanded: true,
      icon: Icon(Icons.keyboard_arrow_down_rounded, color: cs.onSurfaceVariant),
      decoration: FieldStyles.authInputDecoration(label: label, icon: icon).copyWith(
        fillColor: cs.surfaceContainerLow,
        filled: true,
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}

class _FieldLoading extends StatelessWidget {
  const _FieldLoading();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 14),
    child: Center(
      child: SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );
}

class _FieldError extends StatelessWidget {
  final String message;
  const _FieldError({required this.message});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: TextStyle(color: cs.error, fontFamily: 'Cairo', fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}