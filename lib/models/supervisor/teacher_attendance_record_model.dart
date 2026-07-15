class TeacherAttendanceRecord {
  final int id;
  final String date;
  final String? checkInTime;
  final String? checkOutTime;
  final int lateMinutes;
  final String? notes;
  final int teacherId;
  final String employeeId;
  final String teacherFullName;
  final String teacherFullNameAr;
  final String? teacherAvatar;
  final int statusId;
  final String statusName;
  final String statusNameAr;
  final String statusCode;
  final String statusColor;


  const TeacherAttendanceRecord({
    required this.id,
    required this.date,
    required this.checkInTime,
    required this.checkOutTime,
    required this.lateMinutes,
    required this.notes,
    required this.teacherId,
    required this.employeeId,
    required this.teacherFullName,
    required this.teacherAvatar,
    required this.statusId,
    required this.statusName,
    required this.statusNameAr,
    required this.statusCode,
    required this.statusColor,
    required this.teacherFullNameAr,
  });

  factory TeacherAttendanceRecord.fromJson(Map<String, dynamic> json) {
    final teacher = json['teacher'] as Map<String, dynamic>;
    final status  = json['status']  as Map<String, dynamic>;
    return TeacherAttendanceRecord(
      id:              json['id'] as int,
      date:            json['date'] ?? '',
      checkInTime:     json['check_in_time'],
      checkOutTime:    json['check_out_time'],
      lateMinutes:     json['late_minutes'] ?? 0,
      notes:           json['notes'],
      teacherId:       teacher['id'] as int,
      employeeId:      teacher['employee_id'] ?? '',
      teacherFullName: teacher['full_name'] ?? '',
      teacherAvatar:   teacher['avatar'],
      statusId:        status['id'] as int,
      statusName:      status['name'] ?? '',
      statusNameAr:    status['name_ar'] ?? '',
      statusCode:      status['code'] ?? '',
      statusColor:     status['color'] ?? '#64748B',
      teacherFullNameAr: teacher['full_name_ar'] ?? '',


    );
  }
}