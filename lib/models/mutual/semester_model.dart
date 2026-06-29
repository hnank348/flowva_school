class SemesterModel {
  final int id;
  final int academicYearId;
  final String name;
  final int order;
  final String startDate;
  final String endDate;
  final bool isCurrent;
  final bool isActive;

  SemesterModel({
    required this.id,
    required this.academicYearId,
    required this.name,
    required this.order,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
    required this.isActive,
  });

  factory SemesterModel.fromJson(Map<String, dynamic> json) {
    return SemesterModel(
      id: json['id'] ?? 0,
      academicYearId: json['academic_year_id'] ?? 0,
      name: json['name'] ?? '',
      order: json['order'] ?? 0,
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      isCurrent: json['is_current'] == 1 || json['is_current'] == true,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'academic_year_id': academicYearId,
      'name': name,
      'order': order,
      'start_date': startDate,
      'end_date': endDate,
      'is_current': isCurrent,
      'is_active': isActive,
    };
  }
}