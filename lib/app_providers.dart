import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Services
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/auth/change_password_service.dart';
import 'package:flowva_school/services/auth/logout_service.dart';
import 'package:flowva_school/services/auth/profile_service.dart';
import 'package:flowva_school/services/mutual/academic_year_service.dart';
import 'package:flowva_school/services/mutual/semester_service.dart';
import 'package:flowva_school/services/supervisor/classes_service.dart';
import 'package:flowva_school/services/supervisor/exam_service.dart';
import 'package:flowva_school/services/supervisor/schedule_service.dart';
import 'package:flowva_school/services/supervisor/student_attendance_service.dart';
import 'package:flowva_school/services/supervisor/submit_attendance_service.dart';
import 'package:flowva_school/services/supervisor/subjects_service.dart';
import 'package:flowva_school/services/supervisor/teacher_attendance_service.dart';
import 'package:flowva_school/services/supervisor/teachers_service.dart';
import 'package:flowva_school/notifications/services/notification_service.dart';

// Cubits
import 'package:flowva_school/cubit/change_password/change_password_cubit.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_cubit.dart';
import 'package:flowva_school/cubit/current_year/current_year_cubit.dart';
import 'package:flowva_school/cubit/logout/logout_cubit.dart';
import 'package:flowva_school/cubit/profile/profile_cubit.dart';
import 'package:flowva_school/cubit/profile/profile_update_cubit.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_cubit.dart';
import 'package:flowva_school/cubit/supervisor/cubit_supervisor/navigation_cubit.dart';
import 'package:flowva_school/cubit/supervisor/exam_schedule/exam_schedule_cubit.dart';
import 'package:flowva_school/cubit/supervisor/exam_schedule/manage_exam_cubit.dart';
import 'package:flowva_school/cubit/supervisor/schedule/schedule_cubit.dart';
import 'package:flowva_school/cubit/supervisor/student/student_attendance_cubit.dart';
import 'package:flowva_school/cubit/supervisor/submit_student/submit_attendance_cubit.dart';
import 'package:flowva_school/cubit/supervisor/submit_teacher/teachers_attendance_cubit.dart';
import 'package:flowva_school/cubit/supervisor/subjects/subjects_cubit.dart';
import 'package:flowva_school/cubit/supervisor/teachers/teachers_cubit.dart';
import 'package:flowva_school/cubit/theme/theme_cubit.dart';
import 'package:flowva_school/notifications/cubit/notifications_cubit.dart';

import 'notifications/cubit/notification_switch_cubit.dart';

class AppProviders {
  static List<BlocProvider> getProviders(String userToken) {
    final apiService = ApiService()..forceUpdateToken(userToken);

    final profileService = ProfileService(apiService);
    final teacherAttendanceService = TeacherAttendanceService(apiService);
    final changePasswordService = ChangePasswordService(apiService);
    final examService = ExamService(apiService);
    final semesterService = SemesterService(apiService);
    final notificationService = NotificationService(apiService);

    return [
      BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),
      BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),

      BlocProvider<ProfileCubit>(
        create: (_) => ProfileCubit(profileService)..fetchUserProfile(token: userToken),
      ),
      BlocProvider<ProfileUpdateCubit>(
        create: (ctx) => ProfileUpdateCubit(profileService, ctx.read<ProfileCubit>()),
      ),
      BlocProvider<ChangePasswordCubit>(
        create: (_) => ChangePasswordCubit(changePasswordService),
      ),
      BlocProvider<LogoutCubit>(
        create: (_) => LogoutCubit(LogoutService(apiService)),
      ),

      BlocProvider<CurrentYearCubit>(
        create: (_) => CurrentYearCubit(AcademicYearService(apiService))..fetchCurrentYear(),
      ),
      BlocProvider<CurrentSemesterCubit>(
        create: (_) => CurrentSemesterCubit(semesterService)..fetchCurrentSemester(),
      ),

      BlocProvider<ClassesCubit>(
        create: (_) => ClassesCubit(
          classesService: ClassesService(apiService),
          userToken: userToken,
        )..fetchClassesAndSections(),
      ),
      BlocProvider<ScheduleCubit>(
        create: (_) => ScheduleCubit(
          scheduleService: ScheduleService(apiService),
          semesterService: semesterService,
          userToken: userToken,
        ),
      ),
      BlocProvider<SubjectsCubit>(
        create: (_) => SubjectsCubit(
          subjectsService: SubjectsService(apiService),
          userToken: userToken,
        )..fetchSubjects(),
      ),
      BlocProvider<TeachersCubit>(
        create: (_) => TeachersCubit(
          teachersService: TeachersService(apiService),
          userToken: userToken,
        )..fetchTeachers(),
      ),

      BlocProvider<StudentAttendanceCubit>(
        create: (_) => StudentAttendanceCubit(
          attendanceService: StudentAttendanceService(apiService),
          userToken: userToken,
        ),
      ),
      BlocProvider<SubmitAttendanceCubit>(
        create: (_) => SubmitAttendanceCubit(SubmitAttendanceService(apiService)),
      ),
      BlocProvider<TeacherAttendanceCubit>(
        create: (_) => TeacherAttendanceCubit(teacherAttendanceService)..fetchTeachers(),
      ),
      BlocProvider<SubmitTeacherAttendanceCubit>(
        create: (_) => SubmitTeacherAttendanceCubit(teacherAttendanceService),
      ),

      BlocProvider<ExamScheduleCubit>(
        create: (_) => ExamScheduleCubit(examService),
      ),
      BlocProvider<ManageExamCubit>(
        create: (_) => ManageExamCubit(examService),
      ),

      BlocProvider<NotificationsCubit>(
        create: (_) => NotificationsCubit(notificationService)..loadNotifications(),
      ),

      BlocProvider<NotificationSwitchCubit>(
        create: (_) => NotificationSwitchCubit(),
      ),
    ];
  }
}