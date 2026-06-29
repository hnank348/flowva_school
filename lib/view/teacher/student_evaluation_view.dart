import 'package:flutter/material.dart';
import '../../models/teacher/student.dart';

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
          content: const Text('تم حفظ التقييم بنجاح'),
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
      appBar: AppBar(
        title: Text('تقييم ${widget.student.name}'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
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
                  backgroundColor: colorScheme.primaryContainer,
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
              const Text(
                'الدرجات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gradeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'الدرجة (0-100)',
                  prefixIcon: Icon(Icons.grade),
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  labelText: 'نسبة الحضور (0-100)',
                  prefixIcon: Icon(Icons.check_circle),
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  labelText: 'الأداء العام (0-100)',
                  prefixIcon: Icon(Icons.trending_up),
                  border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  labelText: 'ملاحظات إضافية',
                  prefixIcon: Icon(Icons.note),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'حفظ التقييم',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
