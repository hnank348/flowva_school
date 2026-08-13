import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/supervisor/teachers_service.dart';
import 'teachers_state.dart';

class TeachersCubit extends Cubit<TeachersState> {
  final TeachersService _teachersService;
  final String userToken;

  TeachersCubit({
    required TeachersService teachersService,
    required this.userToken,
  })  : _teachersService = teachersService,
        super(TeachersInitial());

  Future<void> fetchTeachers() async {
    emit(TeachersLoading());
    try {
      final teachers = await _teachersService.getTeachers(token: userToken);

      if (teachers.isEmpty) {
        emit(TeachersError("لا يوجد معلمون مضافون حالياً"));
      } else {
        emit(TeachersSuccess(teachers));
      }
    } catch (e) {
      emit(TeachersError(e.toString()));
    }
  }
}