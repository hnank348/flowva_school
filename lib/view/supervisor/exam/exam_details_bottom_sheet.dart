import 'package:flutter/material.dart';
import 'package:flowva_school/models/supervisor/exam_model.dart';
import '../../../app_localizations.dart';

class ExamDetailsBottomSheet {
  static void show(BuildContext context, ExamModel exam) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final subjectTitle = exam.subject != null
        ? '${exam.subject!.name}${exam.subject!.code.isNotEmpty ? ' (${exam.subject!.code})' : ''}'
        : context.tr('exam_unspecified');

    final examTypeName = exam.examType != null
        ? (exam.examType!.nameAr.isNotEmpty ? exam.examType!.nameAr : exam.examType!.name)
        : context.tr('exam_unspecified');

    final teacherName = exam.teacher?.fullName ?? context.tr('exam_unspecified');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return Container(
            width: isWide ? 550 : double.infinity,
            margin: isWide
                ? EdgeInsets.symmetric(horizontal: (constraints.maxWidth - 550) / 2)
                : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            padding: EdgeInsets.only(
              top: 16, left: 24, right: 24,
              bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 50, height: 5,
                    decoration: BoxDecoration(
                      color: cs.outlineVariant.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  exam.nameAr.isNotEmpty ? exam.nameAr : exam.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo',
                    color: isDark ? cs.primary : const Color(0xFF234E52),
                  ),
                ),
                const SizedBox(height: 20),
                _row(context, Icons.book_outlined, context.tr('exam_subject_label'), subjectTitle),
                _row(context, Icons.category_outlined, context.tr('exam_type_label'), examTypeName),
                _row(context, Icons.calendar_month_outlined, context.tr('exam_date'), exam.examDate),
                _row(context, Icons.access_time_rounded, context.tr('table_header_time'), exam.timeRange),
                _row(context, Icons.meeting_room_outlined, context.tr('exam_room'), exam.room.isNotEmpty ? exam.room : '-'),
                _row(context, Icons.grade_outlined, context.tr('exam_marks_label'), '${exam.totalMarks.toStringAsFixed(0)} / ${exam.passMarks.toStringAsFixed(0)}'),
                _row(context, Icons.person_outline_rounded, context.tr('exam_teacher_label'), teacherName),
                if (exam.instructions != null && exam.instructions!.isNotEmpty)
                  _row(context, Icons.info_outline_rounded, context.tr('exam_notes_label'), exam.instructions!),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.outlineVariant),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(sheetCtx),
                  child: Text(context.tr('exam_close_btn'), style: TextStyle(color: cs.onSurfaceVariant, fontFamily: 'Cairo')),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _row(BuildContext context, IconData icon, String label, String value) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: cs.primary),
          const SizedBox(width: 10),
          Text('$label: ', style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.onSurfaceVariant)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold, color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}