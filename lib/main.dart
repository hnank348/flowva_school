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
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      ),
    );
  }
}