class StudentDetailModel {
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
  final String? nationalId;
  final String? bloodType;
  final String? address;
  final String? city;
  final String? photo;
  final String? enrollmentDate;
  final String status;
  final String? notes;
  final StudentDetailSection? section; // 🟢 إضافة الشعبة
  final StudentDetailAcademicYear? academicYear; // 🟢 إضافة العام الدراسي
  final List<ParentModel> parents;

  StudentDetailModel({
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
    this.nationalId,
    this.bloodType,
    this.address,
    this.city,
    this.photo,
    this.enrollmentDate,
    required this.status,
    this.notes,
    this.section,
    this.academicYear,
    required this.parents,
  });

  /// 🟢 خاصية للتحقق إذا كان الطالب مرتبطاً بشعبة
  bool get hasSection => section != null && section!.id > 0;

  factory StudentDetailModel.fromJson(Map<String, dynamic> json) {
    var rawParents = json['parents'];
    List<ParentModel> parentsList = [];
    if (rawParents != null && rawParents is List) {
      parentsList = rawParents.map((e) => ParentModel.fromJson(e)).toList();
    }

    return StudentDetailModel(
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
      nationalId: json['national_id'],
      bloodType: json['blood_type'],
      address: json['address'],
      city: json['city'],
      photo: json['photo'],
      enrollmentDate: json['enrollment_date'],
      status: json['status'] ?? 'active',
      notes: json['notes'],
      section: json['section'] != null && json['section'] is Map<String, dynamic>
          ? StudentDetailSection.fromJson(json['section'])
          : null,
      academicYear: json['academic_year'] != null && json['academic_year'] is Map<String, dynamic>
          ? StudentDetailAcademicYear.fromJson(json['academic_year'])
          : null,
      parents: parentsList,
    );
  }

  String getDisplayName(bool isArabic) {
    final ar = '$firstNameAr $lastNameAr'.trim();
    final en = '$firstName $lastName'.trim();
    if (isArabic && ar.isNotEmpty) return ar;
    return en.isNotEmpty ? en : ar;
  }
}

class StudentDetailSection {
  final int id;
  final String name;
  final String className;
  final String grade;

  StudentDetailSection({
    required this.id,
    required this.name,
    required this.className,
    required this.grade,
  });

  factory StudentDetailSection.fromJson(Map<String, dynamic> json) {
    return StudentDetailSection(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      className: json['class'] ?? '',
      grade: json['grade'] ?? '',
    );
  }
}

class StudentDetailAcademicYear {
  final int id;
  final String name;

  StudentDetailAcademicYear({
    required this.id,
    required this.name,
  });

  factory StudentDetailAcademicYear.fromJson(Map<String, dynamic> json) {
    return StudentDetailAcademicYear(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class ParentModel {
  final int id;
  final String fullName;
  final String? phone;
  final String relationship;
  final bool isPrimaryContact;
  final bool canPickup;

  ParentModel({
    required this.id,
    required this.fullName,
    this.phone,
    required this.relationship,
    required this.isPrimaryContact,
    required this.canPickup,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      phone: json['phone'],
      relationship: json['relationship'] ?? '',
      isPrimaryContact: json['is_primary_contact'] ?? false,
      canPickup: json['can_pickup'] ?? false,
    );
  }
}