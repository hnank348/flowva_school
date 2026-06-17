import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/supervisor/subjects_service.dart';
import 'subjects_state.dart';

class SubjectsCubit extends Cubit<SubjectsState> {
  final SubjectsService _subjectsService;
  final String userToken;

  // الكونستركتور يستقبل السيرفر والتوكن بشكل نظيف ومتوافق مع الـ AppProviders
  SubjectsCubit({
    required SubjectsService subjectsService,
    required this.userToken,
  })  : _subjectsService = subjectsService,
        super(SubjectsInitial());

  /// دالة جلب المواد من السيرفر وتحديث الحالة تلقائياً
  Future<void> fetchSubjects() async {
    emit(SubjectsLoading());
    try {
      final subjects = await _subjectsService.getSubjects(token: userToken);

      if (subjects.isEmpty) {
        emit(SubjectsError("لا توجد مواد مضافة لهذا الصف حالياً"));
      } else {
        emit(SubjectsSuccess(subjects));
      }
    } catch (e) {
      // تمرير نص الخطأ الصافي القادم من السيرفر
      emit(SubjectsError(e.toString()));
    }
  }
}