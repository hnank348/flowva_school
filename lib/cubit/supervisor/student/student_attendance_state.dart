import 'package:flowva_school/models/supervisor/student_attendance_model.dart';
import 'package:flowva_school/models/supervisor/student_attendance_record_model.dart';

enum StudentAttendanceStatus { present, absent, late, excused }

enum AttendanceMode { record, view }

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
  final Map<String, String?> noteMap;
  final Map<String, bool> expandedMap; // ✅ جديد - حالة توسّع كل كارت

  const StudentAttendanceSuccess(
      this.students,
      super.attendanceMap, {
        this.noteMap = const {},
        this.expandedMap = const {},
      });

  StudentAttendanceSuccess copyWith({
    List<StudentAttendanceModel>? students,
    Map<String, StudentAttendanceStatus>? attendanceMap,
    Map<String, String?>? noteMap,
    Map<String, bool>? expandedMap,
  }) {
    return StudentAttendanceSuccess(
      students ?? this.students,
      attendanceMap ?? this.attendanceMap,
      noteMap: noteMap ?? this.noteMap,
      expandedMap: expandedMap ?? this.expandedMap,
    );
  }
}

class StudentAttendanceViewMode extends StudentAttendanceState {
  final List<StudentAttendanceRecord> records;
  final Map<int, StudentAttendanceStatus> editMap;
  final Map<int, String?> noteEditMap;
  final Map<int, bool> expandedMap; // ✅ جديد
  final Map<int, bool> savingMap;   // ✅ جديد - حالة تحميل زر الحفظ
  final Map<int, bool> savedMap;    // ✅ جديد - حالة "تم الحفظ"

  const StudentAttendanceViewMode(
      this.records,
      super.attendanceMap,
      this.editMap, {
        this.noteEditMap = const {},
        this.expandedMap = const {},
        this.savingMap = const {},
        this.savedMap = const {},
      });

  StudentAttendanceViewMode copyWith({
    List<StudentAttendanceRecord>? records,
    Map<String, StudentAttendanceStatus>? attendanceMap,
    Map<int, StudentAttendanceStatus>? editMap,
    Map<int, String?>? noteEditMap,
    Map<int, bool>? expandedMap,
    Map<int, bool>? savingMap,
    Map<int, bool>? savedMap,
  }) {
    return StudentAttendanceViewMode(
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

class StudentAttendanceError extends StudentAttendanceState {
  final String errorMessage;
  const StudentAttendanceError(this.errorMessage) : super(const {});
}