import '../../services/constant_api.dart';

class StudentAttendanceRecord {
  final int id;
  final String date;
  final String? checkInTime;
  final int lateMinutes;
  final String? notes;
  final int studentId;
  final String studentFullName;
  final String? studentAvatar;
  final int statusId;
  final String statusName;
  final String statusNameAr;
  final String statusCode;
  final String statusColor;

  const StudentAttendanceRecord({
    required this.id,
    required this.date,
    required this.checkInTime,
    required this.lateMinutes,
    required this.notes,
    required this.studentId,
    required this.studentFullName,
    required this.studentAvatar,
    required this.statusId,
    required this.statusName,
    required this.statusNameAr,
    required this.statusCode,
    required this.statusColor,
  });

  factory StudentAttendanceRecord.fromJson(Map<String, dynamic> json) {
    final student = json['student'] as Map<String, dynamic>;
    final status  = json['status']  as Map<String, dynamic>;

    return StudentAttendanceRecord(
      id:              json['id'] as int,
      date:            json['date'] ?? '',
      checkInTime:     json['check_in_time'],
      lateMinutes:     json['late_minutes'] ?? 0,
      notes:           json['notes'],
      studentId:       student['id'] as int,
      studentFullName: student['full_name'] ?? '',
      studentAvatar:   ConstantApi.getImageUrl(student['avatar']), // 🔴 هنا التعديل
      statusId:        status['id'] as int,
      statusName:      status['name'] ?? '',
      statusNameAr:    status['name_ar'] ?? '',
      statusCode:      status['code'] ?? '',
      statusColor:     status['color'] ?? '#64748B',
    );
  }

  // تحويل statusId → enum
  AttendanceStatusEnum get statusEnum {
    switch (statusId) {
      case 2:  return AttendanceStatusEnum.absent;
      case 3:  return AttendanceStatusEnum.late;
      case 4:  return AttendanceStatusEnum.excused;
      default: return AttendanceStatusEnum.present;
    }
  }
}

enum AttendanceStatusEnum { present, absent, late, excused }

extension AttendanceStatusEnumX on AttendanceStatusEnum {
  int get id {
    switch (this) {
      case AttendanceStatusEnum.present:  return 1;
      case AttendanceStatusEnum.absent:   return 2;
      case AttendanceStatusEnum.late:     return 3;
      case AttendanceStatusEnum.excused:  return 4;
    }
  }
}