import 'package:flowva_school/services/supervisor/teachers_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/services/api_service.dart';
import 'cubit/supervisor/teachers/teachers_cubit.dart';
import 'services/supervisor/classes_service.dart';
import 'services/supervisor/schedule_service.dart';
import 'services/supervisor/subjects_service.dart';
import 'cubit/supervisor/cubit_supervisor/navigation_cubit.dart';
import 'cubit/supervisor/classes/classes_cubit.dart';
import 'cubit/supervisor/schedule/schedule_cubit.dart';
import 'cubit/supervisor/subjects/subjects_cubit.dart';
import 'cubit/supervisor/state_supervisor/exam_schedule_state.dart';
import 'package:flowva_school/cubit/theme/theme_cubit.dart';

import 'package:flowva_school/services/profile_service.dart';
import 'package:flowva_school/cubit/profile/profile_cubit.dart';

class AppProviders {
  static const String actualUserToken = "9|LsW0YoySPyLjaclO8teVphskYEeUfjiirPIOb6wK5acdc60e";

  static List<BlocProvider> get providers => [
    BlocProvider<NavigationCubit>(create: (context) => NavigationCubit()),

    BlocProvider<ClassesCubit>(
      create: (context) => ClassesCubit(
        classesService: ClassesService(ApiService()),
        userToken: actualUserToken,
      )..fetchClassesAndSections(),
    ),

    BlocProvider<ScheduleCubit>(
      create: (context) => ScheduleCubit(
        scheduleService: ScheduleService(ApiService()),
        userToken: actualUserToken,
      ),
    ),

    BlocProvider<SubjectsCubit>(
      create: (context) => SubjectsCubit(
        subjectsService: SubjectsService(ApiService()),
        userToken: actualUserToken,
      )..fetchSubjects(),
    ),

    BlocProvider<TeachersCubit>(
      create: (context) => TeachersCubit(
        teachersService: TeachersService(ApiService()),
        userToken: actualUserToken,
      )..fetchTeachers(),
    ),

    BlocProvider<ExamScheduleCubit>(create: (context) => ExamScheduleCubit()),

    BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),

    BlocProvider<ProfileCubit>(
      create: (context) => ProfileCubit(
        ProfileService(ApiService()),
      )..fetchUserProfile(token: actualUserToken),
    ),
  ];
}