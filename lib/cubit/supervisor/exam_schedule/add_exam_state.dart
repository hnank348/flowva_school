abstract class AddExamState {
  const AddExamState();
}

class AddExamInitial extends AddExamState {
  const AddExamInitial();
}

class AddExamLoading extends AddExamState {
  const AddExamLoading();
}

class AddExamSuccess extends AddExamState {
  const AddExamSuccess();
}

class AddExamError extends AddExamState {
  final String message;
  const AddExamError(this.message);
}