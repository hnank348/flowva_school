import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class TeacherBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const TeacherBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _icons = [
    Icons.home_outlined,
    Icons.calendar_view_week_rounded,
    Icons.menu_book_outlined,
    Icons.people_outline,
    Icons.chat_bubble_outline,
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: CurvedNavigationBar(
        index: currentIndex,
        height: 52,
        backgroundColor: Colors.transparent,
        color: isDark ? cs.surfaceContainer : cs.primary,
        buttonBackgroundColor: isDark ? cs.primary : Colors.white,
        animationDuration: const Duration(milliseconds: 350),
        animationCurve: Curves.easeOutCubic,
        onTap: onTap,
        items: List.generate(_icons.length, (i) {
          final isSelected = i == currentIndex;
          final iconColor = isSelected
              ? (isDark ? Colors.white : cs.primary)
              : Colors.white.withValues(alpha: 0.85);

          return Icon(_icons[i], size: 20, color: iconColor);
        }),
      ),
    );
  }
}
