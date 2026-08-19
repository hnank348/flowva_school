import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../data/mock_data.dart';
import '../../widget/common_widgets.dart';
import 'teacher_sub_screen_app_bar.dart';

class PerformanceReportsView extends StatelessWidget {
  const PerformanceReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final students = MockData.getStudents();
    final averageGrade =
        students.map((s) => s.grade).reduce((a, b) => a + b) / students.length;
    final averageAttendance =
        students.map((s) => s.attendance).reduce((a, b) => a + b) /
        students.length;
    final averagePerformance =
        students.map((s) => s.performance).reduce((a, b) => a + b) /
        students.length;

    final excellentCount = students.where((s) => s.grade >= 90).length;
    final goodCount = students
        .where((s) => s.grade >= 75 && s.grade < 90)
        .length;
    final averageCount = students
        .where((s) => s.grade >= 60 && s.grade < 75)
        .length;
    final poorCount = students.where((s) => s.grade < 60).length;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: TeacherSubScreenAppBar(
        title: context.tr('teacher_performance_reports'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('teacher_overview'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: context.tr('teacher_avg_grades'),
                    value: averageGrade.toStringAsFixed(1),
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: context.tr('teacher_avg_attendance'),
                    value: averageAttendance.toStringAsFixed(1),
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: context.tr('teacher_avg_performance'),
                    value: averagePerformance.toStringAsFixed(1),
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: context.tr('teacher_total_students'),
                    value: students.length.toString(),
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              context.tr('teacher_grade_distribution'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 16),
            _buildGradeDistribution(
              context,
              excellentCount,
              goodCount,
              averageCount,
              poorCount,
              colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              context.tr('teacher_top_students'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 16),
            ...(() {
              final sortedStudents = students.toList()
                ..sort((a, b) => b.grade.compareTo(a.grade));
              return sortedStudents
                  .take(3)
                  .map(
                    (student) => Card(
                      elevation: isDark ? 0 : 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      color: isDark
                          ? colorScheme.surfaceContainer
                          : colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: isDark
                            ? BorderSide(color: colorScheme.outlineVariant)
                            : BorderSide.none,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                          child: Text(
                            student.name[0],
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(student.name),
                        subtitle: Text(
                          '${context.tr('teacher_attendance_stat')}: ${student.attendance.toInt()}%',
                        ),
                        trailing: Text(
                          '${student.grade.toInt()}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList();
            })(),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeDistribution(
    BuildContext context,
    int excellent,
    int good,
    int average,
    int poor,
    Color primary,
  ) {
    final total = excellent + good + average + poor;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: isDark ? 0 : 2,
      color: isDark ? colorScheme.surfaceContainer : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDark
            ? BorderSide(color: colorScheme.outlineVariant)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GradeBar(
              label: context.tr('teacher_grade_excellent'),
              count: excellent,
              total: total,
              color: primary,
            ),
            const SizedBox(height: 8),
            GradeBar(
              label: context.tr('teacher_grade_good'),
              count: good,
              total: total,
              color: primary,
            ),
            const SizedBox(height: 8),
            GradeBar(
              label: context.tr('teacher_grade_average'),
              count: average,
              total: total,
              color: primary,
            ),
            const SizedBox(height: 8),
            GradeBar(
              label: context.tr('teacher_grade_poor'),
              count: poor,
              total: total,
              color: colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
