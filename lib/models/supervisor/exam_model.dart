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
  final ExamTypeModel examType;
  final ExamSubjectModel subject;
  final ExamTeacherModel teacher;

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
    required this.instructions,
    required this.examType,
    required this.subject,
    required this.teacher,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id:           json['id'] as int,
      name:         json['name'] ?? '',
      nameAr:       json['name_ar'] ?? '',
      examDate:     json['exam_date'] ?? '',
      startTime:    json['start_time'] ?? '',
      endTime:      json['end_time'] ?? '',
      room:         json['room'] ?? '',
      totalMarks:   double.tryParse(json['total_marks'].toString()) ?? 0,
      passMarks:    double.tryParse(json['pass_marks'].toString()) ?? 0,
      status:       json['status'] ?? 'scheduled',
      instructions: json['instructions'],
      examType:     ExamTypeModel.fromJson(json['exam_type']),
      subject:      ExamSubjectModel.fromJson(json['subject']),
      teacher:      ExamTeacherModel.fromJson(json['teacher']),
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
      id:     json['id'] as int,
      name:   json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      weight: json['weight'] ?? 0,
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
      id:   json['id'] as int,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
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
      id:         json['id'] as int,
      employeeId: json['employee_id'] ?? '',
      fullName:   json['full_name'] ?? '',
    );
  }
}