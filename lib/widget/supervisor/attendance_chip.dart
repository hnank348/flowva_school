import 'package:flutter/material.dart';

class GenericAttendanceChip extends StatelessWidget {
  final String label;
  final Color activeColor;
  final Color activeBg;
  final bool isSelected;
  final VoidCallback onTap;
  final double height;
  final double fontSize;

  const GenericAttendanceChip({
    super.key,
    required this.label,
    required this.activeColor,
    required this.activeBg,
    required this.isSelected,
    required this.onTap,
    this.height = 30,
    this.fontSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          height: height,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 3), // ✅ هامش داخلي بسيط
          decoration: BoxDecoration(
            color: isSelected
                ? activeBg.withOpacity(isDark ? 0.25 : 1.0)
                : (isDark ? cs.surfaceContainer : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? activeColor.withOpacity(isDark ? 0.7 : 1.0)
                  : cs.outlineVariant.withOpacity(0.4),
              width: isSelected ? 1.2 : 0.8,
            ),
          ),
          // ✅ هاد هو الحل: يصغّر الخط أوتوماتيكياً بدل ما يلف لسطر تاني
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: fontSize,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : cs.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}