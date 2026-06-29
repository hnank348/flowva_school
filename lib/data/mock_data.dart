import '../models/teacher/student.dart';
import '../models/teacher/classroom.dart';
import '../models/teacher/activity.dart';
import '../models/teacher/schedule.dart';
import '../models/teacher/message.dart';

class MockData {
  static List<Student> getStudents() {
    return [
      Student(
        id: '1',
        name: 'أحمد محمد',
        grade: 95,
        attendance: 98,
        performance: 92,
      ),
      Student(
        id: '2',
        name: 'فاطمة علي',
        grade: 88,
        attendance: 95,
        performance: 90,
      ),
      Student(
        id: '3',
        name: 'محمد خالد',
        grade: 78,
        attendance: 85,
        performance: 80,
      ),
      Student(
        id: '4',
        name: 'نور حسن',
        grade: 92,
        attendance: 97,
        performance: 94,
      ),
      Student(
        id: '5',
        name: 'سارة أحمد',
        grade: 85,
        attendance: 90,
        performance: 87,
      ),
      Student(
        id: '6',
        name: 'عمر يوسف',
        grade: 91,
        attendance: 93,
        performance: 89,
      ),
      Student(
        id: '7',
        name: 'ليلى حسين',
        grade: 87,
        attendance: 88,
        performance: 86,
      ),
    ];
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

  static List<Activity> getActivities() {
    return [
      Activity(
        id: '1',
        title: 'اختبار الجبر - الوحدة 3',
        date: '2026-05-15',
        type: ActivityType.exam,
        classRoom: 'الصف 9-أ',
      ),
      Activity(
        id: '2',
        title: 'واجب: حل المعادلات التربيعية',
        date: '2026-05-14',
        type: ActivityType.homework,
        classRoom: 'الصف 9-ب',
      ),
      Activity(
        id: '3',
        title: 'اجتماع أولياء الأمور',
        date: '2026-05-20',
        type: ActivityType.event,
        classRoom: 'قاعة الاجتماعات',
      ),
      Activity(
        id: '4',
        title: 'اختبار الفيزياء - الحركة',
        date: '2026-05-18',
        type: ActivityType.exam,
        classRoom: 'الصف 10-أ',
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
}
