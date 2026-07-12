import 'package:flowva_school/models/supervisor/teacher_attendance_model.dart';

enum TeacherAttendanceStatus { active, inactive, vacation, transferred }

abstract class TeacherAttendanceState {
  final Map<int, TeacherAttendanceStatus> attendanceMap;
  const TeacherAttendanceState(this.attendanceMap);
}

class TeacherAttendanceInitial extends TeacherAttendanceState {
  TeacherAttendanceInitial() : super(const {});
}

class TeacherAttendanceLoading extends TeacherAttendanceState {
  const TeacherAttendanceLoading(super.attendanceMap);
}

class TeacherAttendanceSuccess extends TeacherAttendanceState {
  final List<TeacherModel> teachers;
  const TeacherAttendanceSuccess(this.teachers, super.attendanceMap);
}

class TeacherAttendanceError extends TeacherAttendanceState {
  final String errorMessage;
  const TeacherAttendanceError(this.errorMessage) : super(const {});
}

// ─── Submit States ───────────────────────────────────────────────────────────

abstract class SubmitTeacherAttendanceState {}

class SubmitTeacherAttendanceInitial extends SubmitTeacherAttendanceState {}

class SubmitTeacherAttendanceLoading extends SubmitTeacherAttendanceState {}

class SubmitTeacherAttendanceSuccess extends SubmitTeacherAttendanceState {
  final String message;
  SubmitTeacherAttendanceSuccess(this.message);
}

class SubmitTeacherAttendanceError extends SubmitTeacherAttendanceState {
  final String errorMessage;
  SubmitTeacherAttendanceError(this.errorMessage);
}