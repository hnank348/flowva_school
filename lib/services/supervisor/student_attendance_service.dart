import 'package:dio/dio.dart';
import 'package:flowva_school/models/supervisor/student_attendance_model.dart';
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';

class StudentAttendanceService {
  final ApiService _apiService;

  StudentAttendanceService(this._apiService);

  /// جلب طلاب شعبة معينة من السيرفر
  Future<List<StudentAttendanceModel>> getStudentsBySection({
    required int sectionId,
    required String token,
  }) async {
    try {
      final response = await _apiService.get(
        '${ConstantApi.section}/$sectionId/students',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('🌐 [StudentAttendanceService] Response Data: ${response.data}');
      print('📊 [StudentAttendanceService] Status Code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> rawList = response.data['data'];
        return rawList
            .map((json) => StudentAttendanceModel.fromJson(json))
            .toList();
      }

      throw Exception(
        response.data['message'] ?? 'فشل جلب قائمة الطلاب من السيرفر',
      );
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}