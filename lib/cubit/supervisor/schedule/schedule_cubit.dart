import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/supervisor/schedule_session_model.dart';
import '../../../services/supervisor/schedule_service.dart';
import '../../../services/mutual/semester_service.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleService _scheduleService;
  final SemesterService _semesterService;
  final String userToken;

  ScheduleCubit({
    required ScheduleService scheduleService,
    required SemesterService semesterService,
    required this.userToken,
  })  : _scheduleService = scheduleService,
        _semesterService = semesterService,
        super(ScheduleInitial(selectedClass: ''));

  void setFormSubjectId(int? subjectId) {
    emit(_copyState(formSubjectId: subjectId));
  }

  void setFormTeacherId(int? teacherId) {
    emit(_copyState(formTeacherId: teacherId));
  }

  void setFormRoom(String room) {
    emit(_copyState(formRoom: room));
  }

  void initFormData({int? subjectId, int? teacherId, String? room}) {
    emit(_copyState(
      formSubjectId: subjectId,
      formTeacherId: teacherId,
      formRoom: room ?? '',
    ));
  }

  void clearFormData() {
    emit(_copyState(formSubjectId: null, formTeacherId: null, formRoom: ''));
  }

  ScheduleState _copyState({
    int? formSubjectId,
    int? formTeacherId,
    String? formRoom,
  }) {
    final subId = formSubjectId ?? state.formSubjectId;
    final teachId = formTeacherId ?? state.formTeacherId;
    final room = formRoom ?? state.formRoom;

    if (state is ScheduleLoaded) {
      final s = state as ScheduleLoaded;
      return ScheduleLoaded(
        sessions: s.sessions,
        selectedClass: s.selectedClass,
        semesterName: s.semesterName,
        formSubjectId: subId,
        formTeacherId: teachId,
        formRoom: room,
      );
    } else if (state is ScheduleLoading) {
      return ScheduleLoading(
        selectedClass: state.selectedClass,
        formSubjectId: subId,
        formTeacherId: teachId,
        formRoom: room,
      );
    } else if (state is ScheduleError) {
      final s = state as ScheduleError;
      return ScheduleError(
        message: s.message,
        selectedClass: s.selectedClass,
        formSubjectId: subId,
        formTeacherId: teachId,
        formRoom: room,
      );
    }
    return ScheduleInitial(
      selectedClass: state.selectedClass,
      formSubjectId: subId,
      formTeacherId: teachId,
      formRoom: room,
    );
  }

  void fetchWeeklySchedule(
      int sectionId,
      String className, {
        int? semester,
        String Function(String key)? tr,
      }) async {
    final String Function(String key) safeTr = tr ?? (key) => key;

    if (state is ScheduleLoading && (state as ScheduleLoading).selectedClass == className) {
      return;
    }

    emit(ScheduleLoading(
      selectedClass: className,
      formSubjectId: state.formSubjectId,
      formTeacherId: state.formTeacherId,
      formRoom: state.formRoom,
    ));

    try {
      int activeSemesterId = semester ?? 1;
      String activeSemesterName = 'First semester';

      if (semester == null) {
        try {
          final currentSemesterData = await _semesterService.getCurrentSemester(tr: safeTr);
          activeSemesterId = currentSemesterData.id;
          activeSemesterName = currentSemesterData.name;
        } catch (_) {
          activeSemesterId = 1;
        }
      }

      final sessions = await _scheduleService.getTimetableBySection(
        sectionId: sectionId,
        token: userToken,
        semesterId: activeSemesterId,
        tr: safeTr,
      );

      emit(ScheduleLoaded(
        sessions: sessions,
        selectedClass: className,
        semesterName: activeSemesterName,
        formSubjectId: state.formSubjectId,
        formTeacherId: state.formTeacherId,
        formRoom: state.formRoom,
      ));
    } catch (e) {
      emit(ScheduleError(
        message: e.toString().replaceAll("Exception: ", ""),
        selectedClass: className,
        formSubjectId: state.formSubjectId,
        formTeacherId: state.formTeacherId,
        formRoom: state.formRoom,
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
        tr: (key) => key,
      );

      clearFormData();

      emit(ScheduleActionSuccess(
        successMessage: 'session_add_success',
        selectedClass: className,
      ));

      fetchWeeklySchedule(sectionId, className, semester: semesterId);
    } catch (e) {
      final rawError = e.toString().replaceAll("Exception: ", "");

      emit(ScheduleError(
        message: rawError,
        selectedClass: className,
        formSubjectId: state.formSubjectId,
        formTeacherId: state.formTeacherId,
        formRoom: state.formRoom,
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
        tr: (key) => key,
      );

      clearFormData();

      emit(ScheduleActionSuccess(
        successMessage: 'session_update_success',
        selectedClass: className,
      ));

      fetchWeeklySchedule(sectionId, className, semester: semesterId);
    } catch (e) {
      final rawError = e.toString().replaceAll("Exception: ", "");

      emit(ScheduleError(
        message: rawError,
        selectedClass: className,
        formSubjectId: state.formSubjectId,
        formTeacherId: state.formTeacherId,
        formRoom: state.formRoom,
      ));
    }
  }

  Future<void> deleteSession({
    required int timetableId,
    required int sectionId,
    required String className,
    required int semesterId,
  }) async {
    try {
      await _scheduleService.deleteSession(
        timetableId: timetableId,
        tr: (key) => key,
      );

      clearFormData();

      emit(ScheduleActionSuccess(
        successMessage: 'session_delete_success',
        selectedClass: className,
      ));

      fetchWeeklySchedule(sectionId, className, semester: semesterId);
    } catch (e) {
      final rawError = e.toString().replaceAll("Exception: ", "");

      emit(ScheduleError(
        message: rawError,
        selectedClass: className,
        formSubjectId: state.formSubjectId,
        formTeacherId: state.formTeacherId,
        formRoom: state.formRoom,
      ));
    }
  }
}