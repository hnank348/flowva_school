class ConstantApi {
  static const String url              = "127.0.0.1";
  //static const String url              = "10.214.248.23";
  static const String baseUrl          = 'http://$url:8000';
  static const String baseApi          = '$baseUrl/api';
  static const String baseApiV1        = '$baseUrl/api/v1';

  static const String login            = '$baseApi/login';
  static const String logout           = '$baseApi/auth/logout';
  static const String updateUser       = '$baseApi/users';
  static const String timetables       = '$baseApi/timetables';
  static const String section          = '$baseApi/sections';
  static const String classes          = '$baseApi/classes';
  static const String subjects         = '$baseApi/subjects';
  static const String teachers         = '$baseApi/teachers';
  static const String profile          = '$baseApi/auth/me';
  static const String currentYear      = '$baseApi/academic-years/current';

  static const String semestersCurrent         = '$baseApi/semesters/current';
  static const String studentAttendance        = '$baseApiV1/student-attendance';
  static const String teacherAttendance        = '$baseApiV1/teacher-attendance';

  static String sectionAttendance(int sectionId) =>
      '$baseApiV1/sections/$sectionId/attendance';

  static String updateStudentAttendance(int attendanceId) =>
      '$baseApiV1/student-attendance/$attendanceId';

  static const String teacherDailyAttendance = '$baseApiV1/teacher-attendance/daily';

  static String updateTeacherAttendance(int attendanceId) =>
      '$baseApiV1/teacher-attendance/$attendanceId';

  static String changePassword(int userId) => '$baseApi/users/$userId/change-password';

}