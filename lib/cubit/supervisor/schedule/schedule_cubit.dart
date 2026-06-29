import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/supervisor/schedule_session_model.dart';
import '../../../services/supervisor/schedule_service.dart';
import '../../../services/mutual/semester_service.dart'; // 🌟 تأكد من استيراد الـ Service الجديد
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleService _scheduleService;
  final SemesterService _semesterService; // 🌟 إضافة الـ Service الخاص بالفصول
  final String userToken;

  ScheduleCubit({
    required ScheduleService scheduleService,
    required SemesterService semesterService, // حقن الـ Service هنا
    required this.userToken,
  })  : _scheduleService = scheduleService,
        _semesterService = semesterService,
        super(ScheduleInitial(selectedClass: ''));

  // 🔄 تم تعديل الدالة لـ تجلب الفصل تلقائياً إن لم يتم تمريره
  void fetchWeeklySchedule(int sectionId, String className, {int? semester}) async {
    emit(ScheduleLoading(selectedClass: className));
    try {
      int activeSemesterId = semester ?? 1;
      String activeSemesterName = "Second Semester"; // قيمة افتراضية متطابقة مع الـ API لديك

      // 🎯 إذا لم نمرر فصل محدد، نذهب فوراً لجلب الفصل الحالي النشط من الـ API تلقائياً
      if (semester == null) {
        final currentSemesterData = await _semesterService.getCurrentSemester();
        activeSemesterId = currentSemesterData.id;
        activeSemesterName = currentSemesterData.name;
      }

      // جلب جدول الحصص بناءً على الفصل الذكي المستخرج
      final sessions = await _scheduleService.getTimetableBySection(
        sectionId: sectionId,
        token: userToken,
        semesterId: activeSemesterId,
      );

      emit(ScheduleLoaded(
        sessions: sessions,
        selectedClass: className,
        selectedSemester: activeSemesterId,
        semesterName: activeSemesterName, // ✅ تمرير الاسم لتستقبله الشاشات وتعرضه بالشارة
      ));
    } catch (e) {
      emit(ScheduleError(
        message: e.toString().replaceAll("Exception: ", ""),
        selectedClass: className,
      ));
    }
  }

  Future<void> uploadNewSession({
    required int sectionId,
    required String className,
    required ScheduleSessionModel updatedSession,
    required int semesterId,
    required int subjectId,
    required int teacherId,
    required int academicYearId,
  }) async {
    try {
      await _scheduleService.createSession(
        session: updatedSession,
        token: userToken,
        sectionId: sectionId,
        subjectId: subjectId,
        teacherId: teacherId,
        academicYearId: academicYearId,
        semesterId: semesterId,
      );

      // إعادة جلب الجدول للفصل الحالي
      fetchWeeklySchedule(sectionId, className, semester: semesterId);
    } catch (e) {
      emit(ScheduleError(
        message: "فشل في حفظ تفاصيل الحصة: ${e.toString().replaceAll("Exception: ", "")}",
        selectedClass: className,
      ));
    }
  }

  Future<void> updateSession({
    required int timetableId,
    required int sectionId,
    required String className,
    required ScheduleSessionModel updatedSession,
    required int semesterId,
    required int subjectId,
    required int teacherId,
    required int academicYearId,
  }) async {
    try {
      await _scheduleService.updateSession(
        timetableId: timetableId,
        session: updatedSession,
        token: userToken,
        sectionId: sectionId,
        subjectId: subjectId,
        teacherId: teacherId,
        academicYearId: academicYearId,
        semesterId: semesterId,
      );

      // إعادة تحديث الواجهة تلقائياً بعد نجاح التعديل على السيرفر
      fetchWeeklySchedule(sectionId, className, semester: semesterId);
    } catch (e) {
      emit(ScheduleError(
        message: "فشل في تعديل تفاصيل الحصة: ${e.toString().replaceAll("Exception: ", "")}",
        selectedClass: className,
      ));
    }
  }
}