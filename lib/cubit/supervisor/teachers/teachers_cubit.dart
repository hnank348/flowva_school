import 'package:easy_localization/easy_localization.dart' as context;
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

  Future<void> fetchTeachers({
    required String Function(String key) tr, // 🟢 إجباري بدون أي فحص إضافي
  }) async {
    emit(TeachersLoading());
    try {
      final teachers = await _teachersService.getTeachers(token: userToken,tr: context.tr,);

      if (teachers.isEmpty) {
        emit(TeachersError(tr('teachers_no_teachers_error')));
      } else {
        emit(TeachersSuccess(teachers));
      }
    } catch (e) {
      emit(TeachersError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}