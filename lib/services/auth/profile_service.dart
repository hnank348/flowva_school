import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/models/mutual/user_model.dart';
import 'package:flowva_school/services/constant_api.dart';

class ProfileService {
  final ApiService _apiService;

  ProfileService(this._apiService);

  Future<UserModel> getUserProfile({String? token}) async {
    try {
      final response = await _apiService.get(ConstantApi.profile);

      log('📊 [ProfileService - GetProfile] Status Code: ${response.statusCode}');
      log('🌐 [ProfileService - GetProfile] Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          return UserModel.fromJson(data['data'] as Map<String, dynamic>);
        }
        throw Exception(data['message'] ?? 'فشل في قراءة بيانات المستخدم');
      }
      throw Exception('فشل في الاتصال بالسيرفر: ${response.statusCode}');
    } catch (e) {
      log('❌ [ProfileService - GetProfile Error]: $e');
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
    String? dateOfBirth,
    File? avatar,
  }) async {
    try {
      final Map<String, dynamic> fields = {};
      if (firstName   != null) fields['first_name']    = firstName;
      if (firstNameAr != null) fields['first_name_ar'] = firstNameAr;
      if (lastName    != null) fields['last_name']     = lastName;
      if (lastNameAr  != null) fields['last_name_ar']  = lastNameAr;
      if (phone       != null) fields['phone']         = phone;
      if (dateOfBirth != null) fields['date_of_birth'] = dateOfBirth;

      // 🔴 1. تحديث النصوص عبر PUT
      if (fields.isNotEmpty) {
        final response = await _apiService.put(
          "${ConstantApi.updateUser}/$userId",
          data: fields,
        );

        log('📊 [ProfileService - UpdateText] Status Code: ${response.statusCode}');
        log('🌐 [ProfileService - UpdateText] Response Data: ${response.data}');
      }

      if (avatar != null) {
        final imageFormData = FormData.fromMap({
          'avatar': await MultipartFile.fromFile(
            avatar.path,
            filename: avatar.path.split('/').last,
          ),
        });

        final imageResponse = await _apiService.post(
          ConstantApi.updateUserAvatar(userId),
          data: imageFormData,
          options: Options(
            contentType: 'multipart/form-data',
          ),
        );

        log('📊 [ProfileService - UpdateAvatar] Status Code: ${imageResponse.statusCode}');
        log('🌐 [ProfileService - UpdateAvatar] Response Data: ${imageResponse.data}');

        if (imageResponse.statusCode != 200 && imageResponse.statusCode != 201) {
          throw Exception(imageResponse.data['message'] ?? 'فشل رفع الصورة الشخصية');
        }
      }
    } catch (e) {
      log('❌ [ProfileService - UpdateProfile Error]: $e');
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}