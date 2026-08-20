import 'package:flowva_school/cubit/supervisor/submit_student/submit_attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/models/supervisor/student_attendance_model.dart';
import 'package:flowva_school/services/supervisor/submit_attendance_service.dart';

import '../student_attendance/student_attendance_state.dart';

class SubmitAttendanceCubit extends Cubit<SubmitAttendanceState> {
  final SubmitAttendanceService _service;

  SubmitAttendanceCubit(this._service) : super(const SubmitAttendanceInitial());

  static int statusToId(StudentAttendanceStatus status) {
    switch (status) {
      case StudentAttendanceStatus.present:  return 1;
      case StudentAttendanceStatus.absent:   return 2;
      case StudentAttendanceStatus.late:     return 3;
      case StudentAttendanceStatus.excused:  return 4;
    }
  }

  Future<void> submitAttendance({
    required List<StudentAttendanceModel> students,
    required Map<String, StudentAttendanceStatus> attendanceMap,
    required int sectionId,
    required int academicYearId,
    required int semesterId,
    required String Function(String key) tr,
    Map<String, String?> noteMap = const {},
  }) async {
    if (students.isEmpty) {
      emit(SubmitAttendanceError(tr('submit_attendance_no_students')));
      return;
    }

    emit(const SubmitAttendanceLoading());

    try {
      final now  = DateTime.now();
      final date = '${now.year}-${_p(now.month)}-${_p(now.day)}';
      final time = '${_p(now.hour)}:${_p(now.minute)}';

      // 🟢 طباعة تشخيصية - احذفها بعد التأكد من الحل
      print('📅 [DEBUG] Device DateTime.now() = $now');
      print('📅 [DEBUG] Sending date = $date');
      print('📅 [DEBUG] Sending time = $time');

      final statusMap = <String, int>{};
      for (final student in students) {
        final sid    = student.id.toString();
        final status = attendanceMap[sid] ?? StudentAttendanceStatus.present;
        statusMap[sid] = statusToId(status);
      }

      await _service.submitAll(
        studentIds:     students.map((s) => s.id).toList(),
        sectionId:      sectionId,
        academicYearId: academicYearId,
        semesterId:     semesterId,
        statusMap:      statusMap,
        date:           date,
        checkInTime:    time,
        notesMap:       noteMap,
        tr: tr, // ✅ تم إصلاح المشكلة: استخدام البارامتر الممرر بدلاً من context.tr
      );

      emit(SubmitAttendanceSuccess(tr('submit_attendance_success')));
    } catch (e) {
      emit(SubmitAttendanceError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  void reset() => emit(const SubmitAttendanceInitial());

  String _p(int n) => n.toString().padLeft(2, '0');
}