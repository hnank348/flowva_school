import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../models/supervisor/point_category_model.dart';
import '../../models/supervisor/student_points_summary_model.dart';
import '../api_service.dart';
import '../constant_api.dart';

class StudentPointsService {
  final ApiService _apiService;

  StudentPointsService(this._apiService);

  Future<List<PointCategoryModel>> getPointCategories({
    required String Function(String key) tr,
  }) async {
    try {
      final endpoint = ConstantApi.pointCategories;
      log('🌐 [GET POINT CATEGORIES] Endpoint: $endpoint');

      final response = await _apiService.get(endpoint, tr: tr);

      debugPrint('📊 [GET POINT CATEGORIES] Status Code: ${response.statusCode}');
      log('📄 [GET POINT CATEGORIES] Response Data: ${response.data}');

      final data = response.data;
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data != null &&
          data['success'] == true &&
          data['data'] is List) {
        return (data['data'] as List)
            .map((e) => PointCategoryModel.fromJson(e))
            .where((cat) => cat.isActive)
            .toList();
      }
      throw Exception(data?['message'] ?? tr('fetch_failed'));
    } catch (e) {
      debugPrint('❌ [GET POINT CATEGORIES ERROR]: $e');
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<StudentPointsSummaryModel> getStudentPointsTotal({
    required int studentId,
    required int semesterId,
    required String Function(String key) tr,
  }) async {
    try {
      final endpoint = ConstantApi.studentPointsTotal(studentId);
      log('🌐 [GET STUDENT POINTS SUMMARY] Endpoint: $endpoint | Semester ID: $semesterId');

      final response = await _apiService.get(
        endpoint,
        queryParameters: {'semester_id': semesterId},
        tr: tr,
      );

      debugPrint('📊 [GET STUDENT POINTS SUMMARY] Status Code: ${response.statusCode}');
      log('📄 [GET STUDENT POINTS SUMMARY] Response Data: ${response.data}');

      final data = response.data;
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data != null &&
          data['success'] == true &&
          data['data'] != null) {
        return StudentPointsSummaryModel.fromJson(data['data']);
      }
      throw Exception(data?['message'] ?? tr('fetch_failed'));
    } catch (e) {
      debugPrint('❌ [GET STUDENT POINTS SUMMARY ERROR]: $e');
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> addStudentPoint({
    required int studentId,
    required int pointCategoryId,
    required int academicYearId,
    required int semesterId,
    required int points,
    required String reason,
    required String date,

    required int inspectionProgramId, // 🟢 إجباري
    String? notes,
    required String Function(String key) tr,
  }) async {
    try {
      final bodyMap = {
        'student_id': studentId,
        'point_category_id': pointCategoryId,
        'academic_year_id': academicYearId,
        'semester_id': semesterId,
        'points': points,
        'reason': reason,
        'date': date,

        'inspection_program_id': inspectionProgramId, // 🟢 إجباري
        if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
      };

      final formData = FormData.fromMap(bodyMap);

      final response = await _apiService.post(
        ConstantApi.studentPoints,
        data: formData,
        tr: tr,
      );

      final data = response.data;
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(data?['message'] ?? tr('submit_failed'));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}