import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../data/mock_data.dart';
import '../../models/teacher/student.dart';
import 'class_evaluation_view.dart';
import 'student_evaluation_view.dart';
import 'student_report_view.dart';
import 'teacher_sub_screen_app_bar.dart';

class ClassStudentsView extends StatefulWidget {
  final String classRoomId;
  final String classRoomName;

  const ClassStudentsView({
    super.key,
    required this.classRoomId,
    required this.classRoomName,
  });

  @override
  State<ClassStudentsView> createState() => _ClassStudentsViewState();
}

class _ClassStudentsViewState extends State<ClassStudentsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  List<Student> _filter(List<Student> list, String q) {
    if (q.trim().isEmpty) return list;
    return list
        .where((s) => s.name.toLowerCase().contains(q.trim().toLowerCase()))
        .toList();
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

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final query = _searchController.text;
    final all = _filter(
      MockData.getStudentsByClassRoom(widget.classRoomId),
      query,
    );
    final excellent = all.where((s) => s.isExcellent).toList();
    final attention = all.where((s) => s.needsAttention).toList();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: TeacherSubScreenAppBar(title: widget.classRoomName),
      // ── FAB: class overview evaluation ────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClassEvaluationView(
              classRoomId: widget.classRoomId,
              classRoomName: widget.classRoomName,
            ),
          ),
        ),
        icon: const Icon(Icons.bar_chart_outlined),
        label: Text(
          context.tr('class_view_eval_btn'),
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
      ),
      body: Column(
        children: [
          // ── search ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: context.tr('teacher_search_student'),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: cs.surfaceContainerHighest,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // ── tabs ────────────────────────────────────────────────────
          TabBar(
            controller: _tabController,
            labelColor: cs.primary,
            unselectedLabelColor: cs.onSurfaceVariant,
            indicatorColor: cs.primary,
            labelStyle: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: '${context.tr('filter_all')} (${all.length})'),
              Tab(
                text:
                    '${context.tr('teacher_excellent')} (${excellent.length})',
              ),
              Tab(
                text:
                    '${context.tr('teacher_needs_attention')} (${attention.length})',
              ),
            ],
          ),

          // ── tab views ───────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(all, cs, isDark),
                _buildList(excellent, cs, isDark),
                _buildList(attention, cs, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── list builder ──────────────────────────────────────────────────────────

  Widget _buildList(List<Student> students, ColorScheme cs, bool isDark) {
    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: 56,
              color: cs.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              context.tr('filter_empty_students'),
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontFamily: 'Cairo',
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: students.length,
      itemBuilder: (_, i) {
        final s = students[i];
        final gc = _gradeColor(s.grade, cs);
        final gt = _gradeTag(s.grade, context);
        return _StudentCard(
          student: s,
          cs: cs,
          isDark: isDark,
          gradeColor: gc,
          gradeTag: gt,
          onReport: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StudentReportView(student: s)),
          ),
          onEvaluate: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StudentEvaluationView(student: s),
              ),
            );
            setState(() {});
          },
        );
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Rich student card
// ══════════════════════════════════════════════════════════════════════════════

class _StudentCard extends StatelessWidget {
  final Student student;
  final ColorScheme cs;
  final bool isDark;
  final Color gradeColor;
  final String gradeTag;
  final VoidCallback onReport;
  final VoidCallback onEvaluate;

  const _StudentCard({
    required this.student,
    required this.cs,
    required this.isDark,
    required this.gradeColor,
    required this.gradeTag,
    required this.onReport,
    required this.onEvaluate,
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
      // tap opens report
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onReport,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── header ─────────────────────────────────────────────
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: gradeColor.withValues(alpha: 0.12),
                    child: Text(
                      student.name[0],
                      style: TextStyle(
                        color: gradeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: cs.onSurface,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: gradeColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            gradeTag,
                            style: TextStyle(
                              color: gradeColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // big grade
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${student.grade.toInt()}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: gradeColor,
                          fontFamily: 'Cairo',
                          height: 1,
                        ),
                      ),
                      Text(
                        '/100',
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: cs.outlineVariant),
              const SizedBox(height: 10),

              // ── 3 mini bars ─────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _MiniBar(
                      label: context.tr('teacher_grades'),
                      value: student.grade,
                      color: gradeColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniBar(
                      label: context.tr('teacher_attendance_stat'),
                      value: student.attendance,
                      color: student.attendance >= 85
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniBar(
                      label: context.tr('teacher_performance'),
                      value: student.performance,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── action buttons ──────────────────────────────────────
              Row(
                children: [
                  // report — outlined
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton.icon(
                        onPressed: onReport,
                        icon: const Icon(Icons.bar_chart_outlined, size: 16),
                        label: Text(
                          context.tr('teacher_reports'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.deepPurple,
                          side: const BorderSide(
                            color: Colors.deepPurple,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // evaluate — filled tonal
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: onEvaluate,
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: Text(
                          context.tr('teacher_evaluate'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E), // teal
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── compact progress bar ──────────────────────────────────────────────────────

class _MiniBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _MiniBar({
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
