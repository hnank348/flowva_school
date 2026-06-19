class TeacherModel {
  final int id;
  final String employeeId;
  final String firstNameAr;
  final String lastNameAr;
  final String firstName;
  final String lastName;
  final String fullNameAr;
  final String fullName;

  TeacherModel({
    required this.id,
    required this.employeeId,
    required this.firstNameAr,
    required this.lastNameAr,
    required this.fullNameAr,
    required this.lastName,
    required this.firstName,
    required this.fullName,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    final fNameAr = json['first_name_ar'] ?? '';
    final lNameAr = json['last_name_ar'] ?? '';
    final fName = json['first_name'] ?? '';
    final lName = json['last_name'] ?? '';
    return TeacherModel(
      id: json['id'],
      employeeId: json['employee_id'] ?? '',
      firstNameAr: fNameAr,
      lastNameAr: lNameAr,
      firstName: fName,
      lastName: lName,
      fullNameAr: '$fNameAr $lNameAr'.trim(),
      fullName: '$fName $lName'.trim(),
    );
  }
}