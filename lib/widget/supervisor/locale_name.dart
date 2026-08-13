import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';

 resolveName(
    BuildContext context, {
      required String nameAr,
      required String nameEn,
    }) {
  final localeState = context.read<LocaleCubit>().state;
  final isArabic = localeState.currentLanguage.toUpperCase() == 'AR' ||
      Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';

  if (isArabic) {
    return nameAr.isNotEmpty ? nameAr : nameEn;
  }
  return nameEn.isNotEmpty ? nameEn : nameAr;
}