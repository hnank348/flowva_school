import 'package:flutter/material.dart';
import 'package:flowva_school/app_localizations.dart';
import 'attendance_types.dart';
import 'attendance_status_badge.dart';
import 'attendance_chip.dart';
import 'attendance_note_field.dart';

class AttendanceRecordEntityCard<T> extends StatelessWidget {
  final String name;
  final String subtitle;
  final T currentStatus;
  final AttendanceStatusStyle Function(T status) styleOf;
  final List<AttendanceOption<T>> options;
  final void Function(T status) onSelect;
  final Future<void> Function() onSave;

  final bool expanded; // ✅ من الـ Cubit
  final ValueChanged<bool> onExpandedChanged; // ✅ من الـ Cubit
  final bool isSaving; // ✅ من الـ Cubit
  final bool isSaved;  // ✅ من الـ Cubit

  final String? note;
  final ValueChanged<String?>? onNoteChanged;

  const AttendanceRecordEntityCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.currentStatus,
    required this.styleOf,
    required this.options,
    required this.onSelect,
    required this.onSave,
    required this.expanded,
    required this.onExpandedChanged,
    required this.isSaving,
    required this.isSaved,
    this.note,
    this.onNoteChanged,
  });

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return name.isNotEmpty ? name[0] : '?';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = styleOf(currentStatus);

    final currentOption = options.firstWhere(
          (o) => o.status == currentStatus,
      orElse: () => options.first,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;

        final isNarrow = w < 160;
        final chipH = isNarrow ? 26.0 : 30.0;
        final chipFz = isNarrow ? 9.0 : 10.0;
        final nameFz = isNarrow ? 10.0 : 12.0;
        final hPad = isNarrow ? 8.0 : 12.0;
        final vPad = isNarrow ? 6.0 : 8.0;
        final gap = isNarrow ? 5.0 : 7.0;
        final actionBtnSize = isNarrow ? 24.0 : 28.0;
        const topBarH = 3.0;

        return Container(
          decoration: BoxDecoration(
            color: isDark ? cs.surfaceContainer : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: cs.outlineVariant.withOpacity(isDark ? 0.6 : 0.5),
              width: 0.8,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height: topBarH, color: style.accent),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(hPad, vPad, hPad, vPad),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: isDark ? style.bgDark : style.bg,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _initials(name),
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: nameFz - 1,
                                fontWeight: FontWeight.w700,
                                color: style.accent,
                              ),
                            ),
                          ),
                          SizedBox(width: isNarrow ? 6 : 9),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Tooltip(
                                  message: name,
                                  waitDuration: const Duration(milliseconds: 400),
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: nameFz,
                                      fontWeight: FontWeight.w600,
                                      color: cs.onSurface,
                                      height: 1.15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  ),
                                ),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 10,
                                    color: cs.onSurfaceVariant,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          _SaveButton(
                            onSave: onSave,
                            size: actionBtnSize,
                            isSaving: isSaving,
                            isSaved: isSaved,
                          ),
                        ],
                      ),

                      if (onNoteChanged != null) ...[
                        SizedBox(height: gap * 0.7),
                        AttendanceNoteArea(
                          note: note,
                          accentColor: style.accent,
                          onChanged: onNoteChanged!,
                          compact: isNarrow,
                        ),
                      ],

                      const Spacer(),

                      SizedBox(height: gap),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        crossFadeState: expanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: GenericAttendanceStatusBadge(
                          style: style,
                          label: currentOption.label,
                          onEditTap: () => onExpandedChanged(true),
                        ),
                        secondChild: Row(
                          children: [
                            for (int i = 0; i < options.length; i++) ...[
                              if (i != 0) const SizedBox(width: 3),
                              GenericAttendanceChip(
                                label: options[i].label,
                                activeColor: options[i].accent,
                                activeBg: options[i].bg,
                                isSelected: currentStatus == options[i].status,
                                height: chipH,
                                fontSize: chipFz,
                                onTap: () {
                                  onSelect(options[i].status);
                                  onExpandedChanged(false);
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ✅ صار Stateless بالكامل - isSaving و isSaved قادمين من الـ Cubit
class _SaveButton extends StatelessWidget {
  final Future<void> Function() onSave;
  final double size;
  final bool isSaving;
  final bool isSaved;

  const _SaveButton({
    required this.onSave,
    required this.isSaving,
    required this.isSaved,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final iconSize = size * 0.5;

    if (isSaved) {
      return Icon(Icons.check_circle_rounded,
          color: const Color(0xFF0F766E), size: size * 0.7);
    }

    return GestureDetector(
      onTap: isSaving
          ? null
          : () async {
        try {
          await onSave();
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(context.tr('error_update_attendance'),
                  style: const TextStyle(fontFamily: 'Cairo')),
              backgroundColor: cs.error,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ));
          }
        }
      },
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: cs.primary.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: isSaving
            ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
                color: cs.primary, strokeWidth: 2))
            : Icon(Icons.save_rounded, size: iconSize, color: cs.primary),
      ),
    );
  }
}