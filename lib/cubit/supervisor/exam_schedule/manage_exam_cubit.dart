import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/models/supervisor/update_exam_request_model.dart';
import 'package:flowva_school/services/supervisor/exam_service.dart';

import 'manage_exam_state.dart';

class ManageExamCubit extends Cubit<ManageExamState> {
  final ExamService _service;

  ManageExamCubit(this._service) : super(const ManageExamInitial());

  Future<void> updateExam(int examId, UpdateExamRequest request) async {
    emit(const ManageExamLoading());
    try {
      final updatedExam = await _service.updateExam(examId, request);
      emit(UpdateExamSuccess(updatedExam));
    } catch (e) {
      emit(ManageExamError(e.toString()));
    }
  }

  Future<void> changeStatus(int examId, String status) async {
    emit(const ManageExamLoading());
    try {
      await _service.changeExamStatus(examId, status);
      emit(ChangeExamStatusSuccess(status));
    } catch (e) {
      emit(ManageExamError(e.toString()));
    }
  }

  Future<void> deleteExam(int examId) async {
    emit(const ManageExamLoading());
    try {
      await _service.deleteExam(examId);
      emit(const DeleteExamSuccess());
    } catch (e) {
      emit(ManageExamError(e.toString()));
    }
  }

  void reset() => emit(const ManageExamInitial());
}