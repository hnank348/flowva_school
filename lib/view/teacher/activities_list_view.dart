import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../data/mock_data.dart';
import '../../models/teacher/activity.dart';
import 'add_activity_view.dart';
import 'teacher_sub_screen_app_bar.dart';

class ActivitiesListView extends StatefulWidget {
  const ActivitiesListView({super.key});

  @override
  State<ActivitiesListView> createState() => _ActivitiesListViewState();
}

class _ActivitiesListViewState extends State<ActivitiesListView> {
  ActivityType? _filter; // null = all

  // ── helpers ───────────────────────────────────────────────────────────────

  List<Activity> get _filtered {
    final all = MockData.getActivities();
    if (_filter == null) return all.toList();
    return all.where((a) => a.type == _filter).toList();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {});
  }

  void _openAdd() async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddActivityView()),
    );
    if (added == true) setState(() {});
  }

  // ── type helpers ──────────────────────────────────────────────────────────

  String _typeLabel(ActivityType t) {
    switch (t) {
      case ActivityType.parentMeeting:
        return context.tr('act_type_parent_meeting');
      case ActivityType.schoolTrip:
        return context.tr('act_type_school_trip');
      case ActivityType.competition:
        return context.tr('act_type_competition');
      case ActivityType.ceremony:
        return context.tr('act_type_ceremony');
      case ActivityType.workshop:
        return context.tr('act_type_workshop');
      case ActivityType.other:
        return context.tr('act_type_other');
    }
  }

  IconData _typeIcon(ActivityType t) {
    switch (t) {
      case ActivityType.parentMeeting:
        return Icons.people_outline;
      case ActivityType.schoolTrip:
        return Icons.directions_bus_outlined;
      case ActivityType.competition:
        return Icons.emoji_events_outlined;
      case ActivityType.ceremony:
        return Icons.celebration_outlined;
      case ActivityType.workshop:
        return Icons.build_outlined;
      case ActivityType.other:
        return Icons.event_outlined;
    }
  }

  Color _typeColor(ActivityType t, ColorScheme cs) {
    switch (t) {
      case ActivityType.parentMeeting:
        return cs.primary;
      case ActivityType.schoolTrip:
        return const Color(0xFF0F766E);
      case ActivityType.competition:
        return Colors.amber.shade700;
      case ActivityType.ceremony:
        return Colors.deepPurple;
      case ActivityType.workshop:
        return Colors.orange;
      case ActivityType.other:
        return cs.onSurfaceVariant;
    }
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = _filtered;
    final all = MockData.getActivities();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: TeacherSubScreenAppBar(title: context.tr('act_list_title')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAdd,
        icon: const Icon(Icons.add),
        label: Text(
          context.tr('act_new_button'),
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            // ── summary pill ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                children: [
                  _Pill(
                    count: all.length,
                    label: context.tr('filter_all'),
                    color: cs.primary,
                  ),
                  const SizedBox(width: 8),
                  _Pill(
                    count: all
                        .where((a) => a.type == ActivityType.parentMeeting)
                        .length,
                    label: context.tr('act_type_parent_meeting'),
                    color: cs.primary,
                  ),
                  const SizedBox(width: 8),
                  _Pill(
                    count: all
                        .where((a) => a.type == ActivityType.competition)
                        .length,
                    label: context.tr('act_type_competition'),
                    color: Colors.amber.shade700,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // ── type filter chips ─────────────────────────────────────
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _FilterChip(
                    label: context.tr('filter_all'),
                    selected: _filter == null,
                    color: cs.primary,
                    isDark: isDark,
                    onTap: () => setState(() => _filter = null),
                  ),
                  ...ActivityType.values.map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: _typeLabel(t),
                        selected: _filter == t,
                        color: _typeColor(t, cs),
                        isDark: isDark,
                        onTap: () =>
                            setState(() => _filter = _filter == t ? null : t),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ── list ──────────────────────────────────────────────────
            Expanded(
              child: items.isEmpty
                  ? LayoutBuilder(
                      builder: (_, c) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: c.maxHeight,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.event_outlined,
                                  size: 64,
                                  color: cs.onSurfaceVariant.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  context.tr('act_empty'),
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
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        final a = items[i];
                        final color = _typeColor(a.type, cs);
                        return _ActivityCard(
                          activity: a,
                          cs: cs,
                          isDark: isDark,
                          typeColor: color,
                          typeLabel: _typeLabel(a.type),
                          typeIcon: _typeIcon(a.type),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── card ──────────────────────────────────────────────────────────────────────

class _ActivityCard extends StatelessWidget {
  final Activity activity;
  final ColorScheme cs;
  final bool isDark;
  final Color typeColor;
  final String typeLabel;
  final IconData typeIcon;

  const _ActivityCard({
    required this.activity,
    required this.cs,
    required this.isDark,
    required this.typeColor,
    required this.typeLabel,
    required this.typeIcon,
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
        child: Row(
          children: [
            // icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(typeIcon, color: typeColor, size: 22),
            ),
            const SizedBox(width: 12),

            // text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: cs.onSurface,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  if (activity.description.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      activity.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        size: 12,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          activity.classRoom,
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

            // badge + date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    typeLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: typeColor,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      activity.date,
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
          ],
        ),
      ),
    );
  }
}

// ── micro-widgets ─────────────────────────────────────────────────────────────

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
  final Color color;
  final bool isDark;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? color
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
}
