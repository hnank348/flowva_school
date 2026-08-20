import 'package:flutter/material.dart';
import 'package:flowva_school/app_localizations.dart';


class AttendanceErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AttendanceErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded,
                size: 40, color: cs.error.withOpacity(0.5)),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                  fontFamily: 'Cairo', color: cs.error, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(context.tr('btn_retry'),
                    style: const TextStyle(fontFamily: 'Cairo')),
                style: TextButton.styleFrom(
                  foregroundColor: cs.primary,
                  side: BorderSide(color: cs.primary.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}