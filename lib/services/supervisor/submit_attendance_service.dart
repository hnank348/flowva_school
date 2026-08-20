import 'dart:developer';
import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flutter/foundation.dart';
import 'package:flowva_school/models/supervisor/submit_attendance_model.dart';
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';

class SubmitAttendanceService {
  final ApiService _apiService;

  SubmitAttendanceService(this._apiService);

  Future<SubmitAttendanceResponse> submitOne({
    required SubmitAttendanceRequest request,
    required String Function(String key) tr,
  }) async {
    try {
      log('🚀 [SUBMIT ONE ATTENDANCE] Body: ${request.toJson()}');

      final response = await _apiService.post(
        ConstantApi.studentAttendance,
        data: request.toJson(),
        tr: context.tr,
      );

      debugPrint('📊 [SUBMIT ONE ATTENDANCE] Status Code: ${response.statusCode}');
      log('📄 [SUBMIT ONE ATTENDANCE] Response Data: ${response.data}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map) {
        return SubmitAttendanceResponse.fromJson(
            response.data as Map<String, dynamic>);
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ??
          tr('submit_attendance_failed');
      throw Exception(errorMsg);
    } catch (e) {
      debugPrint('❌ [SUBMIT ONE ATTENDANCE ERROR]: $e');
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<SubmitAttendanceResponse>> submitAll({
    required List<int> studentIds,
    required int sectionId,
    required int academicYearId,
    required int semesterId,
    required Map<String, int> statusMap,
    required String date,
    required String checkInTime,
    required String Function(String key) tr,
    Map<String, String?> notesMap = const {},
  }) async {
    final results = <SubmitAttendanceResponse>[];

    for (final studentId in studentIds) {
      final sid       = studentId.toString();
      final statusId  = statusMap[sid] ?? 1;

      final response = await submitOne(
        request: SubmitAttendanceRequest(
          studentId:      studentId,
          sectionId:      sectionId,
          academicYearId: academicYearId,
          semesterId:     semesterId,
          statusId:       statusId,
          date:           date,
          checkInTime:    checkInTime,
          notes:          notesMap[sid],
        ),
        tr: tr,
      );
      results.add(response);
    }

    return results;
  }
}