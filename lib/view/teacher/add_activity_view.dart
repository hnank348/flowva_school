import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../data/mock_data.dart';
import '../../models/teacher/activity.dart';
import 'teacher_sub_screen_app_bar.dart';

class AddActivityView extends StatefulWidget {
  const AddActivityView({super.key});

  @override
  State<AddActivityView> createState() => _AddActivityViewState();
}

class _AddActivityViewState extends State<AddActivityView> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  ActivityType _type = ActivityType.parentMeeting;
  String? _classId;
  DateTime? _date;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime(2028),
    );
    if (picked != null) setState(() => _date = picked);
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _typeLabel(ActivityType t) {
    switch (t) {
      case ActivityType.parentMeeting:
        return context.tr('act_type_parent_meeting');
      case ActivityType.schoolTrip:
        return context.tr('act_type_school_trip');
      case ActivityType.competition:
        return context.tr('act_type_competition');
      case ActivityType.ceremony:
        return context.tr('act_type_ceremony');
      case ActivityType.workshop:
        return context.tr('act_type_workshop');
      case ActivityType.other:
        return context.tr('act_type_other');
    }
  }

  IconData _typeIcon(ActivityType t) {
    switch (t) {
      case ActivityType.parentMeeting:
        return Icons.people_outline;
      case ActivityType.schoolTrip:
        return Icons.directions_bus_outlined;
      case ActivityType.competition:
        return Icons.emoji_events_outlined;
      case ActivityType.ceremony:
        return Icons.celebration_outlined;
      case ActivityType.workshop:
        return Icons.build_outlined;
      case ActivityType.other:
        return Icons.event_outlined;
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('act_date_required')),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final classRooms = MockData.getClassRooms();
    final classRoom = _classId != null
        ? classRooms.firstWhere((c) => c.id == _classId).name
        : context.tr('act_general');

    MockData.addActivity(
      Activity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        date: _fmt(_date!),
        type: _type,
        classRoom: classRoom,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('act_added_success')),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );

    Navigator.pop(context, true);
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final classRooms = MockData.getClassRooms();

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: TeacherSubScreenAppBar(title: context.tr('act_add_title')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── event type chips ──────────────────────────────────────
              _Section(label: context.tr('act_type_label')),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ActivityType.values.map((t) {
                  final selected = t == _type;
                  return GestureDetector(
                    onTap: () => setState(() => _type = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? cs.primary.withValues(alpha: 0.1)
                            : (isDark
                                  ? cs.surfaceContainer
                                  : cs.surfaceContainerHighest),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? cs.primary : cs.outlineVariant,
                          width: selected ? 1.8 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _typeIcon(t),
                            size: 16,
                            color: selected ? cs.primary : cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _typeLabel(t),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: selected
                                  ? cs.primary
                                  : cs.onSurfaceVariant,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // ── title ─────────────────────────────────────────────────
              _Section(label: context.tr('act_basic_info')),
              const SizedBox(height: 12),
              TextFormField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  labelText: context.tr('act_title_label'),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? context.tr('act_title_required')
                    : null,
              ),
              const SizedBox(height: 16),

              // ── description ───────────────────────────────────────────
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: context.tr('act_description_label'),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.description_outlined),
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),

              // ── classroom ─────────────────────────────────────────────
              DropdownButtonFormField<String>(
                initialValue: _classId,
                decoration: InputDecoration(
                  labelText: context.tr('act_class_label'),
                  prefixIcon: const Icon(Icons.menu_book_outlined),
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(
                      context.tr('act_general'),
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                  ),
                  ...classRooms.map(
                    (c) => DropdownMenuItem(
                      value: c.id,
                      child: Text(
                        '${c.name} — ${c.subject}',
                        style: const TextStyle(fontFamily: 'Cairo'),
                      ),
                    ),
                  ),
                ],
                onChanged: (v) => setState(() => _classId = v),
              ),
              const SizedBox(height: 20),

              // ── date ─────────────────────────────────────────────────
              _Section(label: context.tr('act_details_section')),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: context.tr('act_date_label'),
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    _date != null ? _fmt(_date!) : context.tr('act_date_hint'),
                    style: TextStyle(
                      color: _date != null ? cs.onSurface : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // ── submit ────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_rounded),
                  label: Text(
                    context.tr('act_save_button'),
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

class _Section extends StatelessWidget {
  final String label;
  const _Section({required this.label});

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
      fontFamily: 'Cairo',
    ),
  );
}
