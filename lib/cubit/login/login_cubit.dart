import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/login/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 💡 استيراد المكتبة
import '../../../services/auth/login_services.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginService _loginService = LoginService();

  LoginCubit() : super(LoginInitial());

  Future<void> loginUser({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      emit(LoginError(errorMessage: "الرجاء ملء جميع الحقول المطلوبة"));
      return;
    }

    emit(LoginLoading());

    final result = await _loginService.login(email.trim(), password.trim());

    if (result['success']) {
      final String token = result['data']['token'] ?? '';

      if (token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userToken', token);
      }

      emit(LoginSuccess(
        data: result['data'],
        message: result['message'],
      ));
    } else {
      emit(LoginError(errorMessage: result['message']));
    }
  }
}