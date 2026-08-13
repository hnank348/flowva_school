import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as context;
import '../../models/mutual/academic_year_model.dart';
import '../api_service.dart';
import '../constant_api.dart';

class AcademicYearService {
  final ApiService _apiService;

  AcademicYearService(this._apiService);

  Future<AcademicYearModel> getCurrentYear({
    required String Function(String key) tr,
  }) async {
    try {
      final response = await _apiService.get(ConstantApi.currentYear,tr: context.tr,);

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null && response.data is Map && response.data['success'] == true) {
        return AcademicYearModel.fromJson(response.data['data']);
      } else {
        final errorMsg = (response.data is Map ? response.data['message'] : null) ??
            tr('academic_year_load_failed');
        throw Exception(errorMsg);
      }
    } catch (e) {
      final rawError = e.toString().replaceAll('Exception: ', '');
      throw Exception(tr('academic_year_fetch_error').replaceAll('{error}', rawError));
    }
  }
}