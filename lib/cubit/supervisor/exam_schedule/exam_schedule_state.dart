import 'package:flowva_school/models/supervisor/exam_model.dart';

abstract class ExamScheduleState {
  const ExamScheduleState();
}

class ExamScheduleInitial extends ExamScheduleState {
  const ExamScheduleInitial();
}

class ExamScheduleLoading extends ExamScheduleState {
  const ExamScheduleLoading();
}

class ExamScheduleSuccess extends ExamScheduleState {
  final List<ExamModel> exams;
  const ExamScheduleSuccess(this.exams);
}

class ExamScheduleError extends ExamScheduleState {
  final String message;
  const ExamScheduleError(this.message);
}