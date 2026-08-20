import 'package:flowva_school/cubit/supervisor/student_section/transfer_student_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/mutual/section_item_model.dart';
import '../../../services/supervisor/students_service.dart';


class TransferStudentSubmitting extends TransferStudentState {
  const TransferStudentSubmitting();
}

class TransferStudentSuccess extends TransferStudentState {
  final String message;
  const TransferStudentSuccess(this.message);
}

class TransferStudentError extends TransferStudentState {
  final String message;
  const TransferStudentError(this.message);
}

class TransferStudentCubit extends Cubit<TransferStudentState> {
  final StudentsService _service;

  TransferStudentCubit(this._service) : super(const TransferStudentInitial());

  Future<void> loadSections({
    required String Function(String key) tr,
    int? currentSectionId,
  }) async {
    emit(const TransferStudentLoadingSections());
    try {
      final allSections = await _service.getAllSections(tr: tr);
      final filteredSections = currentSectionId != null
          ? allSections.where((s) => s.id != currentSectionId).toList()
          : allSections;

      emit(TransferStudentSectionsLoaded(
        sections: filteredSections,
        selectedSection: filteredSections.isNotEmpty ? filteredSections.first : null,
      ));
    } catch (e) {
      emit(TransferStudentError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  void selectSection(SectionItemModel section) {
    if (state is TransferStudentSectionsLoaded) {
      emit((state as TransferStudentSectionsLoaded).copyWith(selectedSection: section));
    }
  }

  Future<void> transferStudent({
    required int studentId,
    required String Function(String key) tr,
  }) async {
    if (state is! TransferStudentSectionsLoaded) return;
    final current = state as TransferStudentSectionsLoaded;
    if (current.selectedSection == null) return;

    emit(const TransferStudentSubmitting());
    try {
      await _service.transferStudentToSection(
        studentId: studentId,
        sectionId: current.selectedSection!.id,
        tr: tr,
      );
      emit(TransferStudentSuccess(tr('student_transfer_success')));
    } catch (e) {
      emit(TransferStudentError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}