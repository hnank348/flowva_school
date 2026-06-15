import 'package:flowva_school/view/splash/splach_view.dart';
import 'package:flowva_school/view/teacher/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_providers.dart'; // استيراد الملف الجديد
import 'view/supervisor/main_layout_view.dart';
import 'theme.dart';

void main() => runApp(const SchoolManagementApp());

class SchoolManagementApp extends StatelessWidget {
  const SchoolManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام إدارة المدرسة',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: MultiBlocProvider(
        providers: AppProviders.providers,
        child: const MainLayoutView(),
      ),
    );
  }
}