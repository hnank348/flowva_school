import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/login/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../services/auth/login_services.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginService _loginService = LoginService();

  LoginCubit() : super(LoginInitial());

  Future<void> loginUser({
    required String email,
    required String password,
    required String Function(String key) tr,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      emit(LoginError(errorMessage: tr('login_fill_required_fields')));
      return;
    }

    emit(LoginLoading());

    try {
      final result = await _loginService.login(
        email: email.trim(),
        password: password.trim(),
        tr: tr,
      );

      if (result['success']) {
        final String token = result['data']['token'] ?? '';

        if (token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userToken', token);

          try {
            final String? fcmToken = await FirebaseMessaging.instance.getToken();
            if (fcmToken != null && fcmToken.isNotEmpty) {
              await prefs.setString('fcmToken', fcmToken);
              // 🟢 تم التصحيح: تمرير fcmToken و tr بشكل صحيح
              await _loginService.sendFcmToken(
                fcmToken: fcmToken,
                tr: tr,
              );
            }
          } catch (e) {
            print('⚠️ FCM Token Error: $e');
          }
        }

        emit(LoginSuccess(
          data: result['data'],
          message: result['message'],
        ));
      } else {
        emit(LoginError(errorMessage: result['message'] ?? ''));
      }
    } catch (e) {
      emit(LoginError(errorMessage: e.toString().replaceAll("Exception: ", "")));
    }
  }
}