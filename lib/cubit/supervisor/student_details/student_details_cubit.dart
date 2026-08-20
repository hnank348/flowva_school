import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/supervisor/students_service.dart';
import 'student_details_state.dart';

class StudentDetailsCubit extends Cubit<StudentDetailsState> {
  final StudentsService _studentsService;

  StudentDetailsCubit(this._studentsService)
      : super(const StudentDetailsInitial());

  Future<void> fetchStudentDetails({
    required int studentId,
    required String Function(String key) tr,
  }) async {
    emit(const StudentDetailsLoading());
    try {
      final student = await _studentsService.getStudentDetails(
        studentId: studentId,
        tr: tr,
      );
      emit(StudentDetailsLoaded(student));
    } catch (e) {
      emit(StudentDetailsError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}