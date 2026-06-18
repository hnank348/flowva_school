import 'package:flutter_bloc/flutter_bloc.dart';
import 'current_year_state.dart';
import '../../services/academic_year_service.dart';

class CurrentYearCubit extends Cubit<CurrentYearState> {
  final AcademicYearService _service;

  CurrentYearCubit(this._service) : super(CurrentYearInitial());

  // 🚀 جلب البيانات مباشرة دون الحاجة لتمرير توكن يدوي هنا
  Future<void> fetchCurrentYear() async {
    emit(CurrentYearLoading());
    try {
      final year = await _service.getCurrentYear();
      emit(CurrentYearSuccess(year));
    } catch (e) {
      emit(CurrentYearError(e.toString()));
    }
  }
}