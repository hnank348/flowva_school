/// نوع الفعالية — الاختبارات والواجبات لها شاشاتها الخاصة
enum ActivityType {
  parentMeeting, // اجتماع أولياء أمور
  schoolTrip, // رحلة مدرسية
  competition, // مسابقة
  ceremony, // حفل / تكريم
  workshop, // ورشة عمل
  other, // أخرى
}

class Activity {
  final String id;
  final String title;
  final String description;
  final String date;
  final ActivityType type;
  final String classRoom;

  Activity({
    required this.id,
    required this.title,
    this.description = '',
    required this.date,
    required this.type,
    required this.classRoom,
  });
}
