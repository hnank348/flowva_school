import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flowva_school/cubit/supervisor/submit_teacher/teacher_attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/models/supervisor/teacher_attendance_model.dart';
import 'package:flowva_school/services/supervisor/teacher_attendance_service.dart';

export 'package:flowva_school/cubit/supervisor/submit_teacher/teacher_attendance_state.dart';

class TeacherAttendanceCubit extends Cubit<TeacherAttendanceState> {
  final TeacherAttendanceService _service;

  TeacherAttendanceCubit(this._service) : super(TeacherAttendanceInitial());

  Future<void> fetchTeachers({
    required String Function(String key) tr, // 🟢 إجباري بدون خيارات
  }) async {
    emit(TeacherAttendanceLoading(state.attendanceMap));
    try {
      final today = _todayString();
      final records = await _service.getDailyAttendance(date: today);

      if (records.isNotEmpty) {
        final attendanceMap = <int, TeacherAttendanceStatus>{};
        final editMap       = <int, TeacherAttendanceStatus>{};
        final noteEditMap   = <int, String?>{};

        for (final r in records) {
          final status = _toStatus(r.statusId);
          attendanceMap[r.teacherId] = status;
          editMap[r.id] = status;
          noteEditMap[r.id] = r.notes;
        }

        emit(TeacherAttendanceViewMode(
          records,
          attendanceMap,
          editMap,
          noteEditMap: noteEditMap,
        ));
      } else {
        final teachers = await _service.getTeachers(tr: context.tr,);

        if (teachers.isEmpty) {
          emit(TeacherAttendanceError(tr('teacher_attendance_no_teachers')));
          return;
        }

        final map        = <int, TeacherAttendanceStatus>{};
        final noteMap     = <int, String?>{};
        final expandedMap = <int, bool>{};
        for (final t in teachers) {
          map[t.id] = TeacherAttendanceStatus.active;
          noteMap[t.id] = t.notes;
          expandedMap[t.id] = true;
        }
        emit(TeacherAttendanceSuccess(
          teachers,
          map,
          noteMap: noteMap,
          expandedMap: expandedMap,
        ));
      }
    } catch (e) {
      emit(TeacherAttendanceError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  void updateAttendance(int teacherId, TeacherAttendanceStatus status) {
    if (state is TeacherAttendanceSuccess) {
      final s   = state as TeacherAttendanceSuccess;
      final map = Map<int, TeacherAttendanceStatus>.from(s.attendanceMap);
      map[teacherId] = status;

      final newExpanded = Map<int, bool>.from(s.expandedMap);
      newExpanded[teacherId] = false;

      emit(s.copyWith(attendanceMap: map, expandedMap: newExpanded));
    }
  }

  void updateNote(int teacherId, String? note) {
    if (state is TeacherAttendanceSuccess) {
      final s = state as TeacherAttendanceSuccess;
      final map = Map<int, String?>.from(s.noteMap);
      map[teacherId] = note;
      emit(s.copyWith(noteMap: map));
    }
  }

  void toggleExpanded(int teacherId, bool value) {
    if (state is TeacherAttendanceSuccess) {
      final s = state as TeacherAttendanceSuccess;
      final map = Map<int, bool>.from(s.expandedMap);
      map[teacherId] = value;
      emit(s.copyWith(expandedMap: map));
    }
  }

  void updateEditStatus(int attendanceRecordId, TeacherAttendanceStatus status) {
    if (state is TeacherAttendanceViewMode) {
      final s          = state as TeacherAttendanceViewMode;
      final newEditMap = Map<int, TeacherAttendanceStatus>.from(s.editMap);
      final newAttMap  = Map<int, TeacherAttendanceStatus>.from(s.attendanceMap);
      final newExpanded = Map<int, bool>.from(s.expandedMap);

      newEditMap[attendanceRecordId] = status;
      newExpanded[attendanceRecordId] = false;

      final record = s.records.firstWhere((r) => r.id == attendanceRecordId);
      newAttMap[record.teacherId] = status;

      emit(s.copyWith(
        attendanceMap: newAttMap,
        editMap: newEditMap,
        expandedMap: newExpanded,
      ));
    }
  }

  void updateEditNote(int attendanceRecordId, String? note) {
    if (state is TeacherAttendanceViewMode) {
      final s = state as TeacherAttendanceViewMode;
      final newNoteMap = Map<int, String?>.from(s.noteEditMap);
      newNoteMap[attendanceRecordId] = note;
      emit(s.copyWith(noteEditMap: newNoteMap));
    }
  }

  void toggleEditExpanded(int attendanceRecordId, bool value) {
    if (state is TeacherAttendanceViewMode) {
      final s = state as TeacherAttendanceViewMode;
      final map = Map<int, bool>.from(s.expandedMap);
      map[attendanceRecordId] = value;
      emit(s.copyWith(expandedMap: map));
    }
  }

  Future<void> submitSingleUpdate(int attendanceRecordId) async {
    if (state is! TeacherAttendanceViewMode) return;

    final s      = state as TeacherAttendanceViewMode;
    final status = s.editMap[attendanceRecordId];
    if (status == null) return;
    final note = s.noteEditMap[attendanceRecordId];

    final savingMap = Map<int, bool>.from(s.savingMap)
      ..[attendanceRecordId] = true;
    emit(s.copyWith(savingMap: savingMap));

    try {
      await _service.updateAttendanceRecord(
        attendanceId: attendanceRecordId,
        statusId:     _fromStatus(status),
        notes:        note,
        tr: context.tr,
      );

      if (state is TeacherAttendanceViewMode) {
        final current   = state as TeacherAttendanceViewMode;
        final newSaving = Map<int, bool>.from(current.savingMap)
          ..[attendanceRecordId] = false;
        final newSaved  = Map<int, bool>.from(current.savedMap)
          ..[attendanceRecordId] = true;
        emit(current.copyWith(savingMap: newSaving, savedMap: newSaved));

        Future.delayed(const Duration(seconds: 2), () {
          if (state is TeacherAttendanceViewMode) {
            final c2 = state as TeacherAttendanceViewMode;
            final resetSaved = Map<int, bool>.from(c2.savedMap)
              ..[attendanceRecordId] = false;
            emit(c2.copyWith(savedMap: resetSaved));
          }
        });
      }
    } catch (e) {
      if (state is TeacherAttendanceViewMode) {
        final current   = state as TeacherAttendanceViewMode;
        final newSaving = Map<int, bool>.from(current.savingMap)
          ..[attendanceRecordId] = false;
        emit(current.copyWith(savingMap: newSaving));
      }
      rethrow;
    }
  }

  String _todayString() {
    final now = DateTime.now();
    final y   = now.year.toString();
    final m   = now.month.toString().padLeft(2, '0');
    final d   = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  TeacherAttendanceStatus _toStatus(int id) {
    switch (id) {
      case 2:  return TeacherAttendanceStatus.inactive;
      case 3:  return TeacherAttendanceStatus.vacation;
      case 4:  return TeacherAttendanceStatus.transferred;
      default: return TeacherAttendanceStatus.active;
    }
  }

  int _fromStatus(TeacherAttendanceStatus s) {
    switch (s) {
      case TeacherAttendanceStatus.active:       return 1;
      case TeacherAttendanceStatus.inactive:     return 2;
      case TeacherAttendanceStatus.vacation:     return 3;
      case TeacherAttendanceStatus.transferred:  return 4;
    }
  }
}

class SubmitTeacherAttendanceCubit extends Cubit<SubmitTeacherAttendanceState> {
  final TeacherAttendanceService _service;

  SubmitTeacherAttendanceCubit(this._service)
      : super(SubmitTeacherAttendanceInitial());

  static int _statusToId(TeacherAttendanceStatus s) {
    switch (s) {
      case TeacherAttendanceStatus.active:       return 1;
      case TeacherAttendanceStatus.inactive:     return 2;
      case TeacherAttendanceStatus.vacation:     return 3;
      case TeacherAttendanceStatus.transferred:  return 4;
    }
  }

  Future<void> submitAttendance({
    required List<TeacherModel> teachers,
    required Map<int, TeacherAttendanceStatus> attendanceMap,
    required String Function(String key) tr, // 🟢 إجباري بدون خيارات
    Map<int, String?> noteMap = const {},
  }) async {
    if (teachers.isEmpty) {
      emit(SubmitTeacherAttendanceError(tr('submit_teacher_attendance_no_teachers')));
      return;
    }
    emit(SubmitTeacherAttendanceLoading());
    try {
      final now       = DateTime.now();
      final date      = '${now.year}-${_p(now.month)}-${_p(now.day)}';
      final checkIn   = '${_p(now.hour)}:${_p(now.minute)}';
      final statusMap = <int, int>{};

      for (final t in teachers) {
        final status = attendanceMap[t.id] ?? TeacherAttendanceStatus.active;
        statusMap[t.id] = _statusToId(status);
      }

      await _service.submitAll(
        teachers:     teachers,
        statusMap:    statusMap,
        date:         date,
        checkInTime:  checkIn,
        notesMap:     noteMap,
        tr: context.tr,
      );

      emit(SubmitTeacherAttendanceSuccess(tr('submit_teacher_attendance_success')));
    } catch (e) {
      emit(SubmitTeacherAttendanceError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  void reset() => emit(SubmitTeacherAttendanceInitial());

  String _p(int n) => n.toString().padLeft(2, '0');
}