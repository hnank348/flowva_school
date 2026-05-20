import 'package:flutter/material.dart';
import 'screens/teacher_dashboard.dart';
import 'theme.dart';

void main() {
  runApp(const SchoolManagementApp());
}

class SchoolManagementApp extends StatelessWidget {
  const SchoolManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام إدارة المدرسة',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const TeacherDashboard(),
    );
  }
}
