import '../../services/constant_api.dart';

class TeacherModel {
  final int id;
  final String employeeId;
  final String fullName;
  final String fullNameAr;
  final String? gender;
  final String? avatar;
  final String? notes;

  const TeacherModel({
    required this.id,
    required this.employeeId,
    required this.fullName,
    required this.fullNameAr,
    this.gender,
    this.avatar,
    this.notes,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    final firstName   = json['first_name']    ?? '';
    final lastName    = json['last_name']     ?? '';
    final firstNameAr = json['first_name_ar'] ?? '';
    final lastNameAr  = json['last_name_ar']  ?? '';

    // 🟢 قراءة مسار الصورة وتحويله إلى رابط كامل تلقائياً
    final rawAvatar = json['avatar'] ?? json['photo'];

    return TeacherModel(
      id:         json['id'] as int,
      employeeId: json['employee_id'] ?? '',
      fullName:   '$firstName $lastName'.trim(),
      fullNameAr: '$firstNameAr $lastNameAr'.trim(),
      gender:     json['gender'],
      avatar:     ConstantApi.getImageUrl(rawAvatar), // 🟢 تحويل المسار لرابط كامل هنا
      notes:      json['notes'],
    );
  }

  bool get hasValidAvatar {
    final url = avatar ?? '';
    return url.trim().isNotEmpty && (url.startsWith('http://') || url.startsWith('https://'));
  }

  TeacherModel copyWith({String? notes}) {
    return TeacherModel(
      id: id,
      employeeId: employeeId,
      fullName: fullName,
      fullNameAr: fullNameAr,
      gender: gender,
      avatar: avatar,
      notes: notes ?? this.notes,
    );
  }
}

class TeacherAttendanceRequest {
  final int teacherId;
  final int statusId;
  final String date;
  final String checkInTime;
  final String? checkOutTime;
  final int? lateMinutes;
  final String? notes;

  const TeacherAttendanceRequest({
    required this.teacherId,
    required this.statusId,
    required this.date,
    required this.checkInTime,
    this.checkOutTime,
    this.lateMinutes,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'teacher_id':    teacherId,
    'status_id':     statusId,
    'date':          date,
    'check_in_time': checkInTime,
    if (checkOutTime != null) 'check_out_time': checkOutTime,
    if (lateMinutes  != null) 'late_minutes':   lateMinutes,
    if (notes != null && notes!.isNotEmpty) 'notes': notes,
  };
}