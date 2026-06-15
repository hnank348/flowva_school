import 'package:flutter/material.dart';
import 'student_attendance_view.dart';
import 'teachers_attendance_view.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // عنوان القسم العصري مع إشارة ملونة جانبية
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'إدارة الحضور والغياب اليومي',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Cairo'
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF319795),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // الحاوية المستقرة والمحمية من الـ Overflow
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isWideScreen = constraints.maxWidth > 600;

                if (isWideScreen) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildAttendanceCard(
                          context,
                          title: 'حضور وغياب الطلاب',
                          subtitle: 'متابعة وتسجيل غياب الصفوف والشعب الدراسية',
                          icon: Icons.school_rounded,
                          statsText: 'تم تسجيل 24 صف اليوم',
                          progressValue: 0.85,
                          gradientColors: [const Color(0xFF319795), const Color(0xFF4FD1C5)],
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentAttendanceView())),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _buildAttendanceCard(
                          context,
                          title: 'حضور وغياب المعلمين',
                          subtitle: 'متابعة توقيع وحضور الكادر التدريسي والإداري',
                          icon: Icons.badge_rounded,
                          statsText: 'نسبة الحضور الحالية: 94%',
                          progressValue: 0.94,
                          gradientColors: [const Color(0xFF234E52), const Color(0xFF319795)],
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeachersAttendanceView())),
                        ),
                      ),
                    ],
                  );
                } else {
                  return ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildAttendanceCard(
                        context,
                        title: 'حضور وغياب الطلاب',
                        subtitle: 'متابعة وتسجيل غياب الصفوف والشعب الدراسية',
                        icon: Icons.school_rounded,
                        statsText: 'تم تسجيل 24 صف اليوم',
                        progressValue: 0.85,
                        gradientColors: [const Color(0xFF319795), const Color(0xFF4FD1C5)],
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentAttendanceView())),
                      ),
                      const SizedBox(height: 14),
                      _buildAttendanceCard(
                        context,
                        title: 'حضور وغياب المعلمين',
                        subtitle: 'متابعة توقيع وحضور الكادر التدريسي والإداري',
                        icon: Icons.badge_rounded,
                        statsText: 'نسبة الحضور الحالية: 94%',
                        progressValue: 0.94,
                        gradientColors: [const Color(0xFF234E52), const Color(0xFF319795)],
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeachersAttendanceView())),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ميثود بناء الكرت المطور والمحمي بالكامل من التداخل والأخطاء الصفراء
  Widget _buildAttendanceCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required String statsText,
        required double progressValue,
        required List<Color> gradientColors,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: const Color(0xFFE2E8F0), width: 1.2)
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: gradientColors.first.withOpacity(0.04),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // السطر العلوي الأصلي مع تلطيف الخلفية الدائرية للأيقونة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: gradientColors.first.withOpacity(0.6)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B)
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: gradientColors.first.withOpacity(0.08),
                            shape: BoxShape.circle
                        ),
                        child: Icon(icon, color: gradientColors.first, size: 24),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // الوصف التوضيحي
              Text(
                subtitle,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Color(0xFF64748B),
                    height: 1.4
                ),
              ),
              const SizedBox(height: 16),

              Divider(color: Colors.grey.withOpacity(0.1), height: 1),
              const SizedBox(height: 14),

              // الإحصائيات والأرقام التوضيحية
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progressValue * 100).toInt()}%',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: gradientColors.first
                    ),
                  ),
                  Text(
                    statsText,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: Color(0xFF475569),
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // شريط الحضور الملون العريض والمحمي
              Directionality(
                textDirection: TextDirection.rtl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(gradientColors.first),
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}