import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/services/supervisor/exam_service.dart';

import '../../../models/supervisor/add_exam_request_model.dart';
import 'add_exam_state.dart';


class AddExamCubit extends Cubit<AddExamState> {
  final ExamService _service;

  AddExamCubit(this._service) : super(const AddExamInitial());

  Future<void> submit(AddExamRequest request) async {
    emit(const AddExamLoading());
    try {
      await _service.createExam(request);
      emit(const AddExamSuccess());
    } catch (e) {
      emit(AddExamError(e.toString()));
    }
  }

  void reset() => emit(const AddExamInitial());
}