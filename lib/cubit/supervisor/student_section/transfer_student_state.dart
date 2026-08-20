import '../../../models/mutual/section_item_model.dart';

abstract class TransferStudentState {
  const TransferStudentState();
}

class TransferStudentInitial extends TransferStudentState {
  const TransferStudentInitial();
}

class TransferStudentLoadingSections extends TransferStudentState {
  const TransferStudentLoadingSections();
}

class TransferStudentSectionsLoaded extends TransferStudentState {
  final List<SectionItemModel> sections;
  final SectionItemModel? selectedSection;

  const TransferStudentSectionsLoaded({
    required this.sections,
    this.selectedSection,
  });

  TransferStudentSectionsLoaded copyWith({
    List<SectionItemModel>? sections,
    SectionItemModel? selectedSection,
  }) {
    return TransferStudentSectionsLoaded(
      sections: sections ?? this.sections,
      selectedSection: selectedSection ?? this.selectedSection,
    );
  }
}
