class SubjectModel {
  final int id;
  final String code;
  final String name;
  final String nameAr;
  final String? description;
  final int weeklyHours;
  final int creditHours;
  final String passMark;
  final String fullMark;
  final bool isMandatory;
  final String? color;
  final String status;

  SubjectModel({
    required this.id,
    required this.code,
    required this.name,
    required this.nameAr,
    this.description,
    required this.weeklyHours,
    required this.creditHours,
    required this.passMark,
    required this.fullMark,
    required this.isMandatory,
    this.color,
    required this.status,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      description: json['description'],
      weeklyHours: json['weekly_hours'] ?? 0,
      creditHours: json['credit_hours'] ?? 0,
      passMark: json['pass_mark'] ?? '0.00',
      fullMark: json['full_mark'] ?? '0.00',
      isMandatory: json['is_mandatory'] == true || json['is_mandatory'] == 1,
      color: json['color'],
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'weekly_hours': weeklyHours,
      'credit_hours': creditHours,
      'pass_mark': passMark,
      'full_mark': fullMark,
      'is_mandatory': isMandatory,
      'color': color,
      'status': status,
    };
  }
}