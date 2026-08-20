import '../../../models/supervisor/inspection_program_model.dart';

abstract class CurrentInspectionState {}

class CurrentInspectionInitial extends CurrentInspectionState {}

class CurrentInspectionLoading extends CurrentInspectionState {}

class CurrentInspectionLoaded extends CurrentInspectionState {
  final InspectionProgramModel? program;
  CurrentInspectionLoaded(this.program);
}

class CurrentInspectionError extends CurrentInspectionState {
  final String message;
  CurrentInspectionError(this.message);
}