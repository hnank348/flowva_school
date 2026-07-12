class ConstantApi {
  static const String url               = "127.0.0.1";
  static const String baseUrl           = 'http://$url:8000';
  static const String baseApi           = '$baseUrl/api';

  static const String login             = '$baseApi/login';
  static const String logout            = '$baseApi/auth/logout';
  static const String updateUser        = '$baseApi/users';
  static const String timetables        = '$baseApi/timetables';
  static const String section           = '$baseApi/sections';
  static const String classes           = '$baseApi/classes';
  static const String subjects          = '$baseApi/subjects';
  static const String teachers          = '$baseApi/teachers';
  static const String profile           = '$baseApi/auth/me';
  static const String academicYears     = '$baseApi/academic-years/current';
  static const String semestersCurrent  = '$baseApi/semesters/current';
  static const String studentAttendance = '$baseApi/v1/student-attendance';
  static const String teacherAttendance = '$baseApi/v1/teacher-attendance';
}