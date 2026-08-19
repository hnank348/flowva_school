import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_localizations.dart';
import '../../cubit/locale/locale_cubit.dart';
import '../../cubit/locale/locale_state.dart';
import '../../data/mock_data.dart';
import '../../models/teacher/homework.dart';
import '../../widget/common_widgets.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, ls) => Directionality(
        textDirection: ls.textDirection,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: cs.primary,
              unselectedLabelColor: cs.onSurfaceVariant,
              indicatorColor: cs.primary,
              labelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
              tabs: [
                Tab(text: context.tr('stats_tab_overview')),
                Tab(text: context.tr('stats_tab_classes')),
                Tab(text: context.tr('stats_tab_homework')),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _OverviewTab(gradeColor: _gradeColor, gradeTag: _gradeTag),
                  _ClassesTab(gradeColor: _gradeColor),
                  const _HomeworkTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Tab 0 — Overview
// ══════════════════════════════════════════════════════════════════════════════

class _OverviewTab extends StatelessWidget {
  final Color Function(double, ColorScheme) gradeColor;
  final String Function(double, BuildContext) gradeTag;

  const _OverviewTab({required this.gradeColor, required this.gradeTag});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final students = MockData.getStudents();
    final classes = MockData.getClassRooms();
    final homeworks = MockData.getHomeworks();

    final avgGrade =
        students.map((s) => s.grade).reduce((a, b) => a + b) / students.length;
    final avgAtt =
        students.map((s) => s.attendance).reduce((a, b) => a + b) /
        students.length;
    final avgPerf =
        students.map((s) => s.performance).reduce((a, b) => a + b) /
        students.length;

    final excellent = students.where((s) => s.grade >= 90).length;
    final good = students.where((s) => s.grade >= 75 && s.grade < 90).length;
    final average = students.where((s) => s.grade >= 60 && s.grade < 75).length;
    final poor = students.where((s) => s.grade < 60).length;
    final total = students.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── top summary numbers ───────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  icon: Icons.people_outline,
                  label: context.tr('teacher_total_students'),
                  value: '$total',
                  color: cs.primary,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryTile(
                  icon: Icons.menu_book_outlined,
                  label: context.tr('teacher_classes'),
                  value: '${classes.length}',
                  color: const Color(0xFF0F766E),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryTile(
                  icon: Icons.home_work_outlined,
                  label: context.tr('hw_list_title'),
                  value: '${homeworks.length}',
                  color: Colors.orange,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── avg score hero card ───────────────────────────────────────
          _AverageHeroCard(
            avg: avgGrade,
            color: gradeColor(avgGrade, cs),
            tag: gradeTag(avgGrade, context),
            total: total,
          ),
          const SizedBox(height: 20),

          // ── 3 averages ────────────────────────────────────────────────
          _SectionTitle(label: context.tr('teacher_overview')),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: context.tr('teacher_avg_grades'),
                  value: avgGrade.toStringAsFixed(1),
                  icon: Icons.grade_outlined,
                  color: gradeColor(avgGrade, cs),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  title: context.tr('teacher_avg_attendance'),
                  value: '${avgAtt.toStringAsFixed(1)}%',
                  icon: Icons.check_circle_outline,
                  color: cs.primary,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  title: context.tr('teacher_avg_performance'),
                  value: '${avgPerf.toStringAsFixed(1)}%',
                  icon: Icons.trending_up,
                  color: Colors.green,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── grade distribution ────────────────────────────────────────
          _SectionTitle(label: context.tr('teacher_grade_distribution')),
          const SizedBox(height: 12),
          _DistCard(
            excellent: excellent,
            good: good,
            average: average,
            poor: poor,
            total: total,
            isDark: isDark,
          ),
          const SizedBox(height: 20),

          // ── top 5 students ────────────────────────────────────────────
          _SectionTitle(label: context.tr('teacher_top_students')),
          const SizedBox(height: 12),
          ...() {
            final sorted = [...students]
              ..sort((a, b) => b.grade.compareTo(a.grade));
            return sorted
                .take(5)
                .toList()
                .asMap()
                .entries
                .map(
                  (e) => _TopStudentRow(
                    rank: e.key + 1,
                    student: e.value,
                    color: gradeColor(e.value.grade, cs),
                    isDark: isDark,
                  ),
                );
          }(),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Tab 1 — Per-class breakdown
// ══════════════════════════════════════════════════════════════════════════════

class _ClassesTab extends StatelessWidget {
  final Color Function(double, ColorScheme) gradeColor;
  const _ClassesTab({required this.gradeColor});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allStudents = MockData.getStudents();
    final classes = MockData.getClassRooms();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: classes.length,
      itemBuilder: (context, i) {
        final cls = classes[i];
        final sts = allStudents.where((s) => s.classRoomId == cls.id).toList();
        if (sts.isEmpty) return const SizedBox.shrink();

        final avg =
            sts.map((s) => s.grade).reduce((a, b) => a + b) / sts.length;
        final attAvg =
            sts.map((s) => s.attendance).reduce((a, b) => a + b) / sts.length;
        final color = gradeColor(avg, cs);

        return Card(
          elevation: isDark ? 0 : 2,
          margin: const EdgeInsets.only(bottom: 14),
          color: isDark ? cs.surfaceContainer : cs.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: isDark
                ? BorderSide(color: cs.outlineVariant)
                : BorderSide.none,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.menu_book_outlined,
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cls.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: cs.onSurface,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          Text(
                            cls.subject,
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurfaceVariant,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          avg.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: color,
                            fontFamily: 'Cairo',
                            height: 1,
                          ),
                        ),
                        Text(
                          context.tr('stats_avg_label'),
                          style: TextStyle(
                            fontSize: 10,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(height: 1, color: cs.outlineVariant),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _ClassStatPill(
                        icon: Icons.people_outline,
                        label:
                            '${sts.length} ${context.tr('teacher_student_count')}',
                        color: cs.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ClassStatPill(
                        icon: Icons.check_circle_outline,
                        label:
                            '${attAvg.toStringAsFixed(0)}% ${context.tr('teacher_attendance_stat')}',
                        color: attAvg >= 85 ? Colors.green : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ClassStatPill(
                        icon: Icons.star_outline,
                        label:
                            '${sts.where((s) => s.grade >= 90).length} ${context.tr('teacher_excellent')}',
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Tab 2 — Homework stats
// ══════════════════════════════════════════════════════════════════════════════

class _HomeworkTab extends StatelessWidget {
  const _HomeworkTab();

  Color _hwColor(HomeworkStatus s) {
    switch (s) {
      case HomeworkStatus.pending:
        return Colors.orange;
      case HomeworkStatus.submitted:
        return Colors.blue;
      case HomeworkStatus.graded:
        return Colors.green;
    }
  }

  String _hwStatusLabel(HomeworkStatus s, BuildContext ctx) {
    switch (s) {
      case HomeworkStatus.pending:
        return ctx.tr('hw_status_pending');
      case HomeworkStatus.submitted:
        return ctx.tr('hw_status_submitted');
      case HomeworkStatus.graded:
        return ctx.tr('hw_status_graded');
    }
  }

  IconData _hwTypeIcon(HomeworkType t) {
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hws = MockData.getHomeworks();

    final pending = hws.where((h) => h.status == HomeworkStatus.pending).length;
    final submitted = hws
        .where((h) => h.status == HomeworkStatus.submitted)
        .length;
    final graded = hws.where((h) => h.status == HomeworkStatus.graded).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // summary chips
          Row(
            children: [
              _PillStat(
                count: hws.length,
                label: context.tr('filter_all'),
                color: cs.primary,
              ),
              const SizedBox(width: 8),
              _PillStat(
                count: pending,
                label: context.tr('hw_status_pending'),
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              _PillStat(
                count: submitted,
                label: context.tr('hw_status_submitted'),
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              _PillStat(
                count: graded,
                label: context.tr('hw_status_graded'),
                color: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitle(label: context.tr('stats_hw_recent')),
          const SizedBox(height: 12),

          // homework cards
          ...hws.map((hw) {
            final isOverdue =
                hw.status == HomeworkStatus.pending &&
                hw.dueDate.isBefore(DateTime.now());
            final statusColor = isOverdue ? cs.error : _hwColor(hw.status);

            return Card(
              elevation: isDark ? 0 : 1,
              margin: const EdgeInsets.only(bottom: 10),
              color: isDark ? cs.surfaceContainer : cs.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: isDark
                    ? BorderSide(color: cs.outlineVariant)
                    : BorderSide.none,
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _hwTypeIcon(hw.type),
                        color: statusColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hw.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: cs.onSurface,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            hw.classRoomName,
                            style: TextStyle(
                              fontSize: 11,
                              color: cs.onSurfaceVariant,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isOverdue
                            ? context.tr('hw_status_overdue')
                            : _hwStatusLabel(hw.status, context),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Shared sub-widgets
// ══════════════════════════════════════════════════════════════════════════════

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

class _SummaryTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainer : color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? cs.outlineVariant : color.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 2),
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
    );
  }
}

class _AverageHeroCard extends StatelessWidget {
  final double avg;
  final Color color;
  final String tag;
  final int total;

  const _AverageHeroCard({
    required this.avg,
    required this.color,
    required this.tag,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.04),
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
            backgroundColor: color.withValues(alpha: 0.18),
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
                  fontSize: 12,
                  color: cs.onSurfaceVariant,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tag,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$total ${context.tr('teacher_total_students')}',
                style: TextStyle(
                  fontSize: 12,
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
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
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
                fontSize: 17,
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

class _DistCard extends StatelessWidget {
  final int excellent, good, average, poor, total;
  final bool isDark;

  const _DistCard({
    required this.excellent,
    required this.good,
    required this.average,
    required this.poor,
    required this.total,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
              color: cs.primary,
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
              color: cs.error,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopStudentRow extends StatelessWidget {
  final int rank;
  final dynamic student;
  final Color color;
  final bool isDark;

  const _TopStudentRow({
    required this.rank,
    required this.student,
    required this.color,
    required this.isDark,
  });

  static const _medals = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: isDark ? 0 : 1,
      margin: const EdgeInsets.only(bottom: 8),
      color: isDark ? cs.surfaceContainer : cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDark ? BorderSide(color: cs.outlineVariant) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: cs.primaryContainer,
              child: Text(
                rank <= 3 ? _medals[rank - 1] : '$rank',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                student.name as String,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: cs.onSurface,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            Text(
              '${(student.grade as double).toInt()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClassStatPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ClassStatPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillStat extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _PillStat({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
