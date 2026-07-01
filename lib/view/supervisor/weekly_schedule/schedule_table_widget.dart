import 'package:flutter/material.dart';
import '../../../models/supervisor/schedule_session_model.dart';
import 'edit_session_bottom_sheet.dart';
import '../../../app_localizations.dart';

class ScheduleTableWidget extends StatelessWidget {
  final List<ScheduleSessionModel> sessions;
  final int sectionId;
  final String className;
  final int semesterId;
  final String currentLanguage; // 🌍 نمرر اللغة الحالية لضمان دقة الفحص والترجمة الحية

  const ScheduleTableWidget({
    super.key,
    required this.sessions,
    required this.sectionId,
    required this.className,
    required this.semesterId,
    required this.currentLanguage,
  });

  // 🔄 فحص الأيام بشكل مرن يدعم ما يرسله السيرفر (سواء أرسلها كـ الاسم أو اليوم بالكامل)
  ScheduleSessionModel? _findSession(String dayKey, int period) {
    try {
      return sessions.firstWhere(
            (s) {
          final dbDay = s.dayOfWeek.trim().toLowerCase();
          final targetDay = dayKey.trim().toLowerCase();

          // دعم الفحص باللغة الإنجليزية أو العربية المعادة من السيرفر
          bool isMatchingDay = dbDay == targetDay;
          if (targetDay == 'sunday') isMatchingDay = isMatchingDay || dbDay == 'الأحد' || dbDay == 'الاحد';
          if (targetDay == 'monday') isMatchingDay = isMatchingDay || dbDay == 'الاثنين' || dbDay == 'الإثنين';
          if (targetDay == 'tuesday') isMatchingDay = isMatchingDay || dbDay == 'الثلاثاء';
          if (targetDay == 'wednesday') isMatchingDay = isMatchingDay || dbDay == 'الأربعاء' || dbDay == 'الاربعاء';
          if (targetDay == 'thursday') isMatchingDay = isMatchingDay || dbDay == 'الخميس';

          return isMatchingDay && s.periodNumber == period && s.semesterId == semesterId;
        },
      );
    } catch (_) {
      return null;
    }
  }

  // 🎨 تم التعديل لفحص اللغتين معاً داخل الموديل لضمان استقرار الألوان بناء على جدول المواد والأساتذة
  Color _getSubjectBackgroundColor(BuildContext context, ApiSubjectModel? subject) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (subject == null) return isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    final nameEn = subject.name.toLowerCase();
    final nameAr = subject.nameAr;

    if (nameEn.contains('math') || nameAr.contains('رياضيات')) return isDark ? const Color(0xFF07263E) : const Color(0xFFBAE6FD);
    if (nameEn.contains('arabic') || nameAr.contains('عربي') || nameEn.contains('language')) return isDark ? const Color(0xFF062D17) : const Color(0xFFBBF7D0);
    if (nameEn.contains('science') || nameAr.contains('علوم')) return isDark ? const Color(0xFF25103F) : const Color(0xFFE9D5FF);
    if (nameEn.contains('english') || nameAr.contains('إنجليزي') || nameAr.contains('انجليزي')) return isDark ? const Color(0xFF3B0717) : const Color(0xFFFECDD3);
    if (nameEn.contains('sport') || nameAr.contains('رياضة')) return isDark ? const Color(0xFF07263E) : const Color(0xFFBAE6FD);
    if (nameEn.contains('islamic') || nameAr.contains('إسلامية') || nameAr.contains('اسلامية') || nameEn.contains('studies')) return isDark ? const Color(0xFF064E3B) : const Color(0xFFCCFBF1);
    if (nameEn.contains('social') || nameAr.contains('اجتماعيات') || nameAr.contains('اجتماعية')) return isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);

    return isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
  }

  Color _getSubjectTextColor(BuildContext context, ApiSubjectModel? subject) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (subject == null) return isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155);

    final nameEn = subject.name.toLowerCase();
    final nameAr = subject.nameAr;

    if (nameEn.contains('math') || nameAr.contains('رياضيات')) return isDark ? const Color(0xFF38BDF8) : const Color(0xFF0C4A6E);
    if (nameEn.contains('arabic') || nameAr.contains('عربي') || nameEn.contains('language')) return isDark ? const Color(0xFF4ADE80) : const Color(0xFF14532D);
    if (nameEn.contains('science') || nameAr.contains('علوم')) return isDark ? const Color(0xFFC084FC) : const Color(0xFF581C87);
    if (nameEn.contains('english') || nameAr.contains('إنجليزي') || nameAr.contains('انجليزي')) return isDark ? const Color(0xFFFB7185) : const Color(0xFF881337);
    if (nameEn.contains('islamic') || nameAr.contains('إسلامية') || nameAr.contains('اسلامية') || nameEn.contains('studies')) return isDark ? const Color(0xFF2DD4BF) : const Color(0xFF115E59);
    if (nameEn.contains('social') || nameAr.contains('اجتماعيات') || nameAr.contains('اجتماعية')) return isDark ? const Color(0xFFF87171) : const Color(0xFF991B1B);

    return isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
  }

  Color _getDayHeaderColor(BuildContext context, String day) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) return Theme.of(context).colorScheme.surfaceContainerHigh;

    switch (day.toLowerCase()) {
      case 'sunday': return const Color(0xFFF8FAFC);
      case 'monday': return const Color(0xFFEDF2F7);
      case 'tuesday': return const Color(0xFFE6FFFA);
      case 'wednesday': return const Color(0xFFFAF5FF);
      case 'thursday': return const Color(0xFFFEFCBF);
      default: return const Color(0xFFF8FAFC);
    }
  }

  Color _getDayTextColor(BuildContext context, String day) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) return Theme.of(context).colorScheme.onSurface;
    switch (day.toLowerCase()) {
      case 'monday': return const Color(0xFF2D3748);
      case 'tuesday': return const Color(0xFF047481);
      case 'wednesday': return const Color(0xFF553C9A);
      case 'thursday': return const Color(0xFF744210);
      default: return const Color(0xFF2D3748);
    }
  }

  Widget _buildTimeCell(BuildContext context, String title, String time) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainer : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? colorScheme.outlineVariant.withOpacity(0.5) : const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: isDark ? colorScheme.onSurface : const Color(0xFF334155)),
          ),
          const SizedBox(height: 3),
          Text(
            time,
            style: TextStyle(fontSize: 9, color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B), fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
          ),
        ],
      ),
    );
  }

  Widget _buildRestCell(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 58,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF451A03), const Color(0xFF78350F).withOpacity(0.6)]
              : [const Color(0xFFFEF3C7), const Color(0xFFFFFBEB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF78350F) : const Color(0xFFFDE68A),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.coffee_rounded, size: 15, color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706)),
          const SizedBox(width: 6),
          Text(
            context.tr('table_rest_text'),
            style: TextStyle(
              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
              fontSize: 11,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicCell(BuildContext context, String day, int period) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final session = _findSession(day, period);

    if (session != null) {
      // 🌍 جلب الاسم الصحيح بناءً على لغة واجهة التطبيق الحالية
      final isArabic = currentLanguage == 'ar';
      final subjectName = isArabic
          ? (session.subject?.nameAr.isNotEmpty == true ? session.subject?.nameAr : session.subject?.name)
          : (session.subject?.name.isNotEmpty == true ? session.subject?.name : session.subject?.nameAr);

      final bgColor = _getSubjectBackgroundColor(context, session.subject);
      final textColor = _getSubjectTextColor(context, session.subject);

      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(isDark ? 0.1 : 0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => EditSessionBottomSheet.show(
              context,
              sessionId: session.id,
              currentSubjectId: session.subject?.id,
              currentTeacherId: session.teacher?.id,
              currentSubject: subjectName ?? context.tr('table_unknown_subject'),
              currentTeacher: session.teacher?.fullName ?? context.tr('table_no_teacher'),
              currentRoom: session.roomNumber,
              sectionId: sectionId,
              className: className,
              dayOfWeek: day,
              periodNumber: period,
              semesterId: semesterId,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                color: bgColor,
                border: Border(
                  right: isArabic ? BorderSide.none : BorderSide(color: textColor.withOpacity(0.5), width: 4),
                  left: isArabic ? BorderSide(color: textColor.withOpacity(0.5), width: 4) : BorderSide.none,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    subjectName ?? context.tr('table_unknown_subject'),
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 🌟 تم إزالة أيقونة الأستاذ بنجاح بناءً على طلبك
                      Expanded(
                        child: Text(
                          session.teacher?.fullName ?? context.tr('table_no_teacher'),
                          style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 9, fontFamily: 'Cairo', fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: textColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${context.tr('table_room')} ${session.roomNumber}',
                      style: TextStyle(color: textColor, fontSize: 8, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.all(5),
        height: 70,
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surfaceContainerLow : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? colorScheme.outlineVariant.withOpacity(0.5) : const Color(0xFFE2E8F0), width: 1.2),
        ),
        child: InkWell(
          onTap: () => EditSessionBottomSheet.show(
            context,
            sessionId: null,
            currentSubject: '',
            currentTeacher: '',
            currentRoom: '',
            sectionId: sectionId,
            className: className,
            dayOfWeek: day,
            periodNumber: period,
            semesterId: semesterId,
            currentSubjectId: null,
            currentTeacherId: null,
          ),
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Icon(Icons.add_rounded, color: isDark ? colorScheme.onSurfaceVariant.withOpacity(0.6) : const Color(0xFF94A3B8), size: 24),
          ),
        ),
      );
    }
  }

  Widget _buildDayHeader(BuildContext context, String dayName, String dayKey) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        color: _getDayHeaderColor(context, dayKey),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? colorScheme.outlineVariant.withOpacity(0.4) : const Color(0xFFE2E8F0).withOpacity(0.5), width: 1),
      ),
      child: Text(
        dayName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: _getDayTextColor(context, dayKey),
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  List<Widget> _buildTableRowCells({required Widget timeCell, required List<Widget> dayCells}) {
    if (currentLanguage == 'ar') {
      return [...dayCells.reversed, timeCell];
    } else {
      return [timeCell, ...dayCells];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double finalWidth = constraints.maxWidth > 800 ? constraints.maxWidth : 800.0;
        final double cellWidth = finalWidth / 6;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? colorScheme.surfaceContainerLow : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: finalWidth,
                padding: const EdgeInsets.all(6),
                child: Table(
                  defaultColumnWidth: FixedColumnWidth(cellWidth),
                  border: TableBorder.all(color: Colors.transparent, width: 0),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: _buildTableRowCells(
                        timeCell: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: isDark ? colorScheme.onSurfaceVariant.withOpacity(0.2) : const Color(0xFF334155),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isDark ? colorScheme.outlineVariant.withOpacity(0.4) : Colors.transparent),
                          ),
                          child: Text(
                            context.tr('table_header_time'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white, fontFamily: 'Cairo'),
                          ),
                        ),
                        dayCells: [
                          _buildDayHeader(context, context.tr('day_sunday'), 'sunday'),
                          _buildDayHeader(context, context.tr('day_monday'), 'monday'),
                          _buildDayHeader(context, context.tr('day_tuesday'), 'tuesday'),
                          _buildDayHeader(context, context.tr('day_wednesday'), 'wednesday'),
                          _buildDayHeader(context, context.tr('day_thursday'), 'thursday'),
                        ],
                      ),
                    ),
                    TableRow(
                      children: _buildTableRowCells(
                        timeCell: _buildTimeCell(context, context.tr('period_1'), '8:15 - 7:30'),
                        dayCells: [
                          _buildDynamicCell(context, 'sunday', 1),
                          _buildDynamicCell(context, 'monday', 1),
                          _buildDynamicCell(context, 'tuesday', 1),
                          _buildDynamicCell(context, 'wednesday', 1),
                          _buildDynamicCell(context, 'thursday', 1),
                        ],
                      ),
                    ),
                    TableRow(
                      children: _buildTableRowCells(
                        timeCell: _buildTimeCell(context, context.tr('period_2'), '9:05 - 8:20'),
                        dayCells: [
                          _buildDynamicCell(context, 'sunday', 2),
                          _buildDynamicCell(context, 'monday', 2),
                          _buildDynamicCell(context, 'tuesday', 2),
                          _buildDynamicCell(context, 'wednesday', 2),
                          _buildDynamicCell(context, 'thursday', 2),
                        ],
                      ),
                    ),
                    TableRow(
                      children: _buildTableRowCells(
                        timeCell: _buildTimeCell(context, '${context.tr('table_rest_text')} ١', '9:35 - 9:05'),
                        dayCells: [
                          _buildRestCell(context),
                          _buildRestCell(context),
                          _buildRestCell(context),
                          _buildRestCell(context),
                          _buildRestCell(context),
                        ],
                      ),
                    ),
                    TableRow(
                      children: _buildTableRowCells(
                        timeCell: _buildTimeCell(context, context.tr('period_3'), '10:20 - 9:35'),
                        dayCells: [
                          _buildDynamicCell(context, 'sunday', 3),
                          _buildDynamicCell(context, 'monday', 3),
                          _buildDynamicCell(context, 'tuesday', 3),
                          _buildDynamicCell(context, 'wednesday', 3),
                          _buildDynamicCell(context, 'thursday', 3),
                        ],
                      ),
                    ),
                    TableRow(
                      children: _buildTableRowCells(
                        timeCell: _buildTimeCell(context, context.tr('period_4'), '11:05 - 10:20'),
                        dayCells: [
                          _buildDynamicCell(context, 'sunday', 4),
                          _buildDynamicCell(context, 'monday', 4),
                          _buildDynamicCell(context, 'tuesday', 4),
                          _buildDynamicCell(context, 'wednesday', 4),
                          _buildDynamicCell(context, 'thursday', 4),
                        ],
                      ),
                    ),
                    TableRow(
                      children: _buildTableRowCells(
                        timeCell: _buildTimeCell(context, '${context.tr('table_rest_text')} ٢', '11:30 - 11:05'),
                        dayCells: [
                          _buildRestCell(context),
                          _buildRestCell(context),
                          _buildRestCell(context),
                          _buildRestCell(context),
                          _buildRestCell(context),
                        ],
                      ),
                    ),
                    TableRow(
                      children: _buildTableRowCells(
                        timeCell: _buildTimeCell(context, context.tr('period_5'), '12:15 - 11:30'),
                        dayCells: [
                          _buildDynamicCell(context, 'sunday', 5),
                          _buildDynamicCell(context, 'monday', 5),
                          _buildDynamicCell(context, 'tuesday', 5),
                          _buildDynamicCell(context, 'wednesday', 5),
                          _buildDynamicCell(context, 'thursday', 5),
                        ],
                      ),
                    ),
                    TableRow(
                      children: _buildTableRowCells(
                        timeCell: _buildTimeCell(context, context.tr('period_6'), '1:00 - 12:15'),
                        dayCells: [
                          _buildDynamicCell(context, 'sunday', 6),
                          _buildDynamicCell(context, 'monday', 6),
                          _buildDynamicCell(context, 'tuesday', 6),
                          _buildDynamicCell(context, 'wednesday', 6),
                          _buildDynamicCell(context, 'thursday', 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}