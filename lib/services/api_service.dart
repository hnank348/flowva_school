import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
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
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  ApiService() {
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.maxConnectionsPerHost = 5;
      client.idleTimeout = const Duration(seconds: 10);
      client.connectionTimeout = const Duration(seconds: 30);
      client.autoUncompress = true;
      return client;
    };

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
        onError: (DioException error, handler) async {
          final isFormatError = error.error is FormatException ||
              error.message?.contains('Unexpected end of input') == true;

          if (isFormatError) {
            log('🔁 Retry after FormatException: ${error.requestOptions.path}');
            try {
              final retryResponse = await _dio.fetch(error.requestOptions);
              return handler.resolve(retryResponse);
            } catch (e) {
              return handler.next(error);
            }
          }
          return handler.next(error);
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
        required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
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
      throw _handleError(e, tr: tr);
    }
  }

  Future<Response> post(
      String path, {
        required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
        Object? data,
        Options? options,
      }) async {
    try {
      log('🚀 POST Request to: $path');
      final response = await _dio.post(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      throw _handleError(e, tr: tr);
    }
  }

  Future<Response> put(
      String path, {
        required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
        Object? data,
        Options? options,
      }) async {
    try {
      log('🔄 PUT Request to: $path');
      final response = await _dio.put(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      throw _handleError(e, tr: tr);
    }
  }

  Future<Response> patch(
      String path, {
        required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
        Object? data,
        Options? options,
      }) async {
    try {
      log('🩹 PATCH Request to: $path');
      final response = await _dio.patch(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      throw _handleError(e, tr: tr);
    }
  }

  Future<Response> delete(
      String path, {
        required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
        Object? data,
        Options? options,
      }) async {
    try {
      log('🗑️ DELETE Request to: $path');
      final response = await _dio.delete(path, data: data, options: options);
      return response;
    } on DioException catch (e) {
      throw _handleError(e, tr: tr);
    }
  }

  ApiException _handleError(
      DioException e, {
        required String Function(String key) tr, // 🟢 إجباري لتقديم رسالة مترجمة صحيحة
      }) {
    log('❌ [ApiService Error]');
    log('📍 Endpoint Path: ${e.requestOptions.path}');
    log('⚙️ Dio Error Type: ${e.type}');

    String serverMessage = tr('api_unexpected_error');
    int? statusCode;

    if (e.response != null) {
      statusCode = e.response?.statusCode;
      final data = e.response?.data;

      log('🚩 Status Code: $statusCode');
      log('📄 Response Data: $data');

      if (data is Map<String, dynamic>) {
        if (data.containsKey('message') && data['message'] != null && data['message'].toString().isNotEmpty) {
          serverMessage = data['message'].toString();
        } else if (data.containsKey('error') && data['error'] != null) {
          serverMessage = data['error'].toString();
        } else if (data.containsKey('errors') && data['errors'] is Map) {
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
      log('⚠️ Raw Error Exception: ${e.error}');
      log('⚠️ Raw Error Message: ${e.message ?? "No explicit message string provided"}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        serverMessage = tr('api_timeout_error');
      } else if (e.type == DioExceptionType.connectionError) {
        serverMessage = tr('api_connection_error');
      } else if (e.type == DioExceptionType.cancel) {
        serverMessage = tr('api_cancel_error');
      }
    }

    return ApiException(serverMessage, statusCode: statusCode);
  }
}