import 'package:flutter/material.dart';
import 'package:flowva_school/app_localizations.dart';

class CustomConfirmationDialog {
  static Future<bool?> show(
      BuildContext context, {
        required String titleKey,
        required String bodyKey,
        required String confirmBtnKey,
        String cancelBtnKey = 'session_btn_cancel',
        bool isDanger = true,
      }) {
    final colorScheme = Theme.of(context).colorScheme;

    return showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          context.tr(titleKey),
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Text(
          context.tr(bodyKey),
          style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: Text(
              context.tr(cancelBtnKey),
              style: TextStyle(
                fontFamily: 'Cairo',
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: Text(
              context.tr(confirmBtnKey),
              style: TextStyle(
                fontFamily: 'Cairo',
                color: isDanger ? colorScheme.error : colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}