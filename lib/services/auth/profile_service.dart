import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/models/mutual/user_model.dart';
import 'package:flowva_school/services/constant_api.dart';

class ProfileService {
  final ApiService _apiService;

  ProfileService(this._apiService);

  Future<UserModel> getUserProfile({
    required String Function(String key) tr,
    String? token,
  }) async {
    try {
      final response = await _apiService.get(ConstantApi.profile,tr: context.tr,);

      log('📊 [ProfileService - GetProfile] Status Code: ${response.statusCode}');
      log('🌐 [ProfileService - GetProfile] Response Data: ${response.data}');

      final isSuccessStatus = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccessStatus && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['success'] == true && data['data'] != null) {
          return UserModel.fromJson(data['data'] as Map<String, dynamic>);
        }
        throw Exception(data['message'] ?? tr('profile_read_user_failed'));
      }
      throw Exception(
        tr('profile_server_error').replaceAll('{status}', response.statusCode.toString()),
      );
    } catch (e) {
      log('❌ [ProfileService - GetProfile Error]: $e');
      final rawError = e.toString().replaceAll('Exception: ', '');
      throw Exception(tr('profile_fetch_error').replaceAll('{error}', rawError));
    }
  }

  Future<void> updateUserProfile({
    required int userId,
    required String Function(String key) tr,
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


      if (fields.isNotEmpty) {
        final response = await _apiService.put(
          "${ConstantApi.updateUser}/$userId",
          data: fields,
          tr: context.tr,
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
          tr: context.tr,
        );

        log('📊 [ProfileService - UpdateAvatar] Status Code: ${imageResponse.statusCode}');
        log('🌐 [ProfileService - UpdateAvatar] Response Data: ${imageResponse.data}');

        final isAvatarSuccess = imageResponse.statusCode == 200 || imageResponse.statusCode == 201;

        if (!isAvatarSuccess) {
          final errorMsg = (imageResponse.data is Map ? imageResponse.data['message'] : null) ??
              tr('profile_avatar_upload_failed');
          throw Exception(errorMsg);
        }
      }
    } catch (e) {
      log('❌ [ProfileService - UpdateProfile Error]: $e');
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}