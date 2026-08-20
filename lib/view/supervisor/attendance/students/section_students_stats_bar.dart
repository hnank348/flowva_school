import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import '../../../../app_localizations.dart';
import '../../../../cubit/supervisor/student_attendance/section_students_cubit.dart';
import '../../../../cubit/supervisor/student_attendance/section_students_stats.dart';

class SectionStudentsStatsBar extends StatelessWidget {
  final bool isTablet;

  const SectionStudentsStatsBar({super.key, required this.isTablet});

  String _getLabel(BuildContext context, String key, bool isArabic) {
    final translated = context.tr(key);
    if (translated == key) {
      switch (key) {
        case 'stats_total_students':
          return isArabic ? 'الإجمالي' : 'Total';
        case 'stats_active_students':
          return isArabic ? 'النشطين' : 'Active';
        case 'stats_male_students':
          return isArabic ? 'الذكور' : 'Male';
        case 'stats_female_students':
          return isArabic ? 'الإناث' : 'Female';
      }
    }
    return translated;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        final isArabic = localeState.currentLanguage.toUpperCase() == 'AR';

        return BlocBuilder<SectionStudentsStatsCubit, SectionStudentsStatsState>(
          builder: (context, state) {
            if (state is SectionStudentsStatsLoading) {
              return Container(
                height: 74,
                decoration: BoxDecoration(
                  color: isDark ? cs.surfaceContainerHigh : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }

            if (state is SectionStudentsStatsLoaded) {
              final stats = state.stats;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? cs.surfaceContainerHigh : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: cs.outlineVariant.withOpacity(isDark ? 0.35 : 0.45),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.28 : 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _BentoStatCard(
                      icon: Icons.groups_rounded,
                      label: _getLabel(context, 'stats_total_students', isArabic),
                      value: '${stats.total}',
                      accentColor: cs.primary,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 6),
                    _BentoStatCard(
                      icon: Icons.verified_rounded,
                      label: _getLabel(context, 'stats_active_students', isArabic),
                      value: '${stats.active}',
                      accentColor: const Color(0xFF10B981),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 6),
                    _BentoStatCard(
                      icon: Icons.male_rounded,
                      label: _getLabel(context, 'stats_male_students', isArabic),
                      value: '${stats.male}',
                      accentColor: const Color(0xFF3B82F6),
                      isDark: isDark,
                    ),
                    const SizedBox(width: 6),
                    _BentoStatCard(
                      icon: Icons.female_rounded,
                      label: _getLabel(context, 'stats_female_students', isArabic),
                      value: '${stats.female}',
                      accentColor: const Color(0xFFEC4899),
                      isDark: isDark,
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}

class _BentoStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;
  final bool isDark;

  const _BentoStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(isDark ? 0.14 : 0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: accentColor.withOpacity(isDark ? 0.28 : 0.15),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(isDark ? 0.22 : 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 13, color: accentColor),
                ),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                    height: 1.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}