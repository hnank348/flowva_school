class ScheduleSessionModel {
  final int? id;
  final int? academicYearId;
  final int? sectionId;
  final int? teacherId;
  final int? subjectId;
  final int? semesterId;
  final String dayOfWeek;
  final int periodNumber;
  final String startTime;
  final String endTime;
  final String roomNumber;
  final String? status;
  final String? createdAt;

  // الكائنات المدمجة لعرض النصوص بالواجهة
  final ApiSubjectModel? subject;
  final ApiTeacherModel? teacher;

  ScheduleSessionModel({
    this.id,
    this.academicYearId,
    this.sectionId,
    this.teacherId,
    this.subjectId,
    this.semesterId,
    required this.dayOfWeek,
    required this.periodNumber,
    required this.startTime,
    required this.endTime,
    required this.roomNumber,
    this.status,
    this.createdAt,
    this.subject,
    this.teacher,
  });

  factory ScheduleSessionModel.fromJson(Map<String, dynamic> json) {
    return ScheduleSessionModel(
      id: json['id'],
      dayOfWeek: json['day_of_week'] ?? '',
      periodNumber: json['period_number'] ?? 0,
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      roomNumber: json['room_number'] ?? '',
      status: json['status'],
      createdAt: json['created_at'],
      academicYearId: json['academic_year_id'],
      sectionId: json['section_id'],
      teacherId: json['teacher_id'],
      subjectId: json['subject_id'],
      semesterId: json['semester_id'],

      // عمل تفكيك آمن للعلاقات القادمة من السيرفر
      subject: json['subject'] != null ? ApiSubjectModel.fromJson(json['subject']) : null,
      teacher: json['teacher'] != null ? ApiTeacherModel.fromJson(json['teacher']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'academic_year_id': academicYearId,
      'section_id': sectionId,
      'teacher_id': teacherId,
      'subject_id': subjectId,
      'semester_id': semesterId,
      'day_of_week': dayOfWeek,
      'period_number': periodNumber,
      'start_time': startTime,
      'end_time': endTime,
      'room_number': roomNumber,
    };
  }
}

class ApiSubjectModel {
  final int id;
  final String name;
  final String nameAr; // 🎯 تمت إضافته هنا ليطابق رد السيرفر ويختفي الخطأ بالواجهة
  final String? code;

  ApiSubjectModel({required this.id, required this.name, required this.nameAr, this.code});

  factory ApiSubjectModel.fromJson(Map<String, dynamic> json) {
    return ApiSubjectModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '', // تفكيك الاسم العربي القادم من الباكيند
      code: json['code'],
    );
  }
}

class ApiTeacherModel {
  final int id;
  final String fullName;

  ApiTeacherModel({required this.id, required this.fullName});

  factory ApiTeacherModel.fromJson(Map<String, dynamic> json) {
    return ApiTeacherModel(
      id: json['id'] ?? 0,
      // 🎯 السيرفر يرسل اسم المعلم بـ "full_name" داخل كائن الـ teacher، تأكد من استخراجه بشكل صحيح هكذا:
      fullName: json['full_name'] ?? json['name'] ?? '',
    );
  }
}