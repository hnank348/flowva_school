import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as context;
import '../../models/supervisor/teacher_model.dart';
import '../api_service.dart';
import '../constant_api.dart';

class TeachersService {
  final ApiService _apiService;

  TeachersService(this._apiService);

  Future<List<TeacherModel>> getTeachers({
    required String token,
    required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
  }) async {
    try {
      final response = await _apiService.get(
        ConstantApi.teachers,
        tr: context.tr,
      );

      print('🌐 [TeachersService] Response Data: ${response.data}');
      print('📊 [TeachersService] Status Code: ${response.statusCode}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        final List<dynamic> rawList = response.data['data'] ?? [];

        return rawList.map((json) => TeacherModel.fromJson(json)).toList();
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ??
          tr('teachers_fetch_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}