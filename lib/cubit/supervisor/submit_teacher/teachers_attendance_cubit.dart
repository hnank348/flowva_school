import 'package:flowva_school/cubit/supervisor/submit_teacher/teacher_attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/models/supervisor/teacher_attendance_model.dart';
import 'package:flowva_school/services/supervisor/teacher_attendance_service.dart';


class TeacherAttendanceCubit extends Cubit<TeacherAttendanceState> {
  final TeacherAttendanceService _service;

  TeacherAttendanceCubit(this._service) : super(TeacherAttendanceInitial());

  Future<void> fetchTeachers() async {
    emit(TeacherAttendanceLoading(state.attendanceMap));
    try {
      final teachers = await _service.getTeachers();
      if (teachers.isEmpty) {
        emit(const TeacherAttendanceError('لا يوجد معلمون مسجلون'));
      } else {
        final map = Map<int, TeacherAttendanceStatus>.from(state.attendanceMap);
        for (final t in teachers) {
          map.putIfAbsent(t.id, () => TeacherAttendanceStatus.active);
        }
        emit(TeacherAttendanceSuccess(teachers, map));
      }
    } catch (e) {
      emit(TeacherAttendanceError(e.toString()));
    }
  }

  void updateAttendance(int teacherId, TeacherAttendanceStatus status) {
    if (state is TeacherAttendanceSuccess) {
      final s = state as TeacherAttendanceSuccess;
      final map = Map<int, TeacherAttendanceStatus>.from(s.attendanceMap);
      map[teacherId] = status;
      emit(TeacherAttendanceSuccess(s.teachers, map));
    }
  }
}

// ─── Submit Cubit ─────────────────────────────────────────────────────────────

class SubmitTeacherAttendanceCubit extends Cubit<SubmitTeacherAttendanceState> {
  final TeacherAttendanceService _service;

  SubmitTeacherAttendanceCubit(this._service)
      : super(SubmitTeacherAttendanceInitial());

  static int _statusToId(TeacherAttendanceStatus s) {
    switch (s) {
      case TeacherAttendanceStatus.active:  return 1;
      case TeacherAttendanceStatus.inactive:   return 2;
      case TeacherAttendanceStatus.vacation:     return 3;
      case TeacherAttendanceStatus.transferred:  return 4;
    }
  }

  Future<void> submitAttendance({
    required List<TeacherModel> teachers,
    required Map<int, TeacherAttendanceStatus> attendanceMap,
  }) async {
    if (teachers.isEmpty) {
      emit(SubmitTeacherAttendanceError('لا يوجد معلمون لتسجيل حضورهم'));
      return;
    }
    emit(SubmitTeacherAttendanceLoading());
    try {
      final now        = DateTime.now();
      final date       = '${now.year}-${_p(now.month)}-${_p(now.day)}';
      final checkIn    = '${_p(now.hour)}:${_p(now.minute)}';
      final statusMap  = <int, int>{};

      for (final t in teachers) {
        final status = attendanceMap[t.id] ?? TeacherAttendanceStatus.active;
        statusMap[t.id] = _statusToId(status);
      }

      await _service.submitAll(
        teachers:     teachers,
        statusMap:    statusMap,
        date:         date,
        checkInTime:  checkIn,
      );

      emit(SubmitTeacherAttendanceSuccess('تم تسجيل حضور المعلمين بنجاح ✓'));
    } catch (e) {
      emit(SubmitTeacherAttendanceError(e.toString()));
    }
  }

  void reset() => emit(SubmitTeacherAttendanceInitial());

  String _p(int n) => n.toString().padLeft(2, '0');
}