class ClassDetailsModel {
  final int id;
  final int academicYearId;
  final String name;
  final List<SectionModel> sections;

  ClassDetailsModel({
    required this.id,
    required this.academicYearId,
    required this.name,
    required this.sections,
  });

  factory ClassDetailsModel.fromSectionsList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) {
      return ClassDetailsModel(
        id: 0,
        academicYearId: 1,
        name: '',
        sections: [],
      );
    }

    final firstItem = jsonList.first;
    final classData = firstItem['class'] ?? {};

    final sectionsList = jsonList
        .map((item) => SectionModel.fromJson(item))
        .toList();

    return ClassDetailsModel(
      id: classData['id'] ?? 0,
      academicYearId: classData['academic_year_id'] ?? 1,
      name: classData['name'] ?? '',
      sections: sectionsList,
    );
  }
}

class SectionModel {
  final int id;
  final int classId;
  final String name; // اسم الشعبة مثل "A" أو "أ"
  final int maxStudents;
  final int currentStudents;
  final String roomNumber;
  final bool isActive;
  final String className; // اسم الصف مثل "Grade 1 - A" أو "الصف الأول"

  SectionModel({
    required this.id,
    required this.classId,
    required this.name,
    required this.maxStudents,
    required this.currentStudents,
    required this.roomNumber,
    required this.isActive,
    required this.className,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    // جلب اسم الصف من الكائن المرفق داخل الاستجابة class -> name
    final classData = json['class'] as Map<String, dynamic>?;
    final classNameStr = classData?['name'] ?? '';

    return SectionModel(
      id: json['id'] ?? 0,
      classId: json['class_id'] ?? 0,
      name: json['name'] ?? '',
      maxStudents: json['max_students'] ?? 0,
      currentStudents: json['current_students'] ?? 0,
      roomNumber: json['room_number']?.toString() ?? '',
      isActive: json['is_active'] ?? true,
      className: classNameStr,
    );
  }

  String get fullSectionName {
    if (className.isNotEmpty) {
      return '$className - شعبة $name';
    }
    return 'شعبة $name';
  }
}