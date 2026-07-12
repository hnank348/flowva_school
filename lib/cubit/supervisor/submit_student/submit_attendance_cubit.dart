import 'package:flowva_school/cubit/supervisor/submit_student/submit_attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/student/student_attendance_state.dart';
import 'package:flowva_school/models/supervisor/student_attendance_model.dart';
import 'package:flowva_school/services/supervisor/submit_attendance_service.dart';


class SubmitAttendanceCubit extends Cubit<SubmitAttendanceState> {
  final SubmitAttendanceService _service;

  SubmitAttendanceCubit(this._service) : super(const SubmitAttendanceInitial());

  // ─── تحويل enum → statusId ───
  static int statusToId(StudentAttendanceStatus status) {
    switch (status) {
      case StudentAttendanceStatus.present:  return 1;
      case StudentAttendanceStatus.absent:   return 2;
      case StudentAttendanceStatus.late:     return 3;
      case StudentAttendanceStatus.excused:  return 4;
    }
  }

  /// إرسال حضور كل الطلاب في الشعبة
  Future<void> submitAttendance({
    required List<StudentAttendanceModel> students,
    required Map<String, StudentAttendanceStatus> attendanceMap,
    required int sectionId,
    required int academicYearId,
    required int semesterId,
  }) async {
    if (students.isEmpty) {
      emit(const SubmitAttendanceError('لا يوجد طلاب لتسجيل حضورهم'));
      return;
    }

    emit(const SubmitAttendanceLoading());

    try {
      final now     = DateTime.now();
      final date    = '${now.year}-${_p(now.month)}-${_p(now.day)}';
      final time    = '${_p(now.hour)}:${_p(now.minute)}';

      // بناء statusMap: studentId → statusId
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
      );

      emit(const SubmitAttendanceSuccess('تم تسجيل الحضور بنجاح ✓'));
    } catch (e) {
      emit(SubmitAttendanceError(e.toString()));
    }
  }

  void reset() => emit(const SubmitAttendanceInitial());

  String _p(int n) => n.toString().padLeft(2, '0');
}