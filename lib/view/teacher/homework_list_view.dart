import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../data/mock_data.dart';
import '../../models/teacher/homework.dart';
import 'send_homework_view.dart';
import 'teacher_sub_screen_app_bar.dart';

class HomeworkListView extends StatefulWidget {
  const HomeworkListView({super.key});

  @override
  State<HomeworkListView> createState() => _HomeworkListViewState();
}

class _HomeworkListViewState extends State<HomeworkListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /// null means "all classes"
  String? _selectedClassId;

  /// local copy of homeworks — replaced on "refresh"
  late List<Homework> _homeworks;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _homeworks = MockData.getHomeworks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── pull-to-refresh (mock — re-fetches same data) ─────────────────────────
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _homeworks = MockData.getHomeworks());
  }

  // ── filtered list based on selected class ─────────────────────────────────
  List<Homework> get _filtered => _selectedClassId == null
      ? _homeworks
      : _homeworks.where((h) => h.classRoomId == _selectedClassId).toList();

  // ── helpers ───────────────────────────────────────────────────────────────

  Color _statusColor(HomeworkStatus s, ColorScheme cs) {
    switch (s) {
      case HomeworkStatus.pending:
        return Colors.orange;
      case HomeworkStatus.submitted:
        return cs.primary;
      case HomeworkStatus.graded:
        return Colors.green;
    }
  }

  String _statusLabel(HomeworkStatus s, BuildContext ctx) {
    switch (s) {
      case HomeworkStatus.pending:
        return ctx.tr('hw_status_pending');
      case HomeworkStatus.submitted:
        return ctx.tr('hw_status_submitted');
      case HomeworkStatus.graded:
        return ctx.tr('hw_status_graded');
    }
  }

  IconData _typeIcon(HomeworkType t) {
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

  String _typeLabel(HomeworkType t, BuildContext ctx) {
    switch (t) {
      case HomeworkType.written:
        return ctx.tr('hw_type_written');
      case HomeworkType.reading:
        return ctx.tr('hw_type_reading');
      case HomeworkType.research:
        return ctx.tr('hw_type_research');
      case HomeworkType.project:
        return ctx.tr('hw_type_project');
    }
  }

  String _fmt(DateTime d) =>
      '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

  bool _isOverdue(Homework hw) =>
      hw.status == HomeworkStatus.pending &&
      hw.dueDate.isBefore(DateTime.now());

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final classes = MockData.getClassRooms();

    final all = _filtered;
    final pending = all
        .where((h) => h.status == HomeworkStatus.pending)
        .toList();
    final submitted = all
        .where((h) => h.status == HomeworkStatus.submitted)
        .toList();
    final graded = all.where((h) => h.status == HomeworkStatus.graded).toList();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: TeacherSubScreenAppBar(title: context.tr('hw_list_title')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SendHomeworkView()),
        ).then((_) => setState(() => _homeworks = MockData.getHomeworks())),
        icon: const Icon(Icons.add),
        label: Text(
          context.tr('hw_new_button'),
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            // ── summary pills ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  _SummaryChip(
                    count: all.length,
                    label: context.tr('filter_all'),
                    color: cs.primary,
                  ),
                  const SizedBox(width: 8),
                  _SummaryChip(
                    count: pending.length,
                    label: context.tr('hw_status_pending'),
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  _SummaryChip(
                    count: graded.length,
                    label: context.tr('hw_status_graded'),
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── class filter chips ──────────────────────────────────────
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // "All" chip
                  _ClassFilterChip(
                    label: context.tr('filter_all'),
                    selected: _selectedClassId == null,
                    onTap: () => setState(() => _selectedClassId = null),
                  ),
                  ...classes.map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _ClassFilterChip(
                        label: c.name,
                        selected: _selectedClassId == c.id,
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
            const SizedBox(height: 8),

            // ── status tabs ─────────────────────────────────────────────
            TabBar(
              controller: _tabController,
              labelColor: cs.primary,
              unselectedLabelColor: cs.onSurfaceVariant,
              indicatorColor: cs.primary,
              labelStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
              tabs: [
                Tab(text: '${context.tr('filter_all')} (${all.length})'),
                Tab(
                  text:
                      '${context.tr('hw_status_pending')} (${pending.length})',
                ),
                Tab(
                  text:
                      '${context.tr('hw_status_submitted')} (${submitted.length + graded.length})',
                ),
              ],
            ),

            // ── tab content ─────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildList(all, cs),
                  _buildList(pending, cs),
                  _buildList([...submitted, ...graded], cs),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── list builder ──────────────────────────────────────────────────────────

  Widget _buildList(List<Homework> items, ColorScheme cs) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (items.isEmpty) {
      // Keep enough height so RefreshIndicator can trigger on empty state
      return LayoutBuilder(
        builder: (_, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: constraints.maxHeight,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 64,
                    color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.tr('hw_empty'),
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontFamily: 'Cairo',
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final hw = items[i];
        final overdue = _isOverdue(hw);
        final statusColor = overdue ? cs.error : _statusColor(hw.status, cs);

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
                // ── header: icon + title + status badge ────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _typeIcon(hw.type),
                        color: statusColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hw.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: cs.onSurface,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hw.classRoomName,
                            style: TextStyle(
                              fontSize: 13,
                              color: cs.onSurfaceVariant,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        overdue
                            ? context.tr('hw_status_overdue')
                            : _statusLabel(hw.status, context),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── description preview ────────────────────────────────
                Text(
                  hw.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: cs.onSurfaceVariant,
                    fontFamily: 'Cairo',
                  ),
                ),

                const SizedBox(height: 12),
                Divider(color: cs.outlineVariant, height: 1),
                const SizedBox(height: 10),

                // ── meta: type | date | marks ──────────────────────────
                Row(
                  children: [
                    _MetaItem(
                      icon: Icons.label_outline,
                      label: _typeLabel(hw.type, context),
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 16),
                    _MetaItem(
                      icon: Icons.event_outlined,
                      label: _fmt(hw.dueDate),
                      color: overdue ? cs.error : cs.onSurfaceVariant,
                    ),
                    const Spacer(),
                    _MetaItem(
                      icon: Icons.grade_outlined,
                      label: '${hw.totalMarks} ${context.tr('hw_marks_unit')}',
                      color: cs.primary,
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

// ── sub-widgets ───────────────────────────────────────────────────────────────

class _ClassFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ClassFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
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
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _SummaryChip({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count $label',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color, fontFamily: 'Cairo'),
        ),
      ],
    );
  }
}
