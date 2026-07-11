import 'package:dio/dio.dart';
import 'package:flowva_school/services/constant_api.dart';
import '../api_service.dart';

class LoginService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
      });

      final response = await _apiService.post(ConstantApi.login, data: formData);

      print('🌐 [LoginService] Response Data: ${response.data}');
      print('📊 [LoginService] Status Code: ${response.statusCode}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final innerData = response.data['data'];

        return {
          'success': true,
          'message': response.data['message'] ?? 'Login Successful',
          'token': innerData['token'] ?? '',
          'user_type': innerData['user']?['user_type'] ?? 'admin',
          'data': innerData
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Check your email or password'
        };
      }
    } catch (e) {
      print('❌ [LoginService Exception]: $e');
      return {
        'success': false,
        'message': 'Server is unreachable. Make sure it is running.'
      };
    }
  }
}