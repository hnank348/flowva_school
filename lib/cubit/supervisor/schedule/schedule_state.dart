import '../../../models/supervisor/schedule_session_model.dart';

abstract class ScheduleState {
  final String selectedClass;
  ScheduleState({required this.selectedClass});
}

class ScheduleInitial extends ScheduleState {
  ScheduleInitial({required super.selectedClass});
}

class ScheduleLoading extends ScheduleState {
  ScheduleLoading({required super.selectedClass});
}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleSessionModel> sessions;
  final String selectedClass;
  final int selectedSemester;
  final String? semesterName;
  ScheduleLoaded({
    required this.sessions,
    required this.selectedClass,
    this.selectedSemester = 1,
    this.semesterName,
  }) : super(selectedClass: selectedClass);
}

class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError({required this.message, required super.selectedClass});
}

class ScheduleActionSuccess extends ScheduleState {
  final String successMessage;
  ScheduleActionSuccess({required this.successMessage, required super.selectedClass});
}