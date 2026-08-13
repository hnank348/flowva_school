import 'package:flowva_school/models/supervisor/submit_attendance_model.dart'; // 🔶 تأكد اسم الملف اللي فيه SubmitAttendanceRequest/Response
import 'package:flowva_school/services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';

class SubmitAttendanceService {
  final ApiService _apiService;

  SubmitAttendanceService(this._apiService);

  Future<SubmitAttendanceResponse> submitOne(
      SubmitAttendanceRequest request) async {
    try {
      final response = await _apiService.post(
        ConstantApi.studentAttendance,
        data: request.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return SubmitAttendanceResponse.fromJson(
            response.data as Map<String, dynamic>);
      }

      throw Exception(response.data['message'] ?? 'فشل تسجيل الحضور');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<List<SubmitAttendanceResponse>> submitAll({
    required List<int> studentIds,
    required int sectionId,
    required int academicYearId,
    required int semesterId,
    required Map<String, int> statusMap,
    required String date,
    required String checkInTime,
    Map<String, String?> notesMap = const {},
  }) async {
    final results = <SubmitAttendanceResponse>[];

    for (final studentId in studentIds) {
      final sid       = studentId.toString();
      final statusId  = statusMap[sid] ?? 1;

      final response = await submitOne(
        SubmitAttendanceRequest(
          studentId:      studentId,
          sectionId:      sectionId,
          academicYearId: academicYearId,
          semesterId:     semesterId,
          statusId:       statusId,
          date:           date,
          checkInTime:    checkInTime,
          notes:          notesMap[sid],
        ),
      );
      results.add(response);
    }

    return results;
  }
}