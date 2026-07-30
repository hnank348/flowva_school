import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';
import 'package:flowva_school/models/supervisor/teacher_attendance_model.dart';
import 'package:flowva_school/models/supervisor/teacher_attendance_record_model.dart';

class TeacherAttendanceService {
  final ApiService _apiService;

  TeacherAttendanceService(this._apiService);

  Future<List<TeacherModel>> getTeachers() async {
    try {
      final response = await _apiService.get(ConstantApi.teachers);

      if (response.statusCode == 200 || response.statusCode == 201 && response.data['success'] == true) {
        final List<dynamic> raw = response.data['data'];
        return raw.map((json) => TeacherModel.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'فشل جلب المعلمين');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<TeacherAttendanceRecord>> getDailyAttendance({
    required String date,
  }) async {
    try {
      final response = await _apiService.get(
        ConstantApi.teacherDailyAttendance,
        queryParameters: {'date': date},
      );

      if (response.statusCode == 200 || response.statusCode == 201 && response.data['success'] == true) {
        final List<dynamic> raw = response.data['data'] ?? [];
        return raw.map((j) => TeacherAttendanceRecord.fromJson(j)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> updateAttendanceRecord({
    required int attendanceId,
    required int statusId,
    String? notes,
  }) async {
    try {
      final response = await _apiService.put(
        ConstantApi.updateTeacherAttendance(attendanceId),
        data: {
          'status_id': statusId,
          if (notes != null) 'notes': notes,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) return;
      throw Exception(response.data['message'] ?? 'فشل تعديل الحضور');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> submitOne(TeacherAttendanceRequest request) async {
    try {
      final response = await _apiService.post(
        ConstantApi.teacherAttendance,
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) return;

      throw Exception(response.data['message'] ?? 'فشل تسجيل الحضور');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> submitAll({
    required List<TeacherModel> teachers,
    required Map<int, int> statusMap, // teacherId → statusId
    required String date,
    required String checkInTime,
    Map<int, String?> notesMap = const {},
  }) async {
    for (final teacher in teachers) {
      final statusId = statusMap[teacher.id] ?? 1;
      await submitOne(
        TeacherAttendanceRequest(
          teacherId:   teacher.id,
          statusId:    statusId,
          date:        date,
          checkInTime: checkInTime,
          lateMinutes: statusId == 3 ? 0 : null,
          notes:       notesMap[teacher.id],
        ),
      );
    }
  }
}