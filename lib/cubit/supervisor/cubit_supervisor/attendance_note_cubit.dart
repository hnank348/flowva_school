import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceNoteCubit extends Cubit<String> {
  AttendanceNoteCubit(String initialText) : super(initialText);

  void updateText(String text) => emit(text);

  void clear() => emit('');
}