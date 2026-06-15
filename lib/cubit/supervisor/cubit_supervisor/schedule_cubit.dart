import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/supervisor/schedule_session_model.dart';
import '../../../services/supervisor/schedule_service.dart';

import '../state_supervisor/schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleService _scheduleService;
  final String userToken;

  ScheduleCubit({required ScheduleService scheduleService, required this.userToken})
      : _scheduleService = scheduleService,
        super(ScheduleInitial(selectedClass: 'الصف الثالث - أ'));

  // جلب جدول الحصص لصف معين وعرضه
  void fetchWeeklySchedule(int sectionId, String className) async {
    emit(ScheduleLoading(selectedClass: className));
    try {
      final sessions = await _scheduleService.getTimetableBySection(sectionId, userToken);
      emit(ScheduleLoaded(sessions: sessions, selectedClass: className));
    } catch (e) {
      emit(ScheduleError(message: e.toString(), selectedClass: className));
    }
  }

  // رفع حصة جديدة للبرنامج
  void uploadNewSession(ScheduleSessionModel newSession, int sectionId, String className) async {
    emit(ScheduleLoading(selectedClass: className));
    try {
      await _scheduleService.createSession(newSession, userToken);
      emit(ScheduleActionSuccess(successMessage: 'تم رفع الحصة بنجاح', selectedClass: className));

      // تحديث الجدول تلقائياً بالبيانات الجديدة من الباكيند
      fetchWeeklySchedule(sectionId, className);
    } catch (e) {
      emit(ScheduleError(message: e.toString(), selectedClass: className));
    }
  }
}