import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../data/mock_data.dart';
import '../../models/teacher/classroom.dart';
import 'teacher_sub_screen_app_bar.dart';

class CreateExamView extends StatefulWidget {
  /// When provided the class selector is pre-filled and locked (from ClassesView).
  /// When null the teacher picks from the full list (from quick actions).
  final String? preselectedClassRoomId;
  final String? preselectedClassRoomName;

  const CreateExamView({
    super.key,
    this.preselectedClassRoomId,
    this.preselectedClassRoomName,
  });

  @override
  State<CreateExamView> createState() => _CreateExamViewState();
}

class _CreateExamViewState extends State<CreateExamView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _totalMarksController = TextEditingController();

  String? _selectedClassRoom;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    // Pre-fill if coming from a specific class card
    _selectedClassRoom = widget.preselectedClassRoomId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _totalMarksController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('teacher_exam_created')),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final classRooms = MockData.getClassRooms();
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLocked = widget.preselectedClassRoomId != null;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: TeacherSubScreenAppBar(
        title: context.tr('teacher_create_exam_title'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('teacher_exam_info'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 20),

              // ── title ──────────────────────────────────────────────────
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: context.tr('teacher_exam_title_label'),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (v) => (v == null || v.isEmpty)
                    ? context.tr('teacher_exam_title_required')
                    : null,
              ),
              const SizedBox(height: 16),

              // ── description ────────────────────────────────────────────
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: context.tr('teacher_exam_description'),
                  prefixIcon: const Icon(Icons.description_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // ── class field — locked badge OR dropdown ─────────────────
              if (isLocked)
                // show a read-only decorated container instead of a dropdown
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? colorScheme.surfaceContainer
                        : colorScheme.primary.withValues(alpha: 0.1).withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book_outlined,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.preselectedClassRoomName ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: colorScheme.onSurface,
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
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          context.tr('exam_class_auto'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                // normal dropdown when no class is pre-selected
                DropdownButtonFormField<String>(
                  initialValue: _selectedClassRoom,
                  decoration: InputDecoration(
                    labelText: context.tr('teacher_exam_class'),
                    prefixIcon: const Icon(Icons.menu_book_outlined),
                  ),
                  items: classRooms.map((ClassRoom c) {
                    return DropdownMenuItem<String>(
                      value: c.id,
                      child: Text('${c.name} — ${c.subject}'),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedClassRoom = v),
                  validator: (v) => (v == null || v.isEmpty)
                      ? context.tr('teacher_exam_class_required')
                      : null,
                ),
              const SizedBox(height: 16),

              // ── date ───────────────────────────────────────────────────
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: context.tr('teacher_exam_date'),
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    _selectedDate != null
                        ? '${_selectedDate!.year}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}'
                        : context.tr('teacher_exam_select_date'),
                    style: TextStyle(
                      color: _selectedDate != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── time ───────────────────────────────────────────────────
              InkWell(
                onTap: _selectTime,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: context.tr('teacher_exam_time'),
                    prefixIcon: const Icon(Icons.access_time),
                  ),
                  child: Text(
                    _selectedTime != null
                        ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                        : context.tr('teacher_exam_select_time'),
                    style: TextStyle(
                      color: _selectedTime != null
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── duration ───────────────────────────────────────────────
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.tr('teacher_exam_duration'),
                  prefixIcon: const Icon(Icons.timer_outlined),
                ),
                validator: (v) => (v == null || v.isEmpty)
                    ? context.tr('teacher_exam_duration_required')
                    : null,
              ),
              const SizedBox(height: 16),

              // ── total marks ────────────────────────────────────────────
              TextFormField(
                controller: _totalMarksController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.tr('teacher_exam_total_marks'),
                  prefixIcon: const Icon(Icons.grade_outlined),
                ),
                validator: (v) => (v == null || v.isEmpty)
                    ? context.tr('teacher_exam_marks_required')
                    : null,
              ),
              const SizedBox(height: 32),

              // ── submit ─────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_rounded),
                  label: Text(
                    context.tr('teacher_create_exam'),
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
