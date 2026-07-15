import 'package:dio/dio.dart';
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
  }) async {
    try {
      final response = await _apiService.get(
        '${ConstantApi.section}/$sectionId/students',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> raw = response.data['data'];
        return raw.map((j) => StudentAttendanceModel.fromJson(j)).toList();
      }
      throw Exception(response.data['message'] ?? 'فشل جلب الطلاب');
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
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> raw = response.data['data'] ?? [];
        return raw.map((j) => StudentAttendanceRecord.fromJson(j)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// ✅ أضفنا notes
  Future<void> updateAttendanceRecord({
    required int attendanceId,
    required int statusId,
    String? notes, // ✅ جديد
  }) async {
    try {
      final response = await _apiService.put(
        ConstantApi.updateStudentAttendance(attendanceId),
        data: {
          'status_id': statusId,
          if (notes != null) 'notes': notes, // ✅ جديد
        },
      );
      if (response.statusCode == 200) return;
      throw Exception(response.data['message'] ?? 'فشل تعديل الحضور');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}