import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_cubit.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_state.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import '../../app_localizations.dart';

class AttendanceSectionHeader extends StatelessWidget {
  final dynamic selectedSection;
  final List<dynamic> sections;
  final ValueChanged<dynamic> onSectionChanged;

  final bool showDateBadge;
  final VoidCallback? onExportPdfPressed;
  final String? labelText;

  const AttendanceSectionHeader({
    super.key,
    required this.selectedSection,
    required this.sections,
    required this.onSectionChanged,
    this.showDateBadge = false,
    this.onExportPdfPressed,
    this.labelText,
  });

  String _todayFormatted() {
    final now = DateTime.now();
    final d = now.day.toString().padLeft(2, '0');
    final m = now.month.toString().padLeft(2, '0');
    return '$d/$m/${now.year}';
  }

  String _getSectionDisplayName(dynamic section) {
    if (section == null) return '';

    try {
      return section.fullSectionName;
    } catch (_) {}

    final className = (section.className ?? '').toString();
    final sectionName = (section.name ?? '').toString();

    if (className.isNotEmpty) {
      return '$className - $sectionName';
    }
    return sectionName;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
          textDirection: localeState.textDirection,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: cs.outlineVariant.withOpacity(isDark ? 0.4 : 0.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownRow(context, cs, isDark),
                        ),
                        if (onExportPdfPressed != null) ...[
                          const SizedBox(width: 8),
                          _buildExportButton(context, cs),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildBadgesRow(context, cs, isDark),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdownRow(BuildContext context, ColorScheme cs, bool isDark) {
    return Row(
      children: [
        Text(
          labelText ?? context.tr('header_section_label'),
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: cs.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<dynamic>(
              value: selectedSection,
              isExpanded: true,
              isDense: true,
              icon: Icon(
                Icons.arrow_drop_down_rounded,
                color: cs.primary,
                size: 22,
              ),
              borderRadius: BorderRadius.circular(16),
              dropdownColor:
              isDark ? cs.surfaceContainer : cs.surfaceContainerLow,
              selectedItemBuilder: (context) => sections.map<Widget>((section) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    _getSectionDisplayName(section),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              items: sections.map((section) {
                return DropdownMenuItem<dynamic>(
                  value: section,
                  child: Text(
                    _getSectionDisplayName(section),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (newSection) {
                if (newSection != null) onSectionChanged(newSection);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesRow(BuildContext context, ColorScheme cs, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<CurrentSemesterCubit, CurrentSemesterState>(
            builder: (context, semesterState) {
              final name = semesterState is CurrentSemesterSuccess
                  ? semesterState.currentSemester.name
                  : context.tr('header_loading');

              return _badge(
                icon: Icons.school_rounded,
                label: name,
                color: cs.primary,
                bg: cs.primary.withOpacity(isDark ? 0.15 : 0.08),
                border: cs.primary.withOpacity(0.3),
              );
            },
          ),
          if (showDateBadge) ...[
            const SizedBox(width: 8),
            _badge(
              icon: Icons.calendar_today_rounded,
              label: _todayFormatted(),
              color: cs.onSurfaceVariant,
              bg: isDark
                  ? cs.surfaceContainer
                  : cs.onSurfaceVariant.withOpacity(0.07),
              border: cs.outlineVariant.withOpacity(0.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _badge({
    required IconData icon,
    required String label,
    required Color color,
    required Color bg,
    required Color border,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(BuildContext context, ColorScheme cs) {
    return OutlinedButton.icon(
      onPressed: onExportPdfPressed,
      icon: Icon(Icons.picture_as_pdf_rounded, size: 14, color: cs.onSurface),
      label: Text(
        context.tr('header_btn_export_pdf'),
        style: TextStyle(
          fontSize: 11,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          color: cs.onSurface,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        side: BorderSide(color: cs.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}