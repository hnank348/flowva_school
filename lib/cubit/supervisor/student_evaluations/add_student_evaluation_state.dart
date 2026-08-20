import '../../../models/supervisor/point_category_model.dart';

abstract class AddEvaluationState {
  const AddEvaluationState();
}

class AddEvaluationInitial extends AddEvaluationState {
  const AddEvaluationInitial();
}

class AddEvaluationLoadingCategories extends AddEvaluationState {
  const AddEvaluationLoadingCategories();
}

class AddEvaluationCategoriesLoaded extends AddEvaluationState {
  final List<PointCategoryModel> categories;
  final PointCategoryModel? selectedCategory;
  final int points;

  const AddEvaluationCategoriesLoaded({
    required this.categories,
    this.selectedCategory,
    this.points = 0,
  });

  AddEvaluationCategoriesLoaded copyWith({
    List<PointCategoryModel>? categories,
    PointCategoryModel? selectedCategory,
    int? points,
  }) {
    return AddEvaluationCategoriesLoaded(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      points: points ?? this.points,
    );
  }
}

class AddEvaluationSubmitting extends AddEvaluationState {
  const AddEvaluationSubmitting();
}

class AddEvaluationSuccess extends AddEvaluationState {
  const AddEvaluationSuccess();
}

class AddEvaluationError extends AddEvaluationState {
  final String message;
  const AddEvaluationError(this.message);
}