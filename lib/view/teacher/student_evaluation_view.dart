import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../models/teacher/student.dart';
import 'teacher_sub_screen_app_bar.dart';

class StudentEvaluationView extends StatefulWidget {
  final Student student;

  const StudentEvaluationView({super.key, required this.student});

  @override
  State<StudentEvaluationView> createState() => _StudentEvaluationViewState();
}

class _StudentEvaluationViewState extends State<StudentEvaluationView> {
  final _formKey = GlobalKey<FormState>();
  final _gradeController = TextEditingController();
  final _attendanceController = TextEditingController();
  final _performanceController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _gradeController.text = widget.student.grade.toString();
    _attendanceController.text = widget.student.attendance.toString();
    _performanceController.text = widget.student.performance.toString();
  }

  @override
  void dispose() {
    _gradeController.dispose();
    _attendanceController.dispose();
    _performanceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('teacher_evaluation_saved')),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: TeacherSubScreenAppBar(
        title: '${context.tr('teacher_evaluate')} ${widget.student.name}',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  child: Text(
                    widget.student.name[0],
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  widget.student.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                context.tr('teacher_grades'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gradeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.tr('teacher_grade_label'),
                  prefixIcon: const Icon(Icons.grade_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الدرجة';
                  }
                  final grade = double.tryParse(value);
                  if (grade == null || grade < 0 || grade > 100) {
                    return 'الدرجة يجب أن تكون بين 0 و 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _attendanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.tr('teacher_attendance_label'),
                  prefixIcon: const Icon(Icons.check_circle_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال نسبة الحضور';
                  }
                  final attendance = double.tryParse(value);
                  if (attendance == null ||
                      attendance < 0 ||
                      attendance > 100) {
                    return 'نسبة الحضور يجب أن تكون بين 0 و 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _performanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: context.tr('teacher_performance_label'),
                  prefixIcon: const Icon(Icons.trending_up),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الأداء العام';
                  }
                  final performance = double.tryParse(value);
                  if (performance == null ||
                      performance < 0 ||
                      performance > 100) {
                    return 'الأداء يجب أن يكون بين 0 و 100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: context.tr('teacher_notes'),
                  prefixIcon: const Icon(Icons.note_outlined),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_rounded),
                  label: Text(
                    context.tr('teacher_save_evaluation'),
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
