import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/supervisor/cubit_supervisor/student_attendance_cubit.dart';

class StudentAttendanceView extends StatelessWidget {
  const StudentAttendanceView({super.key});

  final List<String> classes = const ['الصف الثالث - أ', 'الصف الثالث - ب', 'الصف الرابع - أ'];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final bool isTablet = screenWidth > 650;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => StudentAttendanceCubit(),
      child: BlocBuilder<StudentAttendanceCubit, StudentAttendanceState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: isDark ? colorScheme.surface : const Color(0xFFF8FAFC),

            // 🌟 الـ AppBar الآن نظيف تماماً ويقرأ ألوانه وحوافه تلقائياً من كلاس AppTheme الخاص بك
            appBar: AppBar(
              title: const Text(
                'حضور وغياب الطلاب',
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
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),

            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // 🏷️ شريط اختيار الصفوف التفاعلي المرن والمتناسق مع المودين
                  SizedBox(
                    height: 42,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      padding: EdgeInsets.symmetric(horizontal: isTablet ? 24.0 : 16.0),
                      itemCount: classes.length,
                      itemBuilder: (context, index) {
                        final className = classes[index];
                        final isSelected = className == state.selectedClass;

                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: InkWell(
                            onTap: () => context.read<StudentAttendanceCubit>().changeClass(className),
                            borderRadius: BorderRadius.circular(14),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? colorScheme.primary
                                    : colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : colorScheme.outlineVariant.withOpacity(isDark ? 0.3 : 0.6),
                                ),
                                boxShadow: isSelected && !isDark
                                    ? [BoxShadow(color: colorScheme.primary.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 4))]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  className,
                                  style: TextStyle(
                                      color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                                      fontFamily: 'Cairo',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 🕸️ شبكة كروت الطلاب العصرية الحركية والمتجاوبة
                  Expanded(
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
                          padding: EdgeInsets.symmetric(horizontal: isTablet ? 24.0 : 16.0, vertical: 8.0),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: aspectRatio,
                            crossAxisSpacing: isTablet ? 16 : 12,
                            mainAxisSpacing: isTablet ? 16 : 12,
                          ),
                          itemCount: 15,
                          itemBuilder: (context, index) {
                            final studentName = 'اسم الطالب الثلاثي الكامل التجريبي رقم ${index + 1}';
                            final currentStatus = state.attendanceMap[studentName] ?? StudentAttendanceStatus.present;

                            // 🎨 دلالة لونية سريعة وشاملة لأيقونة الطالب بحسب حالته الحالية
                            Color statusBaseColor = const Color(0xFF10B981);
                            if (currentStatus == StudentAttendanceStatus.absent) {
                              statusBaseColor = const Color(0xFFEF4444);
                            } else if (currentStatus == StudentAttendanceStatus.late) {
                              statusBaseColor = const Color(0xFFF59E0B);
                            } else if (currentStatus == StudentAttendanceStatus.excused) {
                              statusBaseColor = const Color(0xFF6366F1);
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
                                          child: Icon(Icons.person_rounded, color: statusBaseColor, size: 18),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            studentName,
                                            textAlign: TextAlign.right,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: colorScheme.onSurface),
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
                                              _buildStatusChip(context, studentName, 'حاضر', const Color(0xFF10B981), StudentAttendanceStatus.present, currentStatus),
                                              const SizedBox(width: 6),
                                              _buildStatusChip(context, studentName, 'غائب', const Color(0xFFEF4444), StudentAttendanceStatus.absent, currentStatus),
                                              const SizedBox(width: 6),
                                              _buildStatusChip(context, studentName, 'تأخير', const Color(0xFFF59E0B), StudentAttendanceStatus.late, currentStatus),
                                              const SizedBox(width: 6),
                                              _buildStatusChip(context, studentName, 'إذن', const Color(0xFF6366F1), StudentAttendanceStatus.excused, currentStatus),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String studentName, String label, Color color, StudentAttendanceStatus buttonStatus, StudentAttendanceStatus currentStatus) {
    bool isSelected = currentStatus == buttonStatus;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => context.read<StudentAttendanceCubit>().updateAttendance(studentName, buttonStatus),
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