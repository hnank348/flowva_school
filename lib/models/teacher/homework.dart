enum HomeworkStatus { pending, submitted, graded }
enum HomeworkType { written, reading, research, project }

class Homework {
  final String id;
  final String title;
  final String description;
  final String classRoomId;
  final String classRoomName;
  final DateTime dueDate;
  final HomeworkType type;
  final int totalMarks;
  final DateTime createdAt;
  final HomeworkStatus status;

  Homework({
    required this.id,
    required this.title,
    required this.description,
    required this.classRoomId,
    required this.classRoomName,
    required this.dueDate,
    required this.type,
    required this.totalMarks,
    required this.createdAt,
    this.status = HomeworkStatus.pending,
  });

  String get typeIcon {
    switch (type) {
      case HomeworkType.written:
        return '✏️';
      case HomeworkType.reading:
        return '📖';
      case HomeworkType.research:
        return '🔍';
      case HomeworkType.project:
        return '🗂️';
    }
  }
}
