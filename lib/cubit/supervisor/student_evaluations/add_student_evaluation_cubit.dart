import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/supervisor/point_category_model.dart';
import '../../../services/supervisor/student_points_service.dart';
import 'add_student_evaluation_state.dart';



class AddStudentEvaluationCubit extends Cubit<AddEvaluationState> {
  final StudentPointsService _service;

  AddStudentEvaluationCubit(this._service)
      : super(const AddEvaluationInitial());

  Future<void> loadCategories({
    required String Function(String key) tr,
  }) async {
    emit(const AddEvaluationLoadingCategories());
    try {
      final categories = await _service.getPointCategories(tr: tr);
      final first = categories.isNotEmpty ? categories.first : null;
      emit(AddEvaluationCategoriesLoaded(
        categories: categories,
        selectedCategory: first,
        points: first?.defaultPoints ?? 0,
      ));
    } catch (e) {
      emit(AddEvaluationError(e.toString().replaceAll("Exception: ", "")));
    }
  }

  void selectCategory(PointCategoryModel category) {
    if (state is AddEvaluationCategoriesLoaded) {
      final current = state as AddEvaluationCategoriesLoaded;
      emit(current.copyWith(
        selectedCategory: category,
        points: category.defaultPoints,
      ));
    }
  }

  void updatePoints(int points) {
    if (state is AddEvaluationCategoriesLoaded) {
      final current = state as AddEvaluationCategoriesLoaded;
      emit(current.copyWith(points: points));
    }
  }

  Future<void> submitEvaluation({
    required int studentId,
    required int academicYearId,
    required int semesterId,
    required String reason,

    required int inspectionProgramId,
    String? notes,
    required String Function(String key) tr,
  }) async {
    if (state is! AddEvaluationCategoriesLoaded) return;
    final current = state as AddEvaluationCategoriesLoaded;
    if (current.selectedCategory == null) {
      emit(AddEvaluationError(tr('please_select_category')));
      return;
    }

    emit(AddEvaluationSubmitting());
    try {
      await _service.addStudentPoint(
        studentId: studentId,
        pointCategoryId: current.selectedCategory!.id,
        academicYearId: academicYearId,
        semesterId: semesterId,
        points: current.points,
        reason: reason,
        date: DateTime.now().toIso8601String().substring(0, 10),

        inspectionProgramId: inspectionProgramId,
        notes: notes,
        tr: tr,
      );
      emit(AddEvaluationSuccess());
    } catch (e) {
      emit(AddEvaluationError(e.toString()));
    }
  }
}