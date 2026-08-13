import '../../models/supervisor/class_details_model.dart';
import '../api_service.dart';
import '../constant_api.dart';

class ClassesService {
  final ApiService _apiService;

  ClassesService(this._apiService);

  Future<ClassDetailsModel> getClassesDetails({
    required int academicYearId,
    required String token,
    required String Function(String key) tr,
  }) async {
    try {
      final response = await _apiService.get(
        ConstantApi.getSection,
        data: {
          'academic_year_id': academicYearId,
        },
        tr: tr,
      );

      final data = response.data;

      final isSuccessStatus =
          response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus &&
          data != null &&
          data is Map &&
          data['success'] == true &&
          data['data'] != null &&
          data['data'] is List) {
        return ClassDetailsModel.fromSectionsList(data['data']);
      } else {
        final errorMsg = (data is Map ? data['message'] : null) ??
            tr('classes_fetch_details_failed');
        throw Exception(errorMsg);
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}