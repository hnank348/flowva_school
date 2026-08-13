import '../../../models/supervisor/schedule_session_model.dart';

abstract class ScheduleState {
  final String selectedClass;
  final int? formSubjectId;
  final int? formTeacherId;
  final String formRoom;

  ScheduleState({
    required this.selectedClass,
    this.formSubjectId,
    this.formTeacherId,
    this.formRoom = '',
  });
}

class ScheduleInitial extends ScheduleState {
  ScheduleInitial({
    required super.selectedClass,
    super.formSubjectId,
    super.formTeacherId,
    super.formRoom,
  });
}

class ScheduleLoading extends ScheduleState {
  ScheduleLoading({
    required super.selectedClass,
    super.formSubjectId,
    super.formTeacherId,
    super.formRoom,
  });
}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleSessionModel> sessions;

  final String? semesterName;

  ScheduleLoaded({
    required this.sessions,
    required super.selectedClass,
    this.semesterName,
    super.formSubjectId,
    super.formTeacherId,
    super.formRoom,
  });
}

class ScheduleError extends ScheduleState {
  final String message;

  ScheduleError({
    required this.message,
    required super.selectedClass,
    super.formSubjectId,
    super.formTeacherId,
    super.formRoom,
  });
}

class ScheduleActionSuccess extends ScheduleState {
  final String successMessage;

  ScheduleActionSuccess({
    required this.successMessage,
    required super.selectedClass,
    super.formSubjectId,
    super.formTeacherId,
    super.formRoom,
  });
}