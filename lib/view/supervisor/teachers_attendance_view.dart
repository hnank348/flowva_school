import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/supervisor/cubit_supervisor/teachers_attendance_cubit.dart';

class TeachersAttendanceView extends StatelessWidget {
  const TeachersAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final bool isTablet = screenWidth > 650;

    return BlocProvider(
      create: (context) => TeachersAttendanceCubit(),
      child: BlocBuilder<TeachersAttendanceCubit, TeachersAttendanceState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            // --- AppBar متدرج متناسق تماماً مع الواجهة الرئيسية ---
            appBar: AppBar(
              title: const Text(
                'حضور وغياب المعلمين',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent, // جعل الخلفية شفافة ليظهر التدرج
              elevation: 0,
              foregroundColor: Colors.white,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              // حقن التدرج اللوني والحواف الدائرية المماثلة للـ MainLayout
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFF319795),
                      Color(0xFF4FD1C5),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 1;
                  double aspectRatio = 2.6;

                  if (constraints.maxWidth > 950) {
                    crossAxisCount = 3;
                    aspectRatio = 2.4;
                  } else if (constraints.maxWidth > 600) {
                    crossAxisCount = 2;
                    aspectRatio = 2.4;
                  }

                  return GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: isTablet ? 24.0 : 16.0, vertical: 12.0),
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
                      final currentStatus = state.attendanceMap[teacherName] ?? TeacherAttendanceStatus.present;

                      return Card(
                        elevation: 2,
                        shadowColor: const Color(0xFF0F172A).withOpacity(0.05),
                        margin: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Color(0xFFF1F5F9))
                        ),
                        color: Colors.white,
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
                                    backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.08),
                                    radius: 18,
                                    child: const Icon(Icons.badge_rounded, color: Color(0xFF1E3A8A), size: 18),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          teacherName,
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E293B)
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          currentStatus == TeacherAttendanceStatus.present
                                              ? 'حضر: 07:45 ص'
                                              : (currentStatus == TeacherAttendanceStatus.absent ? 'لم يسجل دخول' : 'إجازة رسمية مصدقة'),
                                          textAlign: TextAlign.right,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 10, color: Colors.grey),
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
                                  height: 34,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Row(
                                      children: [
                                        _buildTeacherStatusChip(context, teacherName, 'حاضر الآن', Colors.green, TeacherAttendanceStatus.present, currentStatus),
                                        const SizedBox(width: 6),
                                        _buildTeacherStatusChip(context, teacherName, 'غائب', Colors.red, TeacherAttendanceStatus.absent, currentStatus),
                                        const SizedBox(width: 6),
                                        _buildTeacherStatusChip(context, teacherName, 'إجازة رسمية', Colors.blue, TeacherAttendanceStatus.vacation, currentStatus),
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
    return InkWell(
      onTap: () => context.read<TeachersAttendanceCubit>().updateAttendance(teacherName, buttonStatus),
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isSelected ? Colors.transparent : color.withOpacity(0.3)),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withOpacity(0.25), blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontFamily: 'Cairo',
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}