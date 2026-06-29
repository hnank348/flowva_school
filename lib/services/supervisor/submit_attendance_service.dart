import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';

class SubmitAttendanceService {
  final ApiService _apiService;

  SubmitAttendanceService(this._apiService);

  /// تسجيل حضور طالب واحد
  Future<SubmitAttendanceResponse> submitOne(
      SubmitAttendanceRequest request) async {
    try {
      final response = await _apiService.post(
        ConstantApi.studentAttendance,
        data: request.toJson(),
      );
      print('🌐 [SubmitAttendanceService] Response Data: ${response.data}');
      print('📊 [SubmitAttendanceService] Status Code: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return SubmitAttendanceResponse.fromJson(
            response.data as Map<String, dynamic>);
      }

      throw Exception(
          response.data['message'] ?? 'فشل تسجيل الحضور');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<SubmitAttendanceResponse>> submitAll({
    required List<int> studentIds,
    required int sectionId,
    required int academicYearId,
    required int semesterId,
    required Map<String, int> statusMap, // studentId.toString() → statusId
    required String date,
    required String checkInTime,
  }) async {
    final results = <SubmitAttendanceResponse>[];

    for (final studentId in studentIds) {
      final statusId = statusMap[studentId.toString()] ?? 1;
      final response = await submitOne(
        SubmitAttendanceRequest(
          studentId:       studentId,
          sectionId:       sectionId,
          academicYearId:  academicYearId,
          semesterId:      semesterId,
          statusId:        statusId,
          date:            date,
          checkInTime:     checkInTime,
        ),
      );
      results.add(response);
    }

    return results;
  }
}         // 1 = حاضر | 2 = غائب | 3 = تأخير | 4 = إذن

class SubmitAttendanceRequest {
  final int studentId;
  final int sectionId;
  final int academicYearId;
  final int semesterId;
  final int statusId;
  final String date;         // yyyy-MM-dd
  final String checkInTime;  // HH:mm
  final String? notes;

  const SubmitAttendanceRequest({
    required this.studentId,
    required this.sectionId,
    required this.academicYearId,
    required this.semesterId,
    required this.statusId,
    required this.date,
    required this.checkInTime,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'student_id':       studentId,
    'section_id':       sectionId,
    'academic_year_id': academicYearId,
    'semester_id':      semesterId,
    'status_id':        statusId,
    'date':             date,
    'check_in_time':    checkInTime,
    if (notes != null && notes!.isNotEmpty) 'notes': notes,
  };
}

class SubmitAttendanceResponse {
  final bool success;
  final String message;
  final int? attendanceId;

  const SubmitAttendanceResponse({
    required this.success,
    required this.message,
    this.attendanceId,
  });

  factory SubmitAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return SubmitAttendanceResponse(
      success:      json['success'] == true,
      message:      json['message'] ?? '',
      attendanceId: json['data']?['id'],
    );
  }
}