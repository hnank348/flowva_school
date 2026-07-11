abstract class ProfileUpdateState {}

class ProfileUpdateInitial extends ProfileUpdateState {}

class ProfileUpdateLoading extends ProfileUpdateState {}

class ProfileUpdateSuccess extends ProfileUpdateState {
  final String message;
  ProfileUpdateSuccess(this.message);
}

class ProfileUpdateError extends ProfileUpdateState {
  final String errorMessage;
  ProfileUpdateError(this.errorMessage);
}