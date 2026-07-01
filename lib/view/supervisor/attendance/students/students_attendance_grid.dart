import 'package:flutter/material.dart';
import 'package:flowva_school/cubit/supervisor/cubit_supervisor/student_attendance_cubit.dart';
import 'package:flowva_school/models/supervisor/student_attendance_model.dart';
import '../../../../app_localizations.dart';
import 'student_attendance_card.dart';

enum _AttendanceFilter { all, present, absent, late, excused }

class StudentsAttendanceGrid extends StatefulWidget {
  final List<StudentAttendanceModel> students;
  final Map<String, StudentAttendanceStatus> attendanceMap;
  final bool isTablet;

  const StudentsAttendanceGrid({
    super.key,
    required this.students,
    required this.attendanceMap,
    required this.isTablet,
  });

  @override
  State<StudentsAttendanceGrid> createState() => _StudentsAttendanceGridState();
}

class _StudentsAttendanceGridState extends State<StudentsAttendanceGrid> {
  _AttendanceFilter _filter = _AttendanceFilter.all;

  // فك الارتباط المباشر بالنصوص لتجهيز الفلاتر برمجياً وترجمتها داخل الـ build حياً
  List<({_AttendanceFilter filter, String labelKey, Color color})> _getFilterItems() {
    return [
      (filter: _AttendanceFilter.all, labelKey: 'filter_all', color: const Color(0xFF64748B)),
      (filter: _AttendanceFilter.present, labelKey: 'attendance_present', color: const Color(0xFF0F766E)),
      (filter: _AttendanceFilter.absent, labelKey: 'attendance_absent', color: const Color(0xFFDC2626)),
      (filter: _AttendanceFilter.late, labelKey: 'attendance_late', color: const Color(0xFFD97706)),
      (filter: _AttendanceFilter.excused, labelKey: 'attendance_excused', color: const Color(0xFF7C3AED)),
    ];
  }

  StudentAttendanceStatus? get _requiredStatus {
    switch (_filter) {
      case _AttendanceFilter.present:
        return StudentAttendanceStatus.present;
      case _AttendanceFilter.absent:
        return StudentAttendanceStatus.absent;
      case _AttendanceFilter.late:
        return StudentAttendanceStatus.late;
      case _AttendanceFilter.excused:
        return StudentAttendanceStatus.excused;
      case _AttendanceFilter.all:
        return null;
    }
  }

  List<StudentAttendanceModel> get _filtered {
    final required = _requiredStatus;
    if (required == null) return widget.students;
    return widget.students.where((s) {
      final status = widget.attendanceMap[s.id.toString()] ?? StudentAttendanceStatus.present;
      return status == required;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hPad = widget.isTablet ? 20.0 : 14.0;
    final filteredList = _filtered;
    final filterItems = _getFilterItems();

    return Column(
      children: [
        // ─── شريط الفلترة ───
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: hPad),
            physics: const BouncingScrollPhysics(),
            itemCount: filterItems.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final item = filterItems[i];
              final isSelected = _filter == item.filter;
              final count = item.filter == _AttendanceFilter.all
                  ? widget.students.length
                  : widget.students.where((s) {
                final st = widget.attendanceMap[s.id.toString()] ?? StudentAttendanceStatus.present;
                return st == _requiredStatusFor(item.filter);
              }).length;

              return GestureDetector(
                onTap: () => setState(() => _filter = item.filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? item.color.withOpacity(isDark ? 0.2 : 0.1)
                        : (isDark ? colorScheme.surfaceContainer : Colors.white),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? item.color.withOpacity(isDark ? 0.6 : 0.8)
                          : colorScheme.outlineVariant.withOpacity(isDark ? 0.3 : 0.5),
                      width: isSelected ? 1.2 : 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.tr(item.labelKey),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? item.color : colorScheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: isSelected ? item.color.withOpacity(0.15) : colorScheme.onSurfaceVariant.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? item.color : colorScheme.onSurfaceVariant.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // ─── الـ Grid ───
        Expanded(
          child: filteredList.isEmpty
              ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_list_off_rounded, size: 36, color: colorScheme.onSurfaceVariant.withOpacity(0.3)),
                const SizedBox(height: 10),
                Text(
                  context.tr('filter_empty_students'),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          )
              : LayoutBuilder(
            builder: (context, constraints) {
              final int cols = constraints.maxWidth > 900 ? 3 : 2;
              const double cardHeight = 112;

              return GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 4.0),
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  mainAxisExtent: cardHeight,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final student = filteredList[index];
                  final status = widget.attendanceMap[student.id.toString()] ?? StudentAttendanceStatus.present;
                  return StudentAttendanceCard(
                    student: student,
                    currentStatus: status,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  StudentAttendanceStatus? _requiredStatusFor(_AttendanceFilter f) {
    switch (f) {
      case _AttendanceFilter.present:
        return StudentAttendanceStatus.present;
      case _AttendanceFilter.absent:
        return StudentAttendanceStatus.absent;
      case _AttendanceFilter.late:
        return StudentAttendanceStatus.late;
      case _AttendanceFilter.excused:
        return StudentAttendanceStatus.excused;
      case _AttendanceFilter.all:
        return null;
    }
  }
}