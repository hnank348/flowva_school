import '../../../models/supervisor/student_detail_model.dart';

abstract class StudentDetailsState {
  const StudentDetailsState();
}

class StudentDetailsInitial extends StudentDetailsState {
  const StudentDetailsInitial();
}

class StudentDetailsLoading extends StudentDetailsState {
  const StudentDetailsLoading();
}

class StudentDetailsLoaded extends StudentDetailsState {
  final StudentDetailModel student;
  const StudentDetailsLoaded(this.student);
}

class StudentDetailsError extends StudentDetailsState {
  final String message;
  const StudentDetailsError(this.message);
}