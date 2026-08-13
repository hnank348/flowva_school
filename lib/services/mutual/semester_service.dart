import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as context;
import '../../models/mutual/semester_model.dart';
import '../api_service.dart';
import '../constant_api.dart';

class SemesterService {
  final ApiService _apiService;

  SemesterService(this._apiService);

  Future<SemesterModel> getCurrentSemester({
    required String Function(String key) tr,
  }) async {
    try {
      final response = await _apiService.get(ConstantApi.semestersCurrent,tr: context.tr,);

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        return SemesterModel.fromJson(response.data['data']);
      } else {
        final errorMsg = (response.data is Map ? response.data['message'] : null) ??
            tr('semester_load_failed');
        throw Exception(errorMsg);
      }
    } catch (e) {
      final rawError = e.toString().replaceAll('Exception: ', '');
      throw Exception(tr('semester_fetch_error').replaceAll('{error}', rawError));
    }
  }
}