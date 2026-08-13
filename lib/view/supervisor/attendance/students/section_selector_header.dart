import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_cubit.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_state.dart';
import 'package:flowva_school/app_localizations.dart';
import '../../../../widget/supervisor/custom_section_semester_header.dart';

class SectionSelectorHeader extends StatelessWidget {
  final ClassesState classState;
  final String semesterName;
  final void Function(int sectionId) onSectionChanged;

  const SectionSelectorHeader({
    super.key,
    required this.classState,
    required this.semesterName,
    required this.onSectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (classState is ClassesLoading) {
      return SizedBox(
        height: 38,
        child: Center(child: LinearProgressIndicator(color: colorScheme.primary)),
      );
    }

    if (classState is ClassesError) {
      return Center(
        child: Text(
          (classState as ClassesError).message,
          style: TextStyle(fontFamily: 'Cairo', color: colorScheme.error),
        ),
      );
    }

    if (classState is! ClassesLoaded) return const SizedBox();

    final loaded = classState as ClassesLoaded;

    return AttendanceSectionHeader(
      selectedSection: loaded.selectedSection,
      sections: loaded.classDetails.sections,
      showDateBadge: true,
      labelText: context.tr('attendance_section_label'),
      onSectionChanged: (newSection) {
        context.read<ClassesCubit>().selectSection(newSection);
        onSectionChanged(newSection.id);
      },
    );
  }
}