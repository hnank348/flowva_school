import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/profile/profile_update_state.dart';
import 'package:flowva_school/cubit/profile/profile_cubit.dart';
import 'package:flowva_school/services/auth/profile_service.dart';

export 'package:flowva_school/cubit/profile/profile_update_state.dart';

class ProfileUpdateCubit extends Cubit<ProfileUpdateState> {
  final ProfileService _profileService;
  final ProfileCubit _profileCubit;

  ProfileUpdateCubit(this._profileService, this._profileCubit)
      : super(ProfileUpdateInitial());

  Future<void> updateProfile({
    required int userId,
    required String userToken,
    String? firstName,
    String? firstNameAr,
    String? lastName,
    String? lastNameAr,
    String? phone,
    String? dateOfBirth,
    File? avatar,
  }) async {
    emit(ProfileUpdateLoading());

    try {
      await _profileService.updateUserProfile(
        userId:       userId,
        firstName:    firstName?.isNotEmpty == true ? firstName : null,
        firstNameAr:  firstNameAr?.isNotEmpty == true ? firstNameAr : null,
        lastName:     lastName?.isNotEmpty == true ? lastName : null,
        lastNameAr:   lastNameAr?.isNotEmpty == true ? lastNameAr : null,
        phone:        phone?.isNotEmpty == true ? phone : null,
        dateOfBirth:  dateOfBirth?.isNotEmpty == true ? dateOfBirth : null,
        avatar:       avatar,
      );

      await _profileCubit.fetchUserProfile(token: userToken);

      emit(ProfileUpdateSuccess('تم تحديث الملف الشخصي بنجاح ✓'));
    } catch (e) {
      emit(ProfileUpdateError(e.toString()));
    }
  }

  void reset() => emit(ProfileUpdateInitial());
}