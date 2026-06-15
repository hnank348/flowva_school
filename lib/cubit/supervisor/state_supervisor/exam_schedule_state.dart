import 'package:flutter_bloc/flutter_bloc.dart';

class ExamScheduleState {
  final String selectedClass;

  const ExamScheduleState({required this.selectedClass});
}

class ExamScheduleCubit extends Cubit<ExamScheduleState> {
  // الحالة الابتدائية لجدول الامتحانات
  ExamScheduleCubit() : super(const ExamScheduleState(selectedClass: 'الصف الثالث - أ'));

  // دالة لتغيير الصف المحدد في جدول الامتحانات
  void changeClass(String className) {
    emit(ExamScheduleState(selectedClass: className));
  }

  // دالة لحفظ التعديلات أو تحديث جدول الامتحان مستقبلاً
  void saveExamSchedule() {
    // منطق الحفظ هنا
    emit(ExamScheduleState(selectedClass: state.selectedClass));
  }
}