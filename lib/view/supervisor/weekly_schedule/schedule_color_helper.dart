import 'package:flutter/material.dart';
import '../../../models/supervisor/schedule_session_model.dart';

class ScheduleColorHelper {
  const ScheduleColorHelper._();

  static Color subjectBackground(BuildContext context, ApiSubjectModel? subject) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (subject == null) {
      return isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    }
    final en = subject.name.toLowerCase();
    final ar = subject.nameAr;

    if (en.contains('math')     || ar.contains('رياضيات'))                          return isDark ? const Color(0xFF07263E) : const Color(0xFFBAE6FD);
    if (en.contains('arabic')   || ar.contains('عربي') || en.contains('language'))  return isDark ? const Color(0xFF062D17) : const Color(0xFFBBF7D0);
    if (en.contains('science')  || ar.contains('علوم'))                             return isDark ? const Color(0xFF25103F) : const Color(0xFFE9D5FF);
    if (en.contains('english')  || ar.contains('إنجليزي') || ar.contains('انجليزي')) return isDark ? const Color(0xFF3B0717) : const Color(0xFFFECDD3);
    if (en.contains('sport')    || ar.contains('رياضة'))                             return isDark ? const Color(0xFF07263E) : const Color(0xFFBAE6FD);
    if (en.contains('islamic')  || ar.contains('إسلامية') || ar.contains('اسلامية') || en.contains('studies')) return isDark ? const Color(0xFF064E3B) : const Color(0xFFCCFBF1);
    if (en.contains('social')   || ar.contains('اجتماعيات') || ar.contains('اجتماعية')) return isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
    return isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
  }

  static Color subjectText(BuildContext context, ApiSubjectModel? subject) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (subject == null) {
      return isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155);
    }
    final en = subject.name.toLowerCase();
    final ar = subject.nameAr;

    if (en.contains('math')     || ar.contains('رياضيات'))                          return isDark ? const Color(0xFF38BDF8) : const Color(0xFF0C4A6E);
    if (en.contains('arabic')   || ar.contains('عربي') || en.contains('language'))  return isDark ? const Color(0xFF4ADE80) : const Color(0xFF14532D);
    if (en.contains('science')  || ar.contains('علوم'))                             return isDark ? const Color(0xFFC084FC) : const Color(0xFF581C87);
    if (en.contains('english')  || ar.contains('إنجليزي') || ar.contains('انجليزي')) return isDark ? const Color(0xFFFB7185) : const Color(0xFF881337);
    if (en.contains('islamic')  || ar.contains('إسلامية') || ar.contains('اسلامية') || en.contains('studies')) return isDark ? const Color(0xFF2DD4BF) : const Color(0xFF115E59);
    if (en.contains('social')   || ar.contains('اجتماعيات') || ar.contains('اجتماعية')) return isDark ? const Color(0xFFF87171) : const Color(0xFF991B1B);
    return isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
  }

  static Color dayHeader(BuildContext context, String dayKey) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) return Theme.of(context).colorScheme.surfaceContainerHigh;
    switch (dayKey.toLowerCase()) {
      case 'sunday':    return const Color(0xFFF8FAFC);
      case 'monday':    return const Color(0xFFEDF2F7);
      case 'tuesday':   return const Color(0xFFE6FFFA);
      case 'wednesday': return const Color(0xFFFAF5FF);
      case 'thursday':  return const Color(0xFFFEFCBF);
      default:          return const Color(0xFFF8FAFC);
    }
  }

  static Color dayText(BuildContext context, String dayKey) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) return Theme.of(context).colorScheme.onSurface;
    switch (dayKey.toLowerCase()) {
      case 'monday':    return const Color(0xFF2D3748);
      case 'tuesday':   return const Color(0xFF047481);
      case 'wednesday': return const Color(0xFF553C9A);
      case 'thursday':  return const Color(0xFF744210);
      default:          return const Color(0xFF2D3748);
    }
  }
}