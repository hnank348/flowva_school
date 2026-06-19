import 'package:flowva_school/view/auth/login/login_view.dart';
import 'package:flowva_school/view/splash/splach_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/theme/theme_cubit.dart';
import 'package:flowva_school/cubit/theme/theme_state.dart';
import 'package:flowva_school/cubit/login/login_cubit.dart'; // استيراد الكيوبت الجديد
import 'theme.dart';

void main() => runApp(const SchoolManagementApp());

class SchoolManagementApp extends StatelessWidget {
  const SchoolManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),

        // 💡 حقن الـ LoginCubit هنا لتوفيره لصفحة الـ LoginScreen فور تشغيلها
        BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final isDark = state is DarkModeState;

          return MaterialApp(
            title: 'نظام إدارة المدرسة',
            debugShowCheckedModeBanner: false,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),

            // 🚀 البداية من صفحة تسجيل الدخول، ومنها يتم الانتقال وحقن باقي الـ Providers بالتوكن الديناميكي
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}