import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/models/supervisor/teacher_attendance_model.dart';
import 'package:flowva_school/app_localizations.dart';
import '../../../../cubit/supervisor/cubit_supervisor/teacher_filter_cubit.dart';
import '../../../../cubit/supervisor/submit_teacher/teacher_attendance_state.dart';
import 'teacher_attendance_card.dart';

class TeachersAttendanceGrid extends StatelessWidget {
  final List<TeacherModel> teachers;
  final Map<int, TeacherAttendanceStatus> attendanceMap;
  final bool isTablet;

  const TeachersAttendanceGrid({
    super.key,
    required this.teachers,
    required this.attendanceMap,
    required this.isTablet,
  });

  static const _filterItems = [
    (f: TeacherAttendanceFilter.all,     key: 'filter_all',         color: Color(0xFF64748B)),
    (f: TeacherAttendanceFilter.active, key: 'attendance_active', color: Color(0xFF0F766E)),
    (f: TeacherAttendanceFilter.inactive,  key: 'attendance_inactive',  color: Color(0xFFDC2626)),
    (f: TeacherAttendanceFilter.vacation,    key: 'attendance_vacation',    color: Color(0xFFD97706)),
    (f: TeacherAttendanceFilter.transferred, key: 'attendance_transferred', color: Color(0xFF7C3AED)),
  ];

  TeacherAttendanceStatus? _toStatus(TeacherAttendanceFilter f) {
    switch (f) {
      case TeacherAttendanceFilter.active:  return TeacherAttendanceStatus.active;
      case TeacherAttendanceFilter.inactive:   return TeacherAttendanceStatus.inactive;
      case TeacherAttendanceFilter.vacation:     return TeacherAttendanceStatus.vacation;
      case TeacherAttendanceFilter.transferred:  return TeacherAttendanceStatus.transferred;
      case TeacherAttendanceFilter.all:      return null;
    }
  }

  List<TeacherModel> _filtered(TeacherAttendanceFilter filter) {
    final required = _toStatus(filter);
    if (required == null) return teachers;
    return teachers.where((t) =>
    (attendanceMap[t.id] ?? TeacherAttendanceStatus.active) == required).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hPad   = isTablet ? 20.0 : 14.0;

    return BlocProvider(
      create: (_) => TeacherFilterCubit(),
      child: BlocBuilder<TeacherFilterCubit, TeacherAttendanceFilter>(
        builder: (context, activeFilter) {
          final filtered = _filtered(activeFilter);

          return Column(
            children: [
              // ─── شريط الفلترة ───
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _filterItems.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final item       = _filterItems[i];
                    final isSelected = activeFilter == item.f;
                    final count      = item.f == TeacherAttendanceFilter.all
                        ? teachers.length
                        : teachers.where((t) =>
                    (attendanceMap[t.id] ?? TeacherAttendanceStatus.active) ==
                        _toStatus(item.f)).length;

                    return GestureDetector(
                      onTap: () => context.read<TeacherFilterCubit>().setFilter(item.f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? item.color.withOpacity(isDark ? 0.2 : 0.1)
                              : (isDark ? cs.surfaceContainer : Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? item.color.withOpacity(isDark ? 0.6 : 0.8)
                                : cs.outlineVariant.withOpacity(isDark ? 0.3 : 0.5),
                            width: isSelected ? 1.2 : 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.tr(item.key),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? item.color
                                    : cs.onSurfaceVariant.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? item.color.withOpacity(0.15)
                                    : cs.onSurfaceVariant.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? item.color
                                      : cs.onSurfaceVariant.withOpacity(0.6),
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
                child: filtered.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_list_off_rounded,
                          size: 36,
                          color: cs.onSurfaceVariant.withOpacity(0.3)),
                      const SizedBox(height: 10),
                      Text(
                        context.tr('filter_empty_teachers'),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          color: cs.onSurfaceVariant.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                )
                    : LayoutBuilder(
                  builder: (context, constraints) {
                    final cols = constraints.maxWidth > 900 ? 3 : 2;
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: hPad, vertical: 4),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        mainAxisExtent: 112,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final teacher = filtered[index];
                        final status  = attendanceMap[teacher.id]
                            ?? TeacherAttendanceStatus.active;
                        return TeacherAttendanceCard(
                          teacher:       teacher,
                          currentStatus: status,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}