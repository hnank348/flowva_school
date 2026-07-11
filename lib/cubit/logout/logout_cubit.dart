import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flowva_school/cubit/logout/logout_state.dart';
import 'package:flowva_school/services/auth/logout_service.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutService _logoutService;

  LogoutCubit(this._logoutService) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());

    final result = await _logoutService.logout();

    if (result['success']) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userToken');

      emit(LogoutSuccess());
    } else {
      emit(LogoutError(errorMessage: result['message']));
    }
  }
}