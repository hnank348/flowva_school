import 'package:flowva_school/view/splash/splach_view.dart';
import 'package:flowva_school/view/teacher/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flowva_school/cubit/theme/theme_cubit.dart';
import 'package:flowva_school/cubit/theme/theme_state.dart';

import 'app_providers.dart';
import 'view/supervisor/main_layout_view.dart';
import 'theme.dart';

void main() => runApp(const SchoolManagementApp());

class SchoolManagementApp extends StatelessWidget {
  const SchoolManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final isDark = state is DarkModeState;

          return MaterialApp(
            title: 'نظام إدارة المدرسة',
            debugShowCheckedModeBanner: false,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: const MainLayoutView(),
          );
        },
      ),
    );
  }
}