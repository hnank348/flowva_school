import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import 'package:flowva_school/view/auth/login/login_view.dart';
import 'package:flowva_school/view/splash/splach_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/theme/theme_cubit.dart';
import 'package:flowva_school/cubit/theme/theme_state.dart';
import 'package:flowva_school/cubit/login/login_cubit.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تحميل اللغة المحفوظة قبل runApp
  final localeCubit = LocaleCubit();
  await localeCubit.init();

  runApp(SchoolManagementApp(localeCubit: localeCubit));
}

class SchoolManagementApp extends StatelessWidget {
  final LocaleCubit localeCubit;

  const SchoolManagementApp({super.key, required this.localeCubit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LoginCubit>(create: (_) => LoginCubit()),
        // ✅ نمرر الـ instance المنشأ مسبقاً بدل إنشاء واحد جديد
        BlocProvider<LocaleCubit>.value(value: localeCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final isDark = themeState is DarkModeState;

          return BlocBuilder<LocaleCubit, LocaleState>(
            // نعيد بناء MaterialApp فقط لما تتغير اللغة
            buildWhen: (prev, curr) =>
            prev.currentLanguage != curr.currentLanguage,
            builder: (context, localeState) {
              return MaterialApp(
                title: 'نظام إدارة المدرسة',
                debugShowCheckedModeBanner: false,
                themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                builder: (context, child) => Directionality(
                  textDirection: localeState.textDirection,
                  child: child!,
                ),
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}