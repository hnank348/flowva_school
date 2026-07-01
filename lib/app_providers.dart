import 'package:flowva_school/services/mutual/academic_year_service.dart';
import 'package:flowva_school/services/mutual/semester_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/supervisor/teachers_service.dart';
import 'package:flowva_school/cubit/current_year/current_year_cubit.dart';
import 'package:flowva_school/cubit/supervisor/teachers/teachers_cubit.dart';
import 'package:flowva_school/services/supervisor/classes_service.dart';
import 'package:flowva_school/services/supervisor/schedule_service.dart';
import 'package:flowva_school/services/supervisor/subjects_service.dart';
import 'package:flowva_school/cubit/supervisor/cubit_supervisor/navigation_cubit.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_cubit.dart';
import 'package:flowva_school/cubit/supervisor/schedule/schedule_cubit.dart';
import 'package:flowva_school/cubit/supervisor/subjects/subjects_cubit.dart';
import 'package:flowva_school/cubit/supervisor/state_supervisor/exam_schedule_state.dart';
import 'package:flowva_school/cubit/theme/theme_cubit.dart';
import 'package:flowva_school/services/auth/profile_service.dart';
import 'package:flowva_school/cubit/profile/profile_cubit.dart';
import 'package:flowva_school/services/supervisor/student_attendance_service.dart';
import 'package:flowva_school/cubit/supervisor/cubit_supervisor/student_attendance_cubit.dart';
import 'package:flowva_school/services/supervisor/submit_attendance_service.dart';
import 'package:flowva_school/cubit/supervisor/submit/submit_attendance_cubit.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_cubit.dart';


class AppProviders {
  static List<BlocProvider> getProviders(String userToken) {
    final apiService = ApiService();
    apiService.forceUpdateToken(userToken);

    return [
      BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),

      BlocProvider<ClassesCubit>(
        create: (_) => ClassesCubit(
          classesService: ClassesService(apiService),
          userToken:      userToken,
        )..fetchClassesAndSections(),
      ),

      BlocProvider<ScheduleCubit>(
        create: (_) => ScheduleCubit(
          scheduleService: ScheduleService(apiService),
          semesterService: SemesterService(apiService),
          userToken:       userToken,
        ),
      ),

      BlocProvider<SubjectsCubit>(
        create: (_) => SubjectsCubit(
          subjectsService: SubjectsService(apiService),
          userToken:       userToken,
        )..fetchSubjects(),
      ),

      BlocProvider<TeachersCubit>(
        create: (_) => TeachersCubit(
          teachersService: TeachersService(apiService),
          userToken:       userToken,
        )..fetchTeachers(),
      ),

      BlocProvider<StudentAttendanceCubit>(
        create: (_) => StudentAttendanceCubit(
          attendanceService: StudentAttendanceService(apiService),
          userToken:         userToken,
        ),
      ),

      BlocProvider<SubmitAttendanceCubit>(
        create: (_) => SubmitAttendanceCubit(
          SubmitAttendanceService(apiService),
        ),
      ),

      BlocProvider<ExamScheduleCubit>(create: (_) => ExamScheduleCubit()),

      // ✅ ThemeCubit هنا للـ routes اللي تحت AppProviders
      // الـ ThemeCubit الرئيسي في main.dart هو المصدر الحقيقي
      BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),

      BlocProvider<ProfileCubit>(
        create: (_) => ProfileCubit(
          ProfileService(apiService),
        )..fetchUserProfile(token: userToken),
      ),

      BlocProvider<CurrentYearCubit>(
        create: (_) => CurrentYearCubit(
          AcademicYearService(apiService),
        )..fetchCurrentYear(),
      ),

      BlocProvider<CurrentSemesterCubit>(
        create: (_) => CurrentSemesterCubit(
          SemesterService(apiService),
        )..fetchCurrentSemester(),
      ),
    ];
  }
}