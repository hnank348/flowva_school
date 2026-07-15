import 'package:flutter/material.dart';
import 'package:flowva_school/app_localizations.dart';

class AttendanceNoteField extends StatelessWidget {
  final String? note;
  final ValueChanged<String?> onChanged;
  final Color accentColor;
  final double size; // ✅ جديد - قابل للتصغير بالشاشات الضيقة

  const AttendanceNoteField({
    super.key,
    required this.note,
    required this.onChanged,
    required this.accentColor,
    this.size = 30,
  });

  bool get _hasNote => note != null && note!.trim().isNotEmpty;

  Future<void> _openEditor(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AttendanceNoteSheet(
        initialText: note ?? '',
        accentColor: accentColor,
      ),
    );

    if (result == null) return;
    onChanged(result.trim().isEmpty ? null : result.trim());
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconSize = size * 0.46;

    if (!_hasNote) {
      return GestureDetector(
        onTap: () => _openEditor(context),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: cs.onSurfaceVariant.withOpacity(isDark ? 0.12 : 0.06),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.note_add_outlined,
              size: iconSize, color: cs.onSurfaceVariant),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _openEditor(context),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: accentColor.withOpacity(isDark ? 0.22 : 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: accentColor.withOpacity(isDark ? 0.6 : 0.4),
          ),
        ),
        child: Icon(Icons.sticky_note_2_rounded,
            size: iconSize, color: accentColor),
      ),
    );
  }
}

class AttendanceNotePreview extends StatelessWidget {
  final String note;
  final Color accentColor;
  final VoidCallback onTap;
  final bool compact; // ✅ جديد

  const AttendanceNotePreview({
    super.key,
    required this.note,
    required this.accentColor,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 8,
          vertical: compact ? 3 : 5,
        ),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(isDark ? 0.15 : 0.08),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Icon(Icons.sticky_note_2_rounded,
                size: compact ? 10 : 12, color: accentColor),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                note,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: compact ? 9 : 10,
                  fontWeight: FontWeight.w500,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceNoteSheet extends StatefulWidget {
  final String initialText;
  final Color accentColor;

  const AttendanceNoteSheet({
    super.key,
    required this.initialText,
    required this.accentColor,
  });

  @override
  State<AttendanceNoteSheet> createState() => _AttendanceNoteSheetState();
}

class _AttendanceNoteSheetState extends State<AttendanceNoteSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? cs.surfaceContainer : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              children: [
                Icon(Icons.sticky_note_2_rounded,
                    size: 18, color: widget.accentColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.tr('attendance_note_title'),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close_rounded,
                      size: 20, color: cs.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              maxLines: 4,
              minLines: 3,
              maxLength: 200,
              autofocus: true,
              style: const TextStyle(fontFamily: 'Cairo', fontSize: 13),
              decoration: InputDecoration(
                hintText: context.tr('attendance_note_hint'),
                hintStyle: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: cs.onSurfaceVariant.withOpacity(0.7),
                ),
                filled: true,
                fillColor: isDark ? cs.surface : const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  BorderSide(color: cs.outlineVariant.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  BorderSide(color: widget.accentColor, width: 1.4),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                if (widget.initialText.trim().isNotEmpty)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, ''),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cs.error,
                        side: BorderSide(color: cs.error.withOpacity(0.4)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        context.tr('attendance_note_delete'),
                        style: const TextStyle(
                            fontFamily: 'Cairo', fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                if (widget.initialText.trim().isNotEmpty)
                  const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, _controller.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      context.tr('attendance_note_save'),
                      style: const TextStyle(
                          fontFamily: 'Cairo', fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceNoteArea extends StatelessWidget {
  final String? note;
  final ValueChanged<String?> onChanged;
  final Color accentColor;
  final bool compact;

  const AttendanceNoteArea({
    super.key,
    required this.note,
    required this.onChanged,
    required this.accentColor,
    this.compact = false,
  });

  bool get _hasNote => note != null && note!.trim().isNotEmpty;

  Future<void> _openEditor(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AttendanceNoteSheet(
        initialText: note ?? '',
        accentColor: accentColor,
      ),
    );
    if (result == null) return;
    onChanged(result.trim().isEmpty ? null : result.trim());
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _openEditor(context),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 8,
          vertical: compact ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: _hasNote
              ? accentColor.withOpacity(isDark ? 0.15 : 0.08)
              : cs.onSurfaceVariant.withOpacity(isDark ? 0.10 : 0.05),
          borderRadius: BorderRadius.circular(7),
          border: _hasNote
              ? null
              : Border.all(color: cs.outlineVariant.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Icon(
              _hasNote ? Icons.sticky_note_2_rounded : Icons.note_add_outlined,
              size: compact ? 11 : 13,
              color: _hasNote ? accentColor : cs.onSurfaceVariant,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                _hasNote ? note! : context.tr('attendance_note_empty_hint'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: compact ? 9.5 : 10.5,
                  fontWeight: _hasNote ? FontWeight.w500 : FontWeight.w400,
                  color: _hasNote ? accentColor : cs.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}