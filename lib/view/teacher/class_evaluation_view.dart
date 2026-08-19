import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../data/mock_data.dart';
import '../../models/teacher/student.dart';
import '../../widget/common_widgets.dart';
import 'teacher_sub_screen_app_bar.dart';

class ClassEvaluationView extends StatefulWidget {
  /// When provided, locks the view to this class only (no selector chips).
  final String? classRoomId;
  final String? classRoomName;

  const ClassEvaluationView({super.key, this.classRoomId, this.classRoomName});

  @override
  State<ClassEvaluationView> createState() => _ClassEvaluationViewState();
}

class _ClassEvaluationViewState extends State<ClassEvaluationView>
    with TickerProviderStateMixin {
  /// Which classroom is currently selected in the overview
  String? _selectedClassRoomId;

  @override
  void initState() {
    super.initState();
    if (widget.classRoomId != null) {
      _selectedClassRoomId = widget.classRoomId;
    } else {
      final classes = MockData.getClassRooms();
      if (classes.isNotEmpty) _selectedClassRoomId = classes.first.id;
    }
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  Color _gradeColor(double grade, ColorScheme cs) {
    if (grade >= 90) return Colors.green;
    if (grade >= 75) return cs.primary;
    if (grade >= 60) return Colors.orange;
    return cs.error;
  }

  String _gradeTag(double grade, BuildContext context) {
    if (grade >= 90) return context.tr('teacher_grade_excellent');
    if (grade >= 75) return context.tr('teacher_grade_good');
    if (grade >= 60) return context.tr('teacher_grade_average');
    return context.tr('teacher_grade_poor');
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: TeacherSubScreenAppBar(
        title: widget.classRoomName ?? context.tr('eval_title'),
      ),
      body: _buildOverviewTab(colorScheme),
    );
  }

  // ── Tab 0: Overview ───────────────────────────────────────────────────────

  Widget _buildOverviewTab(ColorScheme colorScheme) {
    final classes = MockData.getClassRooms();
    final allStudents = MockData.getStudents();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // class-specific students (or all)
    final classStudents = _selectedClassRoomId != null
        ? allStudents
              .where((s) => s.classRoomId == _selectedClassRoomId)
              .toList()
        : allStudents;

    final hasStudents = classStudents.isNotEmpty;
    final avgGrade = hasStudents
        ? classStudents.map((s) => s.grade).reduce((a, b) => a + b) /
              classStudents.length
        : 0.0;
    final avgAttendance = hasStudents
        ? classStudents.map((s) => s.attendance).reduce((a, b) => a + b) /
              classStudents.length
        : 0.0;
    final avgPerformance = hasStudents
        ? classStudents.map((s) => s.performance).reduce((a, b) => a + b) /
              classStudents.length
        : 0.0;

    final excellent = classStudents.where((s) => s.grade >= 90).length;
    final good = classStudents
        .where((s) => s.grade >= 75 && s.grade < 90)
        .length;
    final average = classStudents
        .where((s) => s.grade >= 60 && s.grade < 75)
        .length;
    final poor = classStudents.where((s) => s.grade < 60).length;
    final total = classStudents.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── class selector — hidden when locked to a specific class ───
          if (widget.classRoomId == null) ...[
            _SectionTitle(label: context.tr('eval_select_class')),
            const SizedBox(height: 10),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: classes.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final c = classes[i];
                  final selected = c.id == _selectedClassRoomId;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedClassRoomId = c.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? colorScheme.primary
                            : (isDark
                                  ? colorScheme.surfaceContainer
                                  : colorScheme.surfaceContainerHighest),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        c.name,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : colorScheme.onSurfaceVariant,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 13,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ], // end class selector
          const SizedBox(height: 20),

          if (!hasStudents) ...[
            Center(
              child: Text(
                context.tr('eval_no_students'),
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ] else ...[
            // ── average score card ────────────────────────────────────────
            _buildAverageScoreCard(
              avgGrade,
              colorScheme,
              isDark,
              classStudents.length,
            ),
            const SizedBox(height: 16),

            // ── 3 stat cards ──────────────────────────────────────────────
            _SectionTitle(label: context.tr('teacher_overview')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MiniStatCard(
                    title: context.tr('teacher_avg_grades'),
                    value: avgGrade.toStringAsFixed(1),
                    icon: Icons.grade_outlined,
                    color: _gradeColor(avgGrade, colorScheme),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniStatCard(
                    title: context.tr('teacher_avg_attendance'),
                    value: '${avgAttendance.toStringAsFixed(1)}%',
                    icon: Icons.check_circle_outline,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniStatCard(
                    title: context.tr('teacher_avg_performance'),
                    value: '${avgPerformance.toStringAsFixed(1)}%',
                    icon: Icons.trending_up,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── grade distribution ────────────────────────────────────────
            _SectionTitle(label: context.tr('teacher_grade_distribution')),
            const SizedBox(height: 12),
            _buildDistributionCard(
              excellent,
              good,
              average,
              poor,
              total,
              colorScheme,
              isDark,
            ),
            const SizedBox(height: 20),

            // ── top 3 students ────────────────────────────────────────────
            _SectionTitle(label: context.tr('teacher_top_students')),
            const SizedBox(height: 12),
            ...() {
              final sorted = [...classStudents]
                ..sort((a, b) => b.grade.compareTo(a.grade));
              return sorted.take(3).toList().asMap().entries.map((e) {
                final rank = e.key + 1;
                final student = e.value;
                return _TopStudentTile(
                  rank: rank,
                  student: student,
                  colorScheme: colorScheme,
                  isDark: isDark,
                  gradeColor: _gradeColor(student.grade, colorScheme),
                );
              });
            }(),
          ],
        ],
      ),
    );
  }

  Widget _buildAverageScoreCard(
    double avg,
    ColorScheme colorScheme,
    bool isDark,
    int count,
  ) {
    final color = _gradeColor(avg, colorScheme);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: color.withValues(alpha: 0.2),
            child: Text(
              avg.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('eval_avg_score'),
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _gradeTag(avg, context),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$count ${context.tr('teacher_total_students')}',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionCard(
    int excellent,
    int good,
    int average,
    int poor,
    int total,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Card(
      elevation: isDark ? 0 : 2,
      color: isDark ? colorScheme.surfaceContainer : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
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
              color: Colors.green,
            ),
            const SizedBox(height: 12),
            GradeBar(
              label: context.tr('teacher_grade_good'),
              count: good,
              total: total,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 12),
            GradeBar(
              label: context.tr('teacher_grade_average'),
              count: average,
              total: total,
              color: Colors.orange,
            ),
            const SizedBox(height: 12),
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

// ── private sub-widgets ───────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
        fontFamily: 'Cairo',
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopStudentTile extends StatelessWidget {
  final int rank;
  final Student student;
  final ColorScheme colorScheme;
  final bool isDark;
  final Color gradeColor;

  const _TopStudentTile({
    required this.rank,
    required this.student,
    required this.colorScheme,
    required this.isDark,
    required this.gradeColor,
  });

  static const _medals = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isDark ? 0 : 1,
      margin: const EdgeInsets.only(bottom: 8),
      color: isDark ? colorScheme.surfaceContainer : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDark
            ? BorderSide(color: colorScheme.outlineVariant)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
          child: Text(
            rank <= 3 ? _medals[rank - 1] : '$rank',
            style: const TextStyle(fontSize: 18),
          ),
        ),
        title: Text(
          student.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: colorScheme.onSurface,
            fontFamily: 'Cairo',
          ),
        ),
        subtitle: LabeledProgressBar(
          label: context.tr('teacher_grades'),
          value: student.grade,
        ),
        trailing: Text(
          '${student.grade.toInt()}%',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: gradeColor,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}
