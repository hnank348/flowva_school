import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceFilterCubit<T> extends Cubit<T> {
  AttendanceFilterCubit(T initial) : super(initial);

  void setFilter(T filter) => emit(filter);
}