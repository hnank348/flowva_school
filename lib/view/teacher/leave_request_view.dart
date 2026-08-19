import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import 'teacher_sub_screen_app_bar.dart';

enum LeaveType { sick, personal, emergency, annual, other }

class LeaveRequestView extends StatefulWidget {
  const LeaveRequestView({super.key});

  @override
  State<LeaveRequestView> createState() => _LeaveRequestViewState();
}

class _LeaveRequestViewState extends State<LeaveRequestView> {
  final _formKey   = GlobalKey<FormState>();
  final _reasonCtrl = TextEditingController();

  LeaveType  _leaveType = LeaveType.sick;
  DateTime?  _startDate;
  DateTime?  _endDate;

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  String _typeLabel(LeaveType t) {
    switch (t) {
      case LeaveType.sick:       return context.tr('leave_type_sick');
      case LeaveType.personal:   return context.tr('leave_type_personal');
      case LeaveType.emergency:  return context.tr('leave_type_emergency');
      case LeaveType.annual:     return context.tr('leave_type_annual');
      case LeaveType.other:      return context.tr('leave_type_other');
    }
  }

  IconData _typeIcon(LeaveType t) {
    switch (t) {
      case LeaveType.sick:       return Icons.local_hospital_outlined;
      case LeaveType.personal:   return Icons.person_outline;
      case LeaveType.emergency:  return Icons.warning_amber_outlined;
      case LeaveType.annual:     return Icons.beach_access_outlined;
      case LeaveType.other:      return Icons.more_horiz_rounded;
    }
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  int get _days {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  Future<void> _pickStart() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2028),
    );
    if (picked == null) return;
    setState(() {
      _startDate = picked;
      if (_endDate != null && _endDate!.isBefore(picked)) _endDate = picked;
    });
  }

  Future<void> _pickEnd() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime(2028),
    );
    if (picked != null) setState(() => _endDate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(context.tr('leave_dates_required')),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(context.tr('leave_submitted_success')),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ));
    Navigator.pop(context);
  }

  // ── build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs     = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: TeacherSubScreenAppBar(title: context.tr('leave_title')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── leave type chips ──────────────────────────────────────
              _Section(label: context.tr('leave_type_label')),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: LeaveType.values.map((t) {
                  final selected = t == _leaveType;
                  return GestureDetector(
                    onTap: () => setState(() => _leaveType = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 9),
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
                            color: selected
                                ? cs.primary
                                : cs.onSurfaceVariant,
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

              // ── date range ────────────────────────────────────────────
              _Section(label: context.tr('leave_dates_label')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _pickStart,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: context.tr('leave_start_date'),
                          prefixIcon:
                              const Icon(Icons.calendar_today_outlined),
                        ),
                        child: Text(
                          _startDate != null
                              ? _fmt(_startDate!)
                              : context.tr('leave_select_date'),
                          style: TextStyle(
                            color: _startDate != null
                                ? cs.onSurface
                                : cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _pickEnd,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: context.tr('leave_end_date'),
                          prefixIcon:
                              const Icon(Icons.calendar_today_outlined),
                        ),
                        child: Text(
                          _endDate != null
                              ? _fmt(_endDate!)
                              : context.tr('leave_select_date'),
                          style: TextStyle(
                            color: _endDate != null
                                ? cs.onSurface
                                : cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // days badge
              if (_days > 0) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: cs.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timelapse_outlined,
                          size: 16, color: cs.primary),
                      const SizedBox(width: 6),
                      Text(
                        '$_days ${context.tr('leave_days_count')}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // ── reason ────────────────────────────────────────────────
              _Section(label: context.tr('leave_reason_label')),
              const SizedBox(height: 12),
              TextFormField(
                controller: _reasonCtrl,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: context.tr('leave_reason_hint'),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(Icons.edit_note_outlined),
                  ),
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? context.tr('leave_reason_required')
                    : null,
              ),
              const SizedBox(height: 32),

              // ── submit ────────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.send_outlined),
                  label: Text(
                    context.tr('leave_submit_button'),
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
