import 'package:flowva_school/services/academic_year_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/supervisor/teachers_service.dart';
import 'cubit/current_year/current_year_cubit.dart';
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
import 'package:flowva_school/services/auth/profile_service.dart';
import 'package:flowva_school/cubit/profile/profile_cubit.dart';

class AppProviders {
  static List<BlocProvider> getProviders(String userToken) {
    final apiService = ApiService();

    apiService.forceUpdateToken(userToken);

    return [
      BlocProvider<NavigationCubit>(create: (context) => NavigationCubit()),

      BlocProvider<ClassesCubit>(
        create: (context) => ClassesCubit(
          classesService: ClassesService(apiService),
          userToken: userToken,
        )..fetchClassesAndSections(),
      ),

      BlocProvider<ScheduleCubit>(
        create: (context) => ScheduleCubit(
          scheduleService: ScheduleService(apiService),
          userToken: userToken,
        ),
      ),

      BlocProvider<SubjectsCubit>(
        create: (context) => SubjectsCubit(
          subjectsService: SubjectsService(apiService),
          userToken: userToken,
        )..fetchSubjects(),
      ),

      BlocProvider<TeachersCubit>(
        create: (context) => TeachersCubit(
          teachersService: TeachersService(apiService),
          userToken: userToken,
        )..fetchTeachers(),
      ),

      BlocProvider<ExamScheduleCubit>(create: (context) => ExamScheduleCubit()),

      BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),

      BlocProvider<ProfileCubit>(
        create: (context) => ProfileCubit(
          ProfileService(apiService),
        )..fetchUserProfile(token: userToken),
      ),

      BlocProvider<CurrentYearCubit>(
        create: (context) => CurrentYearCubit(
          AcademicYearService(apiService),
        )..fetchCurrentYear(),
      ),
    ];
  }
}