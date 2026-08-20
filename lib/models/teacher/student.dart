class Student {
  final String id;
  final String name;
  final String classRoomId;
  final String? avatar;
  final double grade;
  final double attendance;
  final double performance;

  Student({
    required this.id,
    required this.name,
    required this.classRoomId,
    this.avatar,
    required this.grade,
    required this.attendance,
    required this.performance,
  });

  bool get isExcellent => grade >= 90;
  bool get needsAttention => grade < 70 || attendance < 80;
}
