import 'dart:io';

abstract class ProfileUpdateState {
  final bool isEditing;
  final File? pickedImage;

  const ProfileUpdateState({this.isEditing = false, this.pickedImage});
}

class ProfileUpdateInitial extends ProfileUpdateState {
  const ProfileUpdateInitial({super.isEditing, super.pickedImage});
}

class ProfileUpdateLoading extends ProfileUpdateState {
  const ProfileUpdateLoading({super.isEditing, super.pickedImage});
}

class ProfileUpdateSuccess extends ProfileUpdateState {
  final String message;
  const ProfileUpdateSuccess(this.message, {super.isEditing = false, super.pickedImage = null});
}

class ProfileUpdateError extends ProfileUpdateState {
  final String errorMessage;
  const ProfileUpdateError(this.errorMessage, {super.isEditing, super.pickedImage});
}