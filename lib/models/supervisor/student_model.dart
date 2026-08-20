class StudentModel {
  final int id;
  final String studentId;
  final String firstName;
  final String lastName;
  final String firstNameAr;
  final String lastNameAr;
  final String gender;
  final String? dateOfBirth;
  final String? phone;
  final String? email;
  final int age;
  final String? photo;
  final String status;
  final String? className;
  final String? sectionName;
  final String? academicYear;

  StudentModel({
    required this.id,
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.firstNameAr,
    required this.lastNameAr,
    required this.gender,
    this.dateOfBirth,
    this.phone,
    this.email,
    required this.age,
    this.photo,
    required this.status,
    this.className,
    this.sectionName,
    this.academicYear,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    final sectionData = json['section'] as Map<String, dynamic>?;
    final academicData = json['academic_year'] as Map<String, dynamic>?;

    return StudentModel(
      id: json['id'] ?? 0,
      studentId: json['student_id']?.toString() ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      firstNameAr: json['first_name_ar'] ?? '',
      lastNameAr: json['last_name_ar'] ?? '',
      gender: json['gender'] ?? 'male',
      dateOfBirth: json['date_of_birth'],
      phone: json['phone'],
      email: json['email'],
      age: json['age'] ?? 0,
      photo: json['photo'],
      status: json['status'] ?? 'active',
      className: sectionData?['class'] ?? '',
      sectionName: sectionData?['name'] ?? '',
      academicYear: academicData?['name'] ?? '',
    );
  }

  String get fullNameEn => '$firstName $lastName'.trim();
  String get fullNameAr => '$firstNameAr $lastNameAr'.trim();

  String getDisplayName(bool isArabic) {
    if (isArabic && fullNameAr.isNotEmpty) return fullNameAr;
    return fullNameEn.isNotEmpty ? fullNameEn : fullNameAr;
  }
}