import 'package:flutter/material.dart';
import '../../../models/supervisor/schedule_session_model.dart';
import '../../../app_localizations.dart';
import 'schedule_cell_builder.dart';

class ScheduleTableWidget extends StatelessWidget {
  final List<ScheduleSessionModel> sessions;
  final int sectionId;
  final String className;
  final int semesterId;
  final String currentLanguage;

  const ScheduleTableWidget({
    super.key,
    required this.sessions,
    required this.sectionId,
    required this.className,
    required this.semesterId,
    required this.currentLanguage,
  });

  static const _dayKeys = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday'];

  List<String> _dayLabels(BuildContext context) => [
    context.tr('day_sunday'),
    context.tr('day_monday'),
    context.tr('day_tuesday'),
    context.tr('day_wednesday'),
    context.tr('day_thursday'),
  ];

  List<({String label, String time, bool isRest, int periodNum})> _periods(
      BuildContext context) =>
      [
        (label: context.tr('period_1'),               time: '8:15 - 7:30',   isRest: false, periodNum: 1),
        (label: context.tr('period_2'),               time: '9:05 - 8:20',   isRest: false, periodNum: 2),
        (label: '${context.tr('table_rest_text')} ١', time: '9:35 - 9:05',   isRest: true,  periodNum: 0),
        (label: context.tr('period_3'),               time: '10:20 - 9:35',  isRest: false, periodNum: 3),
        (label: context.tr('period_4'),               time: '11:05 - 10:20', isRest: false, periodNum: 4),
        (label: '${context.tr('table_rest_text')} ٢', time: '11:30 - 11:05', isRest: true,  periodNum: 0),
        (label: context.tr('period_5'),               time: '12:15 - 11:30', isRest: false, periodNum: 5),
        (label: context.tr('period_6'),               time: '1:00 - 12:15',  isRest: false, periodNum: 6),
      ];

  // ✅ الترتيب الصحيح للأعمدة حسب اللغة
  // عربي:   [أحد، إثنين، ثلاثاء، أربعاء، خميس، وقت]  — الوقت آخر يمين
  // إنجليزي: [وقت، أحد، إثنين، ثلاثاء، أربعاء، خميس] — الوقت أول يسار
  List<Widget> _buildRowCells({
    required Widget timeCell,
    required List<Widget> dayCells,
    required bool isArabic,
  }) {
    if (isArabic) {
      // نعكس الأيام + نضع الوقت في النهاية (يظهر على اليمين بسبب RTL)
      return [...dayCells.reversed.toList(), timeCell];
    } else {
      return [timeCell, ...dayCells];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark      = Theme.of(context).brightness == Brightness.dark;
    final isArabic    = currentLanguage == 'AR';
    final dayLabels   = _dayLabels(context);
    final periods     = _periods(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth =
        constraints.maxWidth > 800 ? constraints.maxWidth : 800.0;
        final double cellWidth = totalWidth / 6;

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
          // ✅ نثبت الـ direction على LTR دائماً داخل الجدول
          // لأن الـ Table widget لا يدعم RTL بشكل صحيح
          // ونتحكم بالترتيب يدوياً عبر _buildRowCells
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: totalWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Table(
                      defaultColumnWidth: FixedColumnWidth(cellWidth),
                      border: TableBorder.all(color: Colors.transparent),
                      defaultVerticalAlignment:
                      TableCellVerticalAlignment.middle,
                      children: [
                        // ─── هيدر الأيام ───
                        TableRow(
                          children: _buildRowCells(
                            isArabic: isArabic,
                            timeCell: _buildHeaderTimeCell(
                                context, colorScheme, isDark),
                            dayCells: List.generate(
                              5,
                                  (i) => ScheduleDayHeader(
                                dayName: dayLabels[i],
                                dayKey: _dayKeys[i],
                              ),
                            ),
                          ),
                        ),

                        // ─── صفوف الحصص ───
                        ...periods.map(
                              (p) => TableRow(
                            children: _buildRowCells(
                              isArabic: isArabic,
                              timeCell: ScheduleTimeCell(
                                  label: p.label, time: p.time),
                              dayCells: p.isRest
                                  ? List.generate(
                                  5, (_) => const ScheduleRestCell())
                                  : List.generate(
                                5,
                                    (i) => ScheduleDynamicCell(
                                  day: _dayKeys[i],
                                  period: p.periodNum,
                                  sectionId: sectionId,
                                  className: className,
                                  semesterId: semesterId,
                                  currentLanguage: currentLanguage,
                                  sessions: sessions,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderTimeCell(
      BuildContext context, ColorScheme colorScheme, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.onSurfaceVariant.withOpacity(0.2)
            : const Color(0xFF334155),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant.withOpacity(0.4)
              : Colors.transparent,
        ),
      ),
      child: Text(
        context.tr('table_header_time'),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Colors.white,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }
}