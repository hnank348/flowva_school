import 'package:flutter/material.dart';
import '../../../models/supervisor/schedule_session_model.dart';
import 'edit_session_bottom_sheet.dart';

class ScheduleTableWidget extends StatelessWidget {
  final List<ScheduleSessionModel> sessions;
  final int sectionId;
  final String className;
  final int semesterId;

  const ScheduleTableWidget({
    super.key,
    required this.sessions,
    required this.sectionId,
    required this.className,
    required this.semesterId,
  });

  ScheduleSessionModel? _findSession(String day, int period) {
    try {
      return sessions.firstWhere(
            (s) =>
        s.dayOfWeek.trim().toLowerCase() == day.trim().toLowerCase() &&
            s.periodNumber == period &&
            s.semesterId == semesterId,
      );
    } catch (_) {
      return null;
    }
  }

  Color _getSubjectBackgroundColor(BuildContext context, String? subjectName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (subjectName == null) return isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final name = subjectName.toLowerCase();

    if (name.contains('رياضيات') || name.contains('math')) {
      // لايت: أزرق حيوي مريح (أغمق من السابق) | دارك: أزرق ليل داكن وعميق
      return isDark ? const Color(0xFF07263E) : const Color(0xFFBAE6FD);
    }
    if (name.contains('عربي') || name.contains('arabic')) {
      // لايت: أخضر عشبي واضح ونقي | دارك: أخضر غاباتي داكن
      return isDark ? const Color(0xFF062D17) : const Color(0xFFBBF7D0);
    }
    if (name.contains('علوم') || name.contains('science')) {
      // لايت: بنفسجي لافندر دافئ وظاهر | دارك: بنفسجي باذنجاني عميق
      return isDark ? const Color(0xFF25103F) : const Color(0xFFE9D5FF);
    }
    if (name.contains('إنجليزي') || name.contains('english')) {
      // لايت: وردي ملحوظ وجذاب | دارك: أحمر طوبي داكن جداً
      return isDark ? const Color(0xFF3B0717) : const Color(0xFFFECDD3);
    }
    if (name.contains('رياضة') || name.contains('sport')) {
      return isDark ? const Color(0xFF07263E) : const Color(0xFFBAE6FD);
    }

    return isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
  }

  Color _getSubjectTextColor(BuildContext context, String? subjectName) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (subjectName == null) return isDark ? const Color(0xFF94A3B8) : const Color(0xFF334155);
    final name = subjectName.toLowerCase();

    if (name.contains('رياضيات') || name.contains('math')) {
      // لايت: كحلي غامق مركز | دارك: أزرق سماوي مضيء
      return isDark ? const Color(0xFF38BDF8) : const Color(0xFF0C4A6E);
    }
    if (name.contains('عربي') || name.contains('arabic')) {
      // لايت: أخضر غامق جداً ومميز | دارك: أخضر فوسفوري ناعم
      return isDark ? const Color(0xFF4ADE80) : const Color(0xFF14532D);
    }
    if (name.contains('علوم') || name.contains('science')) {
      // لايت: بنفسجي ملكي داكن | دارك: موف مضيء
      return isDark ? const Color(0xFFC084FC) : const Color(0xFF581C87);
    }
    if (name.contains('إنجليزي') || name.contains('english')) {
      // لايت: أحmer داكن صريح | دارك: وردي فاقع ناعم
      return isDark ? const Color(0xFFFB7185) : const Color(0xFF881337);
    }

    return isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
  }

  // 📅 إرجاع ألوان الأيام المبهجة المخصصة للايت مود كما كانت
  Color _getDayHeaderColor(BuildContext context, String day) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) return Theme.of(context).colorScheme.surfaceContainerHigh;

    switch (day) {
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
    switch (day) {
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
            'اسـتـراحـة',
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
      final subjectName = session.subject?.nameAr ?? session.subject?.name;
      final bgColor = _getSubjectBackgroundColor(context, subjectName);
      final textColor = _getSubjectTextColor(context, subjectName);

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
                    currentSubject: subjectName ?? 'مادة غير معرفة',
                    currentTeacher: session.teacher?.fullName ?? 'بدون معلم',
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
                    border: Border(right: BorderSide(color: textColor.withOpacity(0.5), width: 4)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        subjectName ?? 'مادة غير معرفة',
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_outline_rounded, size: 11, color: textColor.withOpacity(0.7)),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              session.teacher?.fullName ?? 'بدون معلم',
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
                          'قاعة ${session.roomNumber}',
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
            currentSubject: '',
            currentTeacher: '',
            currentRoom: '',
            sectionId: sectionId,
            className: className,
            dayOfWeek: day,
            periodNumber: period,
            semesterId: semesterId,
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
                          children: [
                          _buildDayHeader(context, 'الخميس', 'thursday'),
                      _buildDayHeader(context, 'الأربعاء', 'wednesday'),
                      _buildDayHeader(context, 'الثلاثاء', 'tuesday'),
                      _buildDayHeader(context, 'الاثنين', 'monday'),
                      _buildDayHeader(context, 'الأحد', 'sunday'),
                      Container(
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        decoration: BoxDecoration(
                          color: isDark ? colorScheme.onSurfaceVariant.withOpacity(0.2) : const Color(0xFF334155),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? colorScheme.outlineVariant.withOpacity(0.4) : Colors.transparent),
                        ),
                        child: Text(
                          'الوقت',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white, fontFamily: 'Cairo'),
                        ),
                      ),
                      ],
                    ),
                    TableRow(
                        children: [
                        _buildDynamicCell(context, 'thursday', 1), _buildDynamicCell(context, 'wednesday', 1), _buildDynamicCell(context, 'tuesday', 1), _buildDynamicCell(context, 'monday', 1), _buildDynamicCell(context, 'sunday', 1),
                          _buildTimeCell(context, 'الحصة الأولى', '8:15 - 7:30'),
                        ],
                    ),
                            TableRow(
                              children: [
                                _buildDynamicCell(context, 'thursday', 2), _buildDynamicCell(context, 'wednesday', 2), _buildDynamicCell(context, 'tuesday', 2), _buildDynamicCell(context, 'monday', 2), _buildDynamicCell(context, 'sunday', 2),
                                _buildTimeCell(context, 'الحصة الثانية', '9:05 - 8:20'),
                              ],
                            ),
                            TableRow(children: [_buildRestCell(context), _buildRestCell(context), _buildRestCell(context), _buildRestCell(context), _buildRestCell(context), _buildTimeCell(context, 'استراحة ١', '9:35 - 9:05')]),
                            TableRow(
                              children: [
                                _buildDynamicCell(context, 'thursday', 3), _buildDynamicCell(context, 'wednesday', 3), _buildDynamicCell(context, 'tuesday', 3), _buildDynamicCell(context, 'monday', 3), _buildDynamicCell(context, 'sunday', 3),
                                _buildTimeCell(context, 'الحصة الثالثة', '10:20 - 9:35'),
                              ],
                            ),
                            TableRow(
                              children: [
                                _buildDynamicCell(context, 'thursday', 4), _buildDynamicCell(context, 'wednesday', 4), _buildDynamicCell(context, 'tuesday', 4), _buildDynamicCell(context, 'monday', 4), _buildDynamicCell(context, 'sunday', 4),
                                _buildTimeCell(context, 'الحصة الرابعة', '11:05 - 10:20'),
                              ],
                            ),
                            TableRow(children: [_buildRestCell(context), _buildRestCell(context), _buildRestCell(context), _buildRestCell(context), _buildRestCell(context), _buildTimeCell(context, 'استراحة ٢', '11:30 - 11:05')]),
                            TableRow(
                              children: [
                                _buildDynamicCell(context, 'thursday', 5), _buildDynamicCell(context, 'wednesday', 5), _buildDynamicCell(context, 'tuesday', 5), _buildDynamicCell(context, 'monday', 5), _buildDynamicCell(context, 'sunday', 5),
                                _buildTimeCell(context, 'الحصة الخامسة', '12:15 - 11:30'),
                              ],
                            ),
                            TableRow(
                              children: [
                                _buildDynamicCell(context, 'thursday', 6), _buildDynamicCell(context, 'wednesday', 6), _buildDynamicCell(context, 'tuesday', 6), _buildDynamicCell(context, 'monday', 6), _buildDynamicCell(context, 'sunday', 6),
                                _buildTimeCell(context, 'الحصة السادسة', '1:00 - 12:15'),
                              ],
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