import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/supervisor/cubit_supervisor/teachers_attendance_cubit.dart';

class TeachersAttendanceView extends StatelessWidget {
  const TeachersAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final bool isTablet = screenWidth > 650;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => TeachersAttendanceCubit(),
      child: BlocBuilder<TeachersAttendanceCubit, TeachersAttendanceState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: isDark ? colorScheme.surface : const Color(0xFFF8FAFC),

            // 🌟 الـ AppBar الآن نظيف تماماً ويقرأ ألوانه تلقائياً من كلاس AppTheme الخاص بك
            appBar: AppBar(
              title: const Text(
                'حضور وغياب المعلمين',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
              // ✨ تم إزالة الـ FlexibleSpace والتدرج القديم ليتطابق مع الـ Theme الخاص بك
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),

            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  double aspectRatio = 2.3;

                  if (constraints.maxWidth > 950) {
                    crossAxisCount = 3;
                    aspectRatio = 2.1;
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 2;
                    aspectRatio = 2.1;
                  }

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 24.0 : 16.0, vertical: 16.0),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: aspectRatio,
                      crossAxisSpacing: isTablet ? 16 : 12,
                      mainAxisSpacing: isTablet ? 16 : 12,
                    ),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      final teacherName = 'الأستاذ / اسم المعلم الكامل التجريبي رقم ${index + 1}';
                      final currentStatus = state.attendanceMap[teacherName] ?? TeacherAttendanceStatus.active;

                      Color statusBaseColor = const Color(0xFF1E3A8A);
                      String statusSubtitle = 'نشط بالمنشأة';

                      if (currentStatus == TeacherAttendanceStatus.inactive) {
                        statusBaseColor = const Color(0xFFEF4444);
                        statusSubtitle = 'غير نشط';
                      } else if (currentStatus == TeacherAttendanceStatus.vacation) {
                        statusBaseColor = const Color(0xFFF59E0B);
                        statusSubtitle = 'في إجازة';
                      } else if (currentStatus == TeacherAttendanceStatus.transferred) {
                        statusBaseColor = const Color(0xFF6366F1);
                        statusSubtitle = 'تم الانتقال';
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withOpacity(isDark ? 0.2 : 0.6),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                textDirection: TextDirection.rtl,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: statusBaseColor.withOpacity(0.12),
                                    radius: 20,
                                    child: Icon(Icons.badge_rounded, color: statusBaseColor, size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          teacherName,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: colorScheme.onSurface
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'حالة المعلم: $statusSubtitle',
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'Cairo',
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: SizedBox(
                                  height: 36,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Row(
                                      children: [
                                        _buildTeacherStatusChip(context, teacherName, 'نشط', const Color(0xFF10B981), TeacherAttendanceStatus.active, currentStatus),
                                        const SizedBox(width: 6),
                                        _buildTeacherStatusChip(context, teacherName, 'غير نشط', const Color(0xFFEF4444), TeacherAttendanceStatus.inactive, currentStatus),
                                        const SizedBox(width: 6),
                                        _buildTeacherStatusChip(context, teacherName, 'إجازة', const Color(0xFFF59E0B), TeacherAttendanceStatus.vacation, currentStatus),
                                        const SizedBox(width: 6),
                                        _buildTeacherStatusChip(context, teacherName, 'انتقل', const Color(0xFF6366F1), TeacherAttendanceStatus.transferred, currentStatus),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeacherStatusChip(BuildContext context, String teacherName, String label, Color color, TeacherAttendanceStatus buttonStatus, TeacherAttendanceStatus currentStatus) {
    bool isSelected = currentStatus == buttonStatus;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.read<TeachersAttendanceCubit>().updateAttendance(teacherName, buttonStatus),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? color.withOpacity(0.2) : color)
              : (isDark ? colorScheme.surfaceContainer : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? color
                : (isDark ? colorScheme.outlineVariant.withOpacity(0.3) : color.withOpacity(0.25)),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected && !isDark
              ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 6, offset: const Offset(0, 2))]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? (isDark ? color : Colors.white)
                  : (isDark ? colorScheme.onSurfaceVariant : color.withOpacity(0.9)),
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}