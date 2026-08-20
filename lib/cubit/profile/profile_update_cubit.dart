import 'dart:io';
import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/profile/profile_update_state.dart';
import 'package:flowva_school/cubit/profile/profile_cubit.dart';
import 'package:flowva_school/services/auth/profile_service.dart';

export 'package:flowva_school/cubit/profile/profile_update_state.dart';

class ProfileUpdateCubit extends Cubit<ProfileUpdateState> {
  final ProfileService _profileService;

  ProfileUpdateCubit(this._profileService, ProfileCubit profileCubit)
      : super(const ProfileUpdateInitial());

  void toggleEditing(bool isEditing) {
    emit(ProfileUpdateInitial(
      isEditing: isEditing,
      pickedImage: isEditing ? state.pickedImage : null,
    ));
  }

  void setPickedImage(File image) {
    emit(ProfileUpdateInitial(
      isEditing: true,
      pickedImage: image,
    ));
  }

  Future<void> updateProfile({
    required int userId,
    required String userToken,
    required String Function(String key) tr,
    String? firstName,
    String? firstNameAr,
    String? lastName,
    String? lastNameAr,
    String? phone,
    String? dateOfBirth,
  }) async {
    final currentImage = state.pickedImage;
    emit(ProfileUpdateLoading(isEditing: state.isEditing, pickedImage: currentImage));

    try {
      await _profileService.updateUserProfile(
        userId:       userId,
        firstName:    firstName?.isNotEmpty == true ? firstName : null,
        firstNameAr:  firstNameAr?.isNotEmpty == true ? firstNameAr : null,
        lastName:     lastName?.isNotEmpty == true ? lastName : null,
        lastNameAr:   lastNameAr?.isNotEmpty == true ? lastNameAr : null,
        phone:        phone?.isNotEmpty == true ? phone : null,
        dateOfBirth:  dateOfBirth?.isNotEmpty == true ? dateOfBirth : null,
        avatar:       currentImage,
        tr:           context.tr,
      );

      emit(ProfileUpdateSuccess(tr('profile_update_success')));
    } catch (e) {
      emit(ProfileUpdateError(
        e.toString().replaceAll('Exception: ', ''),
        isEditing: true,
        pickedImage: currentImage,
      ));
    }
  }

  void reset() => emit(const ProfileUpdateInitial());
}