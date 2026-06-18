import 'package:dio/dio.dart';
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
  }) async {
    try {
      // 🚀 تم تمرير الـ token هنا كمتغير مباشر
      final response = await _apiService.get(
        '${ConstantApi.timetable}/$sectionId/timetable',
        queryParameters: {'semester_id': semesterId},
      );

      print('🌐 [ScheduleService - Fetch] Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
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
      throw Exception(response.data['message'] ?? 'فشل جلب الجدول');
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

      // 🚀 تم تمرير الـ token هنا كمتغير مباشر في الـ POST
      final response = await _apiService.post(
        ConstantApi.timetables,
        data: requestData,
      );

      print('🌐 [ScheduleService - Create] Response Data: ${response.data}');
      print('📊 [ScheduleService - Create] Status Code: ${response.statusCode}');

      if ((response.statusCode == 201 || response.statusCode == 200) && response.data['success'] == true) {
        return ScheduleSessionModel.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'فشل إنشاء الحصة');
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}