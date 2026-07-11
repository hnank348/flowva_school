import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/models/teacher/user_model.dart';
import 'package:flowva_school/services/constant_api.dart';

class ProfileService {
  final ApiService _apiService;

  ProfileService(this._apiService);


  Future<UserModel> getUserProfile({String? token}) async {
    try {
      final response = await _apiService.get(ConstantApi.profile);

      print('🌐 [ProfileService] Response Data: ${response.data}');
      print('📊 [ProfileService] Status Code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          return UserModel.fromJson(data['data'] as Map<String, dynamic>);
        }
        throw Exception(data['message'] ?? 'فشل في قراءة بيانات المستخدم');
      }
      throw Exception('فشل في الاتصال بالسيرفر: ${response.statusCode}');
    } catch (e) {
      throw Exception('خطأ أثناء جلب الملف الشخصي: $e');
    }
  }

  Future<void> updateUserProfile({
    required int userId,
    String? firstName,
    String? firstNameAr,
    String? lastName,
    String? lastNameAr,
    String? phone,
    String? dateOfBirth,  // yyyy-MM-dd
    File? avatar,
  }) async {
    try {
      final Map<String, dynamic> fields = {};

      if (firstName    != null) fields['first_name']    = firstName;
      if (firstNameAr  != null) fields['first_name_ar'] = firstNameAr;
      if (lastName     != null) fields['last_name']     = lastName;
      if (lastNameAr   != null) fields['last_name_ar']  = lastNameAr;
      if (phone        != null) fields['phone']         = phone;
      if (dateOfBirth  != null) fields['date_of_birth'] = dateOfBirth;

      if (avatar != null) {
        fields['avatar'] = await MultipartFile.fromFile(
          avatar.path,
          filename: avatar.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(fields);

      final response = await _apiService.put(
        "${ConstantApi.updateUser}/$userId",
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      print('🌐 [ProfileService] Update Response: ${response.data}');
      print('📊 [ProfileService] Status Code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        return;
      }

      throw Exception(
          response.data['message'] ?? 'فشل تحديث الملف الشخصي');
    } catch (e) {
      throw Exception(
          e.toString().replaceAll('Exception: ', ''));
    }
  }
}