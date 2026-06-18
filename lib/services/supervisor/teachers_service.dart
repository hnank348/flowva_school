import 'package:dio/dio.dart';
import '../../models/supervisor/teacher_model.dart';
import '../api_service.dart';
import '../constant_api.dart';

class TeachersService {
  final ApiService _apiService;

  TeachersService(this._apiService);

  Future<List<TeacherModel>> getTeachers({required String token}) async {
    try {
      // 🚀 تم تمرير الـ token هنا كمتغير مباشر
      final response = await _apiService.get(
        ConstantApi.teachers,
      );

      print('🌐 [TeachersService] Response Data: ${response.data}');
      print('📊 [TeachersService] Status Code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> rawList = response.data['data'];

        return rawList.map((json) => TeacherModel.fromJson(json)).toList();
      }

      throw Exception(response.data['message'] ?? 'فشل جلب قائمة المعلمين من السيرفر');
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}