import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_localizations.dart';
import '../../cubit/locale/locale_cubit.dart';
import '../../cubit/locale/locale_state.dart';

/// Mock teacher performance data used until a real API is wired.
class _TeacherPerf {
  final String name;
  final String subject;
  final String classes;
  final double punctuality; // % on-time attendance
  final double studentAvg; // average student grade under this teacher
  final double engagement; // supervisor-rated engagement score
  final int homeworksSent;

  const _TeacherPerf({
    required this.name,
    required this.subject,
    required this.classes,
    required this.punctuality,
    required this.studentAvg,
    required this.engagement,
    required this.homeworksSent,
  });

  double get overallScore => (punctuality + studentAvg + engagement) / 3;
}

const List<_TeacherPerf> _mockTeachers = [
  _TeacherPerf(
    name: 'أ. سامي العمري',
    subject: 'رياضيات',
    classes: 'الصف 9-أ، 9-ب',
    punctuality: 96,
    studentAvg: 88,
    engagement: 92,
    homeworksSent: 8,
  ),
  _TeacherPerf(
    name: 'أ. منى الزهراني',
    subject: 'فيزياء',
    classes: 'الصف 10-أ، 10-ب',
    punctuality: 89,
    studentAvg: 83,
    engagement: 87,
    homeworksSent: 5,
  ),
  _TeacherPerf(
    name: 'أ. خالد الغامدي',
    subject: 'رياضيات',
    classes: 'الصف 8-أ',
    punctuality: 78,
    studentAvg: 75,
    engagement: 80,
    homeworksSent: 3,
  ),
  _TeacherPerf(
    name: 'أ. ريم السبيعي',
    subject: 'علوم',
    classes: 'الصف 9-أ، 10-أ',
    punctuality: 94,
    studentAvg: 91,
    engagement: 95,
    homeworksSent: 10,
  ),
  _TeacherPerf(
    name: 'أ. فهد المالكي',
    subject: 'لغة عربية',
    classes: 'الصف 9-ب، 8-أ',
    punctuality: 85,
    studentAvg: 80,
    engagement: 83,
    homeworksSent: 6,
  ),
];

class TeachersEvaluationView extends StatefulWidget {
  const TeachersEvaluationView({super.key});

  @override
  State<TeachersEvaluationView> createState() => _TeachersEvaluationViewState();
}

class _TeachersEvaluationViewState extends State<TeachersEvaluationView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sort = 'score'; // 'score' | 'punctuality' | 'homework'

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_TeacherPerf> get _sorted {
    final list = [..._mockTeachers];
    switch (_sort) {
      case 'punctuality':
        list.sort((a, b) => b.punctuality.compareTo(a.punctuality));
      case 'homework':
        list.sort((a, b) => b.homeworksSent.compareTo(a.homeworksSent));
      default:
        list.sort((a, b) => b.overallScore.compareTo(a.overallScore));
    }
    return list;
  }

  Color _scoreColor(double v, ColorScheme cs) {
    if (v >= 90) return Colors.green;
    if (v >= 75) return cs.primary;
    if (v >= 60) return Colors.orange;
    return cs.error;
  }

  String _scoreTag(double v, BuildContext ctx) {
    if (v >= 90) return ctx.tr('teacher_grade_excellent');
    if (v >= 75) return ctx.tr('teacher_grade_good');
    if (v >= 60) return ctx.tr('teacher_grade_average');
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
              labelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
              tabs: [
                Tab(text: context.tr('teval_tab_list')),
                Tab(text: context.tr('teval_tab_summary')),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildListTab(context, cs),
                  _buildSummaryTab(context, cs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Tab 0: teacher list ─────────────────────────────────────────────────────

  Widget _buildListTab(BuildContext context, ColorScheme cs) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final teachers = _sorted;

    return Column(
      children: [
        // sort bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Text(
                context.tr('teval_sort_by'),
                style: TextStyle(
                  fontSize: 12,
                  color: cs.onSurfaceVariant,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(width: 8),
              _SortChip(
                label: context.tr('teval_sort_score'),
                selected: _sort == 'score',
                onTap: () => setState(() => _sort = 'score'),
              ),
              const SizedBox(width: 6),
              _SortChip(
                label: context.tr('teval_sort_punctuality'),
                selected: _sort == 'punctuality',
                onTap: () => setState(() => _sort = 'punctuality'),
              ),
              const SizedBox(width: 6),
              _SortChip(
                label: context.tr('teval_sort_homework'),
                selected: _sort == 'homework',
                onTap: () => setState(() => _sort = 'homework'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: teachers.length,
            itemBuilder: (context, i) => _TeacherCard(
              rank: i + 1,
              teacher: teachers[i],
              cs: cs,
              isDark: isDark,
              scoreColor: _scoreColor(teachers[i].overallScore, cs),
              scoreTag: _scoreTag(teachers[i].overallScore, context),
            ),
          ),
        ),
      ],
    );
  }

  // ── Tab 1: summary overview ─────────────────────────────────────────────────

  Widget _buildSummaryTab(BuildContext context, ColorScheme cs) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final teachers = _mockTeachers;
    final avgScore =
        teachers.map((t) => t.overallScore).reduce((a, b) => a + b) /
        teachers.length;
    final avgPunct =
        teachers.map((t) => t.punctuality).reduce((a, b) => a + b) /
        teachers.length;
    final totalHW = teachers
        .map((t) => t.homeworksSent)
        .reduce((a, b) => a + b);

    final best = [...teachers]
      ..sort((a, b) => b.overallScore.compareTo(a.overallScore));
    final needsSupport = [...teachers]
      ..sort((a, b) => a.overallScore.compareTo(b.overallScore));

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3 summary tiles
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  icon: Icons.people_outline,
                  label: context.tr('teval_total_teachers'),
                  value: '${teachers.length}',
                  color: cs.primary,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoTile(
                  icon: Icons.star_outline,
                  label: context.tr('teval_avg_score'),
                  value: avgScore.toStringAsFixed(1),
                  color: _scoreColor(avgScore, cs),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoTile(
                  icon: Icons.home_work_outlined,
                  label: context.tr('teval_total_hw'),
                  value: '$totalHW',
                  color: Colors.orange,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // punctuality average bar
          _SectionLabel(label: context.tr('teval_punctuality_avg')),
          const SizedBox(height: 10),
          Card(
            elevation: isDark ? 0 : 1,
            color: isDark ? cs.surfaceContainer : cs.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isDark
                  ? BorderSide(color: cs.outlineVariant)
                  : BorderSide.none,
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: _BarRow(
                label: context.tr('teacher_attendance_stat'),
                value: avgPunct,
                color: avgPunct >= 85 ? Colors.green : Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // best performer
          _SectionLabel(label: context.tr('teval_best_performer')),
          const SizedBox(height: 10),
          _TeacherCard(
            rank: 1,
            teacher: best.first,
            cs: cs,
            isDark: isDark,
            scoreColor: _scoreColor(best.first.overallScore, cs),
            scoreTag: _scoreTag(best.first.overallScore, context),
          ),
          const SizedBox(height: 20),

          // needs support
          _SectionLabel(label: context.tr('teval_needs_support')),
          const SizedBox(height: 10),
          _TeacherCard(
            rank: teachers.length,
            teacher: needsSupport.first,
            cs: cs,
            isDark: isDark,
            scoreColor: _scoreColor(needsSupport.first.overallScore, cs),
            scoreTag: _scoreTag(needsSupport.first.overallScore, context),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Teacher card widget
// ══════════════════════════════════════════════════════════════════════════════

class _TeacherCard extends StatelessWidget {
  final int rank;
  final _TeacherPerf teacher;
  final ColorScheme cs;
  final bool isDark;
  final Color scoreColor;
  final String scoreTag;

  const _TeacherCard({
    required this.rank,
    required this.teacher,
    required this.cs,
    required this.isDark,
    required this.scoreColor,
    required this.scoreTag,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isDark ? 0 : 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? cs.surfaceContainer : cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: isDark ? BorderSide(color: cs.outlineVariant) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── header row ──────────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: scoreColor.withValues(alpha: 0.12),
                  child: Text(
                    teacher.name[3],
                    style: TextStyle(
                      color: scoreColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teacher.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: cs.onSurface,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 12,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            teacher.subject,
                            style: TextStyle(
                              fontSize: 11,
                              color: cs.onSurfaceVariant,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.class_outlined,
                            size: 12,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              teacher.classes,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: cs.onSurfaceVariant,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // overall score badge
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      teacher.overallScore.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: scoreColor,
                        fontFamily: 'Cairo',
                        height: 1,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: scoreColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        scoreTag,
                        style: TextStyle(
                          color: scoreColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(height: 1, color: cs.outlineVariant),
            const SizedBox(height: 10),

            // ── 3 metric bars ────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _BarRow(
                    label: context.tr('teval_punctuality'),
                    value: teacher.punctuality,
                    color: teacher.punctuality >= 85
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BarRow(
                    label: context.tr('teval_student_avg'),
                    value: teacher.studentAvg,
                    color: cs.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BarRow(
                    label: context.tr('teval_engagement'),
                    value: teacher.engagement,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // homework sent chip
            Row(
              children: [
                Icon(
                  Icons.home_work_outlined,
                  size: 13,
                  color: cs.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '${teacher.homeworksSent} ${context.tr('teval_hw_sent')}',
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurfaceVariant,
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
}

// ══════════════════════════════════════════════════════════════════════════════
// Shared micro-widgets
// ══════════════════════════════════════════════════════════════════════════════

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
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: cs.onSurfaceVariant,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: cs.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 7,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${value.toInt()}%',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? cs.primary : cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? Colors.white : cs.onSurfaceVariant,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
      fontFamily: 'Cairo',
    ),
  );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _InfoTile({
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
          color: isDark ? cs.outlineVariant : color.withValues(alpha: 0.2),
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
