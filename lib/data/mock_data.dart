import '../models/teacher/student.dart';
import '../models/teacher/classroom.dart';
import '../models/teacher/activity.dart';
import '../models/teacher/homework.dart';
import '../models/teacher/schedule.dart';
import '../models/teacher/message.dart';

class MockData {
  // ── mutable activities list — supports runtime additions ─────────────────
  static final List<Activity> _activities = [
    Activity(
      id: '1',
      title: 'اجتماع أولياء أمور الصف 9-أ',
      description: 'مناقشة نتائج الفصل الدراسي الأول',
      date: '2026-05-20',
      type: ActivityType.parentMeeting,
      classRoom: 'الصف 9-أ',
    ),
    Activity(
      id: '2',
      title: 'رحلة مدرسية إلى المتحف الوطني',
      description: 'رحلة ترفيهية وتعليمية لطلاب الصف 10',
      date: '2026-05-25',
      type: ActivityType.schoolTrip,
      classRoom: 'الصف 10-أ',
    ),
    Activity(
      id: '3',
      title: 'مسابقة الرياضيات الإقليمية',
      description: 'التصفيات الأولى للمسابقة',
      date: '2026-06-02',
      type: ActivityType.competition,
      classRoom: 'الصف 9-ب',
    ),
    Activity(
      id: '4',
      title: 'حفل تكريم المتفوقين',
      description: 'تكريم أفضل 10 طلاب في الفصل الدراسي',
      date: '2026-06-10',
      type: ActivityType.ceremony,
      classRoom: 'عام',
    ),
  ];

  static List<Activity> getActivities() => List.unmodifiable(_activities);

  static void addActivity(Activity activity) {
    _activities.insert(0, activity);
  }

  static List<Student> getStudents() {
    return [
      Student(
        id: '1',
        name: 'أحمد محمد',
        classRoomId: '1',
        grade: 95,
        attendance: 98,
        performance: 92,
      ),
      Student(
        id: '2',
        name: 'فاطمة علي',
        classRoomId: '1',
        grade: 88,
        attendance: 95,
        performance: 90,
      ),
      Student(
        id: '3',
        name: 'محمد خالد',
        classRoomId: '2',
        grade: 78,
        attendance: 85,
        performance: 80,
      ),
      Student(
        id: '4',
        name: 'نور حسن',
        classRoomId: '2',
        grade: 92,
        attendance: 97,
        performance: 94,
      ),
      Student(
        id: '5',
        name: 'سارة أحمد',
        classRoomId: '3',
        grade: 85,
        attendance: 90,
        performance: 87,
      ),
      Student(
        id: '6',
        name: 'عمر يوسف',
        classRoomId: '3',
        grade: 91,
        attendance: 93,
        performance: 89,
      ),
      Student(
        id: '7',
        name: 'ليلى حسين',
        classRoomId: '5',
        grade: 87,
        attendance: 88,
        performance: 86,
      ),
    ];
  }

  static List<Student> getStudentsByClassRoom(String classRoomId) {
    return getStudents()
        .where((student) => student.classRoomId == classRoomId)
        .toList();
  }

  static List<ClassRoom> getClassRooms() {
    return [
      ClassRoom(
        id: '1',
        name: 'الصف 9-أ',
        subject: 'رياضيات',
        studentsCount: 28,
        nextSession: 'غداً 08:00',
      ),
      ClassRoom(
        id: '2',
        name: 'الصف 9-ب',
        subject: 'رياضيات',
        studentsCount: 25,
        nextSession: 'اليوم 09:30',
      ),
      ClassRoom(
        id: '3',
        name: 'الصف 10-أ',
        subject: 'فيزياء',
        studentsCount: 30,
        nextSession: 'اليوم 11:00',
      ),
      ClassRoom(
        id: '4',
        name: 'الصف 10-ب',
        subject: 'فيزياء',
        studentsCount: 26,
        nextSession: 'غداً 08:00',
      ),
      ClassRoom(
        id: '5',
        name: 'الصف 8-أ',
        subject: 'رياضيات',
        studentsCount: 15,
        nextSession: 'الأربعاء 10:00',
      ),
    ];
  }

  static List<Schedule> getSchedule() {
    return [
      Schedule(
        day: 'الأحد',
        sessions: [
          Session(
            time: '08:00',
            subject: 'رياضيات',
            className: 'الصف 9-أ',
            room: '201',
          ),
          Session(
            time: '09:30',
            subject: 'رياضيات',
            className: 'الصف 9-ب',
            room: '202',
          ),
          Session(
            time: '11:00',
            subject: 'فيزياء',
            className: 'الصف 10-أ',
            room: '301',
          ),
        ],
      ),
      Schedule(
        day: 'الإثنين',
        sessions: [
          Session(
            time: '08:00',
            subject: 'فيزياء',
            className: 'الصف 10-ب',
            room: '302',
          ),
          Session(
            time: '10:00',
            subject: 'رياضيات',
            className: 'الصف 9-أ',
            room: '201',
          ),
        ],
      ),
      Schedule(
        day: 'الثلاثاء',
        sessions: [
          Session(
            time: '08:00',
            subject: 'رياضيات',
            className: 'الصف 9-ب',
            room: '202',
          ),
          Session(
            time: '09:30',
            subject: 'فيزياء',
            className: 'الصف 10-أ',
            room: '301',
          ),
          Session(
            time: '11:30',
            subject: 'رياضيات',
            className: 'الصف 9-أ',
            room: '201',
          ),
        ],
      ),
      Schedule(
        day: 'الأربعاء',
        sessions: [
          Session(
            time: '08:00',
            subject: 'رياضيات',
            className: 'الصف 8-أ',
            room: '101',
          ),
          Session(
            time: '10:00',
            subject: 'فيزياء',
            className: 'الصف 10-ب',
            room: '302',
          ),
        ],
      ),
      Schedule(
        day: 'الخميس',
        sessions: [
          Session(
            time: '08:00',
            subject: 'رياضيات',
            className: 'الصف 9-أ',
            room: '201',
          ),
          Session(
            time: '09:30',
            subject: 'رياضيات',
            className: 'الصف 9-ب',
            room: '202',
          ),
        ],
      ),
    ];
  }

  static List<Message> getMessages() {
    return [
      Message(
        id: '1',
        sender: 'الموجه التربوي - أحمد السالم',
        content: 'مرحباً، أود مناقشة نتائج الطلاب في الاختبار الأخير',
        time: '10:30',
        isMe: false,
      ),
      Message(
        id: '2',
        sender: 'أنت',
        content: 'أهلاً، أنا متاح الآن للمناقشة',
        time: '10:32',
        isMe: true,
      ),
      Message(
        id: '3',
        sender: 'الموجه التربوي - أحمد السالم',
        content: 'هل يمكننا الاجتماع غداً الساعة 2 ظهراً؟',
        time: '10:35',
        isMe: false,
      ),
      Message(
        id: '4',
        sender: 'أنت',
        content: 'بالتأكيد، سأكون متواجداً',
        time: '10:37',
        isMe: true,
      ),
    ];
  }

  static List<Homework> getHomeworks() {
    return [
      Homework(
        id: '1',
        title: 'حل تمارين الجبر - الفصل 4',
        description:
            'حل التمارين من 1 إلى 15 في صفحة 87 من الكتاب المدرسي، مع إظهار جميع خطوات الحل.',
        classRoomId: '1',
        classRoomName: 'الصف 9-أ',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        type: HomeworkType.written,
        totalMarks: 20,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        status: HomeworkStatus.pending,
      ),
      Homework(
        id: '2',
        title: 'بحث عن قوانين الحركة',
        description:
            'اكتب بحثاً لا يقل عن صفحتين عن قوانين نيوتن للحركة مع أمثلة من الحياة اليومية.',
        classRoomId: '3',
        classRoomName: 'الصف 10-أ',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        type: HomeworkType.research,
        totalMarks: 30,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        status: HomeworkStatus.pending,
      ),
      Homework(
        id: '3',
        title: 'قراءة الوحدة الثانية',
        description:
            'اقرأ الوحدة الثانية كاملة من الكتاب وأجب عن أسئلة المراجعة في النهاية.',
        classRoomId: '2',
        classRoomName: 'الصف 9-ب',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        type: HomeworkType.reading,
        totalMarks: 10,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        status: HomeworkStatus.submitted,
      ),
      Homework(
        id: '4',
        title: 'مشروع نموذج الجهاز الشمسي',
        description:
            'صمّم نموذجاً مجسماً للجهاز الشمسي مع تعليق على كل كوكب وخصائصه.',
        classRoomId: '4',
        classRoomName: 'الصف 10-ب',
        dueDate: DateTime.now().add(const Duration(days: 10)),
        type: HomeworkType.project,
        totalMarks: 50,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        status: HomeworkStatus.pending,
      ),
      Homework(
        id: '5',
        title: 'تمارين المعادلات التربيعية',
        description: 'حل التمارين الزوجية فقط من صفحة 102 إلى 105.',
        classRoomId: '5',
        classRoomName: 'الصف 8-أ',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        type: HomeworkType.written,
        totalMarks: 15,
        createdAt: DateTime.now().subtract(const Duration(hours: 10)),
        status: HomeworkStatus.graded,
      ),
    ];
  }

  static List<Homework> getHomeworksByClassRoom(String classRoomId) {
    return getHomeworks().where((hw) => hw.classRoomId == classRoomId).toList();
  }
}
