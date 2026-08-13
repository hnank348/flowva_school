import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'parent_navigation_state.dart';

class ParentNavigationCubit extends Cubit<ParentNavigationState> {
  ParentNavigationCubit() : super(const ParentNavigationState(currentIndex: 0));

  void changeIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void selectStudent(String studentId) {
    emit(state.copyWith(
      selectedStudentId: studentId,
    ));
  }
}