import 'package:flutter_bloc/flutter_bloc.dart';

// تعريف الحالات الممكنة للطالب
enum StudentAttendanceStatus { present, absent, late, excused }

class StudentAttendanceState {
  // خريطة تخزن معرف الطالب أو اسمه مع حالته الحالية
  final Map<String, StudentAttendanceStatus> attendanceMap;
  final String selectedClass;

  const StudentAttendanceState({
    required final this.attendanceMap,
    required final this.selectedClass,
  });
}

class StudentAttendanceCubit extends Cubit<StudentAttendanceState> {
  StudentAttendanceCubit() : super(const StudentAttendanceState(attendanceMap: {}, selectedClass: 'الصف الثالث - أ'));

  // تغيير الصف المحدد
  void changeClass(String className) {
    emit(StudentAttendanceState(attendanceMap: state.attendanceMap, selectedClass: className));
  }

  // تحديث حالة الطالب عند الضغط
  void updateAttendance(String studentName, StudentAttendanceStatus status) {
    final updatedMap = Map<String, StudentAttendanceStatus>.from(state.attendanceMap);
    updatedMap[studentName] = status;
    emit(StudentAttendanceState(attendanceMap: updatedMap, selectedClass: state.selectedClass));
  }
}