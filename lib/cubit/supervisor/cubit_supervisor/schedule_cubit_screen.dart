import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleStateScreen {
  final String selectedClass;

  const ScheduleStateScreen({required this.selectedClass});
}

class ScheduleCubitScreen extends Cubit<ScheduleStateScreen> {
  ScheduleCubitScreen() : super(const ScheduleStateScreen(selectedClass: 'الصف الثالث - أ'));

  void changeClass(String className) {
    emit(ScheduleStateScreen(selectedClass: className));
  }

  void updateSessionDetails({required String subject, required String teacher, required String room}) {
    emit(ScheduleStateScreen(selectedClass: state.selectedClass));
  }
}