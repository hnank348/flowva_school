import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/models/supervisor/update_exam_request_model.dart';
import 'package:flowva_school/services/supervisor/exam_service.dart';

import 'manage_exam_state.dart';

class ManageExamCubit extends Cubit<ManageExamState> {
  final ExamService _service;

  ManageExamCubit(this._service) : super(const ManageExamInitial());

  Future<void> updateExam({
    required int examId,
    required UpdateExamRequest request,
    required String Function(String key) tr, // 🟢 استقبال دالة الترجمة كـ Parameter إجباري
  }) async {
    emit(const ManageExamLoading());
    try {
      final updatedExam = await _service.updateExam(
        examId: examId,
        request: request,
        tr: tr,
      );
      emit(UpdateExamSuccess(updatedExam));
    } catch (e) {
      emit(ManageExamError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> changeStatus({
    required int examId,
    required String status,
    required String Function(String key) tr, // 🟢 تمرير tr للخدمة
  }) async {
    emit(const ManageExamLoading());
    try {
      await _service.changeExamStatus(
        examId: examId,
        status: status,
        tr: tr,
      );
      emit(ChangeExamStatusSuccess(status));
    } catch (e) {
      emit(ManageExamError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  Future<void> deleteExam({
    required int examId,
    required String Function(String key) tr, // 🟢 تمرير tr للخدمة
  }) async {
    emit(const ManageExamLoading());
    try {
      await _service.deleteExam(
        examId: examId,
        tr: tr,
      );
      emit(const DeleteExamSuccess());
    } catch (e) {
      emit(ManageExamError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  void reset() => emit(const ManageExamInitial());
}