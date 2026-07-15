import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/student/student_attendance_state.dart';
import 'package:flowva_school/services/supervisor/student_attendance_service.dart';

export 'package:flowva_school/cubit/supervisor/student/student_attendance_state.dart';

class StudentAttendanceCubit extends Cubit<StudentAttendanceState> {
  final StudentAttendanceService _service;
  final String userToken;

  StudentAttendanceCubit({
    required StudentAttendanceService attendanceService,
    required this.userToken,
  })  : _service = attendanceService,
        super(StudentAttendanceInitial());

  Future<void> fetchAttendance(int sectionId, {required int semesterId}) async {
    emit(StudentAttendanceLoading(state.attendanceMap));

    try {
      final today = _todayString();

      final records = await _service.getAttendanceBySection(
        sectionId: sectionId,
        date:      today,
      );

      if (records.isNotEmpty) {
        final attendanceMap = <String, StudentAttendanceStatus>{};
        final editMap       = <int, StudentAttendanceStatus>{};
        final noteEditMap   = <int, String?>{};

        for (final r in records) {
          final status = _toStatus(r.statusId);
          attendanceMap[r.studentId.toString()] = status;
          editMap[r.id] = status;
          noteEditMap[r.id] = r.notes;
        }

        emit(StudentAttendanceViewMode(
          records,
          attendanceMap,
          editMap,
          noteEditMap: noteEditMap,
        ));
      } else {
        final students = await _service.getStudentsBySection(
          sectionId: sectionId,
          token:     userToken,
        );

        if (students.isEmpty) {
          emit(const StudentAttendanceError('لا يوجد طلاب في هذه الشعبة'));
          return;
        }

        final map          = <String, StudentAttendanceStatus>{};
        final noteMap       = <String, String?>{};
        final expandedMap   = <String, bool>{};
        for (final s in students) {
          map[s.id.toString()] = StudentAttendanceStatus.present;
          noteMap[s.id.toString()] = s.notes;
          expandedMap[s.id.toString()] = true; // ✅ موسّع افتراضياً بوضع التسجيل
        }
        emit(StudentAttendanceSuccess(
          students,
          map,
          noteMap: noteMap,
          expandedMap: expandedMap,
        ));
      }
    } catch (e) {
      emit(StudentAttendanceError(e.toString()));
    }
  }

  void updateAttendance(String studentId, StudentAttendanceStatus status) {
    if (state is StudentAttendanceSuccess) {
      final s      = state as StudentAttendanceSuccess;
      final newMap = Map<String, StudentAttendanceStatus>.from(s.attendanceMap);
      newMap[studentId] = status;

      // ✅ يطوي الكارت تلقائياً بعد الاختيار
      final newExpanded = Map<String, bool>.from(s.expandedMap);
      newExpanded[studentId] = false;

      emit(s.copyWith(attendanceMap: newMap, expandedMap: newExpanded));
    }
  }

  void updateNote(String studentId, String? note) {
    if (state is StudentAttendanceSuccess) {
      final s = state as StudentAttendanceSuccess;
      final newMap = Map<String, String?>.from(s.noteMap);
      newMap[studentId] = note;
      emit(s.copyWith(noteMap: newMap));
    }
  }

  // ✅ جديد - فتح/إغلاق منطقة اختيار الحالة (وضع التسجيل)
  void toggleExpanded(String studentId, bool value) {
    if (state is StudentAttendanceSuccess) {
      final s = state as StudentAttendanceSuccess;
      final map = Map<String, bool>.from(s.expandedMap);
      map[studentId] = value;
      emit(s.copyWith(expandedMap: map));
    }
  }

  void updateEditStatus(int attendanceRecordId, StudentAttendanceStatus status) {
    if (state is StudentAttendanceViewMode) {
      final s          = state as StudentAttendanceViewMode;
      final newEditMap = Map<int, StudentAttendanceStatus>.from(s.editMap);
      final newAttMap  = Map<String, StudentAttendanceStatus>.from(s.attendanceMap);
      final newExpanded = Map<int, bool>.from(s.expandedMap);

      newEditMap[attendanceRecordId] = status;
      newExpanded[attendanceRecordId] = false; // ✅ يطوي بعد الاختيار

      final record = s.records.firstWhere((r) => r.id == attendanceRecordId);
      newAttMap[record.studentId.toString()] = status;

      emit(s.copyWith(
        attendanceMap: newAttMap,
        editMap: newEditMap,
        expandedMap: newExpanded,
      ));
    }
  }

  void updateEditNote(int attendanceRecordId, String? note) {
    if (state is StudentAttendanceViewMode) {
      final s = state as StudentAttendanceViewMode;
      final newNoteMap = Map<int, String?>.from(s.noteEditMap);
      newNoteMap[attendanceRecordId] = note;
      emit(s.copyWith(noteEditMap: newNoteMap));
    }
  }

  // ✅ جديد - فتح/إغلاق منطقة اختيار الحالة (وضع العرض/التعديل)
  void toggleEditExpanded(int attendanceRecordId, bool value) {
    if (state is StudentAttendanceViewMode) {
      final s = state as StudentAttendanceViewMode;
      final map = Map<int, bool>.from(s.expandedMap);
      map[attendanceRecordId] = value;
      emit(s.copyWith(expandedMap: map));
    }
  }

  Future<void> submitSingleUpdate(int attendanceRecordId) async {
    if (state is! StudentAttendanceViewMode) return;

    final s      = state as StudentAttendanceViewMode;
    final status = s.editMap[attendanceRecordId];
    if (status == null) return;
    final note = s.noteEditMap[attendanceRecordId];

    // ✅ تفعيل حالة التحميل بالـ Cubit
    final savingMap = Map<int, bool>.from(s.savingMap)
      ..[attendanceRecordId] = true;
    emit(s.copyWith(savingMap: savingMap));

    try {
      await _service.updateAttendanceRecord(
        attendanceId: attendanceRecordId,
        statusId:     _fromStatus(status),
        notes:        note,
      );

      if (state is StudentAttendanceViewMode) {
        final current   = state as StudentAttendanceViewMode;
        final newSaving = Map<int, bool>.from(current.savingMap)
          ..[attendanceRecordId] = false;
        final newSaved  = Map<int, bool>.from(current.savedMap)
          ..[attendanceRecordId] = true;
        emit(current.copyWith(savingMap: newSaving, savedMap: newSaved));

        // ✅ إخفاء علامة "تم الحفظ" بعد ثانيتين
        Future.delayed(const Duration(seconds: 2), () {
          if (state is StudentAttendanceViewMode) {
            final c2 = state as StudentAttendanceViewMode;
            final resetSaved = Map<int, bool>.from(c2.savedMap)
              ..[attendanceRecordId] = false;
            emit(c2.copyWith(savedMap: resetSaved));
          }
        });
      }
    } catch (e) {
      if (state is StudentAttendanceViewMode) {
        final current   = state as StudentAttendanceViewMode;
        final newSaving = Map<int, bool>.from(current.savingMap)
          ..[attendanceRecordId] = false;
        emit(current.copyWith(savingMap: newSaving));
      }
      rethrow;
    }
  }

  // ─── helpers ──────────────────────────────────────────────────────────────

  String _todayString() {
    final now = DateTime.now();
    final y   = now.year.toString();
    final m   = now.month.toString().padLeft(2, '0');
    final d   = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  StudentAttendanceStatus _toStatus(int id) {
    switch (id) {
      case 2:  return StudentAttendanceStatus.absent;
      case 3:  return StudentAttendanceStatus.late;
      case 4:  return StudentAttendanceStatus.excused;
      default: return StudentAttendanceStatus.present;
    }
  }

  int _fromStatus(StudentAttendanceStatus s) {
    switch (s) {
      case StudentAttendanceStatus.present:  return 1;
      case StudentAttendanceStatus.absent:   return 2;
      case StudentAttendanceStatus.late:     return 3;
      case StudentAttendanceStatus.excused:  return 4;
    }
  }
}