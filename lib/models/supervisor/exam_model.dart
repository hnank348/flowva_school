class ExamModel {
  final int id;
  final String name;
  final String nameAr;
  final String examDate;   // yyyy-MM-dd
  final String startTime;  // HH:mm:ss
  final String endTime;
  final String room;
  final double totalMarks;
  final double passMarks;
  final String status;     // scheduled | completed | ...
  final String? instructions;
  final ExamTypeModel? examType;
  final ExamSubjectModel? subject; // 💡 تم تحويله إلى Nullable حمايةً ضد البيانات الفارغة
  final ExamTeacherModel? teacher; // 💡 تم تحويله إلى Nullable حمايةً ضد البيانات الفارغة

  const ExamModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.totalMarks,
    required this.passMarks,
    required this.status,
    this.instructions,
    this.examType,
    this.subject,
    this.teacher,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id:           json['id'] as int? ?? 0,
      name:         json['name']?.toString() ?? '',
      nameAr:       json['name_ar']?.toString() ?? '',
      examDate:     json['exam_date']?.toString() ?? '',
      startTime:    json['start_time']?.toString() ?? '',
      endTime:      json['end_time']?.toString() ?? '',
      room:         json['room']?.toString() ?? '',
      totalMarks:   double.tryParse(json['total_marks']?.toString() ?? '0') ?? 0.0,
      passMarks:    double.tryParse(json['pass_marks']?.toString() ?? '0') ?? 0.0,
      status:       json['status']?.toString() ?? 'scheduled',
      instructions: json['instructions']?.toString(),

      // ✅ التعديل الرئيسي: فحص كينونة الخريطة وتواجدها قبل التحويل لمنع الـ Exception
      examType: json['exam_type'] != null && json['exam_type'] is Map<String, dynamic>
          ? ExamTypeModel.fromJson(json['exam_type'] as Map<String, dynamic>)
          : null,

      subject: json['subject'] != null && json['subject'] is Map<String, dynamic>
          ? ExamSubjectModel.fromJson(json['subject'] as Map<String, dynamic>)
          : null,

      teacher: json['teacher'] != null && json['teacher'] is Map<String, dynamic>
          ? ExamTeacherModel.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
    );
  }

  /// عرض الوقت بصيغة "08:00 - 10:00"
  String get timeRange {
    String short(String t) => t.length >= 5 ? t.substring(0, 5) : t;
    return '${short(startTime)} - ${short(endTime)}';
  }
}

class ExamTypeModel {
  final int id;
  final String name;
  final String nameAr;
  final int weight;

  const ExamTypeModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.weight,
  });

  factory ExamTypeModel.fromJson(Map<String, dynamic> json) {
    return ExamTypeModel(
      id:     json['id'] as int? ?? 0,
      name:   json['name']?.toString() ?? '',
      nameAr: json['name_ar']?.toString() ?? '',
      weight: int.tryParse(json['weight']?.toString() ?? '0') ?? 0,
    );
  }
}

class ExamSubjectModel {
  final int id;
  final String name;
  final String code;

  const ExamSubjectModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ExamSubjectModel.fromJson(Map<String, dynamic> json) {
    return ExamSubjectModel(
      id:   json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
    );
  }
}

class ExamTeacherModel {
  final int id;
  final String employeeId;
  final String fullName;

  const ExamTeacherModel({
    required this.id,
    required this.employeeId,
    required this.fullName,
  });

  factory ExamTeacherModel.fromJson(Map<String, dynamic> json) {
    return ExamTeacherModel(
      id:         json['id'] as int? ?? 0,
      employeeId: json['employee_id']?.toString() ?? '',
      fullName:   json['full_name']?.toString() ?? '',
    );
  }
}