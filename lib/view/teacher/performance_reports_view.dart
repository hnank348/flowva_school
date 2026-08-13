import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../widget/common_widgets.dart';

class PerformanceReportsView extends StatelessWidget {
  const PerformanceReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
      appBar: AppBar(
        title: const Text('تقارير الأداء'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'نظرة عامة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'متوسط الدرجات',
                    value: averageGrade.toStringAsFixed(1),
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'متوسط الحضور',
                    value: averageAttendance.toStringAsFixed(1),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'متوسط الأداء',
                    value: averagePerformance.toStringAsFixed(1),
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'إجمالي الطلاب',
                    value: students.length.toString(),
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'توزيع الدرجات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            const Text(
              'أفضل الطلاب',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...(() {
              final sortedStudents = students.toList()
                ..sort((a, b) => b.grade.compareTo(a.grade));
              return sortedStudents
                  .take(3)
                  .map(
                    (student) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: colorScheme.primaryContainer,
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
                          'الحضور: ${student.attendance.toInt()}%',
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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GradeBar(
              label: 'ممتاز (90+)',
              count: excellent,
              total: total,
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            GradeBar(
              label: 'جيد (75-89)',
              count: good,
              total: total,
              color: primary,
            ),
            const SizedBox(height: 8),
            GradeBar(
              label: 'متوسط (60-74)',
              count: average,
              total: total,
              color: primary,
            ),
            const SizedBox(height: 8),
            GradeBar(
              label: 'ضعيف (<60)',
              count: poor,
              total: total,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
