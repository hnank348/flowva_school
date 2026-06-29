import 'package:flowva_school/models/supervisor/student_attendance_model.dart';

enum StudentAttendanceStatus { present, absent, late, excused }

abstract class StudentAttendanceState {
  final Map<String, StudentAttendanceStatus> attendanceMap;
  const StudentAttendanceState(this.attendanceMap);
}

class StudentAttendanceInitial extends StudentAttendanceState {
  StudentAttendanceInitial() : super(const {});
}

class StudentAttendanceLoading extends StudentAttendanceState {
  const StudentAttendanceLoading(super.attendanceMap);
}

class StudentAttendanceSuccess extends StudentAttendanceState {
  final List<StudentAttendanceModel> students;
  const StudentAttendanceSuccess(this.students, super.attendanceMap);
}

class StudentAttendanceError extends StudentAttendanceState {
  final String errorMessage;
  const StudentAttendanceError(this.errorMessage) : super(const {});
}