import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flowva_school/models/supervisor/exam_model.dart';
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';

import '../../models/supervisor/add_exam_request_model.dart';
import '../../models/supervisor/update_exam_request_model.dart';

class ExamService {
  final ApiService _apiService;

  ExamService(this._apiService);

  Future<List<ExamModel>> getExamsBySection({
    required int sectionId,
    required int semesterId,
    required String Function(String key) tr,
  }) async {
    try {
      final response = await _apiService.get(
        ConstantApi.sectionExams(sectionId),
        data: {'semester_id': semesterId},
        tr: context.tr,
      );

      print('🌐 [GetExamService] Create Response: ${response.data}');
      print('📊 [GetExamService] Status Code: ${response.statusCode}');

      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] == true) {
        final List<dynamic> raw = data['data'] ?? [];
        return raw.map((j) => ExamModel.fromJson(j)).toList();
      }

      final errorMsg = (data is Map ? data['message'] : null) ?? tr('exam_fetch_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> createExam({
    required AddExamRequest request,
    required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
  }) async {
    try {
      final formData = FormData.fromMap(request.toFormMap());

      final response = await _apiService.post(
        ConstantApi.exams,
        data: formData,
        tr: context.tr,
      );

      print('🌐 [CreateExamService] Create Response: ${response.data}');
      print('📊 [CreateExamService] Status Code: ${response.statusCode}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['success'] == true) return;
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ?? tr('exam_create_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<ExamModel> updateExam({
    required int examId,
    required UpdateExamRequest request,
    required String Function(String key) tr,
  }) async {
    try {
      final formData = FormData.fromMap(request.toFormMap());
      final response = await _apiService.put(
        ConstantApi.examById(examId),
        data: formData,
        tr: context.tr,
      );

      print('🌐 [UpdateExamService] Create Response: ${response.data}');
      print('📊 [UpdateExamService] Status Code: ${response.statusCode}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['success'] == true) {
          return ExamModel.fromJson(data['data']);
        }
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ?? tr('exam_update_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> changeExamStatus({
    required int examId,
    required String status,
    required String Function(String key) tr,
  }) async {
    try {
      final formData = FormData.fromMap({'status': status});
      final response = await _apiService.patch(
        ConstantApi.examStatus(examId),
        data: formData,
        tr: context.tr,
      );

      print('🌐 [ChangeExamStatus] Create Response: ${response.data}');
      print('📊 [ChangeExamStatus] Status Code: ${response.statusCode}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['success'] == true) return;
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ?? tr('exam_change_status_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> deleteExam({
    required int examId,
    required String Function(String key) tr,
  }) async {
    try {
      final response = await _apiService.delete(ConstantApi.examById(examId),tr: context.tr,);

      print('🌐 [DeleteExam] Create Response: ${response.data}');
      print('📊 [DeleteExam] Status Code: ${response.statusCode}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['success'] == true) return;
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ?? tr('exam_delete_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}