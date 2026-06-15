import 'package:flutter_bloc/flutter_bloc.dart';

// تعريف الحالات الثلاثة المطلوبة للمعلم
enum TeacherAttendanceStatus { present, absent, vacation }

class TeachersAttendanceState {
  final Map<String, TeacherAttendanceStatus> attendanceMap;

  const TeachersAttendanceState({required this.attendanceMap});
}

class TeachersAttendanceCubit extends Cubit<TeachersAttendanceState> {
  TeachersAttendanceCubit() : super(const TeachersAttendanceState(attendanceMap: {}));

  // دالة تحديث حالة المعلم الدورية
  void updateAttendance(String teacherName, TeacherAttendanceStatus status) {
    final updatedMap = Map<String, TeacherAttendanceStatus>.from(state.attendanceMap);
    updatedMap[teacherName] = status;
    emit(TeachersAttendanceState(attendanceMap: updatedMap));
  }
}