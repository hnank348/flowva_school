import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/services/supervisor/exam_service.dart';

import 'exam_schedule_state.dart';

class ExamScheduleCubit extends Cubit<ExamScheduleState> {
  final ExamService _service;

  ExamScheduleCubit(this._service) : super(const ExamScheduleInitial());

  ExamService get service => _service;

  Future<void> fetchExams({
    required int sectionId,
    required int semesterId,
  }) async {
    emit(const ExamScheduleLoading());
    try {
      final exams = await _service.getExamsBySection(
        sectionId:  sectionId,
        semesterId: semesterId,
        tr: context.tr,
      );
      emit(ExamScheduleSuccess(exams));
    } catch (e) {
      emit(ExamScheduleError(e.toString()));
    }
  }

  void reset() => emit(const ExamScheduleInitial());
}