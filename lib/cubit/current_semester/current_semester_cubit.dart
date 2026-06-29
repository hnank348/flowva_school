import 'package:flutter_bloc/flutter_bloc.dart';
import 'current_semester_state.dart';
import '../../services/mutual/semester_service.dart'; // تأكدي من ضبط مسار السيرفس طبقاً لمشروعك

class CurrentSemesterCubit extends Cubit<CurrentSemesterState> {
  final SemesterService _service;

  CurrentSemesterCubit(this._service) : super(CurrentSemesterInitial());

  Future<void> fetchCurrentSemester() async {
    emit(CurrentSemesterLoading());
    try {
      final semester = await _service.getCurrentSemester();
      emit(CurrentSemesterSuccess(semester));
    } catch (e) {
      // إزالة كلمة Exception الزائدة إن وجدت لعرض رسالة خطأ نظيفة
      emit(CurrentSemesterError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}