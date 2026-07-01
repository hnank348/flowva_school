import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/supervisor/classes/classes_cubit.dart';
import '../../../cubit/supervisor/classes/classes_state.dart';
import '../../../cubit/current_semester/current_semester_cubit.dart';
import '../../../cubit/current_semester/current_semester_state.dart';
import '../../../app_localizations.dart'; // تأكد من صحة مسار ملف الترجمة لديك

class ScheduleHeaderWidget extends StatelessWidget {
  final ClassesLoaded classState;
  final ClassesCubit classesCubit;
  final ValueChanged<dynamic> onSectionChanged;
  final VoidCallback? onExportPdfPressed;

  const ScheduleHeaderWidget({
    super.key,
    required this.classState,
    required this.classesCubit,
    required this.onSectionChanged,
    this.onExportPdfPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeSections = classState.classDetails.sections;
    final selectedSection = classState.selectedSection;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(isDark ? 0.2 : 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.tr('header_section_label'),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 4),

                    IntrinsicWidth(
                      child: DropdownButton<dynamic>(
                        value: selectedSection,
                        underline: const SizedBox(),
                        icon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            Icons.arrow_drop_down_rounded,
                            color: colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(16),
                        dropdownColor: isDark ? colorScheme.surfaceContainer : colorScheme.surfaceContainerLow,
                        isDense: true,

                        selectedItemBuilder: (BuildContext context) {
                          return activeSections.map<Widget>((section) {
                            return Align(
                              alignment: Alignment.center,
                              child: Text(
                                selectedSection?.name ?? context.tr('header_not_specified'),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            );
                          }).toList();
                        },

                        items: activeSections.map((section) {
                          return DropdownMenuItem<dynamic>(
                            value: section,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                section.name,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newSection) {
                          if (newSection != null) {
                            onSectionChanged(newSection);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // 📅 شارة الفصل الدراسي الحية التلقائية من الـ Cubit المشترك
                BlocBuilder<CurrentSemesterCubit, CurrentSemesterState>(
                  builder: (context, semesterState) {
                    String currentSemesterName = context.tr('header_loading');
                    if (semesterState is CurrentSemesterSuccess) {
                      currentSemesterName = semesterState.currentSemester.name;
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 12, color: colorScheme.primary),
                          const SizedBox(width: 6),
                          Text(
                            currentSemesterName,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // ⚙️ زر تصدير PDF
          OutlinedButton.icon(
            onPressed: onExportPdfPressed ?? () {},
            icon: Icon(Icons.picture_as_pdf_rounded, size: 14, color: colorScheme.onSurface),
            label: Text(
              context.tr('header_btn_export_pdf'),
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              side: BorderSide(color: colorScheme.outlineVariant),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}