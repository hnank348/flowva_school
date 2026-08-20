abstract class SubmitObservationState {}

class SubmitObservationInitial extends SubmitObservationState {}

class SubmitObservationLoading extends SubmitObservationState {}

class SubmitObservationSuccess extends SubmitObservationState {
  final String message;
  SubmitObservationSuccess(this.message);
}

class SubmitObservationError extends SubmitObservationState {
  final String message;
  SubmitObservationError(this.message);
}