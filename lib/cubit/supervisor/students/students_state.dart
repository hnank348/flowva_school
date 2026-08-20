import '../../../models/supervisor/student_model.dart';

abstract class StudentsState {
  const StudentsState();
}

class StudentsInitial extends StudentsState {
  const StudentsInitial();
}

class StudentsLoading extends StudentsState {
  const StudentsLoading();
}

class StudentsLoaded extends StudentsState {
  final List<StudentModel> allStudents;
  final List<StudentModel> filteredStudents;
  final String searchQuery;

  const StudentsLoaded({
    required this.allStudents,
    required this.filteredStudents,
    this.searchQuery = '',
  });

  StudentsLoaded copyWith({
    List<StudentModel>? allStudents,
    List<StudentModel>? filteredStudents,
    String? searchQuery,
  }) {
    return StudentsLoaded(
      allStudents: allStudents ?? this.allStudents,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class StudentsError extends StudentsState {
  final String message;
  const StudentsError(this.message);
}