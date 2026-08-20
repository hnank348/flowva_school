class ConstantApi {
  // static const String url           = "127.0.0.1";
  static const String url              = "192.168.137.125";
  static const String baseUrl          = 'http://$url:8000';
  static const String baseApi          = '$baseUrl/api';
  static const String baseApiV1        = '$baseUrl/api/v1';

  static const String login            = '$baseApi/login';
  static const String logout           = '$baseApi/auth/logout';
  static const String updateUser       = '$baseApi/users';
  static const String timetables       = '$baseApi/timetables';
  static const String section          = '$baseApi/sections';
  static const String getSection       = '$baseApi/counselors/get_sections';
  static const String classes          = '$baseApi/classes';
  static const String subjects         = '$baseApi/subjects';
  static const String students         = '$baseApi/students';
  static const String teachers         = '$baseApi/teachers';
  static const String profile          = '$baseApi/auth/me';
  static const String currentYear      = '$baseApi/academic-years/current';

  static const String semestersCurrent         = '$baseApi/semesters/current';
  static const String studentAttendance        = '$baseApiV1/student-attendance';
  static const String teacherAttendance        = '$baseApiV1/teacher-attendance';
  static const String pointCategories          = '$baseApi/point-categories';
  static const String studentPoints            = '$baseApi/student-points';
  static const String teacherDailyAttendance   = '$baseApiV1/teacher-attendance/daily';
  static const String exams                    = '$baseApi/exams';
  static const String notifications            = '$baseApi/Notifications';
  static const String markAllNotificationsRead = '$notifications/read-all';
  static const String unreadNotifications      = '$notifications/unread';
  static const String unreadNotificationsCount = '$notifications/unread-count';
  static const String currentInspectionProgram = '$baseApi/inspection-programs/counselor/current';
  static const String assignStudentToSection = '$students/assign-student_section';

  static String submitInspectionObservation(int programId) => '$baseApi/inspection-programs/$programId/observation';
  static String sectionAttendance(int sectionId) => '$baseApiV1/sections/$sectionId/attendance';
  static String sectionStudentStats(int sectionId) => '$section/$sectionId/students/stats';
  static String updateInspectionStatus(int programId) => '$baseApi/inspection-programs/$programId/status';

  static String updateStudentAttendance(int attendanceId) => '$baseApiV1/student-attendance/$attendanceId';
  static String transferStudent(int studentId) => '$students/$studentId/transfer';

  static String updateTeacherAttendance(int attendanceId) => '$baseApiV1/teacher-attendance/$attendanceId';

  static String changePassword(int userId) => '$baseApi/users/$userId/change-password';
  static String updateUserAvatar(int userId) => '$baseApi/users/image/$userId';

  static String studentDetails(int studentId) => '$students/$studentId';
  static String studentParents(int studentId) => '$students/$studentId/parents';

  static String studentPointsTotal(int studentId) => '$students/$studentId/points/total';
  static String sectionExams(int sectionId) => '$baseApi/sections/$sectionId/exams';

  static String examById(int examId) => '$baseApi/exams/$examId';
  static String examStatus(int examId) => '$baseApi/exams/$examId/status';

  static String markNotificationRead(int id) => '$notifications/$id/read';
  static String destroyNotification(int id) => '$notifications/$id';

  static String? getImageUrl(String? path) {
    if (path == null) return null;
    final clean = path.trim();
    if (clean.isEmpty || clean.toLowerCase() == 'null') return null;

    if (clean.contains(r':\') || clean.contains(r':/') || clean.contains('AppData') || clean.endsWith('.tmp') || clean.contains('php')) {
      if (clean.contains('.tmp') || clean.contains(r'xampp\tmp')) {
        return null;
      }
    }

    if (clean.startsWith('http://') || clean.startsWith('https://')) {
      try {
        final uri = Uri.parse(clean);
        final pathAndQuery = uri.hasQuery ? '${uri.path}?${uri.query}' : uri.path;
        return '$baseUrl$pathAndQuery';
      } catch (_) {
        return clean
            .replaceAll(RegExp(r'http://[0-9.]+(:\d+)?'), baseUrl)
            .replaceAll(RegExp(r'http://localhost(:\d+)?'), baseUrl);
      }
    }

    String relativePath = clean.startsWith('/') ? clean.substring(1) : clean;

    if (relativePath.startsWith('public/')) {
      relativePath = relativePath.replaceFirst('public/', '');
    }
    if (relativePath.startsWith('storage/')) {
      relativePath = relativePath.replaceFirst('storage/', '');
    }

    return '$baseUrl/storage/$relativePath';
  }
}