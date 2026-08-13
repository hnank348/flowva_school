import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flowva_school/services/constant_api.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ConstantApi.baseApi,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
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
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {Object? data, Options? options}) async {
    try {
      log('🚀 POST Request to: $path');
      final response = await _dio.post(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(String path, {Object? data, Options? options}) async {
    try {
      log('🔄 PUT Request to: $path');
      final response = await _dio.put(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> patch(String path, {Object? data, Options? options}) async {
    try {
      log('🩹 PATCH Request to: $path');
      final response = await _dio.patch(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path, {Object? data, Options? options}) async {
    try {
      log('🗑️ DELETE Request to: $path');
      final response = await _dio.delete(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 🔴 معالجة واستخراج الرسالة الحقيقية المرجعة من الباك إند
  ApiException _handleError(DioException e) {
    log('❌ [ApiService Error]');
    String serverMessage = 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً';
    int? statusCode;

    if (e.response != null) {
      statusCode = e.response?.statusCode;
      final data = e.response?.data;

      log('🚩 Status: $statusCode');
      log('📄 Data: $data');

      // 🔴 استخراج الرسالة القادمة من الباك إند (Laravel Response)
      if (data is Map<String, dynamic>) {
        if (data.containsKey('message') && data['message'] != null && data['message'].toString().isNotEmpty) {
          serverMessage = data['message'].toString();
        } else if (data.containsKey('error') && data['error'] != null) {
          serverMessage = data['error'].toString();
        } else if (data.containsKey('errors') && data['errors'] is Map) {
          // استخراج أول خطأValidation إذا وُجد
          final errorsMap = data['errors'] as Map;
          if (errorsMap.isNotEmpty) {
            final firstErrorList = errorsMap.values.first;
            if (firstErrorList is List && firstErrorList.isNotEmpty) {
              serverMessage = firstErrorList.first.toString();
            }
          }
        }
      }
    } else {
      log('⚠️ Message: ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        serverMessage = 'انتهت مهلة الاتصال بالسيرفر، تحقق من الشبكة';
      } else if (e.type == DioExceptionType.connectionError) {
        serverMessage = 'تعذر الاتصال بالسيرفر، يرجى التأكد من اتصال الإنترنت';
      }
    }

    return ApiException(serverMessage, statusCode: statusCode);
  }
}