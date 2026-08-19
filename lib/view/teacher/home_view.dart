import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_localizations.dart';
import '../../cubit/locale/locale_cubit.dart';
import '../../cubit/locale/locale_state.dart';
import '../../data/mock_data.dart';
import '../../models/teacher/activity.dart';
import '../../models/teacher/student.dart';
import 'activities_list_view.dart';
import 'add_activity_view.dart';
import 'class_evaluation_view.dart';
import 'create_exam_view.dart';
import 'homework_list_view.dart';
import 'teacher_exam_schedule_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.userToken});
  final String userToken;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void _refreshActivities() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final students = MockData.getStudents();
    final activities = MockData.getActivities();
    final schedule = MockData.getSchedule();
    final todaySchedule = schedule[2];
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
          textDirection: localeState.textDirection,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('teacher_welcome'),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.tr('teacher_today_date'),
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        context.tr('teacher_students'),
                        '${students.length}',
                        Icons.people_outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        context.tr('teacher_classes'),
                        '${MockData.getClassRooms().length}',
                        Icons.menu_book_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  context.tr('teacher_quick_actions'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Each cell is half the available width minus spacing.
                    // Height = enough for icon (32) + gap (8) + two text lines (~36) + padding (16).
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: ((constraints.maxWidth - 20) / 3) / 90,
                      children: [
                        _buildQuickAction(
                          context,
                          context.tr('teacher_create_exam'),
                          Icons.assignment_outlined,
                          colorScheme.primary,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CreateExamView(),
                            ),
                          ),
                        ),
                        _buildQuickAction(
                          context,
                          context.tr('exam_sched_title'),
                          Icons.calendar_month_outlined,
                          colorScheme.primary,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TeacherExamScheduleView(),
                            ),
                          ),
                        ),
                        _buildQuickAction(
                          context,
                          context.tr('teacher_evaluate_students'),
                          Icons.star_outline,
                          colorScheme.primary,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ClassEvaluationView(),
                            ),
                          ),
                        ),
                        _buildQuickAction(
                          context,
                          context.tr('hw_list_title'),
                          Icons.list_alt_outlined,
                          const Color(0xFF0F766E),
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeworkListView(),
                            ),
                          ),
                        ),
                        _buildQuickAction(
                          context,
                          context.tr('act_list_title'),
                          Icons.event_outlined,
                          Colors.deepPurple,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ActivitiesListView(),
                            ),
                          ).then((_) => _refreshActivities()),
                        ),
                        _buildQuickAction(
                          context,
                          context.tr('exam_final_title'),
                          Icons.school_outlined,
                          Colors.red.shade700,
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TeacherExamScheduleView(
                                showFinalOnly: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                // ── recent homeworks section ──────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('hw_recent_section'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HomeworkListView(),
                        ),
                      ),
                      child: Text(
                        context.tr('hw_view_all'),
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontFamily: 'Cairo',
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...MockData.getHomeworks()
                    .take(3)
                    .map(
                      (hw) =>
                          _buildHomeworkCard(context, hw, colorScheme, isDark),
                    ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('teacher_today_schedule'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: isDark ? 0 : 2,
                  color: isDark
                      ? colorScheme.surfaceContainer
                      : colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isDark
                        ? BorderSide(color: colorScheme.outlineVariant)
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: todaySchedule.sessions
                          .map(
                            (session) =>
                                _buildSessionCard(session, colorScheme, isDark),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // ── upcoming activities ───────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.tr('teacher_upcoming_activities'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // زر عرض الكل
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ActivitiesListView(),
                            ),
                          ).then((_) => _refreshActivities()),
                          child: Text(
                            context.tr('hw_view_all'),
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontFamily: 'Cairo',
                              fontSize: 13,
                            ),
                          ),
                        ),
                        // زر إضافة نشاط جديد
                        GestureDetector(
                          onTap: () =>
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AddActivityView(),
                                ),
                              ).then((added) {
                                if (added == true) _refreshActivities();
                              }),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Icon(
                              Icons.add_rounded,
                              color: colorScheme.primary,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...activities
                    .take(3)
                    .map((activity) => _buildActivityCard(context, activity)),
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
                const SizedBox(height: 12),
                Card(
                  elevation: isDark ? 0 : 2,
                  color: isDark
                      ? colorScheme.surfaceContainer
                      : colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isDark
                        ? BorderSide(color: colorScheme.outlineVariant)
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: students
                          .take(3)
                          .toList()
                          .asMap()
                          .entries
                          .map(
                            (entry) => _buildTopStudentCard(
                              context,
                              entry.value,
                              entry.key,
                              colorScheme,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainer
            : colorScheme.primary
                  .withValues(alpha: 0.1)
                  .withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant
              : colorScheme.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          Icon(icon, color: colorScheme.primary, size: 32),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(
    dynamic session,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.surfaceContainerLow
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.access_time,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.subject,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: colorScheme.onSurface,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      session.className,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  session.time,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${session.room}',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 11,
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

  Widget _buildActivityCard(BuildContext context, Activity activity) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color color;
    final IconData icon;

    switch (activity.type) {
      case ActivityType.parentMeeting:
        color = colorScheme.primary;
        icon = Icons.people_outline;
      case ActivityType.schoolTrip:
        color = const Color(0xFF0F766E);
        icon = Icons.directions_bus_outlined;
      case ActivityType.competition:
        color = Colors.amber.shade700;
        icon = Icons.emoji_events_outlined;
      case ActivityType.ceremony:
        color = Colors.deepPurple;
        icon = Icons.celebration_outlined;
      case ActivityType.workshop:
        color = Colors.orange;
        icon = Icons.build_outlined;
      case ActivityType.other:
        color = colorScheme.onSurfaceVariant;
        icon = Icons.event_outlined;
    }

    return Card(
      elevation: isDark ? 0 : 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? colorScheme.surfaceContainer : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDark
            ? BorderSide(color: colorScheme.outlineVariant)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180,
                      child: Text(
                        activity.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: colorScheme.onSurface,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.classRoom,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                activity.date,
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeworkCard(
    BuildContext context,
    homework,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    final Color typeColor;
    final IconData typeIcon;
    switch (homework.type.toString().split('.').last) {
      case 'written':
        typeColor = colorScheme.primary;
        typeIcon = Icons.edit_outlined;
        break;
      case 'reading':
        typeColor = Colors.teal;
        typeIcon = Icons.menu_book_outlined;
        break;
      case 'research':
        typeColor = Colors.purple;
        typeIcon = Icons.search_outlined;
        break;
      default:
        typeColor = Colors.orange;
        typeIcon = Icons.folder_outlined;
    }

    final isOverdue =
        homework.status.toString().contains('pending') &&
        (homework.dueDate as DateTime).isBefore(DateTime.now());
    final badgeColor = isOverdue ? colorScheme.error : typeColor;

    return Card(
      elevation: isDark ? 0 : 2,
      margin: const EdgeInsets.only(bottom: 10),
      color: isDark ? colorScheme.surfaceContainer : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDark
            ? BorderSide(color: colorScheme.outlineVariant)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomeworkListView()),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: typeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(typeIcon, color: typeColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      homework.title as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: colorScheme.onSurface,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      homework.classRoomName as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.event_outlined, size: 12, color: badgeColor),
                    const SizedBox(width: 3),
                    Text(
                      '${(homework.dueDate as DateTime).day}/${(homework.dueDate as DateTime).month}',
                      style: TextStyle(
                        fontSize: 11,
                        color: badgeColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopStudentCard(
    BuildContext context,
    Student student,
    int index,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      student.name[0],
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  if (index == 0)
                    Positioned(
                      top: -2,
                      left: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.emoji_events,
                          color: colorScheme.onSecondary,
                          size: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: colorScheme.onSurface,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${context.tr('teacher_attendance_stat')}: ${student.attendance.toInt()}%',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 11,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.star, color: colorScheme.secondary, size: 16),
              const SizedBox(width: 4),
              Text(
                student.grade.toInt().toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: colorScheme.onSurface,
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
