import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_cubit.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_state.dart';

import '../../app_localizations.dart';

class CustomModernHeader extends StatelessWidget {
  final dynamic selectedSection;
  final List<dynamic> sections;
  final ValueChanged<dynamic> onSectionChanged;
  final VoidCallback? onExportPdfPressed;

  const CustomModernHeader({
    super.key,
    required this.selectedSection,
    required this.sections,
    required this.onSectionChanged,
    this.onExportPdfPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Row(
                  textDirection: TextDirection.rtl,
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
                      child: DropdownButtonDirectionality(
                        textDirection: TextDirection.rtl,
                        child: DropdownButton<dynamic>(
                          value: selectedSection,
                          underline: const SizedBox(),
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Icon(
                              Icons.arrow_drop_down_rounded,
                              color: colorScheme.primary, // لون السهم التركواز من الثيم
                              size: 22,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(16),
                          dropdownColor: isDark ? colorScheme.surfaceContainer : colorScheme.surfaceContainerLow,
                          isDense: true,

                          // 🛠️ الإصلاح الجذري هنا: بناء العنصر المختار حالياً باستخدام الترتيب (Index) الفعلي للشعبة لفرض اللون بشكل سليم
                          selectedItemBuilder: (BuildContext context) {
                            return sections.map<Widget>((section) {
                              return Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  section.name, // 🌟 نمرر اسم الشعبة الفردي من الـ map ليتعرف فلاتر على الـ Index بدقة
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary, // 🎨 فرض لون الثيم التركواز صراحة لمنع اختفائه باللايت مود
                                  ),
                                ),
                              );
                            }).toList();
                          },
                          items: sections.map((section) {
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
                                    color: colorScheme.primary, // 🎨 تلوين العناصر داخل القائمة المفتوحة أيضاً
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
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // 📅 شارة الفصل الدراسي التلقائية الحية والمستمعة للـ Cubit
                BlocBuilder<CurrentSemesterCubit, CurrentSemesterState>(
                  builder: (context, semesterState) {
                    String currentSemesterName = 'جاري التحميل...';
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
                        textDirection: TextDirection.rtl,
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

          // ⚙️ القسم الأيسر: زر تصدير PDF
          OutlinedButton.icon(
            onPressed: onExportPdfPressed ?? () {},
            icon: Icon(Icons.picture_as_pdf_rounded, size: 14, color: colorScheme.onSurface),
            label: Text(
              'تصدير PDF',
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

class DropdownButtonDirectionality extends StatelessWidget {
  final TextDirection textDirection;
  final Widget child;

  const DropdownButtonDirectionality({
    super.key,
    required this.textDirection,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
      child: child,
    );
  }
}