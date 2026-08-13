import 'package:easy_localization/easy_localization.dart' as context;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/supervisor/subjects_service.dart';
import 'subjects_state.dart';

class SubjectsCubit extends Cubit<SubjectsState> {
  final SubjectsService _subjectsService;
  final String userToken;

  SubjectsCubit({
    required SubjectsService subjectsService,
    required this.userToken,
  })  : _subjectsService = subjectsService,
        super(SubjectsInitial());

  Future<void> fetchSubjects({
    required String Function(String key) tr,
  }) async {
    emit(SubjectsLoading());
    try {
      final subjects = await _subjectsService.getSubjects(token: userToken,tr: context.tr,);

      if (subjects.isEmpty) {
        emit(SubjectsError(tr('subjects_no_subjects_error')));
      } else {
        emit(SubjectsSuccess(subjects));
      }
    } catch (e) {
      emit(SubjectsError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}