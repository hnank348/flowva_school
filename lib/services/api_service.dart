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

  void forceUpdateToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    log('⚡️ [ApiService] Forced Token Update: Bearer $token');
  }

  // ✅ أضفنا "data" اختياري لدعم GET مع body (بعض الـ endpoints تستقبل فلاتر كـ JSON body)
  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Object? data,
        Options? options,
      }) async {
    try {
      log('🔍 GET Request to: $path | Headers: ${_dio.options.headers["Authorization"]}');
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        data: data,
        options: options,
      );
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

  Future<Response> put(String path, {Object? data, Options? options}) async {
    try {
      log('🔄 PUT Request to: $path');
      final response = await _dio.put(path, data: data, options: options);
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

  // أضف هذه الميثودز داخل كلاس ApiService[cite: 14]:

  Future<Response> patch(String path, {Object? data, Options? options}) async {
    try {
      log('🩹 PATCH Request to: $path');
      final response = await _dio.patch(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> delete(String path, {Object? data, Options? options}) async {
    try {
      log('🗑️ DELETE Request to: $path');
      final response = await _dio.delete(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }
}