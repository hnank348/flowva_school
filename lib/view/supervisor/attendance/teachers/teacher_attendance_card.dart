import 'package:flutter/material.dart';
import 'package:flowva_school/models/supervisor/teacher_attendance_model.dart';
import 'package:flowva_school/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// استيراد الـ LocaleCubit لضمان قراءة اللغة الحالية بدقة
import 'package:flowva_school/cubit/locale/locale_cubit.dart';

import '../../../../cubit/supervisor/submit_teacher/teacher_attendance_state.dart';
import '../../../../cubit/supervisor/submit_teacher/teachers_attendance_cubit.dart';

class TeacherAttendanceCard extends StatelessWidget {
  final TeacherModel teacher;
  final TeacherAttendanceStatus currentStatus;

  const TeacherAttendanceCard({
    super.key,
    required this.teacher,
    required this.currentStatus,
  });

  static const _present = (accent: Color(0xFF0F766E), bg: Color(0xFFCCFBF1), bgDark: Color(0xFF134E4A));
  static const _absent  = (accent: Color(0xFFDC2626), bg: Color(0xFFFEE2E2), bgDark: Color(0xFF7F1D1D));
  static const _late    = (accent: Color(0xFFD97706), bg: Color(0xFFFEF3C7), bgDark: Color(0xFF78350F));
  static const _excused = (accent: Color(0xFF7C3AED), bg: Color(0xFFEDE9FE), bgDark: Color(0xFF4C1D95));

  ({Color accent, Color bg, Color bgDark}) get _info {
    switch (currentStatus) {
      case TeacherAttendanceStatus.active:  return _present;
      case TeacherAttendanceStatus.inactive:   return _absent;
      case TeacherAttendanceStatus.vacation:     return _late;
      case TeacherAttendanceStatus.transferred:  return _excused;
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name.isNotEmpty ? name[0] : '?';
  }

  @override
  Widget build(BuildContext context) {
    final cs      = Theme.of(context).colorScheme;
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final info    = _info;

    // ─── جلب اللغة الحالية من الـ Cubit مباشرة لضمان التطابق التام ───
    final localeState = context.read<LocaleCubit>().state;
    final String currentLang = localeState.currentLanguage.toUpperCase(); // ستكون 'AR' أو 'EN'

    // فحص شامل يغطي الـ Cubit ويغطي الـ Localizations العادية كخيار احتياطي
    final bool isArabic = currentLang == 'AR' || Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';

    // ─── اختيار وعرض الاسم بناءً على الفحص المحدث ───
    final String displayName = isArabic
        ? (teacher.fullNameAr.isNotEmpty ? teacher.fullNameAr : teacher.fullName)
        : (teacher.fullName.isNotEmpty ? teacher.fullName : teacher.fullNameAr);

    final avatarBg = isDark ? info.bgDark : info.bg;
    final cubit    = context.read<TeacherAttendanceCubit>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final w        = constraints.maxWidth;
        final chipH    = w < 160 ? 26.0 : 30.0;
        final chipFz   = w < 160 ?  9.0 : 10.0;
        final nameFz   = w < 160 ? 10.0 : 12.0;
        final hPad     = w < 160 ?  8.0 : 12.0;
        final vPad     = w < 160 ?  7.0 : 10.0;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? cs.surfaceContainer : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: cs.outlineVariant.withOpacity(isDark ? 0.25 : 0.5),
              width: 0.8,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height: 3, color: info.accent),
              Padding(
                padding: EdgeInsets.fromLTRB(hPad, vPad, hPad, vPad),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ─── اسم المعلم المحدث ───
                    Row(
                      children: [
                        Container(
                          width: 34, height: 34,
                          decoration: BoxDecoration(color: avatarBg, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Text(
                            _initials(displayName),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: info.accent,
                            ),
                          ),
                        ),
                        SizedBox(width: w < 160 ? 6 : 9),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                displayName,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: nameFz,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                teacher.employeeId,
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 10,
                                  color: cs.onSurfaceVariant.withOpacity(0.55),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: w < 160 ? 7 : 10),

                    // ─── أزرار الحالة ───
                    Row(
                      children: [
                        _Chip(cubit: cubit, teacherId: teacher.id,
                            label: context.tr('attendance_active'),
                            activeColor: _present.accent, activeBg: _present.bg,
                            status: TeacherAttendanceStatus.active,
                            current: currentStatus, height: chipH, fontSize: chipFz,
                            isDark: isDark, cs: cs),
                        const SizedBox(width: 3),
                        _Chip(cubit: cubit, teacherId: teacher.id,
                            label: context.tr('attendance_inactive'),
                            activeColor: _absent.accent, activeBg: _absent.bg,
                            status: TeacherAttendanceStatus.inactive,
                            current: currentStatus, height: chipH, fontSize: chipFz,
                            isDark: isDark, cs: cs),
                        const SizedBox(width: 3),
                        _Chip(cubit: cubit, teacherId: teacher.id,
                            label: context.tr('attendance_vacation'),
                            activeColor: _late.accent, activeBg: _late.bg,
                            status: TeacherAttendanceStatus.vacation,
                            current: currentStatus, height: chipH, fontSize: chipFz,
                            isDark: isDark, cs: cs),
                        const SizedBox(width: 3),
                        _Chip(cubit: cubit, teacherId: teacher.id,
                            label: context.tr('attendance_transferred'),
                            activeColor: _excused.accent, activeBg: _excused.bg,
                            status: TeacherAttendanceStatus.transferred,
                            current: currentStatus, height: chipH, fontSize: chipFz,
                            isDark: isDark, cs: cs),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  final TeacherAttendanceCubit cubit;
  final int teacherId;
  final String label;
  final Color activeColor;
  final Color activeBg;
  final TeacherAttendanceStatus status;
  final TeacherAttendanceStatus current;
  final double height;
  final double fontSize;
  final bool isDark;
  final ColorScheme cs;

  const _Chip({
    required this.cubit, required this.teacherId, required this.label,
    required this.activeColor, required this.activeBg,
    required this.status, required this.current,
    required this.height, required this.fontSize,
    required this.isDark, required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = current == status;
    return Expanded(
      child: GestureDetector(
        onTap: () => cubit.updateAttendance(teacherId, status),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: height, alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? activeBg.withOpacity(isDark ? 0.25 : 1.0)
                : (isDark ? cs.surfaceContainer : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: isSelected
                  ? activeColor.withOpacity(isDark ? 0.7 : 1.0)
                  : cs.outlineVariant.withOpacity(0.4),
              width: isSelected ? 1.2 : 0.8,
            ),
          ),
          child: Text(label,
              style: TextStyle(fontFamily: 'Cairo', fontSize: fontSize,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : cs.onSurfaceVariant.withOpacity(0.7))),
        ),
      ),
    );
  }
}