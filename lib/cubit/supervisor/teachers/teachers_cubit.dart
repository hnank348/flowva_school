import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/supervisor/teachers_service.dart';
import 'teachers_state.dart';

class TeachersCubit extends Cubit<TeachersState> {
  final TeachersService _teachersService;
  final String userToken;

  // الكونستركتور يستقبل السيرفس والتوكن بشكل نظيف ومتوافق تماماً مع الـ AppProviders
  TeachersCubit({
    required TeachersService teachersService,
    required this.userToken,
  })  : _teachersService = teachersService,
        super(TeachersInitial());

  /// دالة جلب المعلمين من السيرفر وتحديث الحالة تلقائياً
  Future<void> fetchTeachers() async {
    emit(TeachersLoading());
    try {
      // استدعاء السيرفس وتمرير التوكن الجاهز المحقون بالكونستركتور
      final teachers = await _teachersService.getTeachers(token: userToken);

      if (teachers.isEmpty) {
        emit(TeachersError("لا يوجد معلمون مضافون حالياً"));
      } else {
        emit(TeachersSuccess(teachers));
      }
    } catch (e) {
      // تمرير نص الخطأ الصافي القادم من السيرفر
      emit(TeachersError(e.toString()));
    }
  }
}