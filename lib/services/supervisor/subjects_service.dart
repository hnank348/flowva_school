import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as context;
import '../../models/supervisor/subject_model.dart';
import '../api_service.dart';
import '../constant_api.dart';

class SubjectsService {
  final ApiService _apiService;

  SubjectsService(this._apiService);

  Future<List<SubjectModel>> getSubjects({
    required String token,
    required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
  }) async {
    try {
      final response = await _apiService.get(
        ConstantApi.subjects,
        tr: context.tr,
      );

      print('🌐 [SubjectsService] Response Data: ${response.data}');
      print('📊 [SubjectsService] Status Code: ${response.statusCode}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        final List<dynamic> rawList = response.data['data'] ?? [];

        return rawList.map((json) => SubjectModel.fromJson(json)).toList();
      }

      final errorMsg = (response.data is Map ? response.data['message'] : null) ??
          tr('subjects_fetch_failed');
      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}