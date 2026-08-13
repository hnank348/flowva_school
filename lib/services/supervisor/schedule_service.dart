import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flowva_school/services/constant_api.dart';
import '../../models/supervisor/schedule_session_model.dart';
import '../api_service.dart';

class ScheduleService {
  final ApiService _apiService;

  ScheduleService(this._apiService);

  Future<List<ScheduleSessionModel>> getTimetableBySection({
    required int sectionId,
    required String token,
    required int semesterId,
    required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
  }) async {
    try {
      final response = await _apiService.get(
        '${ConstantApi.section}/$sectionId/timetable',
        queryParameters: {'semester_id': semesterId},
        tr: context.tr,
      );

      print('🌐 [ScheduleService - Fetch] Response Data: ${response.data}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        final rawData = response.data['data'];

        if (rawData == null) return [];

        if (rawData is Map<String, dynamic> && rawData.containsKey('day_of_week')) {
          return [ScheduleSessionModel.fromJson(rawData)];
        }

        if (rawData is Map<String, dynamic> && !rawData.containsKey('day_of_week')) {
          List<ScheduleSessionModel> allSessions = [];
          rawData.forEach((day, sessionsList) {
            if (sessionsList is List) {
              for (var jsonSession in sessionsList) {
                allSessions.add(ScheduleSessionModel.fromJson(jsonSession));
              }
            }
          });
          return allSessions;
        }

        if (rawData is List) {
          return rawData.map((json) => ScheduleSessionModel.fromJson(json)).toList();
        }
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ?? tr('schedule_fetch_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<ScheduleSessionModel> createSession({
    required ScheduleSessionModel session,
    required String token,
    required int sectionId,
    required int subjectId,
    required int teacherId,
    required int academicYearId,
    required int semesterId,
    required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
  }) async {
    try {
      final Map<String, dynamic> requestData = session.toJson()
        ..addAll({
          'section_id': sectionId,
          'subject_id': subjectId,
          'teacher_id': teacherId,
          'academic_year_id': academicYearId,
          'semester_id': semesterId,
        });

      final response = await _apiService.post(
        ConstantApi.timetables,
        data: requestData,
        tr: context.tr,
      );

      print('🌐 [ScheduleService - Create] Response Data: ${response.data}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        return ScheduleSessionModel.fromJson(response.data['data']);
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ?? tr('schedule_create_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<ScheduleSessionModel> updateSession({
    required int timetableId,
    required ScheduleSessionModel session,
    required String token,
    required int sectionId,
    required int subjectId,
    required int teacherId,
    required int academicYearId,
    required int semesterId,
    required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
  }) async {
    try {
      final Map<String, dynamic> requestData = session.toJson()
        ..addAll({
          'section_id': sectionId,
          'subject_id': subjectId,
          'teacher_id': teacherId,
          'academic_year_id': academicYearId,
          'semester_id': semesterId,
        });

      final response = await _apiService.put(
        '${ConstantApi.timetables}/$timetableId',
        data: requestData,
        tr: context.tr,
      );

      print('🌐 [ScheduleService - Update] Response Data: ${response.data}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        return ScheduleSessionModel.fromJson(response.data['data']);
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ?? tr('schedule_update_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> deleteSession({
    required int timetableId,
    required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
  }) async {
    try {
      final response = await _apiService.delete(
        '${ConstantApi.timetables}/$timetableId',
        tr: context.tr,
      );

      print('🌐 [ScheduleService - Delete] Status Code: ${response.statusCode}');
      print('🌐 [ScheduleService - Delete] Response Data: ${response.data}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (!isSuccessStatus || response.data == null || response.data is! Map || response.data['success'] != true) {
        final errorMsg = (response.data is Map ? response.data['message'] : null) ?? tr('schedule_delete_failed');
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}