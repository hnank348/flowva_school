class AcademicYearModel {
  final int id;
  final String name;
  final String startDate;
  final String endDate;
  final bool isCurrent;
  final bool isActive;

  AcademicYearModel({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
    required this.isActive,
  });

  factory AcademicYearModel.fromJson(Map<String, dynamic> json) {
    return AcademicYearModel(
      id: json['id'],
      name: json['name'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      isCurrent: json['is_current'] ?? false,
      isActive: json['is_active'] ?? false,
    );
  }
}