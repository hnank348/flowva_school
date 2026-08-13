import 'package:flutter/material.dart';
import '../../../models/supervisor/schedule_session_model.dart';
import '../../../app_localizations.dart';
import 'schedule_color_helper.dart';
import 'edit_session_bottom_sheet.dart';

// ─── خلية الوقت ─────────────────────────────────────────────────────────────
class ScheduleTimeCell extends StatelessWidget {
  final String label;
  final String time;

  const ScheduleTimeCell({super.key, required this.label, required this.time});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainer : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant.withOpacity(0.5)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo',
                  color: isDark ? colorScheme.onSurface : const Color(0xFF334155))),
          const SizedBox(height: 3),
          Text(time,
              style: TextStyle(
                  fontSize: 9, fontWeight: FontWeight.bold, fontFamily: 'Cairo',
                  color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B))),
        ],
      ),
    );
  }
}

// ─── خلية الاستراحة ─────────────────────────────────────────────────────────
class ScheduleRestCell extends StatelessWidget {
  const ScheduleRestCell({super.key});

  @override
  Widget build(BuildContext context) {
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
          Icon(Icons.coffee_rounded, size: 15,
              color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706)),
          const SizedBox(width: 6),
          Text(context.tr('table_rest_text'),
              style: TextStyle(
                color: isDark ? const Color(0xFFFBBF24) : const Color(0xFFB45309),
                fontSize: 11, fontFamily: 'Cairo', fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}

// ─── هيدر اليوم ─────────────────────────────────────────────────────────────
class ScheduleDayHeader extends StatelessWidget {
  final String dayName;
  final String dayKey;

  const ScheduleDayHeader({super.key, required this.dayName, required this.dayKey});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: ScheduleColorHelper.dayHeader(context, dayKey),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant.withOpacity(0.4)
              : const Color(0xFFE2E8F0).withOpacity(0.5),
        ),
      ),
      child: Text(dayName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo',
            color: ScheduleColorHelper.dayText(context, dayKey),
          )),
    );
  }
}

// ─── خلية الحصة الديناميكية ─────────────────────────────────────────────────
class ScheduleDynamicCell extends StatelessWidget {
  final String day;
  final int period;
  final int sectionId;
  final String className;
  final int semesterId;
  final String currentLanguage;
  final List<ScheduleSessionModel> sessions;

  const ScheduleDynamicCell({
    super.key,
    required this.day,
    required this.period,
    required this.sectionId,
    required this.className,
    required this.semesterId,
    required this.currentLanguage,
    required this.sessions,
  });

  ScheduleSessionModel? get _session {
    try {
      return sessions.firstWhere((s) {
        final db     = s.dayOfWeek.trim().toLowerCase();
        final target = day.trim().toLowerCase();
        bool match   = db == target;
        if (target == 'sunday')    match = match || db == 'الأحد'    || db == 'الاحد';
        if (target == 'monday')    match = match || db == 'الاثنين'  || db == 'الإثنين';
        if (target == 'tuesday')   match = match || db == 'الثلاثاء';
        if (target == 'wednesday') match = match || db == 'الأربعاء' || db == 'الاربعاء';
        if (target == 'thursday')  match = match || db == 'الخميس';
        return match && s.periodNumber == period && s.semesterId == semesterId;
      });
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    final isArabic    = currentLanguage == 'AR';
    final session     = _session;

    if (session != null) {
      final subjectName = isArabic
          ? (session.subject?.nameAr.isNotEmpty == true ? session.subject?.nameAr : session.subject?.name)
          : (session.subject?.name.isNotEmpty  == true ? session.subject?.name  : session.subject?.nameAr);
      final bg   = ScheduleColorHelper.subjectBackground(context, session.subject);
      final text = ScheduleColorHelper.subjectText(context, session.subject);

      return Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: bg.withOpacity(isDark ? 0.1 : 0.4), blurRadius: 6, offset: const Offset(0, 3))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: () => EditSessionBottomSheet.show(context,
              sessionId:        session.id,
              currentSubjectId: session.subject?.id,
              currentTeacherId: session.teacher?.id,
              currentSubject:   subjectName ?? context.tr('table_unknown_subject'),
              currentTeacher:   session.teacher?.fullName ?? context.tr('table_no_teacher'),
              currentRoom:      session.roomNumber,
              sectionId:        sectionId,
              className:        className,
              dayOfWeek:        day,
              periodNumber:     period,
              semesterId:       semesterId,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                color: bg,
                border: Border(
                  right: isArabic ? BorderSide.none : BorderSide(color: text.withOpacity(0.5), width: 4),
                  left:  isArabic ? BorderSide(color: text.withOpacity(0.5), width: 4) : BorderSide.none,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(subjectName ?? context.tr('table_unknown_subject'),
                      style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(session.teacher?.fullName ?? context.tr('table_no_teacher'),
                      style: TextStyle(color: text.withOpacity(0.8), fontSize: 9, fontFamily: 'Cairo', fontWeight: FontWeight.w600),
                      maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: text.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('${context.tr('table_room')} ${session.roomNumber}',
                        style: TextStyle(color: text, fontSize: 8, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // ─── خلية فارغة ───
    return Container(
      margin: const EdgeInsets.all(5),
      height: 70,
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerLow : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? colorScheme.outlineVariant.withOpacity(0.5) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: InkWell(
        onTap: () => EditSessionBottomSheet.show(context,
          sessionId: null, currentSubject: '', currentTeacher: '',
          currentRoom: '', sectionId: sectionId, className: className,
          dayOfWeek: day, periodNumber: period, semesterId: semesterId,
          currentSubjectId: null, currentTeacherId: null,
        ),
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Icon(Icons.add_rounded,
              color: isDark ? colorScheme.onSurfaceVariant.withOpacity(0.6) : const Color(0xFF94A3B8),
              size: 24),
        ),
      ),
    );
  }
}