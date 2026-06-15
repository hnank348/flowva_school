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

    return BlocProvider(
      create: (context) => StudentAttendanceCubit(),
      child: BlocBuilder<StudentAttendanceCubit, StudentAttendanceState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            // --- AppBar متدرج متناسق تماماً مع الواجهة الرئيسية ---
            appBar: AppBar(
              title: const Text(
                'حضور وغياب الطلاب',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent, // جعل الخلفية شفافة ليظهر التدرج
              elevation: 0,
              foregroundColor: Colors.white,
              // ضبط ألوان شريط النظام العلوي ليطابق التدرج
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              ),
              // سهم العودة الأبيض المتناسق
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
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // --- شريط اختيار الصفوف التفاعلي المرن ---
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
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF319795) : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: isSelected ? Colors.transparent : const Color(0xFFE2E8F0)),
                                boxShadow: isSelected
                                    ? [BoxShadow(color: const Color(0xFF319795).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  className,
                                  style: TextStyle(
                                      color: isSelected ? Colors.white : const Color(0xFF475569),
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

                  // --- شبكة الحضور الحركية المتجاوبة (Responsive Grid) ---
                  Expanded(
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
                                          backgroundColor: const Color(0xFF234E52).withOpacity(0.1),
                                          radius: 18,
                                          child: const Icon(Icons.person, color: Color(0xFF234E52), size: 20),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            studentName,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1E293B)),
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
                                              _buildStatusChip(context, studentName, 'حاضر', Colors.green, StudentAttendanceStatus.present, currentStatus),
                                              const SizedBox(width: 6),
                                              _buildStatusChip(context, studentName, 'غائب', Colors.red, StudentAttendanceStatus.absent, currentStatus),
                                              const SizedBox(width: 6),
                                              _buildStatusChip(context, studentName, 'تأخير', Colors.orange, StudentAttendanceStatus.late, currentStatus),
                                              const SizedBox(width: 6),
                                              _buildStatusChip(context, studentName, 'إذن للغياب', Colors.purple, StudentAttendanceStatus.excused, currentStatus),
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
    return InkWell(
      onTap: () => context.read<StudentAttendanceCubit>().updateAttendance(studentName, buttonStatus),
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
                fontWeight: FontWeight.w600,
                fontSize: 11,
                fontFamily: 'Cairo'),
          ),
        ),
      ),
    );
  }
}