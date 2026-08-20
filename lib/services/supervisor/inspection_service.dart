import 'dart:developer';
import 'package:dio/dio.dart';
import '../../models/supervisor/inspection_program_model.dart';
import '../api_service.dart';
import '../constant_api.dart';

class InspectionService {
  final ApiService _apiService;

  InspectionService(this._apiService);

  Future<InspectionProgramModel?> getCurrentInspectionProgram({
    required String Function(String key) tr,
  }) async {
    try {
      final endpoint = ConstantApi.currentInspectionProgram;
      log('➡️ [GET CURRENT INSPECTION] Request to: $endpoint');

      final response = await _apiService.get(endpoint, tr: tr);
      final data = response.data;

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data != null &&
          data['success'] == true) {
        if (data['data'] != null && data['data'] is Map<String, dynamic>) {
          return InspectionProgramModel.fromJson(data['data']);
        }
        return null;
      }
      throw Exception(data?['message'] ?? tr('fetch_failed'));
    } catch (e) {
      log('🚨 [GET CURRENT INSPECTION] Exception: $e');
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> submitObservation({
    required int programId,
    required String objectives,
    required String result,
    required String Function(String key) tr,
  }) async {
    try {
      final endpoint = ConstantApi.submitInspectionObservation(programId);
      final formData = FormData.fromMap({
        'objectives': objectives,
        'result': result,
      });


      final response = await _apiService.post(
        endpoint,
        data: formData,
        tr: tr,
      );

      final data = response.data;
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(data?['message'] ?? tr('submit_failed'));
      }
    } catch (e) {
      log('🚨 [SUBMIT OBSERVATION ERROR]: $e');
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
  Future<void> updateProgramStatus({
    required int programId,
    required String status,
    required String Function(String key) tr,
  }) async {
    try {
      final endpoint = ConstantApi.updateInspectionStatus(programId);
      log('🔄 [UPDATE INSPECTION STATUS] Endpoint: $endpoint | Status: $status');

      final response = await _apiService.patch(
        endpoint,
        data: {'status': status},
        tr: tr,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final msg = (response.data is Map ? response.data['message'] : null) ?? tr('update_status_failed');
        throw Exception(msg);
      }
    } catch (e) {
      log('🚨 [UPDATE INSPECTION STATUS ERROR]: $e');
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}