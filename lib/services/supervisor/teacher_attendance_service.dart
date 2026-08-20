import 'dart:developer';
import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flutter/foundation.dart';
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
      log('🌐 [GET TEACHERS] Endpoint: ${ConstantApi.teachers}');

      final response = await _apiService.get(
        ConstantApi.teachers,
        tr: context.tr,
      );

      debugPrint('📊 [GET TEACHERS] Status Code: ${response.statusCode}');
      log('📄 [GET TEACHERS] Response Data: ${response.data}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        final List<dynamic> raw = response.data['data'] ?? [];

        // 🟢 طباعة روابط الصور الخاصة بالمعلمين
        for (var item in raw) {
          debugPrint('🖼️ [TEACHER PHOTO] ID: ${item['id']} | Name: ${item['first_name']} | Avatar: ${item['avatar'] ?? item['photo']}');
        }

        return raw.map((json) => TeacherModel.fromJson(json)).toList();
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ??
          tr('teacher_attendance_fetch_teachers_failed');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [GET TEACHERS ERROR]: $e');
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<TeacherAttendanceRecord>> getDailyAttendance({
    required String date,
  }) async {
    try {
      final endpoint = ConstantApi.teacherDailyAttendance;
      log('🌐 [GET TEACHER DAILY ATTENDANCE] Endpoint: $endpoint | Date: $date');

      final response = await _apiService.get(
        endpoint,
        queryParameters: {'date': date},
        tr: context.tr,
      );

      debugPrint('📊 [GET TEACHER DAILY ATTENDANCE] Status Code: ${response.statusCode}');
      log('📄 [GET TEACHER DAILY ATTENDANCE] Response Data: ${response.data}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        final List<dynamic> raw = response.data['data'] ?? [];

        for (var item in raw) {
          debugPrint('🖼️ [TEACHER RECORD PHOTO] Teacher ID: ${item['teacher_id']} | Photo: ${item['avatar'] ?? item['photo']}');
        }

        return raw.map((j) => TeacherAttendanceRecord.fromJson(j)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('❌ [GET TEACHER DAILY ATTENDANCE ERROR]: $e');
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
      final endpoint = ConstantApi.updateTeacherAttendance(attendanceId);
      final body = {
        'status_id': statusId,
        if (notes != null) 'notes': notes,
      };

      log('🔄 [UPDATE TEACHER ATTENDANCE] Endpoint: $endpoint | Body: $body');

      final response = await _apiService.put(
        endpoint,
        data: body,
        tr: context.tr,
      );

      debugPrint('📊 [UPDATE TEACHER ATTENDANCE] Status Code: ${response.statusCode}');
      log('📄 [UPDATE TEACHER ATTENDANCE] Response Data: ${response.data}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus) return;

      final errorMsg = (response.data is Map ? response.data['message'] : null) ??
          tr('teacher_attendance_update_record_failed');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [UPDATE TEACHER ATTENDANCE ERROR]: $e');
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> submitOne({
    required TeacherAttendanceRequest request,
    required String Function(String key) tr,
  }) async {
    try {
      log('🚀 [SUBMIT TEACHER ATTENDANCE] Body: ${request.toJson()}');

      final response = await _apiService.post(
        ConstantApi.teacherAttendance,
        data: request.toJson(),
        tr: context.tr,
      );

      debugPrint('📊 [SUBMIT TEACHER ATTENDANCE] Status Code: ${response.statusCode}');
      log('📄 [SUBMIT TEACHER ATTENDANCE] Response Data: ${response.data}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus) return;

      final errorMsg = (response.data is Map ? response.data['message'] : null) ??
          tr('teacher_attendance_submit_failed');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [SUBMIT TEACHER ATTENDANCE ERROR]: $e');
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> submitAll({
    required List<TeacherModel> teachers,
    required Map<int, int> statusMap,
    required String date,
    required String checkInTime,
    required String Function(String key) tr,
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