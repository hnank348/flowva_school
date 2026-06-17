import 'package:flutter_bloc/flutter_bloc.dart';

// 🎨 الحالات الأربعة المحدثة بدقة لمعلمي المنشأة
enum TeacherAttendanceStatus { active, inactive, vacation, transferred }

class TeachersAttendanceState {
  final Map<String, TeacherAttendanceStatus> attendanceMap;

  const TeachersAttendanceState({required this.attendanceMap});
}

class TeachersAttendanceCubit extends Cubit<TeachersAttendanceState> {
  // القيمة الابتدائية تبدأ بـ active (نشط) كحالة افتراضية
  TeachersAttendanceCubit() : super(const TeachersAttendanceState(attendanceMap: {}));

  // دالة تحديث حالة المعلم الدورية
  void updateAttendance(String teacherName, TeacherAttendanceStatus status) {
    final updatedMap = Map<String, TeacherAttendanceStatus>.from(state.attendanceMap);
    updatedMap[teacherName] = status;
    emit(TeachersAttendanceState(attendanceMap: updatedMap));
  }
}