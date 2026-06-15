import 'package:flutter/material.dart';
import '../../data/mock_data.dart';

class AttendanceView extends StatefulWidget {
  final String classRoomId;
  final String classRoomName;

  const AttendanceView({
    super.key,
    required this.classRoomId,
    required this.classRoomName,
  });

  @override
  State<AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<AttendanceView> {
  final Map<String, bool> _attendance = {};

  @override
  void initState() {
    super.initState();
    final students = MockData.getStudents();
    for (var student in students) {
      _attendance[student.id] = true;
    }
  }

  void _submitAttendance() {
    final presentCount = _attendance.values.where((present) => present).length;
    final absentCount = _attendance.length - presentCount;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم حفظ الحضور: حاضر $presentCount، غائب $absentCount'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final students = MockData.getStudents();

    return Scaffold(
      appBar: AppBar(
        title: Text('حضور ${widget.classRoomName}'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${students.length}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const Text('إجمالي الطلاب'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${_attendance.values.where((present) => present).length}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Text('حاضر'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${_attendance.values.where((present) => !present).length}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const Text('غائب'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                final isPresent = _attendance[student.id] ?? true;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        student.name[0],
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(student.name),
                    subtitle: Text('الدرجة: ${student.grade.toInt()}'),
                    trailing: Switch(
                      value: isPresent,
                      onChanged: (value) {
                        setState(() {
                          _attendance[student.id] = value;
                        });
                      },
                      activeColor: colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitAttendance,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'حفظ الحضور',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
