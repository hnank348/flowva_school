import 'package:flowva_school/view/supervisor/attendance/students/student_attendance_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_cubit.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import '../../../cubit/current_year/current_year_cubit.dart';
import '../../../app_localizations.dart';
import '../../../cubit/supervisor/student_attendance/section_students_cubit.dart';
import '../../../cubit/supervisor/student_attendance/section_students_stats.dart';
import '../../../cubit/supervisor/student_attendance/student_attendance_cubit.dart';
import '../../../cubit/supervisor/submit_student/submit_attendance_cubit.dart';
import '../../../cubit/supervisor/submit_teacher/teachers_attendance_cubit.dart';
import 'teachers/teachers_attendance_view.dart';

class AttendanceView extends StatefulWidget {
  const AttendanceView({super.key});

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  bool _canTakeTeacherAttendance = false;
  bool _isLoadingRoles = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final roles = prefs.getStringList('userRoles') ?? [];

    setState(() {
      // 🟢 فحص إذا كان الموجه يمتلك صلاحية الحضور (أو أي اسم صلاحية مستخدمة في الباك إند)
      _canTakeTeacherAttendance = roles.contains('counselor.attendace') ||
          roles.contains('counselor.attendance') ||
          roles.contains('teacher.attendance') ||
          roles.contains('admin');
      _isLoadingRoles = false;
    });
  }

  void _openStudentAttendance(BuildContext context) {
    final classesCubit         = context.read<ClassesCubit>();
    final attendanceCubit      = context.read<StudentAttendanceCubit>();
    final submitCubit          = context.read<SubmitAttendanceCubit>();
    final currentYearCubit     = context.read<CurrentYearCubit>();
    final currentSemesterCubit = context.read<CurrentSemesterCubit>();
    final sectionStatsCubit    = context.read<SectionStudentsStatsCubit>();

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
            BlocProvider.value(value: sectionStatsCubit),
          ],
          child: const StudentAttendanceView(),
        ),
      ),
    );
  }

  void _openTeacherAttendance(BuildContext context) {
    final teachersCubit      = context.read<TeacherAttendanceCubit>();
    final submitTeacherCubit = context.read<SubmitTeacherAttendanceCubit>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: teachersCubit),
            BlocProvider.value(value: submitTeacherCubit),
          ],
          child: const TeachersAttendanceView(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (_isLoadingRoles) {
      return Center(
        child: CircularProgressIndicator(color: cs.primary, strokeWidth: 2),
      );
    }

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        final isArabic = localeState.currentLanguage == 'AR';

        return Directionality(
          textDirection: localeState.textDirection,
          child: Container(
            color: cs.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(cs: cs),
                const SizedBox(height: 20),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 600;

                      final studentCard = _AttendanceEntry(
                        imagePath: 'assets/Images/student_attendance.png',
                        title:     context.tr('attendance_students_title'),
                        subtitle:  context.tr('attendance_students_subtitle'),
                        accent:    cs.primary,
                        isArabic:  isArabic,
                        onTap:     () => _openStudentAttendance(context),
                      );

                      final teacherCard = _AttendanceEntry(
                        imagePath: 'assets/Images/teacher_attendance.png',
                        title:     context.tr('attendance_teachers_title'),
                        subtitle:  context.tr('attendance_teachers_subtitle'),
                        accent:    const Color(0xFF0F766E),
                        isArabic:  isArabic,
                        onTap:     () => _openTeacherAttendance(context),
                      );

                      if (!_canTakeTeacherAttendance) {
                        return ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [studentCard],
                        );
                      }

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: studentCard),
                            const SizedBox(width: 14),
                            Expanded(child: teacherCard),
                          ],
                        );
                      }

                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          studentCard,
                          const SizedBox(height: 14),
                          teacherCard,
                        ],
                      );
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
}

class _Header extends StatelessWidget {
  final ColorScheme cs;
  const _Header({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4, height: 22,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            context.tr('attendance_management_title'),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
    );
  }
}

class _AttendanceEntry extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final Color accent;
  final bool isArabic;
  final VoidCallback onTap;

  const _AttendanceEntry({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.isArabic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: accent.withOpacity(0.08),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: isDark ? cs.surfaceContainer : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: cs.outlineVariant.withOpacity(isDark ? 0.4 : 0.6),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: accent.withOpacity(0.08),
                        child: Icon(Icons.image_outlined,
                            color: accent.withOpacity(0.4), size: 40),
                      ),
                    ),
                    Positioned(
                      left: 0, right: 0, bottom: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              (isDark ? cs.surfaceContainer : Colors.white)
                                  .withOpacity(0.9),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: accent.withOpacity(isDark ? 0.18 : 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isArabic
                                ? Icons.arrow_back_ios_new_rounded
                                : Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: accent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12.5,
                        color: cs.onSurfaceVariant,
                        height: 1.5,
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
}