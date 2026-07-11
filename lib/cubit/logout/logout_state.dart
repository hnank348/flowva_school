abstract class LogoutState {}

class LogoutInitial extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutSuccess extends LogoutState {}

class LogoutError extends LogoutState {
  final String errorMessage;
  LogoutError({required this.errorMessage});
}