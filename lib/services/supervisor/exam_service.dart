import 'package:dio/dio.dart';
import 'package:flowva_school/models/supervisor/exam_model.dart';
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';

import '../../models/supervisor/add_exam_request_model.dart';
import '../../models/supervisor/update_exam_request_model.dart';

class ExamService {
  final ApiService _apiService;

  ExamService(this._apiService);

  /// جلب جدول امتحانات شعبة معينة بفصل دراسي محدد
  /// GET /api/sections/{id}/exams  body: {"semester_id": ..}
  Future<List<ExamModel>> getExamsBySection({
    required int sectionId,
    required int semesterId,
  }) async {
    try {
      final response = await _apiService.get(
        ConstantApi.sectionExams(sectionId),
        data: {'semester_id': semesterId},
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        final List<dynamic> raw = data['data'] ?? [];
        return raw.map((j) => ExamModel.fromJson(j)).toList();
      }

      throw Exception(data['message'] ?? 'فشل جلب جدول الامتحانات');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> createExam(AddExamRequest request) async {
    try {
      final formData = FormData.fromMap(request.toFormMap());

      final response = await _apiService.post(
        ConstantApi.exams,
        data: formData,
      );

      print('🌐 [ExamService] Create Response: ${response.data}');
      print('📊 [ExamService] Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['success'] == true) return;
      }

      throw Exception(response.data['message'] ?? 'فشل إضافة الامتحان');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
  Future<ExamModel> updateExam(int examId, UpdateExamRequest request) async {
    try {
      final formData = FormData.fromMap(request.toFormMap());
      final response = await _apiService.put(
        ConstantApi.examById(examId),
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['success'] == true) {
          return ExamModel.fromJson(data['data']);
        }
      }
      throw Exception(response.data['message'] ?? 'فشل تعديل الامتحان');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// 2. تغيير حالة الامتحان (PATCH /api/exams/{id}/status)
  Future<void> changeExamStatus(int examId, String status) async {
    try {
      final formData = FormData.fromMap({'status': status});
      final response = await _apiService.patch(
        ConstantApi.examStatus(examId),
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['success'] == true) return;
      }
      throw Exception(response.data['message'] ?? 'فشل تغيير حالة الامتحان');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// 3. حذف امتحان (DELETE /api/exams/{id})
  Future<void> deleteExam(int examId) async {
    try {
      final response = await _apiService.delete(ConstantApi.examById(examId));

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['success'] == true) return;
      }
      throw Exception(response.data['message'] ?? 'فشل حذف الامتحان');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}