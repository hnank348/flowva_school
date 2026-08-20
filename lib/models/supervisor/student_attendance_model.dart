class StudentAttendanceModel {
  final int id;
  final String firstNameAr;
  final String lastNameAr;
  final String firstName;
  final String lastName;
  final String fullNameAr;
  final String fullName;
  final String? photo;
  final String? notes;

  StudentAttendanceModel({
    required this.id,
    required this.firstNameAr,
    required this.lastNameAr,
    required this.fullNameAr,
    required this.lastName,
    required this.firstName,
    required this.fullName,
    this.photo,
    this.notes,
  });

  factory StudentAttendanceModel.fromJson(Map<String, dynamic> json) {
    final fNameAr = json['first_name_ar'] ?? '';
    final lNameAr = json['last_name_ar'] ?? '';
    final fName   = json['first_name'] ?? '';
    final lName   = json['last_name'] ?? '';
    return StudentAttendanceModel(
      id:          json['id'],
      firstNameAr: fNameAr,
      lastNameAr:  lNameAr,
      firstName:   fName,
      lastName:    lName,
      fullNameAr:  '$fNameAr $lNameAr'.trim(),
      fullName:    '$fName $lName'.trim(),
      photo:       json['photo'] ?? json['avatar'],
      notes:       json['notes'],
    );
  }
}