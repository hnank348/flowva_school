import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_localizations.dart';
import '../../cubit/locale/locale_cubit.dart';
import '../../cubit/locale/locale_state.dart';
import '../../data/mock_data.dart';
import 'class_evaluation_view.dart';
import 'class_students_view.dart';
import 'create_exam_view.dart';
import 'send_homework_view.dart';

class ClassesView extends StatelessWidget {
  const ClassesView({super.key});

  @override
  Widget build(BuildContext context) {
    final classRooms = MockData.getClassRooms();
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
          textDirection: localeState.textDirection,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: classRooms.length,
            itemBuilder: (context, index) {
              final classRoom = classRooms[index];
              return Card(
                elevation: isDark ? 0 : 2,
                margin: const EdgeInsets.only(bottom: 12),
                color: isDark
                    ? colorScheme.surfaceContainer
                    : colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: isDark
                      ? BorderSide(color: colorScheme.outlineVariant)
                      : BorderSide.none,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ClassStudentsView(
                        classRoomId: classRoom.id,
                        classRoomName: classRoom.name,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── header row ──────────────────────────────────
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.menu_book_outlined,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    classRoom.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: colorScheme.onSurface,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    classRoom.subject,
                                    style: TextStyle(
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 13,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 15,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ── meta row ─────────────────────────────────────
                        Row(
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 15,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${classRoom.studentsCount} ${context.tr('teacher_student_count')}',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 12,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Icon(
                              Icons.access_time,
                              size: 15,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              classRoom.nextSession,
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 12,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),
                        Divider(height: 1, color: colorScheme.outlineVariant),
                        const SizedBox(height: 12),

                        // ── action buttons ────────────────────────────────
                        Row(
                          children: [
                            _ActionChip(
                              icon: Icons.assignment_outlined,
                              label: context.tr('teacher_create_exam'),
                              baseColor: colorScheme.primary,
                              isDark: isDark,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CreateExamView(
                                    preselectedClassRoomId: classRoom.id,
                                    preselectedClassRoomName:
                                        '${classRoom.name} — ${classRoom.subject}',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _ActionChip(
                              icon: Icons.home_work_outlined,
                              label: context.tr('teacher_send_homework'),
                              baseColor: const Color(0xFF0F766E),
                              isDark: isDark,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SendHomeworkView(
                                    preselectedClassRoomId: classRoom.id,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _ActionChip(
                              icon: Icons.bar_chart_outlined,
                              label: context.tr('teacher_evaluate'),
                              baseColor: Colors.deepPurple,
                              isDark: isDark,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ClassEvaluationView(
                                    classRoomId: classRoom.id,
                                    classRoomName: classRoom.name,
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
            },
          ),
        );
      },
    );
  }
}

// ── reusable action chip ──────────────────────────────────────────────────────

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color baseColor;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.baseColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            decoration: BoxDecoration(
              color: isDark
                  ? baseColor.withValues(alpha: 0.15)
                  : baseColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: baseColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: baseColor, size: 20),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: baseColor,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
