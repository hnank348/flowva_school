import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../data/mock_data.dart';
import 'teacher_sub_screen_app_bar.dart';

/// Mock exam data used until a real API is wired.
class _ExamItem {
  final String title;
  final String classRoom;
  final String subject;
  final String date;
  final String time;
  final int totalMarks;
  final bool completed;
  final bool isFinal;

  const _ExamItem({
    required this.title,
    required this.classRoom,
    required this.subject,
    required this.date,
    required this.time,
    required this.totalMarks,
    this.completed = false,
    this.isFinal = false,
  });
}

final _mockExams = [
  _ExamItem(
    title: 'اختبار الجبر — الوحدة 4',
    classRoom: 'الصف 9-أ',
    subject: 'رياضيات',
    date: '2026-08-20',
    time: '08:00',
    totalMarks: 40,
  ),
  _ExamItem(
    title: 'اختبار المعادلات التربيعية',
    classRoom: 'الصف 9-ب',
    subject: 'رياضيات',
    date: '2026-08-21',
    time: '09:30',
    totalMarks: 30,
  ),
  _ExamItem(
    title: 'اختبار قوانين الحركة',
    classRoom: 'الصف 10-أ',
    subject: 'فيزياء',
    date: '2026-08-23',
    time: '11:00',
    totalMarks: 50,
    completed: true,
  ),
  _ExamItem(
    title: 'اختبار الإلكترونيات',
    classRoom: 'الصف 10-ب',
    subject: 'فيزياء',
    date: '2026-08-25',
    time: '08:00',
    totalMarks: 40,
  ),
  _ExamItem(
    title: 'اختبار نهاية الفصل',
    classRoom: 'الصف 8-أ',
    subject: 'رياضيات',
    date: '2026-09-01',
    time: '08:00',
    totalMarks: 100,
  ),
  // ── امتحانات نهائية ────────────────────────────────────────────────────
  _ExamItem(
    title: 'الامتحان النهائي — رياضيات',
    classRoom: 'الصف 9-أ',
    subject: 'رياضيات',
    date: '2026-09-10',
    time: '08:00',
    totalMarks: 100,
    isFinal: true,
  ),
  _ExamItem(
    title: 'الامتحان النهائي — رياضيات',
    classRoom: 'الصف 9-ب',
    subject: 'رياضيات',
    date: '2026-09-10',
    time: '10:00',
    totalMarks: 100,
    isFinal: true,
  ),
  _ExamItem(
    title: 'الامتحان النهائي — فيزياء',
    classRoom: 'الصف 10-أ',
    subject: 'فيزياء',
    date: '2026-09-12',
    time: '08:00',
    totalMarks: 100,
    isFinal: true,
  ),
  _ExamItem(
    title: 'الامتحان النهائي — فيزياء',
    classRoom: 'الصف 10-ب',
    subject: 'فيزياء',
    date: '2026-09-12',
    time: '10:00',
    totalMarks: 100,
    isFinal: true,
  ),
  _ExamItem(
    title: 'الامتحان النهائي — رياضيات',
    classRoom: 'الصف 8-أ',
    subject: 'رياضيات',
    date: '2026-09-14',
    time: '08:00',
    totalMarks: 100,
    isFinal: true,
  ),
];

class TeacherExamScheduleView extends StatefulWidget {
  /// إذا كانت true تعرض الامتحانات النهائية فقط
  final bool showFinalOnly;

  const TeacherExamScheduleView({super.key, this.showFinalOnly = false});

  @override
  State<TeacherExamScheduleView> createState() =>
      _TeacherExamScheduleViewState();
}

class _TeacherExamScheduleViewState extends State<TeacherExamScheduleView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedClassId; // null = all

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

  List<_ExamItem> get _upcoming => _mockExams
      .where((e) => !e.completed && (!widget.showFinalOnly || e.isFinal))
      .toList();

  List<_ExamItem> get _done => _mockExams
      .where((e) => e.completed && (!widget.showFinalOnly || e.isFinal))
      .toList();

  List<_ExamItem> _filter(List<_ExamItem> list) {
    if (_selectedClassId == null) return list;
    final name = MockData.getClassRooms()
        .firstWhere(
          (c) => c.id == _selectedClassId,
          orElse: () => MockData.getClassRooms().first,
        )
        .name;
    return list.where((e) => e.classRoom == name).toList();
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final classes = MockData.getClassRooms();

    final upcoming = _filter(_upcoming);
    final done = _filter(_done);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: TeacherSubScreenAppBar(
        title: widget.showFinalOnly
            ? context.tr('exam_final_title')
            : context.tr('exam_sched_title'),
      ),
      body: Column(
        children: [
          // ── summary pills ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                _Pill(
                  count: _mockExams.length,
                  label: context.tr('filter_all'),
                  color: cs.primary,
                ),
                const SizedBox(width: 8),
                _Pill(
                  count: _upcoming.length,
                  label: context.tr('exam_sched_upcoming'),
                  color: cs.primary,
                ),
                const SizedBox(width: 8),
                _Pill(
                  count: _done.length,
                  label: context.tr('exam_sched_done'),
                  color: Colors.green,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── class filter chips ────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _FilterChip(
                  label: context.tr('filter_all'),
                  selected: _selectedClassId == null,
                  cs: cs,
                  isDark: isDark,
                  onTap: () => setState(() => _selectedClassId = null),
                ),
                ...classes.map(
                  (c) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _FilterChip(
                      label: c.name,
                      selected: _selectedClassId == c.id,
                      cs: cs,
                      isDark: isDark,
                      onTap: () => setState(
                        () => _selectedClassId = _selectedClassId == c.id
                            ? null
                            : c.id,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // ── tabs ──────────────────────────────────────────────────
          TabBar(
            controller: _tabController,
            labelColor: cs.primary,
            unselectedLabelColor: cs.onSurfaceVariant,
            indicatorColor: cs.primary,
            labelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
            tabs: [
              Tab(
                text:
                    '${context.tr('exam_sched_upcoming')} (${upcoming.length})',
              ),
              Tab(text: '${context.tr('exam_sched_done')} (${done.length})'),
            ],
          ),

          // ── tab views ─────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(upcoming, cs, isDark),
                _buildList(done, cs, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<_ExamItem> items, ColorScheme cs, bool isDark) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 60,
              color: cs.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              context.tr('exam_sched_empty'),
              style: TextStyle(
                color: cs.onSurfaceVariant,
                fontFamily: 'Cairo',
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: items.length,
      itemBuilder: (_, i) => _ExamCard(exam: items[i], cs: cs, isDark: isDark),
    );
  }
}

// ── exam card ─────────────────────────────────────────────────────────────────

class _ExamCard extends StatelessWidget {
  final _ExamItem exam;
  final ColorScheme cs;
  final bool isDark;

  const _ExamCard({required this.exam, required this.cs, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = exam.completed ? Colors.green : cs.primary;

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
            // ── header ────────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.assignment_outlined,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exam.title,
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
                            '${exam.classRoom}  •  ${exam.subject}',
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
                ),
                // status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    exam.completed
                        ? context.tr('exam_sched_done')
                        : context.tr('exam_sched_upcoming'),
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(height: 1, color: cs.outlineVariant),
            const SizedBox(height: 10),

            // ── meta row ──────────────────────────────────────────
            Row(
              children: [
                _Meta(
                  icon: Icons.calendar_today_outlined,
                  label: exam.date,
                  color: cs.onSurfaceVariant,
                ),
                const SizedBox(width: 16),
                _Meta(
                  icon: Icons.access_time,
                  label: exam.time,
                  color: cs.onSurfaceVariant,
                ),
                const Spacer(),
                _Meta(
                  icon: Icons.grade_outlined,
                  label: '${exam.totalMarks} ${context.tr('hw_marks_unit')}',
                  color: color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── micro widgets ─────────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final int count;
  final String label;
  final Color color;
  const _Pill({required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ColorScheme cs;
  final bool isDark;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.cs,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: selected
            ? cs.primary
            : (isDark ? cs.surfaceContainer : cs.surfaceContainerHighest),
        borderRadius: BorderRadius.circular(20),
        border: selected ? null : Border.all(color: cs.outlineVariant),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? Colors.white : cs.onSurfaceVariant,
          fontFamily: 'Cairo',
        ),
      ),
    ),
  );
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Meta({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: color),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(fontSize: 12, color: color, fontFamily: 'Cairo'),
      ),
    ],
  );
}
