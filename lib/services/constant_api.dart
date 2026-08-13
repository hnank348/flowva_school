class ConstantApi {
  //static const String url              = "127.0.0.1";
  static const String url              = "192.168.10.210";
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

  // 🔴 إضافة رابط تعديل الصورة منفصلاً
  static String updateUserAvatar(int userId) => '$baseApi/users/image/$userId';

  static String sectionExams(int sectionId) => '$baseApi/sections/$sectionId/exams';
  static const String exams = '$baseApi/exams';
  static String examById(int examId) => '$baseApi/exams/$examId';
  static String examStatus(int examId) => '$baseApi/exams/$examId/status';

  static const String notifications = '$baseApi/Notifications';

  static String markNotificationRead(int id) => '$notifications/$id/read';
  static const String markAllNotificationsRead = '$notifications/read-all';
  static String destroyNotification(int id) => '$notifications/$id';
  static const String unreadNotifications = '$notifications/unread';
  static const String unreadNotificationsCount = '$notifications/unread-count';

  static String? getImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;

    if (path.contains(':\\') || path.contains('AppData') || path.endsWith('.tmp')) {
      return null;
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path.replaceAll(RegExp(r'http://[0-9.]+:8000'), baseUrl)
          .replaceAll(RegExp(r'http://localhost:8000'), baseUrl);
    }

    String cleanPath = path.startsWith('/') ? path.substring(1) : path;
    if (cleanPath.startsWith('public/')) {
      cleanPath = cleanPath.replaceFirst('public/', '');
    }

    return '$baseUrl/storage/$cleanPath';
  }
}