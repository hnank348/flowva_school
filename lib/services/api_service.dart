import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flowva_school/services/constant_api.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ConstantApi.baseApi,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  ApiService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('userToken') ?? '';
          if (token.isNotEmpty && !options.headers.containsKey('Authorization')) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // 🚀 دالة قسرية لتحديث الـ Headers فوراً في اللحظة الحالية لكسر تأخير الـ Async
  void forceUpdateToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    log('⚡ [ApiService] Forced Token Update: Bearer $token');
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      log('🔍 GET Request to: $path | Headers: ${_dio.options.headers["Authorization"]}');
      final response = await _dio.get(path, queryParameters: queryParameters, options: options);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> post(String path, {Object? data, Options? options}) async {
    try {
      log('🚀 POST Request to: $path');
      final response = await _dio.post(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException e) {
    log('❌ [ApiService Error]');
    if (e.response != null) {
      log('🚩 Status: ${e.response?.statusCode}');
      log('📄 Data: ${e.response?.data}');
    } else {
      log('⚠️ Message: ${e.message}');
    }
  }
}