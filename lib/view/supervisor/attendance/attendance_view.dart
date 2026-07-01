import 'package:flowva_school/view/supervisor/attendance/students/student_attendance_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_cubit.dart';
import 'package:flowva_school/cubit/supervisor/cubit_supervisor/student_attendance_cubit.dart';
import 'package:flowva_school/cubit/supervisor/submit/submit_attendance_cubit.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import '../../../cubit/current_year/current_year_cubit.dart';
import '../../../app_localizations.dart';
import 'teachers_attendance_view.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  void _openStudentAttendance(BuildContext context) {
    final classesCubit         = context.read<ClassesCubit>();
    final attendanceCubit      = context.read<StudentAttendanceCubit>();
    final submitCubit          = context.read<SubmitAttendanceCubit>();
    final currentYearCubit     = context.read<CurrentYearCubit>();
    final currentSemesterCubit = context.read<CurrentSemesterCubit>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: classesCubit),
            BlocProvider.value(value: attendanceCubit),
            BlocProvider.value(value: submitCubit),
            BlocProvider.value(value: currentYearCubit),
            BlocProvider.value(value: currentSemesterCubit),
          ],
          child: const StudentAttendanceView(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
          textDirection: localeState.textDirection,
          child: Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ─── عنوان الإدارة العلوي متجاوب الاتجاه ───
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      context.tr('attendance_management_title'),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final bool isWide = constraints.maxWidth > 600;

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildCard(
                                context,
                                title: context.tr('attendance_students_title'),
                                subtitle: context.tr('attendance_students_subtitle'),
                                icon: Icons.school_rounded,
                                statsText: context.tr('attendance_students_stats'),
                                progressValue: 0.85,
                                gradientColors: [colorScheme.primary, colorScheme.primary.withOpacity(0.7)],
                                onTap: () => _openStudentAttendance(context),
                                isArabic: localeState.currentLanguage == 'AR',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildCard(
                                context,
                                title: context.tr('attendance_teachers_title'),
                                subtitle: context.tr('attendance_teachers_subtitle'),
                                icon: Icons.badge_rounded,
                                statsText: context.tr('attendance_teachers_stats'),
                                progressValue: 0.94,
                                gradientColors: [const Color(0xFF234E52), colorScheme.primary],
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const TeachersAttendanceView()),
                                ),
                                isArabic: localeState.currentLanguage == 'AR',
                              ),
                            ),
                          ],
                        );
                      } else {
                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildCard(
                              context,
                              title: context.tr('attendance_students_title'),
                              subtitle: context.tr('attendance_students_subtitle'),
                              icon: Icons.school_rounded,
                              statsText: context.tr('attendance_students_stats'),
                              progressValue: 0.85,
                              gradientColors: [colorScheme.primary, colorScheme.primary.withOpacity(0.7)],
                              onTap: () => _openStudentAttendance(context),
                              isArabic: localeState.currentLanguage == 'AR',
                            ),
                            const SizedBox(height: 14),
                            _buildCard(
                              context,
                              title: context.tr('attendance_teachers_title'),
                              subtitle: context.tr('attendance_teachers_subtitle'),
                              icon: Icons.badge_rounded,
                              statsText: context.tr('attendance_teachers_stats'),
                              progressValue: 0.94,
                              gradientColors: [const Color(0xFF234E52), colorScheme.primary],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TeachersAttendanceView()),
                              ),
                              isArabic: localeState.currentLanguage == 'AR',
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required String statsText,
        required double progressValue,
        required List<Color> gradientColors,
        required VoidCallback onTap,
        required bool isArabic,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    final accent      = isDark ? colorScheme.primary : gradientColors.first;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5), width: 1.2),
      ),
      color: colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: accent.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(isDark ? 0.15 : 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: accent, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  // السهم يلتفت تلقائياً بناءً على لغة التطبيق الحالية
                  Icon(
                    isArabic ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: accent.withOpacity(0.6),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: colorScheme.outlineVariant.withOpacity(0.3), height: 1),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    statsText,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${(progressValue * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progressValue,
                  backgroundColor: isDark ? colorScheme.surfaceContainerHigh : const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(accent),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}