import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/mutual/section_item_model.dart';
import '../../../services/supervisor/students_service.dart';
import 'assign_student_state.dart';

class AssignStudentCubit extends Cubit<AssignStudentState> {
  final StudentsService _studentsService;

  AssignStudentCubit(this._studentsService) : super(AssignStudentInitial());

  Future<void> loadSections({
    required String Function(String key) tr,
  }) async {
    emit(AssignStudentLoadingSections());
    try {
      final sections = await _studentsService.getAllSections(tr: tr);
      emit(AssignStudentSectionsLoaded(
        sections: sections,
        selectedSection: sections.isNotEmpty ? sections.first : null,
      ));
    } catch (e) {
      emit(AssignStudentError(e.toString()));
    }
  }

  void selectSection(SectionItemModel section) {
    if (state is AssignStudentSectionsLoaded) {
      final current = state as AssignStudentSectionsLoaded;
      emit(current.copyWith(selectedSection: section));
    }
  }

  Future<void> assignStudent({
    required int studentId,
    required int semesterId,
    required int academicYearId,
    required String Function(String key) tr,
  }) async {
    if (state is! AssignStudentSectionsLoaded) return;
    final current = state as AssignStudentSectionsLoaded;

    if (current.selectedSection == null) {
      emit(AssignStudentError(tr('please_select_section')));
      return;
    }

    emit(AssignStudentSubmitting());
    try {
      await _studentsService.assignStudentToSection(
        studentId: studentId,
        sectionId: current.selectedSection!.id,
        semesterId: semesterId,
        academicYearId: academicYearId,
        tr: tr,
      );
      emit(AssignStudentSuccess(tr('student_assigned_success')));
    } catch (e) {
      emit(AssignStudentError(e.toString()));
    }
  }
}