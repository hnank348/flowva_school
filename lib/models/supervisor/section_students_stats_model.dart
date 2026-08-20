class SectionStudentsStatsModel {
  final int total;
  final int active;
  final int male;
  final int female;

  SectionStudentsStatsModel({
    required this.total,
    required this.active,
    required this.male,
    required this.female,
  });

  factory SectionStudentsStatsModel.fromJson(Map<String, dynamic> json) {
    return SectionStudentsStatsModel(
      total: json['total'] ?? 0,
      active: json['active'] ?? 0,
      male: json['male'] ?? 0,
      female: json['female'] ?? 0,
    );
  }
}