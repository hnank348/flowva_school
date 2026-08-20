class SectionItemModel {
  final int id;
  final int classId;
  final String name;
  final int maxStudents;
  final int currentStudents;
  final int availableSeats;
  final String? roomNumber;
  final bool isActive;
  final String? className;

  SectionItemModel({
    required this.id,
    required this.classId,
    required this.name,
    required this.maxStudents,
    required this.currentStudents,
    required this.availableSeats,
    this.roomNumber,
    required this.isActive,
    this.className,
  });

  factory SectionItemModel.fromJson(Map<String, dynamic> json) {
    final classData = json['class'] as Map<String, dynamic>?;
    return SectionItemModel(
      id: json['id'] ?? 0,
      classId: json['class_id'] ?? 0,
      name: json['name'] ?? '',
      maxStudents: json['max_students'] ?? 0,
      currentStudents: json['current_students'] ?? 0,
      availableSeats: json['available_seats'] ?? 0,
      roomNumber: json['room_number']?.toString(),
      isActive: json['is_active'] ?? true,
      className: classData?['name'] ?? '',
    );
  }

  String get fullDisplayName => className != null && className!.isNotEmpty
      ? '$className - $name'
      : name;
}