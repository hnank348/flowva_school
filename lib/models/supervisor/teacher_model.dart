class TeacherModel {
  final int id;
  final String employeeId;
  final String firstNameAr;
  final String lastNameAr;
  final String fullNameAr;

  TeacherModel({
    required this.id,
    required this.employeeId,
    required this.firstNameAr,
    required this.lastNameAr,
    required this.fullNameAr,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    final fNameAr = json['first_name_ar'] ?? '';
    final lNameAr = json['last_name_ar'] ?? '';
    return TeacherModel(
      id: json['id'],
      employeeId: json['employee_id'] ?? '',
      firstNameAr: fNameAr,
      lastNameAr: lNameAr,
      fullNameAr: '$fNameAr $lNameAr'.trim(), // دمج الاسم الأول والأخير للعرض
    );
  }
}