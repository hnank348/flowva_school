import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/supervisor/class_details_model.dart';
import '../../../services/supervisor/classes_service.dart';
import 'classes_state.dart';

class ClassesCubit extends Cubit<ClassesState> {
  final ClassesService _classesService;
  final String userToken;

  ClassesCubit({
    required ClassesService classesService,
    required this.userToken,
  })  : _classesService = classesService,
        super(const ClassesInitial());

  Future<void> fetchClassesAndSections({
    int academicYearId = 1,
    required String Function(String key) tr,
  }) async {
    emit(const ClassesLoading());
    try {
      final classDetails = await _classesService.getClassesDetails(
        academicYearId: academicYearId,
        token: userToken,
        tr: tr,
      );

      if (classDetails.sections.isNotEmpty) {
        emit(ClassesLoaded(
          classDetails: classDetails,
          selectedSection: classDetails.sections.first,
        ));
      } else {
        emit(ClassesError(tr('classes_no_sections_error')));
      }
    } catch (e) {
      emit(ClassesError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  void selectSection(SectionModel section) {
    if (state is ClassesLoaded) {
      final currentState = state as ClassesLoaded;
      emit(ClassesLoaded(
        classDetails: currentState.classDetails,
        selectedSection: section,
      ));
    }
  }
}