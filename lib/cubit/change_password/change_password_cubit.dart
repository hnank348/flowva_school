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
  }) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(ChangePasswordError('الرجاء ملء جميع الحقول المطلوبة'));
      return;
    }

    if (newPassword.length < 8) {
      emit(ChangePasswordError('يجب أن تتكون كلمة المرور من 8 أحرف على الأقل'));
      return;
    }

    if (newPassword != confirmPassword) {
      emit(ChangePasswordError('كلمتا المرور غير متطابقتين'));
      return;
    }

    emit(ChangePasswordLoading());

    final result = await _service.changePassword(
      userId: userId,
      newPassword: newPassword,
      newPasswordConfirmation: confirmPassword,
    );

    if (result['success'] == true) {
      emit(ChangePasswordSuccess(result['message']));
    } else {
      emit(ChangePasswordError(result['message']));
    }
  }

  void reset() => emit(ChangePasswordInitial());
}