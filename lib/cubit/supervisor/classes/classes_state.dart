import '../../../models/supervisor/class_details_model.dart';

abstract class ClassesState {
  final SectionModel? selectedSection;

  const ClassesState({this.selectedSection});
}

class ClassesInitial extends ClassesState {
  const ClassesInitial() : super(selectedSection: null);
}

class ClassesLoading extends ClassesState {
  const ClassesLoading({super.selectedSection});
}

class ClassesLoaded extends ClassesState {
  final ClassDetailsModel classDetails;

  const ClassesLoaded({
    required this.classDetails,
    required SectionModel selectedSection,
  }) : super(selectedSection: selectedSection);
}

class ClassesError extends ClassesState {
  final String message;

  const ClassesError(this.message, {super.selectedSection});
}