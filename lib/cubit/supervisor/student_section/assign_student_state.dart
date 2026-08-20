import '../../../models/mutual/section_item_model.dart';

abstract class AssignStudentState {}

class AssignStudentInitial extends AssignStudentState {}

class AssignStudentLoadingSections extends AssignStudentState {}

class AssignStudentSectionsLoaded extends AssignStudentState {
  final List<SectionItemModel> sections;
  final SectionItemModel? selectedSection;

  AssignStudentSectionsLoaded({
    required this.sections,
    this.selectedSection,
  });

  AssignStudentSectionsLoaded copyWith({
    List<SectionItemModel>? sections,
    SectionItemModel? selectedSection,
  }) {
    return AssignStudentSectionsLoaded(
      sections: sections ?? this.sections,
      selectedSection: selectedSection ?? this.selectedSection,
    );
  }
}

class AssignStudentSubmitting extends AssignStudentState {}

class AssignStudentSuccess extends AssignStudentState {
  final String message;
  AssignStudentSuccess(this.message);
}

class AssignStudentError extends AssignStudentState {
  final String message;
  AssignStudentError(this.message);
}