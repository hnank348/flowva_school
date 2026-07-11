import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/student/student_attendance_cubit.dart';
import 'package:flowva_school/models/supervisor/student_attendance_model.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import '../../../../app_localizations.dart';

class StudentAttendanceCard extends StatelessWidget {
  final StudentAttendanceModel student;
  final StudentAttendanceStatus currentStatus;

  const StudentAttendanceCard({
    super.key,
    required this.student,
    required this.currentStatus,
  });

  static const _present = (accent: Color(0xFF0F766E), bg: Color(0xFFCCFBF1), bgDark: Color(0xFF134E4A));
  static const _absent  = (accent: Color(0xFFDC2626), bg: Color(0xFFFEE2E2), bgDark: Color(0xFF7F1D1D));
  static const _late    = (accent: Color(0xFFD97706), bg: Color(0xFFFEF3C7), bgDark: Color(0xFF78350F));
  static const _excused = (accent: Color(0xFF7C3AED), bg: Color(0xFFEDE9FE), bgDark: Color(0xFF4C1D95));

  ({Color accent, Color bg, Color bgDark}) get _info {
    switch (currentStatus) {
      case StudentAttendanceStatus.present:  return _present;
      case StudentAttendanceStatus.absent:   return _absent;
      case StudentAttendanceStatus.late:     return _late;
      case StudentAttendanceStatus.excused:  return _excused;
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0];
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    final info        = _info;
    final sid         = student.id.toString();
    final avatarBg    = isDark ? info.bgDark : info.bg;

    final cubit = context.read<StudentAttendanceCubit>();

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        final isArabic = localeState.currentLanguage == 'AR';

        // ✨ دعم ذكي لاسم الطالب: إذا كان التطبيق عربي يفضل الاسم العربي، وإلا يقرأ الإنجليزي
        final name = isArabic
            ? (student.fullNameAr.isNotEmpty ? student.fullNameAr : student.fullName)
            : (student.fullName.isNotEmpty ? student.fullName : student.fullNameAr);

        return Directionality(
          textDirection: localeState.textDirection,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w          = constraints.maxWidth;
              final avatarSize = w < 160 ? 28.0 : 34.0;
              final nameFz     = w < 160 ? 10.0 : 12.0;
              final idFz       = w < 160 ?  9.0 : 10.0;
              final chipH      = w < 160 ? 26.0 : 30.0;
              final chipFz     = w < 160 ?  9.0 : 10.0;
              final vPad       = w < 160 ?  7.0 : 10.0;
              final hPadCard   = w < 160 ?  8.0 : 12.0;
              final gap        = w < 160 ?  7.0 : 10.0;

              return Container(
                decoration: BoxDecoration(
                  color: isDark ? colorScheme.surfaceContainer : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withOpacity(isDark ? 0.25 : 0.5),
                    width: 0.8,
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(height: 3, color: info.accent),

                    Padding(
                      padding: EdgeInsets.fromLTRB(hPadCard, vPad, hPadCard, vPad),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ─── اسم الطالب ───
                          Row(
                            children: [
                              Container(
                                width:  avatarSize,
                                height: avatarSize,
                                decoration: BoxDecoration(color: avatarBg, shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: Text(
                                  _initials(name),
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: nameFz - 1,
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
                                      name,
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: nameFz,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurface,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      'ID: ${student.id}',
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: idFz,
                                        color: colorScheme.onSurfaceVariant.withOpacity(0.55),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: gap),

                          // ─── أزرار الحالة المترجمة ديناميكياً ───
                          Row(
                            children: [
                              _StatusChip(cubit: cubit, studentId: sid, label: context.tr('attendance_present'),
                                  activeColor: _present.accent, activeBg: _present.bg,
                                  buttonStatus: StudentAttendanceStatus.present,
                                  currentStatus: currentStatus, height: chipH, fontSize: chipFz,
                                  isDark: isDark, colorScheme: colorScheme),
                              const SizedBox(width: 3),
                              _StatusChip(cubit: cubit, studentId: sid, label: context.tr('attendance_absent'),
                                  activeColor: _absent.accent, activeBg: _absent.bg,
                                  buttonStatus: StudentAttendanceStatus.absent,
                                  currentStatus: currentStatus, height: chipH, fontSize: chipFz,
                                  isDark: isDark, colorScheme: colorScheme),
                              const SizedBox(width: 3),
                              _StatusChip(cubit: cubit, studentId: sid, label: context.tr('attendance_late'),
                                  activeColor: _late.accent, activeBg: _late.bg,
                                  buttonStatus: StudentAttendanceStatus.late,
                                  currentStatus: currentStatus, height: chipH, fontSize: chipFz,
                                  isDark: isDark, colorScheme: colorScheme),
                              const SizedBox(width: 3),
                              _StatusChip(cubit: cubit, studentId: sid, label: context.tr('attendance_excused'),
                                  activeColor: _excused.accent, activeBg: _excused.bg,
                                  buttonStatus: StudentAttendanceStatus.excused,
                                  currentStatus: currentStatus, height: chipH, fontSize: chipFz,
                                  isDark: isDark, colorScheme: colorScheme),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _StatusChip extends StatelessWidget {
  final StudentAttendanceCubit cubit;
  final String studentId;
  final String label;
  final Color activeColor;
  final Color activeBg;
  final StudentAttendanceStatus buttonStatus;
  final StudentAttendanceStatus currentStatus;
  final double height;
  final double fontSize;
  final bool isDark;
  final ColorScheme colorScheme;

  const _StatusChip({
    required this.cubit,
    required this.studentId,
    required this.label,
    required this.activeColor,
    required this.activeBg,
    required this.buttonStatus,
    required this.currentStatus,
    required this.height,
    required this.fontSize,
    required this.isDark,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentStatus == buttonStatus;

    return Expanded(
      child: GestureDetector(
        onTap: () => cubit.updateAttendance(studentId, buttonStatus),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? activeBg.withOpacity(isDark ? 0.25 : 1.0)
                : (isDark ? colorScheme.surfaceContainer : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: isSelected
                  ? activeColor.withOpacity(isDark ? 0.7 : 1.0)
                  : colorScheme.outlineVariant.withOpacity(0.4),
              width: isSelected ? 1.2 : 0.8,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: fontSize,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? activeColor
                  : colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}