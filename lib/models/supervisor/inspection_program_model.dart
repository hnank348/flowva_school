class InspectionProgramModel {
  final int id;
  final String title;
  final String titleAr;
  final String inspectionDate;
  final String startTime;
  final String endTime;
  final String type;
  final String status;
  final String? objectives;
  final int isCurrent;
  final String? notes;
  final InspectionSection? section;
  final InspectionSemester? semester;
  final List<InspectionCounselor> counselors;

  InspectionProgramModel({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.inspectionDate,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.status,
    this.objectives,
    required this.isCurrent,
    this.notes,
    this.section,
    this.semester,
    this.counselors = const [],
  });

  bool get isActiveOrPending =>
      status.toLowerCase() == 'ongoing' || status.toLowerCase() == 'pending';

  factory InspectionProgramModel.fromJson(Map<String, dynamic> json) {
    return InspectionProgramModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] ?? '',
      titleAr: json['title_ar'] ?? '',
      inspectionDate: json['inspection_date'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      objectives: json['objectives'],
      isCurrent: json['is_current'] as int? ?? 0,
      notes: json['notes'],
      section: json['section'] != null ? InspectionSection.fromJson(json['section']) : null,
      semester: json['semester'] != null ? InspectionSemester.fromJson(json['semester']) : null,
      counselors: (json['counselors'] as List<dynamic>?)
          ?.map((e) => InspectionCounselor.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  String getDisplayName(bool isArabic) => isArabic && titleAr.isNotEmpty ? titleAr : title;
}

class InspectionSection {
  final int id;
  final String name;
  final String className;
  final String grade;

  InspectionSection({
    required this.id,
    required this.name,
    required this.className,
    required this.grade,
  });

  factory InspectionSection.fromJson(Map<String, dynamic> json) {
    return InspectionSection(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
      className: json['class'] ?? '',
      grade: json['grade'] ?? '',
    );
  }
}

class InspectionSemester {
  final int id;
  final String name;

  InspectionSemester({required this.id, required this.name});

  factory InspectionSemester.fromJson(Map<String, dynamic> json) {
    return InspectionSemester(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class InspectionCounselor {
  final int id;
  final String counselorId;
  final String fullName;
  final String role;
  final String? observation;
  final String? result;

  InspectionCounselor({
    required this.id,
    required this.counselorId,
    required this.fullName,
    required this.role,
    this.observation,
    this.result,
  });

  factory InspectionCounselor.fromJson(Map<String, dynamic> json) {
    return InspectionCounselor(
      id: json['id'] as int? ?? 0,
      counselorId: json['counselor_id']?.toString() ?? '',
      fullName: json['full_name'] ?? '',
      role: json['role'] ?? '',
      observation: json['observation'],
      result: json['result'],
    );
  }
}