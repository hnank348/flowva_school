import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/supervisor/students_service.dart';
import 'students_state.dart';

class StudentsCubit extends Cubit<StudentsState> {
  final StudentsService _studentsService;

  StudentsCubit({required StudentsService studentsService})
      : _studentsService = studentsService,
        super(const StudentsInitial());

  Future<void> fetchStudents({
    int semesterId = 1,
    required String Function(String key) tr,
  }) async {
    emit(const StudentsLoading());
    try {
      final students = await _studentsService.getStudents(
        semesterId: semesterId,
        tr: tr,
      );
      emit(StudentsLoaded(
        allStudents: students,
        filteredStudents: students,
      ));
    } catch (e) {
      emit(StudentsError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  void searchByName(String query) {
    if (state is StudentsLoaded) {
      final currentState = state as StudentsLoaded;
      final q = query.trim().toLowerCase();

      if (q.isEmpty) {
        emit(currentState.copyWith(
          filteredStudents: currentState.allStudents,
          searchQuery: '',
        ));
        return;
      }

      final filtered = currentState.allStudents.where((student) {
        final nameEn = student.fullNameEn.toLowerCase();
        final nameAr = student.fullNameAr.toLowerCase();
        final code = student.studentId.toLowerCase();
        return nameEn.contains(q) || nameAr.contains(q) || code.contains(q);
      }).toList();

      emit(currentState.copyWith(
        filteredStudents: filtered,
        searchQuery: query,
      ));
    }
  }
}