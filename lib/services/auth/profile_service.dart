import 'package:dio/dio.dart';
import 'package:flowva_school/services/api_service.dart';
import '../../models/teacher/user_model.dart';
import '../constant_api.dart';

class ProfileService {
  final ApiService _apiService;

  ProfileService(this._apiService);

  Future<UserModel> getUserProfile({String? token}) async {
    try {
      // 🚀 تم الاستغناء عن تهيئة الـ Options اليدوية وتمرير الـ token لـ ApiService مباشرة
      final response = await _apiService.get(
        ConstantApi.profile,
      );

      print('🌐 [ProfileService] Response Data: ${response.data}');
      print('📊 [ProfileService] Status Code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData['success'] == true && responseData['data'] != null) {
          return UserModel.fromJson(responseData['data'] as Map<String, dynamic>);
        } else {
          throw Exception(responseData['message'] ?? 'فشل في قراءة بيانات المستخدم');
        }
      } else {
        throw Exception('فشل في الاتصال بالسيرفر: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('خطأ أثناء جلب الملف الشخصي: $e');
    }
  }
}