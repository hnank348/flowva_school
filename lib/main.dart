import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import 'package:flowva_school/notifications/services/local_notification_service.dart';
import 'package:flowva_school/notifications/services/push_notifications_service.dart';
import 'package:flowva_school/view/auth/login/login_view.dart';
import 'package:flowva_school/view/teacher/teacher_dashboard.dart';
import 'package:flowva_school/view/supervisor/main_layout_view.dart';
import 'package:flowva_school/app_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/theme/theme_cubit.dart';
import 'package:flowva_school/cubit/theme/theme_state.dart';
import 'package:flowva_school/cubit/login/login_cubit.dart';
import 'package:flowva_school/cubit/supervisor/cubit_supervisor/navigation_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // ── تشغيل الإشعارات ────────────────────────────────────────────────────
    await LocalNotificationService.init();
    await PushNotificationsService.init();
  }

  final localeCubit = LocaleCubit();
  await localeCubit.init();

  // ── اقرأ التوكن المحفوظ من آخر جلسة ──────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  final savedToken = prefs.getString('userToken') ?? '';
  final savedUserType = prefs.getString('userType') ?? '';

  runApp(
    SchoolManagementApp(
      localeCubit: localeCubit,
      savedToken: savedToken,
      savedUserType: savedUserType,
    ),
  );
}

class SchoolManagementApp extends StatelessWidget {
  final LocaleCubit localeCubit;
  final String savedToken;
  final String savedUserType;

  const SchoolManagementApp({
    super.key,
    required this.localeCubit,
    required this.savedToken,
    required this.savedUserType,
  });

  @override
  Widget build(BuildContext context) {
    // ── تحديد الصفحة الأولى ───────────────────────────────────────────────
    Widget homeScreen;

    if (savedToken.isNotEmpty) {
      // المستخدم سجّل دخوله سابقاً — اذهب مباشرة للوحة التحكم
      Widget dashboard;
      if (savedUserType == 'supervisor' || savedUserType == 'admin') {
        dashboard = MainLayoutView(userToken: savedToken);
      } else {
        // teacher أو أي نوع آخر
        dashboard = TeacherDashboard(userToken: savedToken);
      }

      homeScreen = MultiBlocProvider(
        providers: AppProviders.getProviders(savedToken),
        child: dashboard,
      );
    } else {
      // لم يسجّل دخوله — اعرض صفحة Login
      homeScreen = LoginScreen();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<LoginCubit>(create: (_) => LoginCubit()),
        BlocProvider<LocaleCubit>.value(value: localeCubit),
        BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final isDark = themeState is DarkModeState;

          return BlocBuilder<LocaleCubit, LocaleState>(
            buildWhen: (prev, curr) =>
                prev.currentLanguage != curr.currentLanguage,
            builder: (context, localeState) {
              return MaterialApp(
                title: 'Flowva School',
                debugShowCheckedModeBanner: false,
                themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                builder: (context, child) => Directionality(
                  textDirection: localeState.textDirection,
                  child: child!,
                ),
                home: homeScreen,
              );
            },
          );
        },
      ),
    );
  }
}
