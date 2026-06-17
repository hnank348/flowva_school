import 'package:flutter/material.dart';
import '../../../cubit/supervisor/classes/classes_cubit.dart';
import '../../../cubit/supervisor/classes/classes_state.dart';

class ScheduleHeaderWidget extends StatelessWidget {
  final ClassesLoaded classState;
  final ClassesCubit classesCubit;
  final int selectedSemester;
  final ValueChanged<int> onSemesterChanged;
  final ValueChanged<dynamic> onSectionChanged;

  const ScheduleHeaderWidget({
    super.key,
    required this.classState,
    required this.classesCubit,
    required this.selectedSemester,
    required this.onSemesterChanged,
    required this.onSectionChanged,
  });

  Widget _buildTopButton(BuildContext context, String text, Color bg, Color txt, {bool hasBorder = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: hasBorder ? Border.all(color: colorScheme.outlineVariant) : null,
      ),
      child: Text(
        text,
        style: TextStyle(color: txt, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sections = classState.classDetails.sections;
    final selectedSection = classState.selectedSection;

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final currentSection = sections[index];
              final isSelected = selectedSection?.id == currentSection.id;

              return Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: InkWell(
                  onTap: () {
                    classesCubit.selectSection(currentSection);
                    onSectionChanged(currentSection);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : colorScheme.outlineVariant,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        currentSection.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surfaceContainerHigh : colorScheme.outlineVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant,
                width: 1,
              ),
            ),
          child: Row(
            children: [1, 2, 3].map((semesterNum) {
              final isSelected = selectedSemester == semesterNum;
              final isLast = semesterNum == 3;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => onSemesterChanged(semesterNum),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? colorScheme.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: isSelected
                                ? [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 4, offset: const Offset(0, 2))]
                                : [],
                          ),
                          child: Text(
                            'الفصل $semesterNum',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        height: 20,
                        width: 1,
                        color: colorScheme.outlineVariant,
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _buildTopButton(context, 'حفظ الجدول', colorScheme.primary, Colors.white),
                    const SizedBox(width: 6),
                    _buildTopButton(
                      context,
                      'تصدير PDF',
                      colorScheme.surfaceContainerLow,
                      colorScheme.onSurface,
                      hasBorder: true,
                    ),
                  ],
                ),
                Text(
                  'جدول شعبة: ${selectedSection?.name ?? ""} - الفصل $selectedSemester',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}