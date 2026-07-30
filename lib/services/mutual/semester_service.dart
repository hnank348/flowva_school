import 'package:dio/dio.dart';
import '../../models/mutual/semester_model.dart'; // قم بتعديل المسار حسب مشروعك
import '../api_service.dart';
import '../constant_api.dart';

class SemesterService {
  final ApiService _apiService;

  SemesterService(this._apiService);

  Future<SemesterModel> getCurrentSemester() async {
    try {
      final response = await _apiService.get(ConstantApi.semestersCurrent);

      if (response.statusCode == 200 || response.statusCode == 201&& response.data['success'] == true) {
        return SemesterModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load current semester');
      }
    } catch (e) {
      throw Exception('Error fetching current semester: $e');
    }
  }
}