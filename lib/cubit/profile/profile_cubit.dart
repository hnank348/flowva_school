import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';
import 'package:flowva_school/services/auth/profile_service.dart'; // مسار السيرفس الجديد

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService _profileService;

  ProfileCubit(this._profileService) : super(ProfileInitial());

  Future<void> fetchUserProfile({String? token}) async {
    emit(ProfileLoading());
    try {
      final user = await _profileService.getUserProfile(token: token,tr: context.tr,);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }
}