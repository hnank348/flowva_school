import 'package:flutter/material.dart';

class TeachersAttendanceView extends StatelessWidget {
  const TeachersAttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('حضور وغياب المعلمين', style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E293B),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 700 ? 2 : 1;
          double aspectRatio = constraints.maxWidth > 700 ? 3.6 : 4.6;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: aspectRatio,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 6, // عدد تجريبي للمعلمين
            itemBuilder: (context, index) {
              return _buildTeacherCard('الأستاذ / المعلم رقم ${index + 1}', index % 2 == 0);
            },
          );
        },
      ),
    );
  }

  Widget _buildTeacherCard(String name, bool isPresent) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.grey.withOpacity(0.12))),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // حالة الحضور كـ Badge عصري
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isPresent ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isPresent ? 'حاضر' : 'غائب',
                style: TextStyle(color: isPresent ? Colors.green : Colors.red, fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            // تفاصيل اسم المعلم ووقت البصمة أو الحضور
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name, style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 2),
                Text(isPresent ? 'وقت الحضور: 07:45 ص' : 'لم يسجل دخول', style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.08),
              radius: 20,
              child: const Icon(Icons.badge_rounded, color: Color(0xFF1E3A8A), size: 20),
            ),
          ],
        ),
      ),
    );
  }
}