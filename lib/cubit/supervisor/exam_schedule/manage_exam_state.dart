import 'package:flowva_school/models/supervisor/exam_model.dart';

abstract class ManageExamState {
  const ManageExamState();
}

class ManageExamInitial extends ManageExamState {
  const ManageExamInitial();
}

class ManageExamLoading extends ManageExamState {
  const ManageExamLoading();
}

class UpdateExamSuccess extends ManageExamState {
  final ExamModel updatedExam;
  const UpdateExamSuccess(this.updatedExam);
}

class ChangeExamStatusSuccess extends ManageExamState {
  final String newStatus;
  const ChangeExamStatusSuccess(this.newStatus);
}

class DeleteExamSuccess extends ManageExamState {
  const DeleteExamSuccess();
}

class ManageExamError extends ManageExamState {
  final String message;
  const ManageExamError(this.message);
}