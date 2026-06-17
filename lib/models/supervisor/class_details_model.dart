
class ClassDetailsModel {
  final int id;
  final int gradeId;
  final int academicYearId;
  final String name;
  final List<SectionModel> sections;

  ClassDetailsModel({
    required this.id,
    required this.gradeId,
    required this.academicYearId,
    required this.name,
    required this.sections,
  });

  factory ClassDetailsModel.fromJson(Map<String, dynamic> json) {
    var list = json['sections'] as List? ?? [];
    List<SectionModel> sectionsList = list.map((i) => SectionModel.fromJson(i)).toList();

    return ClassDetailsModel(
      id: json['id'] ?? 0,
      gradeId: json['grade_id'] ?? 0,
      academicYearId: json['academic_year_id'] ?? 0,
      name: json['name'] ?? '',
      sections: sectionsList,
    );
  }
}

class SectionModel {
  final int id;
  final int classId;
  final String name;
  final String roomNumber;

  SectionModel({
    required this.id,
    required this.classId,
    required this.name,
    required this.roomNumber,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] ?? 0,
      classId: json['class_id'] ?? 0,
      name: json['name'] ?? '',
      roomNumber: json['room_number'] ?? '',
    );
  }
}