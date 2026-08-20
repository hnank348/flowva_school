import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_localizations.dart';
import '../../cubit/locale/locale_cubit.dart';
import '../../cubit/locale/locale_state.dart';
import '../../data/mock_data.dart';
import '../../models/teacher/student.dart';

class StudentsView extends StatefulWidget {
  const StudentsView({super.key});

  @override
  State<StudentsView> createState() => _StudentsViewState();
}

class _StudentsViewState extends State<StudentsView>
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

  List<Student> _filterStudents(List<Student> students, String query) {
    if (query.trim().isEmpty) return students;
    return students
        .where((s) => s.name.toLowerCase().contains(query.trim().toLowerCase()))
        .toList();
  }

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final allStudents = MockData.getStudents();
    final query = _searchController.text;
    final students = _filterStudents(allStudents, query);
    final excellentStudents = students.where((s) => s.isExcellent).toList();
    final needsAttention = students.where((s) => s.needsAttention).toList();

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
          textDirection: localeState.textDirection,
          child: Column(
            children: [
              // ── search bar ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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
                    fillColor: colorScheme.surfaceContainerHighest,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),

              // ── tabs ───────────────────────────────────────────────────
              TabBar(
                controller: _tabController,
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                indicatorColor: colorScheme.primary,
                labelStyle: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: '${context.tr('filter_all')} (${students.length})'),
                  Tab(
                    text:
                        '${context.tr('teacher_excellent')} (${excellentStudents.length})',
                  ),
                  Tab(
                    text:
                        '${context.tr('teacher_needs_attention')} (${needsAttention.length})',
                  ),
                ],
              ),

              // ── tab content ────────────────────────────────────────────
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildList(students, colorScheme),
                    _buildList(excellentStudents, colorScheme),
                    _buildList(needsAttention, colorScheme),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildList(List<Student> students, ColorScheme colorScheme) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (students.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: 56,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              context.tr('filter_empty_students'),
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontFamily: 'Cairo',
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: students.length,
      itemBuilder: (context, index) => _StudentCard(
        student: students[index],
        colorScheme: colorScheme,
        isDark: isDark,
        gradeColor: _gradeColor(students[index].grade, colorScheme),
        gradeTag: _gradeTag(students[index].grade, context),
      ),
    );
  }
}

// ── read-only student card ────────────────────────────────────────────────────

class _StudentCard extends StatelessWidget {
  final Student student;
  final ColorScheme colorScheme;
  final bool isDark;
  final Color gradeColor;
  final String gradeTag;

  const _StudentCard({
    required this.student,
    required this.colorScheme,
    required this.isDark,
    required this.gradeColor,
    required this.gradeTag,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isDark ? 0 : 2,
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? colorScheme.surfaceContainer : colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: isDark
            ? BorderSide(color: colorScheme.outlineVariant)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── header row ──────────────────────────────────────────────
            Row(
              children: [
                // avatar
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

                // name + class
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: colorScheme.onSurface,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 3),
                      // grade tag badge
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

                // big grade number
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
                        color: colorScheme.onSurfaceVariant,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),
            Divider(height: 1, color: colorScheme.outlineVariant),
            const SizedBox(height: 12),

            // ── 3 mini progress bars side-by-side ───────────────────────
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
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniBar(
                    label: context.tr('teacher_performance'),
                    value: student.performance,
                    color: Colors.green,
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
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: colorScheme.onSurfaceVariant,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 7,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${value.toInt()}%',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
