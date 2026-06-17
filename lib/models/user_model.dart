class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? dateOfBirth;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.dateOfBirth,
  });

  // الـ Factory لإنشاء الكائن مباشرة من عقدة "data" القادمة من الـ API
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatarUrl: json['avatar'],
      dateOfBirth: json['date_of_birth'],
    );
  }

  String get fullName => "$firstName $lastName".trim();
}