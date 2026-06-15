class Session {
  final String time;
  final String subject;
  final String className;
  final String room;

  Session({
    required this.time,
    required this.subject,
    required this.className,
    required this.room,
  });
}

class Schedule {
  final String day;
  final List<Session> sessions;

  Schedule({
    required this.day,
    required this.sessions,
  });
}
