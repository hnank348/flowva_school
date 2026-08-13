import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/change_password/change_password_state.dart';
import 'package:flowva_school/services/auth/change_password_service.dart';

export 'package:flowva_school/cubit/change_password/change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordService _service;

  ChangePasswordCubit(this._service) : super(ChangePasswordInitial());

  Future<void> changePassword({
    required int userId,
    required String newPassword,
    required String confirmPassword,
    required String Function(String key) tr, // 🟢 استقبال دالة context.tr
  }) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(ChangePasswordError(tr('change_password_fill_fields')));
      return;
    }

    if (newPassword.length < 8) {
      emit(ChangePasswordError(tr('change_password_min_length')));
      return;
    }

    if (newPassword != confirmPassword) {
      emit(ChangePasswordError(tr('change_password_mismatch')));
      return;
    }

    emit(ChangePasswordLoading());

    try {
      final result = await _service.changePassword(
        userId: userId,
        newPassword: newPassword,
        newPasswordConfirmation: confirmPassword,
        tr: context.tr

      );

      if (result['success'] == true) {
        emit(ChangePasswordSuccess(result['message'] ?? ''));
      } else {
        emit(ChangePasswordError(result['message'] ?? ''));
      }
    } catch (e) {
      emit(ChangePasswordError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  void reset() => emit(ChangePasswordInitial());
}