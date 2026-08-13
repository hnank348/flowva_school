import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flowva_school/models/supervisor/student_attendance_model.dart';
import 'package:flowva_school/models/supervisor/student_attendance_record_model.dart';
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';

class StudentAttendanceService {
  final ApiService _apiService;

  StudentAttendanceService(this._apiService);

  Future<List<StudentAttendanceModel>> getStudentsBySection({
    required int sectionId,
    required String token,
    required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
  }) async {
    try {
      final response = await _apiService.get(
        '${ConstantApi.section}/$sectionId/students',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        tr: context.tr,
      );

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        final List<dynamic> raw = response.data['data'] ?? [];
        return raw.map((j) => StudentAttendanceModel.fromJson(j)).toList();
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ??
          tr('student_attendance_fetch_students_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<StudentAttendanceRecord>> getAttendanceBySection({
    required int sectionId,
    required String date,
  }) async {
    try {
      final response = await _apiService.get(
        ConstantApi.sectionAttendance(sectionId),
        queryParameters: {'date': date},
        tr: context.tr,
      );

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        final List<dynamic> raw = response.data['data'] ?? [];
        return raw.map((j) => StudentAttendanceRecord.fromJson(j)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> updateAttendanceRecord({
    required int attendanceId,
    required int statusId,
    required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
    String? notes,
  }) async {
    try {
      final response = await _apiService.put(

        ConstantApi.updateStudentAttendance(attendanceId),
        data: {
          'status_id': statusId,
          if (notes != null) 'notes': notes,
        },
        tr: context.tr,
      );

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus) return;

      final errorMsg = (response.data is Map ? response.data['message'] : null) ??
          tr('student_attendance_update_record_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}