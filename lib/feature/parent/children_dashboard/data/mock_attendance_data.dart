import 'package:flutter/material.dart';
import '../models/child_model.dart';
import '../models/attendance_log_model.dart';

class MockAttendanceData {
  static const List<ChildModel> children = [
    ChildModel(
      id: '1',
      name: 'فهد أحمد محمد',
      grade: 'الصف الثالث الابتدائي - أ',
      attendanceRate: '93.3%',
      gpa: '4.85 / 5',
      totalMaterials: 8,
      currentTerm: 'الفصل الثاني',
      imageUrl: 'https://api.dicebear.com/7.x/adventurer/svg?seed=Fahad',
      isActive: true,
    ),
    ChildModel(
      id: '2',
      name: 'سارة أحمد محمد',
      grade: 'الصف الأول الابتدائي - ب',
      attendanceRate: '98.1%',
      gpa: '4.92 / 5',
      totalMaterials: 6,
      currentTerm: 'الفصل الثاني',
      imageUrl: 'https://api.dicebear.com/7.x/adventurer/svg?seed=Sara',
      isActive: true,
    ),
    ChildModel(
      id: '3',
      name: 'خالد أحمد محمد',
      grade: 'الصف الخامس الابتدائي - ج',
      attendanceRate: '95.0%',
      gpa: '4.70 / 5',
      totalMaterials: 9,
      currentTerm: 'الفصل الثاني',
      imageUrl: 'https://api.dicebear.com/7.x/adventurer/svg?seed=Khaled',
      isActive: true,
    ),
  ];

  static const List<AttendanceLogModel> attendanceLogs = [
    AttendanceLogModel(day: 28, month: 6, year: 2026, dayName: 'الأحد', dateStr: '2026-06-28', status: 'حاضر', time: '7:35 ص', statusColor: Colors.green, icon: Icons.check_circle_rounded),
    AttendanceLogModel(day: 25, month: 6, year: 2026, dayName: 'الخميس', dateStr: '2026-06-25', status: 'حاضر', time: '7:42 ص', statusColor: Colors.green, icon: Icons.check_circle_rounded),
    AttendanceLogModel(day: 24, month: 6, year: 2026, dayName: 'الأربعاء', dateStr: '2026-06-24', status: 'متأخر', time: '8:12 ص', statusColor: Colors.orange, icon: Icons.watch_later_rounded),
    AttendanceLogModel(day: 23, month: 6, year: 2026, dayName: 'الثلاثاء', dateStr: '2026-06-23', status: 'حاضر', time: '7:44 ص', statusColor: Colors.green, icon: Icons.check_circle_rounded),
    AttendanceLogModel(day: 22, month: 6, year: 2026, dayName: 'الإثنين', dateStr: '2026-06-22', status: 'غائب بعذر', time: '--:--', statusColor: Colors.blue, icon: Icons.info_rounded),
    AttendanceLogModel(day: 21, month: 6, year: 2026, dayName: 'الأحد', dateStr: '2026-06-21', status: 'حاضر', time: '7:30 ص', statusColor: Colors.green, icon: Icons.check_circle_rounded),
    AttendanceLogModel(day: 18, month: 6, year: 2026, dayName: 'الخميس', dateStr: '2026-06-18', status: 'غائب', time: '--:--', statusColor: Colors.red, icon: Icons.cancel_rounded),
    AttendanceLogModel(day: 17, month: 6, year: 2026, dayName: 'الأربعاء', dateStr: '2026-06-17', status: 'حاضر', time: '7:40 ص', statusColor: Colors.green, icon: Icons.check_circle_rounded),
    AttendanceLogModel(day: 16, month: 6, year: 2026, dayName: 'الثلاثاء', dateStr: '2026-06-16', status: 'حاضر', time: '7:35 ص', statusColor: Colors.green, icon: Icons.check_circle_rounded),
    AttendanceLogModel(day: 15, month: 6, year: 2026, dayName: 'الإثنين', dateStr: '2026-06-15', status: 'حاضر', time: '7:48 ص', statusColor: Colors.green, icon: Icons.check_circle_rounded),
  ];
}

