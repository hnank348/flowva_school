abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> data;
  final String message;
  LoginSuccess({required this.data, required this.message});
}

class LoginError extends LoginState {
  final String errorMessage;
  LoginError({required this.errorMessage});
}