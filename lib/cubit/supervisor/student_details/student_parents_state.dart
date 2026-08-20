import '../../../models/supervisor/student_detail_model.dart';

abstract class StudentParentsState {
  const StudentParentsState();
}

class StudentParentsInitial extends StudentParentsState {
  const StudentParentsInitial();
}

class StudentParentsLoading extends StudentParentsState {
  const StudentParentsLoading();
}

class StudentParentsLoaded extends StudentParentsState {
  final List<ParentModel> parents;
  const StudentParentsLoaded(this.parents);
}

class StudentParentsError extends StudentParentsState {
  final String message;
  const StudentParentsError(this.message);
}