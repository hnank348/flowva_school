<<<<<<< HEAD

import 'package:flowva_school/feature/parent/children_dashboard/screens/parent_main_layout.dart';
import 'package:flowva_school/view/splash/splach_view.dart';
import 'package:flowva_school/view/teacher/teacher_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_providers.dart'; 
import 'view/supervisor/main_layout_view.dart';
=======
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import 'package:flowva_school/view/auth/splash/splach_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/theme/theme_cubit.dart';
import 'package:flowva_school/cubit/theme/theme_state.dart';
import 'package:flowva_school/cubit/login/login_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'notifications/services/local_notification_service.dart';
import 'notifications/services/push_notifications_service.dart';
>>>>>>> 1b465efd2918a95bb900fa00348a56898b6b9f0d
import 'theme.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< HEAD
  await initializeDateFormatting('ar', null);

  runApp(const SchoolManagementApp());
}class SchoolManagementApp extends StatelessWidget {
  const SchoolManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام إدارة المدرسة',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: MultiBlocProvider(
        providers: AppProviders.providers,
        // child: const MainLayoutView(),
        child: const ParentMainLayout(),
=======

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final localeCubit = LocaleCubit();
  await localeCubit.init();
  await Future.wait([
    PushNotificationsService.init(),
    LocalNotificationService.init()]);

  runApp(SchoolManagementApp(localeCubit: localeCubit));
}

class SchoolManagementApp extends StatelessWidget {
  final LocaleCubit localeCubit;

  const SchoolManagementApp({super.key, required this.localeCubit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<LoginCubit>(
          create: (_) => LoginCubit(),
        ),
        BlocProvider<LocaleCubit>.value(
          value: localeCubit,
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final isDark = themeState is DarkModeState;

          return BlocBuilder<LocaleCubit, LocaleState>(
            buildWhen: (prev, curr) =>
            prev.currentLanguage != curr.currentLanguage,
            builder: (context, localeState) {
              return MaterialApp(
                title: 'Flowva School Management',
                debugShowCheckedModeBanner: false,
                themeMode: isDark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                builder: (context, child) => Directionality(
                  textDirection: localeState.textDirection,
                  child: child!,
                ),
                home: const SplashScreen(),
              );
            },
          );
        },
>>>>>>> 1b465efd2918a95bb900fa00348a56898b6b9f0d
      ),
    );
  }
}