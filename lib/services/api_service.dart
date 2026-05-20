import 'dart:developer';
import 'package:dio/dio.dart';
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

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      log('🔍 GET Request to: $path | Params: $queryParameters');
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> post(String path, {Object? data}) async {
    try {
      log('🚀 POST Request to: $path');
      final response = await _dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> put(String path, {Object? data}) async {
    try {
      log('🔄 PUT Request to: $path');
      final response = await _dio.put(path, data: data);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> patch(String path, {Object? data}) async {
    try {
      log('🛠️ PATCH Request to: $path');
      final response = await _dio.patch(path, data: data);
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  Future<Response> delete(String path, {Object? data}) async {
    try {
      log('🗑️ DELETE Request to: $path');
      final response = await _dio.post(path, data: data); //
      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  void _handleError(DioException e) {
    log('❌ [ApiService Error]');
    if (e.type == DioExceptionType.connectionTimeout) {
      log('⏳ Timeout: تحقق من اتصالك بالسيرفر');
    } else if (e.response != null) {
      log('🚩 Status: ${e.response?.statusCode}');
      log('📄 Data: ${e.response?.data}');
    } else {
      log('⚠️ Message: ${e.message}');
    }
  }
}