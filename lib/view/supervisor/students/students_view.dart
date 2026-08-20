import 'package:flowva_school/view/supervisor/students/submit_observation_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/locale/locale_cubit.dart';
import '../../../cubit/locale/locale_state.dart';
import '../../../cubit/current_semester/current_semester_cubit.dart';
import '../../../cubit/current_semester/current_semester_state.dart';
import '../../../cubit/supervisor/students/students_cubit.dart';
import '../../../cubit/supervisor/students/students_state.dart';
import '../../../cubit/supervisor/inspection/current_inspection_cubit.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/field_styles.dart';
import '../../../widget/button.dart';
import '../../../app_localizations.dart';
import 'student_card.dart';

class StudentsView extends StatelessWidget {
  const StudentsView({super.key});

  void _triggerFetch(BuildContext context) {
    final semesterState = context.read<CurrentSemesterCubit>().state;
    final semesterId =
    semesterState is CurrentSemesterSuccess ? semesterState.currentSemester.id : 1;
    context.read<StudentsCubit>().fetchStudents(
      semesterId: semesterId,
      tr: context.tr,
    );
    context.read<CurrentInspectionCubit>().fetchCurrentProgram(tr: context.tr);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<StudentsCubit>();
      if (cubit.state is StudentsInitial) _triggerFetch(context);
    });

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        final isArabic = localeState.currentLanguage == 'AR';

        return Directionality(
          textDirection: localeState.textDirection,
          child: Scaffold(
            backgroundColor: cs.surface,
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 240,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [
                          cs.surfaceContainerHigh.withOpacity(0.8),
                          cs.surface.withOpacity(0.0),
                        ]
                            : [
                          cs.primary.withOpacity(0.08),
                          cs.surface.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                        child: _Header(cs: cs, isDark: isDark),
                      ),

                      // 🟢 كارد المهمة الحالية بأسلوب Bento فخم (يظهر فقط إذا الحالة ongoing أو pending)
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
                        child: CurrentInspectionCard(),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                        child: _SearchBar(cs: cs, isDark: isDark),
                      ),
                      Expanded(
                        child: BlocBuilder<StudentsCubit, StudentsState>(
                          builder: (context, state) {
                            if (state is StudentsLoading || state is StudentsInitial) {
                              return const _SkeletonList();
                            }

                            if (state is StudentsError) {
                              return _ErrorView(
                                message: state.message,
                                onRetry: () => _triggerFetch(context),
                              );
                            }

                            if (state is StudentsLoaded) {
                              final students = state.filteredStudents;
                              if (students.isEmpty) return const _EmptyView();

                              return RefreshIndicator(
                                color: cs.primary,
                                onRefresh: () async => _triggerFetch(context),
                                child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(
                                    parent: BouncingScrollPhysics(),
                                  ),
                                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                                  itemCount: students.length,
                                  itemBuilder: (context, index) => _FadeSlideIn(
                                    delayMs: (index * 40).clamp(0, 360),
                                    child: StudentCard(
                                      student: students[index],
                                      isArabic: isArabic,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final ColorScheme cs;
  final bool isDark;
  const _Header({required this.cs, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(isDark ? 0.2 : 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: cs.primary.withOpacity(isDark ? 0.35 : 0.2),
              width: 1,
            ),
          ),
          child: Icon(Icons.groups_rounded, color: cs.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('students_title'),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              BlocBuilder<StudentsCubit, StudentsState>(
                builder: (context, state) {
                  final count = state is StudentsLoaded ? state.filteredStudents.length : 0;
                  return Text(
                    '$count ${context.tr('students_count_suffix')}',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: cs.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final ColorScheme cs;
  final bool isDark;

  const _SearchBar({
    super.key,
    required this.cs,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (val) {
        context.read<StudentsCubit>().searchByName(val);
      },
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13.5,
        color: cs.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: FieldStyles.authInputDecoration(
        label: context.tr('students_search_hint'),
        icon: Icons.search_rounded,
      ).copyWith(
        fillColor: isDark ? cs.surfaceContainerHigh : cs.surfaceContainerLow,
        filled: true,
      ),
    );
  }
}

class _FadeSlideIn extends StatelessWidget {
  final Widget child;
  final int delayMs;
  const _FadeSlideIn({required this.child, this.delayMs = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, t, c) => Opacity(
        opacity: t.clamp(0, 1),
        child: Transform.translate(offset: Offset(0, 18 * (1 - t)), child: c),
      ),
      child: child,
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: 6,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.4, end: 1),
        duration: Duration(milliseconds: 600 + i * 100),
        curve: Curves.easeInOut,
        builder: (_, t, __) => Opacity(
          opacity: t,
          child: Container(
            height: 84,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_search_rounded, size: 42, color: cs.primary),
          ),
          const SizedBox(height: 12),
          Text(
            context.tr('students_empty_list'),
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 40, color: cs.error),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: cs.error,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Button(
              text: context.tr('retry_btn'),
              icon: Icons.refresh_rounded,
              width: 150,
              height: 44,
              color: cs.primary,
              colorText: Colors.white,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}