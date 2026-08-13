import 'package:flutter/material.dart';
import 'attendance_types.dart';
import 'attendance_status_badge.dart';
import 'attendance_chip.dart';
import 'attendance_note_field.dart';

class AttendanceEntityCard<T> extends StatelessWidget {
  final String name;
  final String subtitle;
  final T currentStatus;
  final AttendanceStatusStyle Function(T status) styleOf;
  final List<AttendanceOption<T>> options;
  final void Function(T status) onSelect;

  final bool expanded; // ✅ من الـ Cubit
  final ValueChanged<bool> onExpandedChanged; // ✅ من الـ Cubit

  final String? note;
  final ValueChanged<String?>? onNoteChanged;

  const AttendanceEntityCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.currentStatus,
    required this.styleOf,
    required this.options,
    required this.onSelect,
    required this.expanded,
    required this.onExpandedChanged,
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
                        firstCurve: Curves.easeOut,
                        secondCurve: Curves.easeIn,
                        crossFadeState: expanded
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: Row(
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
                                  onExpandedChanged(false); // ✅ عبر الـ Cubit
                                },
                              ),
                            ],
                          ],
                        ),
                        secondChild: GenericAttendanceStatusBadge(
                          style: style,
                          label: currentOption.label,
                          onEditTap: () => onExpandedChanged(true), // ✅ عبر الـ Cubit
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