import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';
import 'package:flowva_school/models/supervisor/teacher_attendance_model.dart';
import 'package:flowva_school/models/supervisor/teacher_attendance_record_model.dart';

class TeacherAttendanceService {
  final ApiService _apiService;

  TeacherAttendanceService(this._apiService);

  Future<List<TeacherModel>> getTeachers({
    required String Function(String key) tr,
  }) async {
    try {
      final response = await _apiService.get(ConstantApi.teachers,tr: context.tr,);

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        final List<dynamic> raw = response.data['data'] ?? [];
        return raw.map((json) => TeacherModel.fromJson(json)).toList();
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ??
          tr('teacher_attendance_fetch_teachers_failed');
      throw Exception(errorMsg);
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
        tr: context.tr,
      );

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
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
    required String Function(String key) tr,
    String? notes,
  }) async {
    try {
      final response = await _apiService.put(
        ConstantApi.updateTeacherAttendance(attendanceId),
        data: {
          'status_id': statusId,
          if (notes != null) 'notes': notes,
        },
        tr: context.tr,
      );

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus) return;

      final errorMsg = (response.data is Map ? response.data['message'] : null) ??
          tr('teacher_attendance_update_record_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> submitOne({
    required TeacherAttendanceRequest request,
    required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
  }) async {
    try {
      final response = await _apiService.post(
        ConstantApi.teacherAttendance,
        data: request.toJson(),
        tr: context.tr,
      );

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus) return;

      final errorMsg = (response.data is Map ? response.data['message'] : null) ??
          tr('teacher_attendance_submit_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> submitAll({
    required List<TeacherModel> teachers,
    required Map<int, int> statusMap, // teacherId → statusId
    required String date,
    required String checkInTime,
    required String Function(String key) tr, // 🟢 إجباري ليمرر لـ submitOne
    Map<int, String?> notesMap = const {},
  }) async {
    for (final teacher in teachers) {
      final statusId = statusMap[teacher.id] ?? 1;
      await submitOne(
        request: TeacherAttendanceRequest(
          teacherId:   teacher.id,
          statusId:    statusId,
          date:        date,
          checkInTime: checkInTime,
          lateMinutes: statusId == 3 ? 0 : null,
          notes:       notesMap[teacher.id],
        ),
        tr: tr,
      );
    }
  }
}