import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_cubit.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_state.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import '../../../../app_localizations.dart';

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

  String _todayFormatted() {
    final now = DateTime.now();
    final d = now.day.toString().padLeft(2, '0');
    final m = now.month.toString().padLeft(2, '0');
    final y = now.year;
    return '$d/$m/$y';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (classState is ClassesLoading) {
      return SizedBox(
        height: 38,
        child: Center(
          child: LinearProgressIndicator(color: colorScheme.primary),
        ),
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
    final activeSections = loaded.classDetails.sections;
    final selectedSection = loaded.selectedSection;

    // 🌍 الاستماع لتغييرات اللغة الحالية لضبط الاتجاه تلقائياً
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
          textDirection: localeState.textDirection,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.outlineVariant.withOpacity(isDark ? 0.2 : 0.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.1 : 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ─── الشعبة + الفصل ───
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dropdown الشعبة
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            context.tr('attendance_section_label'),
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
                                  size: 22,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(16),
                              dropdownColor: isDark
                                  ? colorScheme.surfaceContainer
                                  : colorScheme.surfaceContainerLow,
                              isDense: true,
                              selectedItemBuilder: (context) =>
                                  activeSections.map<Widget>((section) {
                                    return Container(
                                      alignment: localeState.currentLanguage == 'AR'
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Text(
                                        section.name,
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.primary,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              items: activeSections.map((section) {
                                return DropdownMenuItem<dynamic>(
                                  value: section,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                                  context.read<ClassesCubit>().selectSection(newSection);
                                  onSectionChanged(newSection.id);
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // ─── بادج الفصل + التاريخ ───
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // بادج الفصل
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.school_rounded, size: 12, color: colorScheme.primary),
                                const SizedBox(width: 5),
                                Text(
                                  semesterName,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // بادج التاريخ
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colorScheme.onSurfaceVariant.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withOpacity(isDark ? 0.2 : 0.5),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  size: 12,
                                  color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _todayFormatted(),
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurfaceVariant.withOpacity(0.75),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}