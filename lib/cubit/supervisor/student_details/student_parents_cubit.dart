import 'package:flowva_school/cubit/supervisor/student_details/student_parents_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/supervisor/students_service.dart';


class StudentParentsCubit extends Cubit<StudentParentsState> {
  final StudentsService _studentsService;

  StudentParentsCubit(this._studentsService)
      : super(const StudentParentsInitial());

  Future<void> fetchParents({
    required int studentId,
    required String Function(String key) tr,
  }) async {
    emit(const StudentParentsLoading());
    try {
      final parents = await _studentsService.getStudentParents(
        studentId: studentId,
        tr: tr,
      );
      emit(StudentParentsLoaded(parents));
    } catch (e) {
      emit(StudentParentsError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}