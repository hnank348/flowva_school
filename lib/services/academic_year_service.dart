import 'package:dio/dio.dart';
import '../models/academic_year_model.dart';
import 'api_service.dart';
import 'constant_api.dart';

class AcademicYearService {
  final ApiService _apiService;

  AcademicYearService(this._apiService);

  Future<AcademicYearModel> getCurrentYear() async {
    try {
      final response = await _apiService.get(ConstantApi.academic_years);

      if (response.statusCode == 200 && response.data['success'] == true) {
        return AcademicYearModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load current year');
      }
    } catch (e) {
      throw Exception('Error fetching academic year: $e');
    }
  }
}