part of 'parent_navigation_cubit.dart';

class ParentNavigationState extends Equatable {
  final int currentIndex;
  final String? selectedStudentId;

  const ParentNavigationState({
    required this.currentIndex,
    this.selectedStudentId,
  });

  ParentNavigationState copyWith({
    int? currentIndex,
    String? selectedStudentId,
  }) {
    return ParentNavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      selectedStudentId: selectedStudentId ?? this.selectedStudentId,
    );
  }

  @override
  List<Object?> get props => [currentIndex, selectedStudentId];
}