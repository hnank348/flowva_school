abstract class SubmitAttendanceState {
  const SubmitAttendanceState();
}

class SubmitAttendanceInitial extends SubmitAttendanceState {
  const SubmitAttendanceInitial();
}

class SubmitAttendanceLoading extends SubmitAttendanceState {
  const SubmitAttendanceLoading();
}

class SubmitAttendanceSuccess extends SubmitAttendanceState {
  final String message;
  const SubmitAttendanceSuccess(this.message);
}

class SubmitAttendanceError extends SubmitAttendanceState {
  final String errorMessage;
  const SubmitAttendanceError(this.errorMessage);
}