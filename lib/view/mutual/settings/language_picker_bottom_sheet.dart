import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/locale/locale_cubit.dart';
import '../../../app_localizations.dart';

class LanguagePickerBottomSheet extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool isDark;
  final String currentLang;

  const LanguagePickerBottomSheet({
    super.key,
    required this.colorScheme,
    required this.isDark,
    required this.currentLang,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              context.tr('settings_language'),
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // خيار اللغة العربية
            ListTile(
              leading: Icon(Icons.language_rounded, color: colorScheme.primary),
              title: const Text(
                'العربية',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w600),
              ),
              trailing: currentLang == 'AR'
                  ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
                  : null,
              onTap: () {
                context.read<LocaleCubit>().changeLanguage('AR');
                Navigator.pop(context);
              },
            ),
            Divider(color: colorScheme.outlineVariant.withOpacity(0.4), height: 1),

            // خيار اللغة الإنجليزية
            ListTile(
              leading: Icon(Icons.language_rounded, color: colorScheme.primary),
              title: const Text(
                'English',
                style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w600),
              ),
              trailing: currentLang == 'EN'
                  ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
                  : null,
              onTap: () {
                context.read<LocaleCubit>().changeLanguage('EN');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}