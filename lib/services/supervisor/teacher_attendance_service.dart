import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';
import 'package:flowva_school/models/supervisor/teacher_attendance_model.dart';

class TeacherAttendanceService {
  final ApiService _apiService;

  TeacherAttendanceService(this._apiService);

  /// جلب كل المعلمين
  Future<List<TeacherModel>> getTeachers() async {
    try {
      final response = await _apiService.get(ConstantApi.teachers);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> raw = response.data['data'];
        return raw.map((json) => TeacherModel.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'فشل جلب المعلمين');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// تسجيل حضور معلم واحد
  Future<void> submitOne(TeacherAttendanceRequest request) async {
    try {
      final response = await _apiService.post(
        ConstantApi.teacherAttendance,
        data: request.toJson(),
      );

      print('🌐 [TeacherAttendanceService] Response: ${response.data}');
      print('📊 [TeacherAttendanceService] Status: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) return;

      throw Exception(response.data['message'] ?? 'فشل تسجيل الحضور');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// تسجيل حضور كل المعلمين دفعة واحدة
  Future<void> submitAll({
    required List<TeacherModel> teachers,
    required Map<int, int> statusMap, // teacherId → statusId
    required String date,
    required String checkInTime,
  }) async {
    for (final teacher in teachers) {
      final statusId = statusMap[teacher.id] ?? 1;
      await submitOne(
        TeacherAttendanceRequest(
          teacherId:   teacher.id,
          statusId:    statusId,
          date:        date,
          checkInTime: checkInTime,
          lateMinutes: statusId == 3 ? 0 : null, // تأخير
        ),
      );
    }
  }
}