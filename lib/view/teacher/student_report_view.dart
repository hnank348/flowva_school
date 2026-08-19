import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../models/teacher/student.dart';
import '../../data/mock_data.dart';
import '../../models/teacher/homework.dart';
import 'teacher_sub_screen_app_bar.dart';
import 'student_evaluation_view.dart';

class StudentReportView extends StatelessWidget {
  final Student student;

  const StudentReportView({super.key, required this.student});

  Color _gradeColor(double g, ColorScheme cs) {
    if (g >= 90) return Colors.green;
    if (g >= 75) return cs.primary;
    if (g >= 60) return Colors.orange;
    return cs.error;
  }

  String _gradeTag(double g, BuildContext ctx) {
    if (g >= 90) return ctx.tr('teacher_grade_excellent');
    if (g >= 75) return ctx.tr('teacher_grade_good');
    if (g >= 60) return ctx.tr('teacher_grade_average');
    return ctx.tr('teacher_grade_poor');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradeColor = _gradeColor(student.grade, cs);
    final gradeTag = _gradeTag(student.grade, context);

    // Homework related to this student's classroom
    final homeworks = MockData.getHomeworksByClassRoom(student.classRoomId);
    final classroom = MockData.getClassRooms()
        .where((c) => c.id == student.classRoomId)
        .firstOrNull;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: TeacherSubScreenAppBar(title: context.tr('report_title')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── hero profile card ────────────────────────────────────────
            _buildProfileCard(
              context,
              cs,
              isDark,
              gradeColor,
              gradeTag,
              classroom?.name,
            ),

            const SizedBox(height: 20),

            // ── 3 metric cards ───────────────────────────────────────────
            _SectionTitle(label: context.tr('teacher_overview')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    icon: Icons.grade_outlined,
                    label: context.tr('teacher_grades'),
                    value: '${student.grade.toInt()}',
                    color: gradeColor,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricTile(
                    icon: Icons.check_circle_outline,
                    label: context.tr('teacher_attendance_stat'),
                    value: '${student.attendance.toInt()}%',
                    color: student.attendance >= 85
                        ? Colors.green
                        : Colors.orange,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricTile(
                    icon: Icons.trending_up,
                    label: context.tr('teacher_performance'),
                    value: '${student.performance.toInt()}%',
                    color: _gradeColor(student.performance, cs),
                    isDark: isDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── detailed progress bars ───────────────────────────────────
            _SectionTitle(label: context.tr('report_detail_section')),
            const SizedBox(height: 12),
            _buildDetailCard(context, cs, isDark, gradeColor),

            const SizedBox(height: 20),

            // ── homework summary ─────────────────────────────────────────
            if (homeworks.isNotEmpty) ...[
              _SectionTitle(label: context.tr('report_hw_section')),
              const SizedBox(height: 12),
              _buildHomeworkSummary(context, cs, isDark, homeworks),
              const SizedBox(height: 20),
            ],

            // ── evaluate button ──────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudentEvaluationView(student: student),
                  ),
                ),
                icon: const Icon(Icons.edit_outlined),
                label: Text(
                  context.tr('eval_edit_student'),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── profile hero ──────────────────────────────────────────────────────────

  Widget _buildProfileCard(
    BuildContext context,
    ColorScheme cs,
    bool isDark,
    Color gradeColor,
    String gradeTag,
    String? className,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradeColor.withValues(alpha: 0.15),
            gradeColor.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: gradeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          // big avatar
          CircleAvatar(
            radius: 40,
            backgroundColor: gradeColor.withValues(alpha: 0.18),
            child: Text(
              student.name[0],
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: gradeColor,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),
                if (className != null)
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        size: 13,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        className,
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: gradeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    gradeTag,
                    style: TextStyle(
                      color: gradeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // big grade number
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${student.grade.toInt()}',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: gradeColor,
                  fontFamily: 'Cairo',
                  height: 1,
                ),
              ),
              Text(
                '/100',
                style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurfaceVariant,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── detail bars card ──────────────────────────────────────────────────────

  Widget _buildDetailCard(
    BuildContext context,
    ColorScheme cs,
    bool isDark,
    Color gradeColor,
  ) {
    return Card(
      elevation: isDark ? 0 : 2,
      color: isDark ? cs.surfaceContainer : cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: isDark ? BorderSide(color: cs.outlineVariant) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _BarRow(
              label: context.tr('teacher_grades'),
              value: student.grade,
              color: gradeColor,
            ),
            const SizedBox(height: 14),
            _BarRow(
              label: context.tr('teacher_attendance_stat'),
              value: student.attendance,
              color: student.attendance >= 85 ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 14),
            _BarRow(
              label: context.tr('teacher_performance'),
              value: student.performance,
              color: _gradeColor(student.performance, cs),
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: cs.outlineVariant),
            const SizedBox(height: 14),
            // overall computed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('report_overall'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  '${((student.grade + student.attendance + student.performance) / 3).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: gradeColor,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── homework summary ──────────────────────────────────────────────────────

  Widget _buildHomeworkSummary(
    BuildContext context,
    ColorScheme cs,
    bool isDark,
    List<Homework> homeworks,
  ) {
    final pending = homeworks
        .where((h) => h.status == HomeworkStatus.pending)
        .length;
    final graded = homeworks
        .where((h) => h.status == HomeworkStatus.graded)
        .length;

    return Card(
      elevation: isDark ? 0 : 2,
      color: isDark ? cs.surfaceContainer : cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: isDark ? BorderSide(color: cs.outlineVariant) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _HwPill(
                  count: homeworks.length,
                  label: context.tr('filter_all'),
                  color: cs.primary,
                ),
                const SizedBox(width: 8),
                _HwPill(
                  count: pending,
                  label: context.tr('hw_status_pending'),
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                _HwPill(
                  count: graded,
                  label: context.tr('hw_status_graded'),
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...homeworks
                .take(3)
                .map(
                  (hw) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          _hwIcon(hw.type),
                          size: 16,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            hw.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: cs.onSurface,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                        _HwStatusBadge(status: hw.status, cs: cs),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  IconData _hwIcon(HomeworkType t) {
    switch (t) {
      case HomeworkType.written:
        return Icons.edit_outlined;
      case HomeworkType.reading:
        return Icons.menu_book_outlined;
      case HomeworkType.research:
        return Icons.search_outlined;
      case HomeworkType.project:
        return Icons.folder_outlined;
    }
  }
}

// ── shared sub-widgets ────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String label;
  const _SectionTitle({required this.label});

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
      fontFamily: 'Cairo',
    ),
  );
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: isDark ? 0 : 1,
      color: isDark ? cs.surfaceContainer : cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDark ? BorderSide(color: cs.outlineVariant) : BorderSide.none,
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
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: cs.onSurfaceVariant,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _BarRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurfaceVariant,
                fontFamily: 'Cairo',
              ),
            ),
            Text(
              '${value.toInt()}%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: cs.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _HwPill extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _HwPill({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      '$count $label',
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
    ),
  );
}

class _HwStatusBadge extends StatelessWidget {
  final HomeworkStatus status;
  final ColorScheme cs;

  const _HwStatusBadge({required this.status, required this.cs});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    switch (status) {
      case HomeworkStatus.pending:
        color = Colors.orange;
        label = context.tr('hw_status_pending');
      case HomeworkStatus.submitted:
        color = cs.primary;
        label = context.tr('hw_status_submitted');
      case HomeworkStatus.graded:
        color = Colors.green;
        label = context.tr('hw_status_graded');
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}
