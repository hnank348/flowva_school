import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../data/mock_data.dart';
import '../../models/teacher/classroom.dart';
import '../../models/teacher/homework.dart';
import 'teacher_sub_screen_app_bar.dart';

class SendHomeworkView extends StatefulWidget {
  /// If provided, the class selector is pre-filled and locked.
  final String? preselectedClassRoomId;

  const SendHomeworkView({super.key, this.preselectedClassRoomId});

  @override
  State<SendHomeworkView> createState() => _SendHomeworkViewState();
}

class _SendHomeworkViewState extends State<SendHomeworkView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _marksController = TextEditingController();

  String? _selectedClassRoomId;
  DateTime? _dueDate;
  HomeworkType _selectedType = HomeworkType.written;

  @override
  void initState() {
    super.initState();
    _selectedClassRoomId = widget.preselectedClassRoomId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _marksController.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  String _typeLabel(HomeworkType type) {
    switch (type) {
      case HomeworkType.written:
        return context.tr('hw_type_written');
      case HomeworkType.reading:
        return context.tr('hw_type_reading');
      case HomeworkType.research:
        return context.tr('hw_type_research');
      case HomeworkType.project:
        return context.tr('hw_type_project');
    }
  }

  IconData _typeIcon(HomeworkType type) {
    switch (type) {
      case HomeworkType.written:
        return Icons.edit_outlined;
      case HomeworkType.reading:
        return Icons.menu_book_outlined;
      case HomeworkType.research:
        return Icons.search_outlined;
      case HomeworkType.project:
        return Icons.folder_outlined;
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('hw_due_date_required')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // In a real app this would call a repository/API.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('hw_sent_success')),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
    Navigator.pop(context);
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final classRooms = MockData.getClassRooms();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: TeacherSubScreenAppBar(title: context.tr('hw_send_title')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── section header ────────────────────────────────────────────
              _SectionHeader(label: context.tr('hw_basic_info')),
              const SizedBox(height: 16),

              // ── title ─────────────────────────────────────────────────────
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: context.tr('hw_title_label'),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? context.tr('hw_title_required')
                    : null,
              ),
              const SizedBox(height: 16),

              // ── description ───────────────────────────────────────────────
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: context.tr('hw_description_label'),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(Icons.description_outlined),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? context.tr('hw_description_required')
                    : null,
              ),
              const SizedBox(height: 16),

              // ── class: locked badge OR dropdown ──────────────────────
              if (widget.preselectedClassRoomId != null) ...[
                Builder(
                  builder: (context) {
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    final cs = Theme.of(context).colorScheme;
                    final match = classRooms.where(
                      (c) => c.id == widget.preselectedClassRoomId,
                    );
                    final label = match.isNotEmpty
                        ? '${match.first.name} — ${match.first.subject}'
                        : widget.preselectedClassRoomId!;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? cs.primaryContainer.withValues(alpha: 0.2)
                            : cs.primaryContainer.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: cs.primary.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            color: cs.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: cs.onSurface,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              context.tr('exam_class_auto'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ] else ...[
                DropdownButtonFormField<String>(
                  initialValue: _selectedClassRoomId,
                  decoration: InputDecoration(
                    labelText: context.tr('hw_class_label'),
                    prefixIcon: const Icon(Icons.menu_book_outlined),
                  ),
                  items: classRooms.map((ClassRoom c) {
                    return DropdownMenuItem<String>(
                      value: c.id,
                      child: Text('${c.name} — ${c.subject}'),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedClassRoomId = v),
                  validator: (v) => (v == null || v.isEmpty)
                      ? context.tr('hw_class_required')
                      : null,
                ),
              ],
              const SizedBox(height: 24),

              // ── type selector ─────────────────────────────────────────────
              _SectionHeader(label: context.tr('hw_type_label')),
              const SizedBox(height: 12),
              _TypeSelector(
                selected: _selectedType,
                onChanged: (t) => setState(() => _selectedType = t),
                typeLabel: _typeLabel,
                typeIcon: _typeIcon,
              ),
              const SizedBox(height: 24),

              // ── dates & marks ─────────────────────────────────────────────
              _SectionHeader(label: context.tr('hw_details_section')),
              const SizedBox(height: 16),

              // due date picker
              InkWell(
                onTap: _pickDueDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: context.tr('hw_due_date_label'),
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    _dueDate != null
                        ? _formatDate(_dueDate!)
                        : context.tr('hw_due_date_hint'),
                    style: TextStyle(
                      color: _dueDate != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // total marks
              TextFormField(
                controller: _marksController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.tr('hw_marks_label'),
                  prefixIcon: const Icon(Icons.grade_outlined),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return context.tr('hw_marks_required');
                  }
                  final n = int.tryParse(v);
                  if (n == null || n <= 0) {
                    return context.tr('hw_marks_invalid');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // ── submit button ─────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.send_outlined),
                  label: Text(
                    context.tr('hw_send_button'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── reusable sub-widgets ──────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
        fontFamily: 'Cairo',
      ),
    );
  }
}

class _TypeSelector extends StatelessWidget {
  final HomeworkType selected;
  final ValueChanged<HomeworkType> onChanged;
  final String Function(HomeworkType) typeLabel;
  final IconData Function(HomeworkType) typeIcon;

  const _TypeSelector({
    required this.selected,
    required this.onChanged,
    required this.typeLabel,
    required this.typeIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: HomeworkType.values.map((type) {
        final isSelected = type == selected;
        return GestureDetector(
          onTap: () => onChanged(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              // خلفية فاتحة شفافة — النص دائماً مرئي
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.1)
                  : (isDark
                        ? colorScheme.surfaceContainer
                        : colorScheme.surfaceContainerHighest),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                width: isSelected ? 1.8 : 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  typeIcon(type),
                  size: 18,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  typeLabel(type),
                  style: TextStyle(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
