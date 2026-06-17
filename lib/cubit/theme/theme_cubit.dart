import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  bool isDarkMode = false;

  ThemeCubit() : super(ThemeInitial()) {
    loadTheme();
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool("isDark") ?? false;
    if (isDarkMode) {
      emit(DarkModeState());
    } else {
      emit(LightModeState());
    }
  }

  // 🔄 دالة التبديل
  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    isDarkMode = !isDarkMode;
    await prefs.setBool("isDark", isDarkMode);

    if (isDarkMode) {
      emit(DarkModeState());
    } else {
      emit(LightModeState());
    }
  }
}