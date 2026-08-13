import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'current_semester_state.dart';
import '../../services/mutual/semester_service.dart';

class CurrentSemesterCubit extends Cubit<CurrentSemesterState> {
  final SemesterService _service;

  CurrentSemesterCubit(this._service) : super(CurrentSemesterInitial());

  Future<void> fetchCurrentSemester() async {
    emit(CurrentSemesterLoading());
    try {
      final semester = await _service.getCurrentSemester(tr: context.tr,);
      emit(CurrentSemesterSuccess(semester));
    } catch (e) {
      emit(CurrentSemesterError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}