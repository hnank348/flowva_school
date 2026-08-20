import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/supervisor/inspection_service.dart';
import 'current_inspection_state.dart';

class CurrentInspectionCubit extends Cubit<CurrentInspectionState> {
  final InspectionService _service;

  CurrentInspectionCubit(this._service) : super(CurrentInspectionInitial());

  Future<void> fetchCurrentProgram({required String Function(String key) tr}) async {
    emit(CurrentInspectionLoading());
    try {
      final program = await _service.getCurrentInspectionProgram(tr: tr);
      emit(CurrentInspectionLoaded(program));
    } catch (e) {
      emit(CurrentInspectionError(e.toString()));
    }
  }

  Future<void> updateStatus({
    required int programId,
    required String newStatus,
    required String Function(String key) tr,
  }) async {
    emit(CurrentInspectionLoading());
    try {
      await _service.updateProgramStatus(
        programId: programId,
        status: newStatus,
        tr: tr,
      );
      final program = await _service.getCurrentInspectionProgram(tr: tr);
      emit(CurrentInspectionLoaded(program));
    } catch (e) {
      emit(CurrentInspectionError(e.toString()));
    }
  }
}