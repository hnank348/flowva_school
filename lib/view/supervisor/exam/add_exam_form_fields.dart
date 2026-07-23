import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/subjects/subjects_cubit.dart';
import 'package:flowva_school/cubit/supervisor/subjects/subjects_state.dart';
import 'package:flowva_school/cubit/supervisor/teachers/teachers_cubit.dart';
import 'package:flowva_school/cubit/supervisor/teachers/teachers_state.dart';
import '../../../app_localizations.dart';
import '../../../widget/supervisor/locale_name.dart';
import '../../../models/supervisor/exam_type_option.dart';

// ─── Dropdown نوع الامتحان ────────────────────────────────────────────
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
      value:       value,
      hint:        context.tr('exam_select_type'),
      icon:        Icons.category_outlined,
      activeColor: const Color(0xFFF97316),
      items: ExamTypeOption.values.map((t) {
        final name = resolveName(context, nameAr: t.nameAr, nameEn: t.nameEn);
        return DropdownMenuItem(value: t, child: _DropdownText(name));
      }).toList(),
      onChanged: onChanged,
    );
  }
}

// ─── Dropdown المواد ─────────────────────────────────────────────────────────
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
            value:       hasSubject ? selectedSubjectId : null,
            hint:        context.tr('exam_select_subject'),
            icon:        Icons.auto_stories_rounded,
            activeColor: const Color(0xFF3182CE),
            items: state.subjects.map((s) {
              final name = resolveName(context, nameAr: s.nameAr, nameEn: s.name);
              return DropdownMenuItem(value: s.id, child: _DropdownText(name));
            }).toList(),
            onChanged: onChanged,
          );
        }
        return const _FieldLoading();
      },
    );
  }
}

// ─── Dropdown المعلمين ───────────────────────────────────────────────────────
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
        if (state is TeachersLoading) {
          return _ModernDropdown<int>(
            value: null, hint: context.tr('exam_loading_teachers'),
            icon: Icons.supervisor_account_rounded, activeColor: const Color(0xFF805AD5),
            items: const [], onChanged: (_) {},
          );
        }
        if (state is TeachersError) return _FieldError(message: state.errorMessage);
        if (state is TeachersSuccess) {
          final hasTeacher = state.teachers.any((t) => t.id == selectedTeacherId);
          return _ModernDropdown<int>(
            value:       hasTeacher ? selectedTeacherId : null,
            hint:        context.tr('exam_select_teacher'),
            icon:        Icons.supervisor_account_rounded,
            activeColor: const Color(0xFF805AD5),
            items: state.teachers.map((t) {
              final name = resolveName(context, nameAr: t.fullNameAr, nameEn: t.fullName);
              return DropdownMenuItem(value: t.id, child: _DropdownText(name));
            }).toList(),
            onChanged: onChanged,
          );
        }
        return const _FieldLoading();
      },
    );
  }
}

// ─── حقل نصي عام ─────────────────────────────────────────────────────────────
class ExamTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;

  const ExamTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller:   controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText:  label,
        labelStyle: TextStyle(fontFamily: 'Cairo', color: cs.onSurfaceVariant, fontSize: 13),
        prefixIcon: Icon(icon, color: cs.primary),
        filled: true, fillColor: cs.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.outlineVariant.withOpacity(0.6), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
      ),
    );
  }
}

class _ModernDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final IconData icon;
  final Color activeColor;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _ModernDropdown({
    required this.value, required this.hint, required this.icon,
    required this.activeColor, required this.items, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DropdownButtonFormField<T>(
      initialValue: value, dropdownColor: cs.surfaceContainerLow, isExpanded: true,
      hint: Text(hint, style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.onSurfaceVariant),
          maxLines: 1, overflow: TextOverflow.ellipsis),
      icon: Icon(Icons.arrow_drop_down_circle_outlined, color: cs.onSurfaceVariant.withOpacity(0.6), size: 22),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: activeColor),
        filled: true, fillColor: cs.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.outlineVariant.withOpacity(0.6), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: activeColor, width: 2),
        ),
      ),
      items: items, onChanged: onChanged,
    );
  }
}

class _DropdownText extends StatelessWidget {
  final String text;
  const _DropdownText(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w600));
}

class _FieldLoading extends StatelessWidget {
  const _FieldLoading();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: Center(child: SizedBox(width: 24, height: 24,
        child: CircularProgressIndicator(strokeWidth: 2.5))),
  );
}

class _FieldError extends StatelessWidget {
  final String message;
  const _FieldError({required this.message});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cs.error.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(message,
          style: TextStyle(color: cs.error, fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center),
    );
  }
}