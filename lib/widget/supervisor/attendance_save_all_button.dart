import 'package:flutter/material.dart';
import 'package:flowva_school/app_localizations.dart';

class AttendanceSaveAllButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const AttendanceSaveAllButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isLoading ? Colors.white.withOpacity(0.5) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: isLoading
              ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  color: cs.primary, strokeWidth: 2))
              : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_rounded, color: cs.primary, size: 15),
              const SizedBox(width: 5),
              Text(
                context.tr('attendance_save'),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}