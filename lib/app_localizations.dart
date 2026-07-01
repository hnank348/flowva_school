import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';

/// اختصار الوصول للترجمة من أي Widget
/// الاستخدام: context.tr('attendance_title')
extension AppLocalizations on BuildContext {
  String tr(String key) {
    final strings = read<LocaleCubit>().state.localizedStrings;
    return strings[key]?.toString() ?? key;
  }

  TextDirection get textDir =>
      read<LocaleCubit>().state.textDirection;

  String get currentLang =>
      read<LocaleCubit>().state.currentLanguage;

  bool get isArabic =>
      read<LocaleCubit>().state.currentLanguage == 'AR';
}

/// Widget مساعد يعيد البناء عند تغيير اللغة
class TranslatedText extends StatelessWidget {
  final String translationKey;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatedText(
      this.translationKey, {
        super.key,
        this.style,
        this.textAlign,
        this.maxLines,
        this.overflow,
      });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      buildWhen: (prev, curr) =>
      prev.currentLanguage != curr.currentLanguage,
      builder: (context, _) => Text(
        context.tr(translationKey),
        style:     style,
        textAlign: textAlign,
        maxLines:  maxLines,
        overflow:  overflow,
      ),
    );
  }
}