class ProfileModel {
  final String fullName;
  final String phone;
  final String birthDate;
  final String avatarUrl;

  const ProfileModel({
    required this.fullName,
    required this.phone,
    required this.birthDate,
    required this.avatarUrl,
  });
}

class ProfileStaticData {
  static const ProfileModel dummyProfile = ProfileModel(
    fullName: 'أبو احمد الخالد',
    phone: '٠٩٨٠٤٦٩٤٣٥',
    birthDate: '٢٠٠٣ / ٠٥ / ٠٧',
    avatarUrl: '',
  );
}