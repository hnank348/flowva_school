import '../../../models/supervisor/student_points_summary_model.dart';

abstract class StudentEvaluationsState {
  const StudentEvaluationsState();
}

class StudentEvaluationsInitial extends StudentEvaluationsState {
  const StudentEvaluationsInitial();
}

class StudentEvaluationsLoading extends StudentEvaluationsState {
  const StudentEvaluationsLoading();
}

class StudentEvaluationsLoaded extends StudentEvaluationsState {
  final StudentPointsSummaryModel summary;
  const StudentEvaluationsLoaded(this.summary);
}

class StudentEvaluationsError extends StudentEvaluationsState {
  final String message;
  const StudentEvaluationsError(this.message);
}