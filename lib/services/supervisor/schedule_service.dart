import 'package:dio/dio.dart';

import '../../models/supervisor/schedule_session_model.dart';
import '../api_service.dart';


class ScheduleService {
  final ApiService _apiService = ApiService();

  // 1. رفع حصة جديدة للبرنامج (Create)
  Future<ScheduleSessionModel> createSession(ScheduleSessionModel session, String token) async {
    try {
      final response = await _apiService.post(
        'timetables',
        data: session.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 201 && response.data['success'] == true) {
        return ScheduleSessionModel.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'فشل إنشاء الحصة');
    } catch (e) {
      throw Exception('خطأ أثناء رفع الحصة: $e');
    }
  }

  // 2. جلب كل حصص جدول صف معين (Read)
  Future<List<ScheduleSessionModel>> getTimetableBySection(int sectionId, String token) async {
    try {
      final response = await _apiService.get(
        'timetables', // أو المسار المخصص حسب الـ Index endpoint لديك
        queryParameters: {'section_id': sectionId},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ScheduleSessionModel.fromJson(json)).toList();
      }
      throw Exception(response.data['message'] ?? 'فشل جلب الجدول');
    } catch (e) {
      throw Exception('خطأ أثناء جلب الجدول: $e');
    }
  }

  // 3. تعديل تفاصيل حصة موجودة (Update)
  Future<ScheduleSessionModel> updateSession(int id, ScheduleSessionModel session, String token) async {
    try {
      final response = await _apiService.put(
        'timetables/$id',
        data: session.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return ScheduleSessionModel.fromJson(response.data['data']);
      }
      throw Exception(response.data['message'] ?? 'فشل تعديل الحصة');
    } catch (e) {
      throw Exception('خطأ أثناء تعديل الحصة: $e');
    }
  }

  // 4. حذف حصة من الجدول (Delete)
  Future<void> deleteSession(int id, String token) async {
    try {
      final response = await _apiService.delete(
        'timetables/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'فشل حذف الحصة');
      }
    } catch (e) {
      throw Exception('خطأ أثناء حذف الحصة: $e');
    }
  }
}