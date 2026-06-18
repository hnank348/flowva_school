import 'package:dio/dio.dart';
import '../../models/supervisor/class_details_model.dart';
import '../api_service.dart';
import '../constant_api.dart';

class ClassesService {
  final ApiService _apiService;

  ClassesService(this._apiService);

  Future<ClassDetailsModel> getClassesDetails({
    required int classId,
    required String token,
  }) async {
    try {
      // 🚀 تم تمرير الـ token كمتغير مباشر لـ ApiService ليحقنه بالـ Headers
      final response = await _apiService.get(
        '${ConstantApi.classes}/$classId',
      );

      final data = response.data;

      print('🌐 [ClassesService] Response Data: $data');
      print('📊 [ClassesService] Status Code: ${response.statusCode}');

      if (data != null && data['success'] == true && data['data'] != null) {
        return ClassDetailsModel.fromJson(data['data']);
      } else {
        throw Exception(data['message'] ?? "فشل في جلب بيانات الصفوف من السيرفر");
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}