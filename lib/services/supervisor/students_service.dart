import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flowva_school/services/constant_api.dart';
import '../../models/mutual/section_item_model.dart';
import '../../models/supervisor/student_detail_model.dart';
import '../../models/supervisor/student_model.dart';
import '../api_service.dart';

class StudentsService {
  final ApiService _apiService;

  StudentsService(this._apiService);

  Future<List<StudentModel>> getStudents({
    required int semesterId,
    required String Function(String key) tr,
  }) async {
    final endpoint = ConstantApi.students;
    try {
      final formData = FormData.fromMap({
        'semester_id': semesterId,
      });

      log('➡️ [GET STUDENTS] Request to: $endpoint with semester_id: $semesterId');

      final response = await _apiService.get(
        endpoint,
        data: formData,
        tr: tr,
      );

      log('📊 [GET STUDENTS] Status Code: ${response.statusCode}');
      log('📄 [GET STUDENTS] Response Data: ${response.data}');

      final data = response.data;
      final isSuccess = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccess && data != null && data['success'] == true && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => StudentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        final errorMsg = (data is Map ? data['message'] : null) ?? tr('students_fetch_failed');
        log('❌ [GET STUDENTS] Logical Error: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      log('🚨 [GET STUDENTS] Exception: $e\n$stackTrace');
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<StudentDetailModel> getStudentDetails({
    required int studentId,
    required String Function(String key) tr,
  }) async {
    final endpoint = ConstantApi.studentDetails(studentId);
    try {
      log('➡️ [STUDENT DETAILS] Request to: $endpoint');

      final response = await _apiService.get(
        endpoint,
        tr: tr,
      );

      log('📊 [STUDENT DETAILS] Status Code: ${response.statusCode}');
      log('📄 [STUDENT DETAILS] Response Data: ${response.data}');

      final data = response.data;
      final isSuccess = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccess && data != null && data['success'] == true && data['data'] != null) {
        log('👨‍👩‍👧 [STUDENT DETAILS] Raw Parents in details: ${data['data']['parents']}');
        return StudentDetailModel.fromJson(data['data']);
      } else {
        final errorMsg = (data is Map ? data['message'] : null) ?? tr('students_fetch_failed');
        log('❌ [STUDENT DETAILS] Logical Error: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      log('🚨 [STUDENT DETAILS] Exception: $e\n$stackTrace');
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<List<ParentModel>> getStudentParents({
    required int studentId,
    required String Function(String key) tr,
  }) async {
    final endpoint = ConstantApi.studentParents(studentId);
    try {
      log('➡️ [STUDENT PARENTS] Request to: $endpoint');

      final response = await _apiService.get(
        endpoint,
        tr: tr,
      );

      log('📊 [STUDENT PARENTS] Status Code: ${response.statusCode}');
      log('📄 [STUDENT PARENTS] Response Data: ${response.data}');

      final data = response.data;
      final isSuccess = response.statusCode == 200 || response.statusCode == 201;

      if (isSuccess && data != null && data['success'] == true) {
        dynamic parentsList;

        if (data['data'] is Map && data['data']['parents'] is List) {
          parentsList = data['data']['parents'];
        } else if (data['data'] is List) {
          parentsList = data['data'];
        }

        if (parentsList != null && parentsList is List) {
          log('✅ [STUDENT PARENTS] Parents count: ${parentsList.length}');
          return parentsList
              .map((e) => ParentModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }

        return [];
      } else {
        final errorMsg = (data is Map ? data['message'] : null) ?? tr('parents_fetch_failed');
        log('❌ [STUDENT PARENTS] Logical Error: $errorMsg');
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      log('🚨 [STUDENT PARENTS] Exception: $e\n$stackTrace');
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
  Future<List<SectionItemModel>> getAllSections({
    required String Function(String key) tr,
  }) async {
    try {
      final response = await _apiService.get(ConstantApi.section, tr: tr);
      final data = response.data;

      log('📊 [All SECTION] Status Code: ${response.statusCode}');
      log('📄 [All SECTION] Response Data: ${response.data}');


      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data != null &&
          data['success'] == true &&
          data['data'] is List) {
        return (data['data'] as List)
            .map((e) => SectionItemModel.fromJson(e as Map<String, dynamic>))
            .where((s) => s.isActive)
            .toList();
      }
      throw Exception(data?['message'] ?? tr('fetch_failed'));
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> assignStudentToSection({
    required int studentId,
    required int sectionId,
    required int semesterId,
    required int academicYearId,
    required String Function(String key) tr,
  }) async {
    try {
      final formData = FormData.fromMap({
        'student_id': studentId,
        'section_id': sectionId,
        'semester_id': semesterId,
        'academic_year_id': academicYearId,
      });

      log('➡️ [ASSIGN STUDENT TO SECTION] Request with student_id: $studentId, section_id: $sectionId');

      final response = await _apiService.post(
        ConstantApi.assignStudentToSection,
        data: formData,
        tr: tr,
      );


      log('📊 [ASSIGN STUDENT TO SECTION] Status Code: ${response.statusCode}');
      log('📄 [ASSIGN STUDENT TO SECTION] Response Data: ${response.data}');


      final data = response.data;
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(data?['message'] ?? tr('submit_failed'));
      }
    } catch (e) {
      log('🚨 [ASSIGN STUDENT TO SECTION ERROR]: $e');
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<void> transferStudentToSection({
    required int studentId,
    required int sectionId,
    required String Function(String key) tr,
  }) async {
    try {
      final formData = FormData.fromMap({
        'section_id': sectionId,
      });

      final response = await _apiService.post(
        ConstantApi.transferStudent(studentId),
        data: formData,
        tr: tr,
      );

      final data = response.data;
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(data?['message'] ?? tr('submit_failed'));
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}