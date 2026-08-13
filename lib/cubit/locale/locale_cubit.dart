import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';

// ✅ مفتاح حفظ اللغة في SharedPreferences
const String kLanguageKey = 'app_language';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit()
      : super(
    LocaleState(
      currentLanguage: 'AR',      // الافتراضي عربي
      localizedStrings: {},
      textDirection: TextDirection.rtl,
    ),
  );

  /// يُستدعى مرة واحدة عند بدء التطبيق
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(kLanguageKey) ?? 'AR';
    await _loadLocalizedStrings(savedLanguage);
  }

  Future<void> _loadLocalizedStrings(String languageCode) async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/locales/$languageCode.json',
      );
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      emit(
        state.copyWith(
          currentLanguage:   languageCode,
          localizedStrings:  jsonMap,
          textDirection:     languageCode == 'AR'
              ? TextDirection.rtl
              : TextDirection.ltr,
          isLoaded: true,
        ),
      );
    } on Exception catch (e) {
      log('❌ [LocaleCubit] error loading language "$languageCode": $e');
    }
  }

  /// تغيير اللغة وحفظها
  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kLanguageKey, languageCode);
    await _loadLocalizedStrings(languageCode);
  }

  /// مساعد للوصول للترجمة من أي مكان
  String translate(String key) {
    return state.localizedStrings[key]?.toString() ?? key;
  }
}