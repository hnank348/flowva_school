import '../../../models/supervisor/teacher_model.dart';

abstract class TeachersState {}

class TeachersInitial extends TeachersState {}

class TeachersLoading extends TeachersState {}

class TeachersSuccess extends TeachersState {
  final List<TeacherModel> teachers;
  TeachersSuccess(this.teachers);
}

class TeachersError extends TeachersState {
  final String errorMessage;
  TeachersError(this.errorMessage);
}