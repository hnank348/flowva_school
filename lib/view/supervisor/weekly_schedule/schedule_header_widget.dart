import 'package:flutter/material.dart';
import '../../../cubit/supervisor/classes/classes_state.dart';
import '../../../widget/supervisor/custom_section_semester_header.dart';

class ScheduleHeaderWidget extends StatelessWidget {
  final ClassesLoaded classState;
  final ValueChanged<dynamic> onSectionChanged;
  final VoidCallback? onExportPdfPressed;

  const ScheduleHeaderWidget({
    super.key,
    required this.classState,
    required this.onSectionChanged,
    this.onExportPdfPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AttendanceSectionHeader(
      selectedSection: classState.selectedSection,
      sections: classState.classDetails.sections,
      onSectionChanged: onSectionChanged,
      onExportPdfPressed: onExportPdfPressed,
    );
  }
}