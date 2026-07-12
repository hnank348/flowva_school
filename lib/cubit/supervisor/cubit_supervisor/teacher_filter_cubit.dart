import 'package:flutter_bloc/flutter_bloc.dart';

enum TeacherAttendanceFilter { all, active, inactive, vacation, transferred }

class TeacherFilterCubit extends Cubit<TeacherAttendanceFilter> {
  TeacherFilterCubit() : super(TeacherAttendanceFilter.all);

  void setFilter(TeacherAttendanceFilter filter) => emit(filter);

  void reset() => emit(TeacherAttendanceFilter.all);
}