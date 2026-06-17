import 'package:flutter/material.dart';
import 'student_attendance_view.dart';
import 'teachers_attendance_view.dart';

class AttendanceView extends StatelessWidget {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // عنوان القسم العصري مع إشارة ملونة جانبية متوافقة مع الثيم
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'إدارة الحضور والغياب اليومي',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                    fontFamily: 'Cairo'
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
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
                          gradientColors: [colorScheme.primary, colorScheme.primary.withOpacity(0.7)],
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
                          gradientColors: [const Color(0xFF234E52), colorScheme.primary],
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
                        gradientColors: [colorScheme.primary, colorScheme.primary.withOpacity(0.7)],
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
                        gradientColors: [const Color(0xFF234E52), colorScheme.primary],
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

  // ميثود بناء الكرت المطور والمحمي بالكامل ومتوافق مع المودين
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // تحديد لون الأيقونة والخلفية الدائرية حسب الوضع لحماية التباين
    final primaryAccent = isDark ? colorScheme.primary : gradientColors.first;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5), width: 1.2)
      ),
      color: colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: primaryAccent.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: primaryAccent.withOpacity(0.6)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: primaryAccent.withOpacity(isDark ? 0.15 : 0.08),
                            shape: BoxShape.circle
                        ),
                        child: Icon(icon, color: primaryAccent, size: 24),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Text(
                subtitle,
                textAlign: TextAlign.right,
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4
                ),
              ),
              const SizedBox(height: 16),

              Divider(color: colorScheme.outlineVariant.withOpacity(0.3), height: 1),
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progressValue * 100).toInt()}%',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: primaryAccent
                    ),
                  ),
                  Text(
                    statsText,
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Directionality(
                textDirection: TextDirection.rtl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: isDark ? colorScheme.surfaceContainerHigh : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(primaryAccent),
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