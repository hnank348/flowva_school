// current_year_state.dart

import '../../models/academic_year_model.dart';

abstract class CurrentYearState {}

class CurrentYearInitial extends CurrentYearState {}
class CurrentYearLoading extends CurrentYearState {}
class CurrentYearSuccess extends CurrentYearState {
  final AcademicYearModel currentYear;
  CurrentYearSuccess(this.currentYear);
}
class CurrentYearError extends CurrentYearState {
  final String errorMessage;
  CurrentYearError(this.errorMessage);
}