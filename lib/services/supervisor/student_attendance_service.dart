import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flutter/foundation.dart';
import 'package:flowva_school/models/supervisor/student_attendance_model.dart';
import 'package:flowva_school/models/supervisor/student_attendance_record_model.dart';
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';

import '../../models/supervisor/section_students_stats_model.dart';

class StudentAttendanceService {
  final ApiService _apiService;

  StudentAttendanceService(this._apiService);

  Future<List<StudentAttendanceModel>> getStudentsBySection({
    required int sectionId,
    required String token,
    required String Function(String key) tr,
  }) async {
    try {
      final endpoint = '${ConstantApi.section}/$sectionId/students';
      log('🌐 [GET STUDENTS] Request Endpoint: $endpoint');

      final response = await _apiService.get(
        endpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        tr: context.tr,
      );

      debugPrint('📊 [GET STUDENTS] Status Code: ${response.statusCode}');
      log('📄 [GET STUDENTS] Response Data: ${response.data}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        final List<dynamic> raw = response.data['data'] ?? [];

        // 🟢 طباعة روابط الصور المستلمة من الباك إند
        for (var item in raw) {
          debugPrint('🖼️ [STUDENT PHOTO] ID: ${item['id']} | Name: ${item['first_name']} | Photo URL: ${item['photo']}');
        }

        return raw.map((j) => StudentAttendanceModel.fromJson(j)).toList();
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ??
          tr('student_attendance_fetch_students_failed');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [GET STUDENTS ERROR]: $e');
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<StudentAttendanceRecord>> getAttendanceBySection({
    required int sectionId,
    required String date,
  }) async {
    try {
      final endpoint = ConstantApi.sectionAttendance(sectionId);
      log('🌐 [GET STUDENT ATTENDANCE RECORD] Endpoint: $endpoint | Date: $date');

      final response = await _apiService.get(
        endpoint,
        queryParameters: {'date': date},
        tr: context.tr,
      );

      debugPrint('📊 [GET STUDENT ATTENDANCE RECORD] Status Code: ${response.statusCode}');
      log('📄 [GET STUDENT ATTENDANCE RECORD] Response Data: ${response.data}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        final List<dynamic> raw = response.data['data'] ?? [];

        for (var item in raw) {
          debugPrint('🖼️ [RECORD PHOTO] Student ID: ${item['student_id']} | Photo: ${item['photo'] ?? item['student_photo']}');
        }

        return raw.map((j) => StudentAttendanceRecord.fromJson(j)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ [GET STUDENT ATTENDANCE RECORD ERROR]: $e');
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
      final endpoint = ConstantApi.updateStudentAttendance(attendanceId);
      final body = {
        'status_id': statusId,
        if (notes != null) 'notes': notes,
      };

      log('🔄 [UPDATE STUDENT ATTENDANCE] Endpoint: $endpoint | Body: $body');

      final response = await _apiService.put(
        endpoint,
        data: body,
        tr: context.tr,
      );

      debugPrint('📊 [UPDATE STUDENT ATTENDANCE] Status Code: ${response.statusCode}');
      log('📄 [UPDATE STUDENT ATTENDANCE] Response Data: ${response.data}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus) return;

      final errorMsg = (response.data is Map ? response.data['message'] : null) ??
          tr('student_attendance_update_record_failed');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [UPDATE STUDENT ATTENDANCE ERROR]: $e');
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<SectionStudentsStatsModel> getSectionStudentsStats({
    required int sectionId,
    required String Function(String key) tr,
  }) async {
    try {
      final endpoint = ConstantApi.sectionStudentStats(sectionId);
      log('🌐 [GET SECTION STATS] Endpoint: $endpoint');

      final response = await _apiService.get(
        endpoint,
        tr: tr,
      );

      debugPrint('📊 [GET SECTION STATS] Status Code: ${response.statusCode}');
      log('📄 [GET SECTION STATS] Response Data: ${response.data}');

      final data = response.data;
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data != null &&
          data['success'] == true &&
          data['data'] != null) {
        return SectionStudentsStatsModel.fromJson(data['data']);
      }
      throw Exception(data?['message'] ?? tr('fetch_failed'));
    } catch (e) {
      debugPrint('❌ [GET SECTION STATS ERROR]: $e');
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}