import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/supervisor/inspection_service.dart';
import 'submit_observation_state.dart';

class SubmitObservationCubit extends Cubit<SubmitObservationState> {
  final InspectionService _service;

  SubmitObservationCubit(this._service) : super(SubmitObservationInitial());

  Future<void> submitObservation({
    required int programId,
    required String objectives,
    required String result,
    required String Function(String key) tr,
  }) async {
    emit(SubmitObservationLoading());
    try {
      await _service.submitObservation(
        programId: programId,
        objectives: objectives,
        result: result,
        tr: tr,
      );
      emit(SubmitObservationSuccess(tr('observation_submitted_success')));
    } catch (e) {
      emit(SubmitObservationError(e.toString()));
    }
  }
}