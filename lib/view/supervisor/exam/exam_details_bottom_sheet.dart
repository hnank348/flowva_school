import 'package:flutter/material.dart';
import 'package:flowva_school/models/supervisor/exam_model.dart';
import '../../../widget/button.dart';
import '../../../app_localizations.dart';
import '../../../widget/supervisor/locale_name.dart';

class ExamDetailsBottomSheet {
  static void show(BuildContext context, ExamModel exam) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // اسم المادة بحسب اللغة
    final subjectName = exam.subject != null
        ? resolveName(
      context,
      nameAr: exam.subject!.name ?? '',
      nameEn: exam.subject!.name,
    )
        : '';

    final subjectTitle = exam.subject != null
        ? '$subjectName${exam.subject!.code.isNotEmpty ? ' (${exam.subject!.code})' : ''}'
        : context.tr('not_available');

    // نوع الامتحان بحسب اللغة
    final examTypeName = exam.examType != null
        ? resolveName(
      context,
      nameAr: exam.examType!.nameAr,
      nameEn: exam.examType!.name,
    )
        : context.tr('not_available');

    // عنوان الامتحان الرئيسي
    final examTitle = resolveName(
      context,
      nameAr: exam.nameAr,
      nameEn: exam.name,
    );

    // 🟢 قراءة اسم الأستاذ بأمان بدون Forced Unwrap
    final teacherName = exam.teacher != null
        ? (exam.teacher!.fullName.isNotEmpty
        ? exam.teacher!.fullName
        : exam.teacher!.fullName)
        : context.tr('not_available');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        decoration: BoxDecoration(
          color: isDark ? cs.surfaceContainer : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              examTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _row(context, Icons.book_outlined, context.tr('exam_subject_label'), subjectTitle),
            _row(context, Icons.category_outlined, context.tr('exam_type_label'), examTypeName),
            _row(context, Icons.calendar_month_outlined, context.tr('exam_date'), exam.examDate),
            _row(context, Icons.access_time_rounded, context.tr('table_header_time'), exam.timeRange),
            _row(context, Icons.meeting_room_outlined, context.tr('exam_room'),
                exam.room.isNotEmpty ? exam.room : context.tr('not_available')),
            _row(context, Icons.grade_outlined, context.tr('exam_marks_label'),
                '${exam.totalMarks.toStringAsFixed(0)} / ${exam.passMarks.toStringAsFixed(0)}'),
            _row(context, Icons.person_outline_rounded, context.tr('exam_teacher_label'), teacherName),
            if (exam.instructions != null && exam.instructions!.isNotEmpty)
              _row(context, Icons.info_outline_rounded, context.tr('exam_notes_label'), exam.instructions!),
            const SizedBox(height: 18),
            Button(
              text: context.tr('exam_close_btn'),
              color: Colors.transparent,
              colorOutline: cs.outlineVariant,
              colorText: cs.onSurface,
              height: 46,
              onPressed: () => Navigator.pop(sheetCtx),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _row(BuildContext context, IconData icon, String label, String value) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: cs.primary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.onSurfaceVariant),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}