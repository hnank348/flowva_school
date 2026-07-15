import '../models/notification_model.dart';

class NotificationsLocalDataSource {
  static List<NotificationModel> getFakeNotifications() {
    return [
      const NotificationModel(
        id: '1',
        title: 'تنبيه غياب',
        body: 'أحمد محمد علي - غياب اليوم بدون عذر.',
        time: 'منذ ساعة',
        isRead: false,
        type: NotificationType.absence,
        studentName: 'أحمد محمد علي',
        tags: ['جديد', 'مهم'], // 1
      ),
      const NotificationModel(
        id: '2',
        title: 'فاتورة مستحقة',
        body: 'رسوم الفصل الدراسي الثاني - الاستحقاق 30-03-2024.',
        time: 'منذ 3 ساعات',
        isRead: false,
        type: NotificationType.invoice,
        studentName: 'الطالب جميع الأبناء',
        tags: ['مهم'], // 2
      ),
      const NotificationModel(
        id: '3',
        title: 'نتائج جديدة',
        body: 'تم نشر نتائج اختبار الرياضيات - الدرجة: 95/100.',
        time: 'أمس',
        isRead: true,
        type: NotificationType.results,
        studentName: 'أحمد محمد علي',
      ),
      const NotificationModel(
        id: '4',
        title: 'تحديث الباص',
        body: 'الباص رقم 3 في الطريق - الوصول خلال 15 دقيقة.',
        time: 'منذ يومين',
        isRead: true,
        type: NotificationType.busUpdate,
        studentName: 'الطالب جميع الأبناء',
      ),
      const NotificationModel(
        id: '5',
        title: 'قسط باص متأخر',
        body: 'يرجى تسديد دفعة الباص المتبقية لشهر حزيران منعاً لإيقاف الخدمة.',
        time: 'منذ 3 أيام',
        isRead: false,
        type: NotificationType.invoice,
        studentName: 'أحمد محمد علي',
        tags: ['مهم'], // 3
      ),
      const NotificationModel(
        id: '6',
        title: 'إعلان اجتماع أولياء الأمور',
        body: 'ندعوكم لحضور اجتماع أولياء الأمور السنوي في مسرح المدرسة يوم السبت القادم.',
        time: 'منذ 4 أيام',
        isRead: true,
        type: NotificationType.importantAlert,
        tags: ['مهم'], // 4
      ),
      const NotificationModel(
        id: '7',
        title: 'فعالية اليوم العالمي للغة العربية',
        body: 'مشاركة الطلاب في مسابقة الخط العربي والخطابة بالمدرسة.',
        time: 'منذ أسبوع',
        isRead: true,
        type: NotificationType.schoolEvent,
        studentName: 'أحمد محمد علي',
      ),
      const NotificationModel(
        id: '8',
        title: 'تنبيه تأخير صباحي',
        body: 'تم تسجيل تأخير صباحي متكرر للطالب عند الطابور.',
        time: 'منذ أسبوع',
        isRead: true,
        type: NotificationType.absence,
        studentName: 'أحمد محمد علي',
      ),
    ];
  }
}