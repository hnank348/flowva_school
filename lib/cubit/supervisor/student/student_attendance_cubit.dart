import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/student/student_attendance_state.dart';
import 'package:flowva_school/services/supervisor/student_attendance_service.dart';

// ✅ تصدير الـ State من هنا حتى يكفي استيراد ملف الـ Cubit فقط في الـ View
export 'package:flowva_school/cubit/supervisor/student/student_attendance_state.dart';

class StudentAttendanceCubit extends Cubit<StudentAttendanceState> {
  final StudentAttendanceService _attendanceService;
  final String userToken;

  StudentAttendanceCubit({
    required StudentAttendanceService attendanceService,
    required this.userToken,
  })  : _attendanceService = attendanceService,
        super(StudentAttendanceInitial());

  Future<void> fetchAttendance(int sectionId, {required int semesterId}) async {
    emit(StudentAttendanceLoading(state.attendanceMap));
    try {
      final students = await _attendanceService.getStudentsBySection(
        sectionId: sectionId,
        token: userToken,
      );

      if (students.isEmpty) {
        emit( StudentAttendanceError("لا يوجد طلاب مضافون في هذه الشعبة حالياً"));
      } else {
        final Map<String, StudentAttendanceStatus> updatedMap =
        Map.from(state.attendanceMap);
        for (var student in students) {
          updatedMap.putIfAbsent(
            student.id.toString(),
                () => StudentAttendanceStatus.present,
          );
        }
        emit(StudentAttendanceSuccess(students, updatedMap));
      }
    } catch (e) {
      emit(StudentAttendanceError(e.toString()));
    }
  }

  void updateAttendance(String studentId, StudentAttendanceStatus status) {
    if (state is StudentAttendanceSuccess) {
      final currentSuccess = state as StudentAttendanceSuccess;
      final updatedMap = Map<String, StudentAttendanceStatus>.from(
        currentSuccess.attendanceMap,
      );
      updatedMap[studentId] = status;
      emit(StudentAttendanceSuccess(currentSuccess.students, updatedMap));
    }
  }
}