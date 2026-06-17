import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/supervisor/schedule_session_model.dart';
import '../../../services/supervisor/schedule_service.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleService _scheduleService;
  final String userToken;

  ScheduleCubit({
    required ScheduleService scheduleService,
    required this.userToken,
  })  : _scheduleService = scheduleService,
        super(ScheduleInitial(selectedClass: ''));

  // 1️⃣ جلب جدول الحصص وتمرير رقم الفصل وحفظه بالـ State فوراً 🎯
  void fetchWeeklySchedule(int sectionId, String className, {int semester = 1}) async {
    // نرسل حالة التحميل مع تمرير الفصل الحالي
    emit(ScheduleLoading(selectedClass: className));
    try {
      final sessions = await _scheduleService.getTimetableBySection(
        sectionId: sectionId,
        token: userToken,
        semesterId: semester,
      );

      // هنا السر: نرسل الـ semester للـ State لتحديث تلوين الأزرار في الواجهة ✅
      emit(ScheduleLoaded(
        sessions: sessions,
        selectedClass: className,
        selectedSemester: semester,
      ));
    } catch (e) {
      emit(ScheduleError(
        message: e.toString().replaceAll("Exception: ", ""),
        selectedClass: className,
      ));
    }
  }

  // 2️⃣ رفع حصة جديدة باستخدام الفصل المختار من الأعلى مباشرة
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

      // إعادة جلب الجدول فوراً بناءً على نفس الفصل الدراسي المختار
      fetchWeeklySchedule(sectionId, className, semester: semesterId);
    } catch (e) {
      emit(ScheduleError(
        message: "فشل في حفظ تفاصيل الحصة: ${e.toString().replaceAll("Exception: ", "")}",
        selectedClass: className,
      ));
    }
  }
}