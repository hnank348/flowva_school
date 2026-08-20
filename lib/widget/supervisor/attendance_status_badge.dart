import 'package:flutter/material.dart';
import 'attendance_types.dart';

class GenericAttendanceStatusBadge extends StatelessWidget {
  final AttendanceStatusStyle style;
  final String label;
  final VoidCallback onEditTap;

  const GenericAttendanceStatusBadge({
    super.key,
    required this.style,
    required this.label,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? Color.lerp(style.accent, Colors.white, 0.35)!
        : style.accent;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? style.bgDark : style.bg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: style.accent.withOpacity(isDark ? 0.5 : 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(style.icon, size: 14, color: textColor),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: onEditTap,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.edit_rounded, size: 14, color: cs.primary),
          ),
        ),
      ],
    );
  }
}