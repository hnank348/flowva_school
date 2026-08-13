import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/supervisor/subjects/subjects_cubit.dart';
import '../../../cubit/supervisor/subjects/subjects_state.dart';
import '../../../cubit/supervisor/teachers/teachers_cubit.dart';
import '../../../cubit/supervisor/teachers/teachers_state.dart';
import '../../../app_localizations.dart';

// ─── Dropdown المواد ─────────────────────────────────────────────────────────
class SubjectDropdownField extends StatelessWidget {
  final int? selectedSubjectId;
  final bool isArabic;
  final ValueChanged<int?> onChanged;

  const SubjectDropdownField({
    super.key,
    required this.selectedSubjectId,
    required this.isArabic,
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
          final effectiveId = hasSubject ? selectedSubjectId : null;

          return _ModernDropdown<int>(
            value:       effectiveId,
            hint:        context.tr('session_hint_subject'),
            icon:        Icons.auto_stories_rounded,
            activeColor: const Color(0xFF3182CE),
            items: state.subjects.map((s) {
              final name = isArabic
                  ? (s.nameAr.isNotEmpty ? s.nameAr : s.name)
                  : (s.name.isNotEmpty   ? s.name   : s.nameAr);
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
class TeacherDropdownField extends StatelessWidget {
  final int? selectedTeacherId;
  final bool isArabic;
  final ValueChanged<int?> onChanged;

  const TeacherDropdownField({
    super.key,
    required this.selectedTeacherId,
    required this.isArabic,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeachersCubit, TeachersState>(
      builder: (context, state) {
        if (state is TeachersLoading) {
          return _ModernDropdown<int>(
            value: null, hint: context.tr('session_loading_teachers'),
            icon: Icons.supervisor_account_rounded, activeColor: const Color(0xFF805AD5),
            items: const [], onChanged: (_) {},
          );
        }
        if (state is TeachersError) return _FieldError(message: state.errorMessage);
        if (state is TeachersInitial) {
          context.read<TeachersCubit>().fetchTeachers();
          return _ModernDropdown<int>(
            value: null, hint: context.tr('session_init_teachers'),
            icon: Icons.supervisor_account_rounded, activeColor: const Color(0xFF805AD5),
            items: const [], onChanged: (_) {},
          );
        }
        if (state is TeachersSuccess) {
          final hasTeacher = state.teachers.any((t) => t.id == selectedTeacherId);
          final effectiveId = hasTeacher ? selectedTeacherId : null;

          return _ModernDropdown<int>(
            value:       effectiveId,
            hint:        context.tr('session_hint_teacher'),
            icon:        Icons.supervisor_account_rounded,
            activeColor: const Color(0xFF805AD5),
            items: state.teachers.map((t) {
              final name = isArabic
                  ? (t.fullNameAr.isNotEmpty ? t.fullNameAr : t.fullName)
                  : (t.fullName.isNotEmpty   ? t.fullName   : t.fullNameAr);
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

// ─── حقل القاعة ─────────────────────────────────────────────────────────────
class RoomTextField extends StatelessWidget {
  final TextEditingController controller;

  const RoomTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText:   context.tr('session_label_room'),
        labelStyle:  TextStyle(fontFamily: 'Cairo', color: colorScheme.onSurfaceVariant, fontSize: 13),
        prefixIcon:  Icon(Icons.room_rounded, color: colorScheme.primary),
        filled:      true,
        fillColor:   colorScheme.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.6), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
    );
  }
}

// ─── Widgets مساعدة خاصة ────────────────────────────────────────────────────

class _ModernDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final IconData icon;
  final Color activeColor;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _ModernDropdown({
    required this.value,
    required this.hint,
    required this.icon,
    required this.activeColor,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DropdownButtonFormField<T>(
      value:         value,
      dropdownColor: colorScheme.surfaceContainerLow,
      isExpanded:    true,
      hint: Text(hint, style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: colorScheme.onSurfaceVariant),
          maxLines: 1, overflow: TextOverflow.ellipsis),
      icon: Icon(Icons.arrow_drop_down_circle_outlined,
          color: colorScheme.onSurfaceVariant.withOpacity(0.6), size: 22),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: activeColor),
        filled: true, fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.6), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: activeColor, width: 2),
        ),
      ),
      items:     items,
      onChanged: onChanged,
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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message,
          style: TextStyle(color: colorScheme.error, fontFamily: 'Cairo',
              fontSize: 12, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center),
    );
  }
}