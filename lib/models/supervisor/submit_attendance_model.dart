// 1 = حاضر | 2 = غائب | 3 = تأخير | 4 = إذن

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