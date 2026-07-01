class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String firstNameAr;
  final String lastNameAr;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? dateOfBirth;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.firstNameAr,
    required this.lastNameAr,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.dateOfBirth,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {

    String? cleanAvatarUrl(String? url) {
      if (url == null || url.isEmpty) return null;

      if (url.contains(':\\') || url.contains('AppData') || url.endsWith('.tmp')) {
        return null;
      }

      return url;
    }

    return UserModel(
      id: json['id'] as int,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      firstNameAr: json['first_name_ar'] ?? '',
      lastNameAr: json['last_name_ar'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatarUrl: cleanAvatarUrl(json['avatar']),
      dateOfBirth: json['date_of_birth'],
    );
  }

  String get fullName => "$firstName $lastName".trim();
  String get fullNameAr => "$firstNameAr $lastNameAr".trim();
}