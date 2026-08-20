import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/supervisor/student_evaluations/add_student_evaluation_cubit.dart';
import '../../../cubit/supervisor/student_evaluations/add_student_evaluation_state.dart';
import '../../../cubit/supervisor/student_evaluations/student_evaluations_cubit.dart';
import '../../../cubit/supervisor/inspection/current_inspection_cubit.dart';
import '../../../cubit/supervisor/inspection/current_inspection_state.dart';
import '../../../cubit/current_semester/current_semester_cubit.dart';
import '../../../cubit/current_semester/current_semester_state.dart';
import '../../../cubit/current_year/current_year_cubit.dart';
import '../../../cubit/current_year/current_year_state.dart';
import '../../../cubit/profile/profile_cubit.dart';
import '../../../cubit/profile/profile_state.dart';
import '../../../cubit/locale/locale_cubit.dart';
import '../../../widget/button.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/field_styles.dart';
import '../../../app_localizations.dart';

class AddStudentEvaluationBottomSheet extends StatelessWidget {
  final int studentId;

  const AddStudentEvaluationBottomSheet({super.key, required this.studentId});

  static void show(BuildContext context, int studentId) {
    final addCubit = context.read<AddStudentEvaluationCubit>();
    final evaluationsCubit = context.read<StudentEvaluationsCubit>();
    final semesterCubit = context.read<CurrentSemesterCubit>();
    final yearCubit = context.read<CurrentYearCubit>();
    final profileCubit = context.read<ProfileCubit>();
    final localeCubit = context.read<LocaleCubit>();
    final inspectionCubit = context.read<CurrentInspectionCubit>();

    addCubit.loadCategories(tr: context.tr);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: addCubit),
          BlocProvider.value(value: evaluationsCubit),
          BlocProvider.value(value: semesterCubit),
          BlocProvider.value(value: yearCubit),
          BlocProvider.value(value: profileCubit),
          BlocProvider.value(value: localeCubit),
          BlocProvider.value(value: inspectionCubit),
        ],
        child: AddStudentEvaluationBottomSheet(studentId: studentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final reasonController = TextEditingController();
    final notesController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: isDark ? cs.surfaceContainer : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
        child: BlocConsumer<AddStudentEvaluationCubit, AddEvaluationState>(
          listener: (context, state) {
            if (state is AddEvaluationSuccess) {
              final semesterState = context.read<CurrentSemesterCubit>().state;
              final semesterId = semesterState is CurrentSemesterSuccess
                  ? semesterState.currentSemester.id
                  : 1;

              context.read<StudentEvaluationsCubit>().fetchSummary(
                studentId: studentId,
                semesterId: semesterId,
                tr: context.tr,
              );

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.tr('evaluation_added_success'),
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                  backgroundColor: const Color(0xFF10B981),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            if (state is AddEvaluationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                  backgroundColor: cs.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is AddEvaluationLoadingCategories) {
              return Center(child: CircularProgressIndicator(color: cs.primary));
            }

            final isArabic = context.read<LocaleCubit>().state.currentLanguage == 'AR';
            final cubit = context.read<AddStudentEvaluationCubit>();

            if (state is AddEvaluationCategoriesLoaded) {
              final selectedCat = state.selectedCategory;
              final color = selectedCat != null && selectedCat.isPositive
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444);

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
                        height: 4.5,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: cs.outlineVariant.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withOpacity(isDark ? 0.2 : 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.stars_rounded, color: color, size: 22),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            context.tr('add_evaluation_title'),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // اختيار التصنيف
                    DropdownButtonFormField<int>(
                      value: selectedCat?.id,
                      dropdownColor: isDark ? cs.surfaceContainerHigh : Colors.white,
                      isExpanded: true,
                      decoration: FieldStyles.authInputDecoration(
                        label: context.tr('select_category_label'),
                        icon: Icons.category_outlined,
                      ).copyWith(
                        fillColor: cs.surfaceContainerLow,
                        filled: true,
                      ),
                      items: state.categories.map((cat) {
                        final catColor = cat.isPositive
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444);
                        return DropdownMenuItem<int>(
                          value: cat.id,
                          child: Row(
                            children: [
                              Icon(
                                cat.isPositive
                                    ? Icons.thumb_up_rounded
                                    : Icons.thumb_down_rounded,
                                color: catColor,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  cat.getDisplayName(isArabic),
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 13,
                                    color: cs.onSurface,
                                  ),
                                ),
                              ),
                              Text(
                                '${cat.isPositive ? '+' : '-'}${cat.defaultPoints}',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                  color: catColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (catId) {
                        if (catId != null) {
                          final cat = state.categories.firstWhere((c) => c.id == catId);
                          cubit.selectCategory(cat);
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // حقل النقاط والسبب
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomTextField(
                            key: ValueKey('points_${selectedCat?.id}_${state.points}'),
                            controller: TextEditingController(text: '${state.points}'),
                            hintText: context.tr('points_label'),
                            keyboardType: TextInputType.number,
                            decoration: FieldStyles.authInputDecoration(
                              label: context.tr('points_label'),
                              icon: Icons.confirmation_number_outlined,
                            ).copyWith(
                              fillColor: cs.surfaceContainerLow,
                              filled: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: CustomTextField(
                            controller: reasonController,
                            hintText: context.tr('reason_hint'),
                            decoration: FieldStyles.authInputDecoration(
                              label: context.tr('reason_label'),
                              icon: Icons.edit_note_rounded,
                            ).copyWith(
                              fillColor: cs.surfaceContainerLow,
                              filled: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // حقل الملاحظات
                    CustomTextField(
                      controller: notesController,
                      hintText: context.tr('notes_hint'),
                      decoration: FieldStyles.authInputDecoration(
                        label: context.tr('optional_notes_label'),
                        icon: Icons.info_outline_rounded,
                      ).copyWith(
                        fillColor: cs.surfaceContainerLow,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Button(
                      text: context.tr('submit_evaluation_btn'),
                      icon: Icons.check_circle_outline_rounded,
                      color: color,
                      colorText: Colors.white,
                      height: 50,
                      onPressed: () {
                        final inspectionState = context.read<CurrentInspectionCubit>().state;

                        // 🟢 التحقق من وجود مهمة تفتيش جارية أو معلقة
                        if (inspectionState is! CurrentInspectionLoaded ||
                            inspectionState.program == null ||
                            !inspectionState.program!.isActiveOrPending) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.tr('no_active_inspection_program'),
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: cs.error,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        final semesterState = context.read<CurrentSemesterCubit>().state;
                        final yearState = context.read<CurrentYearCubit>().state;
                        final profileState = context.read<ProfileCubit>().state;

                        final semesterId = semesterState is CurrentSemesterSuccess
                            ? semesterState.currentSemester.id
                            : 1;
                        final yearId = yearState is CurrentYearSuccess
                            ? yearState.currentYear.id
                            : 1;
                        final userId = profileState is ProfileLoaded
                            ? profileState.user.id
                            : 1;
                        final userType = profileState is ProfileLoaded
                            ? profileState.user.userType
                            : 'counselor';

                        final int inspectionProgramId = inspectionState.program!.id;

                        cubit.submitEvaluation(
                          studentId: studentId,
                          academicYearId: yearId,
                          semesterId: semesterId,
                          reason: reasonController.text,
                          inspectionProgramId: inspectionProgramId, // 🟢 إرسال القيمة كـ int مؤكد
                          notes: notesController.text,
                          tr: context.tr,
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            if (state is AddEvaluationSubmitting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}