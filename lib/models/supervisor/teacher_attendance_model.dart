class TeacherModel {
  final int id;
  final String employeeId;
  final String fullName;
  final String fullNameAr;
  final String? gender;
  final String? avatar;

  const TeacherModel({
    required this.id,
    required this.employeeId,
    required this.fullName,
    required this.fullNameAr,
    this.gender,
    this.avatar,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    final firstName   = json['first_name']    ?? '';
    final lastName    = json['last_name']     ?? '';
    final firstNameAr = json['first_name_ar'] ?? '';
    final lastNameAr  = json['last_name_ar']  ?? '';

    return TeacherModel(
      id:         json['id'] as int,
      employeeId: json['employee_id'] ?? '',
      fullName:   '$firstName $lastName'.trim(),
      fullNameAr: '$firstNameAr $lastNameAr'.trim(),
      gender:     json['gender'],
      avatar:     json['avatar'],
    );
  }

  bool get hasValidAvatar {
    final url = avatar ?? '';
    return url.startsWith('http://') || url.startsWith('https://');
  }
}

class TeacherAttendanceRequest {
  final int teacherId;
  final int statusId;      // 1=حاضر | 2=غائب | 3=تأخير | 4=إذن
  final String date;       // yyyy-MM-dd
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