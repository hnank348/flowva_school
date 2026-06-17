import 'package:dio/dio.dart';
import 'package:flowva_school/services/api_service.dart';

import '../models/user_model.dart';
import 'constant_api.dart'; // تأكد من مسار الـ ApiService الخاص بك

class ProfileService {
  final ApiService _apiService;

  ProfileService(this._apiService);

  Future<UserModel> getUserProfile({String? token}) async {
    try {
      Options? options;
      if (token != null) {
        options = Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
      }

      final response = await _apiService.get(
        ConstantApi.profile,
        options: options,
      );

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