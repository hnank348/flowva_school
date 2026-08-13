import 'package:flowva_school/models/supervisor/teacher_attendance_model.dart';
import 'package:flowva_school/models/supervisor/teacher_attendance_record_model.dart';

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
  final Map<int, String?> noteMap;
  final Map<int, bool> expandedMap; // ✅ جديد

  const TeacherAttendanceSuccess(
      this.teachers,
      super.attendanceMap, {
        this.noteMap = const {},
        this.expandedMap = const {},
      });

  TeacherAttendanceSuccess copyWith({
    List<TeacherModel>? teachers,
    Map<int, TeacherAttendanceStatus>? attendanceMap,
    Map<int, String?>? noteMap,
    Map<int, bool>? expandedMap,
  }) {
    return TeacherAttendanceSuccess(
      teachers ?? this.teachers,
      attendanceMap ?? this.attendanceMap,
      noteMap: noteMap ?? this.noteMap,
      expandedMap: expandedMap ?? this.expandedMap,
    );
  }
}

class TeacherAttendanceViewMode extends TeacherAttendanceState {
  final List<TeacherAttendanceRecord> records;
  final Map<int, TeacherAttendanceStatus> editMap;
  final Map<int, String?> noteEditMap;
  final Map<int, bool> expandedMap; // ✅ جديد
  final Map<int, bool> savingMap;   // ✅ جديد
  final Map<int, bool> savedMap;    // ✅ جديد

  const TeacherAttendanceViewMode(
      this.records,
      super.attendanceMap,
      this.editMap, {
        this.noteEditMap = const {},
        this.expandedMap = const {},
        this.savingMap = const {},
        this.savedMap = const {},
      });

  TeacherAttendanceViewMode copyWith({
    List<TeacherAttendanceRecord>? records,
    Map<int, TeacherAttendanceStatus>? attendanceMap,
    Map<int, TeacherAttendanceStatus>? editMap,
    Map<int, String?>? noteEditMap,
    Map<int, bool>? expandedMap,
    Map<int, bool>? savingMap,
    Map<int, bool>? savedMap,
  }) {
    return TeacherAttendanceViewMode(
      records ?? this.records,
      attendanceMap ?? this.attendanceMap,
      editMap ?? this.editMap,
      noteEditMap: noteEditMap ?? this.noteEditMap,
      expandedMap: expandedMap ?? this.expandedMap,
      savingMap: savingMap ?? this.savingMap,
      savedMap: savedMap ?? this.savedMap,
    );
  }
}

class TeacherAttendanceError extends TeacherAttendanceState {
  final String errorMessage;
  const TeacherAttendanceError(this.errorMessage) : super(const {});
}

// ─── حالات إرسال الحضور (submit) - بدون تغيير ──────────────────────────────
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