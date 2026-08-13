import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';

const String kLanguageKey = 'app_language';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit()
      : super(
    LocaleState(
      currentLanguage: 'AR',
      localizedStrings: {},
      textDirection: TextDirection.rtl,
    ),
  );

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(kLanguageKey) ?? 'AR';
    await _loadLocalizedStrings(savedLanguage);
  }

  Future<void> _loadLocalizedStrings(String languageCode) async {
    // 🟢 تحويل رمز اللغة لحروف كبيرة دائماً لتنفيذ المطابقة الدقيقة مع الملفات EN.json و AR.json
    final formattedCode = languageCode.toUpperCase();

    try {
      final jsonString = await rootBundle.loadString(
        'assets/locales/$formattedCode.json',
      );
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      emit(
        state.copyWith(
          currentLanguage: formattedCode,
          localizedStrings: jsonMap,
          textDirection: formattedCode == 'AR'
              ? TextDirection.rtl
              : TextDirection.ltr,
          isLoaded: true,
        ),
      );
    } on Exception catch (e) {
      log('❌ [LocaleCubit] error loading language "$formattedCode": $e');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    final formattedCode = languageCode.toUpperCase();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kLanguageKey, formattedCode);
    await _loadLocalizedStrings(formattedCode);
  }

  String translate(String key) {
    return state.localizedStrings[key]?.toString() ?? key;
  }
}