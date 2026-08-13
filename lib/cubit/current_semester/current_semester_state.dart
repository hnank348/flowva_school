import '../../models/mutual/semester_model.dart'; // مسار الموديل الخاص بالفصل الدراسي

abstract class CurrentSemesterState {}

class CurrentSemesterInitial extends CurrentSemesterState {}

class CurrentSemesterLoading extends CurrentSemesterState {}

class CurrentSemesterSuccess extends CurrentSemesterState {
  final SemesterModel currentSemester;

  CurrentSemesterSuccess(this.currentSemester);
}

class CurrentSemesterError extends CurrentSemesterState {
  final String errorMessage;

  CurrentSemesterError(this.errorMessage);
}