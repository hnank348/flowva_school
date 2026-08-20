import 'package:flowva_school/cubit/supervisor/student_evaluations/student_evaluations_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/supervisor/student_points_service.dart';



class StudentEvaluationsCubit extends Cubit<StudentEvaluationsState> {
  final StudentPointsService _service;

  StudentEvaluationsCubit(this._service)
      : super(const StudentEvaluationsInitial());

  Future<void> fetchSummary({
    required int studentId,
    required int semesterId,
    required String Function(String key) tr,
  }) async {
    emit(const StudentEvaluationsLoading());
    try {
      final summary = await _service.getStudentPointsTotal(
        studentId: studentId,
        semesterId: semesterId,
        tr: tr,
      );
      emit(StudentEvaluationsLoaded(summary));
    } catch (e) {
      emit(StudentEvaluationsError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}