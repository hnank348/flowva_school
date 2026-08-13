enum ActivityType { exam, homework, event }

class Activity {
  final String id;
  final String title;
  final String date;
  final ActivityType type;
  final String classRoom;

  Activity({
    required this.id,
    required this.title,
    required this.date,
    required this.type,
    required this.classRoom,
  });
}
