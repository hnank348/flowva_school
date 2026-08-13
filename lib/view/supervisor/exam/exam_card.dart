import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/models/supervisor/exam_model.dart';
import '../../../cubit/locale/locale_cubit.dart';
import '../../../app_localizations.dart';

class ExamCard extends StatelessWidget {
  final ExamModel exam;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const ExamCard({
    super.key,
    required this.exam,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  static const _palette = [
    Color(0xFF3B82F6),
    Color(0xFF22C55E),
    Color(0xFFF97316),
    Color(0xFF06B6D4),
    Color(0xFFEAB308),
    Color(0xFF8B5CF6),
  ];

  Color get _accent => _palette[exam.subject.id % _palette.length];
  bool get _isCompleted => exam.status.toLowerCase() == 'completed';

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subjectName = resolveName(
      context,
      nameAr: exam.subject.name,
      nameEn: exam.subject.name,
    );

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: cs.outlineVariant.withOpacity(0.4), width: 1),
      ),
      color: cs.surfaceContainerLow,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 4.5,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: _accent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      subjectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 12, color: cs.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          exam.timeRange,
                          style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.meeting_room_outlined, size: 12, color: cs.onSurfaceVariant),
                        const SizedBox(width: 3),
                        Text(
                          exam.room,
                          style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: onToggleStatus,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isCompleted
                                ? (isDark ? Colors.green.withOpacity(0.2) : const Color(0xFFDCFCE7))
                                : (isDark ? cs.surfaceContainerHigh : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: !_isCompleted
                                  ? cs.outlineVariant.withOpacity(0.3)
                                  : Colors.green.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isCompleted ? Icons.check_circle_rounded : Icons.pending_actions_rounded,
                                size: 12,
                                color: _isCompleted
                                    ? (isDark ? Colors.greenAccent : const Color(0xFF16A34A))
                                    : (isDark ? cs.onSurface : const Color(0xFF475569)),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isCompleted ? context.tr('exam_status_completed') : context.tr('exam_status_scheduled'),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: _isCompleted
                                      ? (isDark ? Colors.greenAccent : const Color(0xFF16A34A))
                                      : (isDark ? cs.onSurface : const Color(0xFF475569)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_rounded, size: 18, color: cs.onSurfaceVariant),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        onSelected: (value) {
                          if (value == 'edit') onEdit();
                          if (value == 'delete') onDelete();
                          if (value == 'status') onToggleStatus();
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem(
                            value: 'status',
                            child: Row(
                              children: [
                                Icon(
                                  _isCompleted ? Icons.undo_rounded : Icons.task_alt_rounded,
                                  size: 16,
                                  color: cs.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isCompleted ? context.tr('exam_mark_as_scheduled') : context.tr('exam_mark_as_completed'),
                                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          if (!_isCompleted)
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined, size: 16, color: cs.primary),
                                  const SizedBox(width: 8),
                                  Text(context.tr('exam_edit_btn'), style: const TextStyle(fontFamily: 'Cairo', fontSize: 12)),
                                ],
                              ),
                            ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline_rounded, size: 16, color: cs.error),
                                const SizedBox(width: 8),
                                Text(context.tr('exam_delete_btn'), style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: cs.error)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exam.examDate,
                    style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant, fontFamily: 'Cairo'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String resolveName(
    BuildContext context, {
      required String nameAr,
      required String nameEn,
    }) {
  final localeState = context.read<LocaleCubit>().state;
  final isArabic = localeState.currentLanguage.toUpperCase() == 'AR' ||
      Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';

  if (isArabic) {
    return nameAr.isNotEmpty ? nameAr : nameEn;
  }
  return nameEn.isNotEmpty ? nameEn : nameAr;
}