import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_cubit.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_state.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_cubit.dart';
import 'package:flowva_school/cubit/current_semester/current_semester_state.dart';
import 'package:flowva_school/models/supervisor/exam_model.dart';

import '../../../cubit/supervisor/exam_schedule/exam_schedule_cubit.dart';
import '../../../cubit/supervisor/exam_schedule/exam_schedule_state.dart';
import '../../../cubit/supervisor/exam_schedule/manage_exam_cubit.dart';
import '../../../cubit/supervisor/exam_schedule/manage_exam_state.dart';
import '../../../widget/supervisor/custom_section_semester_header.dart';
import '../../../app_localizations.dart';
import 'exam_card.dart';
import 'exam_details_bottom_sheet.dart';
import 'add_exam_bottom_sheet.dart';
import 'delete_exam_dialog.dart';

class ExamScheduleView extends StatelessWidget {
  const ExamScheduleView({super.key});

  void _fetchExams(BuildContext context, int sectionId) {
    final semesterState = context.read<CurrentSemesterCubit>().state;
    final semesterId = semesterState is CurrentSemesterSuccess
        ? semesterState.currentSemester.id
        : 1;
    context.read<ExamScheduleCubit>().fetchExams(
      sectionId:  sectionId,
      semesterId: semesterId,
    );
  }

  void _deleteExam(BuildContext context, ExamModel exam) async {
    final confirmed = await DeleteExamDialog.show(context, exam);
    if (confirmed == true && context.mounted) {
      context.read<ManageExamCubit>().deleteExam(
        examId: exam.id,
        tr: context.tr,
      );
    }
  }

  void _toggleExamStatus(BuildContext context, ExamModel exam) {
    final newStatus = exam.status.toLowerCase() == 'completed' ? 'scheduled' : 'completed';
    context.read<ManageExamCubit>().changeStatus(
      examId: exam.id,
      status: newStatus,
      tr: context.tr,
    );
  }

  void _editExam(BuildContext context, ExamModel exam, int sectionId) {
    AddExamBottomSheet.show(context, sectionId: sectionId, examToEdit: exam);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final selectedFilterNotifier = ValueNotifier<String>('all');

    return BlocBuilder<ClassesCubit, ClassesState>(
      builder: (context, classState) {
        if (classState is ClassesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (classState is ClassesError) {
          return Center(
            child: Text(classState.message, style: TextStyle(fontFamily: 'Cairo', color: cs.error)),
          );
        }

        if (classState is! ClassesLoaded) return const SizedBox();

        final activeSections  = classState.classDetails.sections;
        final selectedSection = classState.selectedSection;

        if (selectedSection != null) {
          final examCubit = context.read<ExamScheduleCubit>();
          if (examCubit.state is ExamScheduleInitial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _fetchExams(context, selectedSection.id);
            });
          }
        }

        return BlocListener<ManageExamCubit, ManageExamState>(
          listener: (context, manageState) {
            if (manageState is DeleteExamSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(context.tr('exam_success_delete'), style: const TextStyle(fontFamily: 'Cairo')),
                backgroundColor: const Color(0xFF0F766E),
                behavior: SnackBarBehavior.floating,
              ));
              if (selectedSection != null) _fetchExams(context, selectedSection.id);
              context.read<ManageExamCubit>().reset();
            }

            if (manageState is ChangeExamStatusSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  manageState.newStatus == 'completed' ? context.tr('exam_success_status_completed') : context.tr('exam_success_status_scheduled'),
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                behavior: SnackBarBehavior.floating,
              ));
              if (selectedSection != null) _fetchExams(context, selectedSection.id);
              context.read<ManageExamCubit>().reset();
            }

            if (manageState is ManageExamError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(manageState.message, style: const TextStyle(fontFamily: 'Cairo')),
                backgroundColor: cs.error,
                behavior: SnackBarBehavior.floating,
              ));
            }
          },
          child: BlocBuilder<ExamScheduleCubit, ExamScheduleState>(
            builder: (context, examState) {
              return Container(
                color: cs.surface,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    AttendanceSectionHeader(
                      selectedSection: selectedSection,
                      sections:        activeSections,
                      onSectionChanged: (newSection) {
                        context.read<ClassesCubit>().selectSection(newSection);
                        _fetchExams(context, newSection.id);
                      },
                      onExportPdfPressed: () {},
                    ),

                    const SizedBox(height: 12),

                    ValueListenableBuilder<String>(
                      valueListenable: selectedFilterNotifier,
                      builder: (context, selectedFilter, _) {
                        return Row(
                          children: [
                            _topButton(
                              context.tr('exam_btn_add'),
                              const Color(0xFF319795),
                              Colors.white,
                              icon: Icons.add_rounded,
                              onTap: selectedSection == null
                                  ? null
                                  : () => AddExamBottomSheet.show(
                                context,
                                sectionId: selectedSection.id,
                              ),
                            ),
                            const Spacer(),
                            _filterChip(context, 'all', context.tr('exam_filter_all'), selectedFilterNotifier),
                            const SizedBox(width: 6),
                            _filterChip(context, 'scheduled', context.tr('exam_filter_scheduled'), selectedFilterNotifier),
                            const SizedBox(width: 6),
                            _filterChip(context, 'completed', context.tr('exam_filter_completed'), selectedFilterNotifier),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    Expanded(
                      child: ValueListenableBuilder<String>(
                        valueListenable: selectedFilterNotifier,
                        builder: (context, selectedFilter, _) {
                          return _buildBody(context, examState, cs, selectedSection?.id, selectedFilter);
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _filterChip(
      BuildContext context,
      String key,
      String label,
      ValueNotifier<String> filterNotifier,
      ) {
    final cs = Theme.of(context).colorScheme;
    final isSelected = filterNotifier.value == key;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? cs.onPrimary : cs.onSurfaceVariant,
        ),
      ),
      selected: isSelected,
      selectedColor: cs.primary,
      backgroundColor: cs.surfaceContainerHigh,
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onSelected: (_) {
        filterNotifier.value = key;
      },
    );
  }

  Widget _topButton(String text, Color bg, Color txt, {required IconData icon, required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: onTap == null ? bg.withOpacity(0.5) : bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: txt, size: 16),
            const SizedBox(width: 6),
            Text(text, style: TextStyle(color: txt, fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context,
      ExamScheduleState state,
      ColorScheme cs,
      int? sectionId,
      String selectedFilter,
      ) {
    if (state is ExamScheduleLoading || state is ExamScheduleInitial) {
      return Center(child: CircularProgressIndicator(color: cs.primary));
    }

    if (state is ExamScheduleError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 40, color: cs.error.withOpacity(0.5)),
              const SizedBox(height: 12),
              Text(
                state.message,
                style: TextStyle(fontFamily: 'Cairo', color: cs.error, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final allExams = (state as ExamScheduleSuccess).exams;

    final filteredExams = allExams.where((e) {
      if (selectedFilter == 'scheduled') return e.status.toLowerCase() == 'scheduled';
      if (selectedFilter == 'completed') return e.status.toLowerCase() == 'completed';
      return true;
    }).toList();

    if (filteredExams.isEmpty) {
      return Center(
        child: Text(
          context.tr('exam_empty_category'),
          style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: cs.onSurfaceVariant),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
        final ratio = constraints.maxWidth > 900 ? 2.5 : (constraints.maxWidth > 600 ? 2.2 : 3.2);

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            childAspectRatio: ratio,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: filteredExams.length,
          itemBuilder: (context, index) {
            final exam = filteredExams[index];
            return ExamCard(
              exam: exam,
              onTap: () => ExamDetailsBottomSheet.show(context, exam),
              onEdit: () {
                if (sectionId != null) _editExam(context, exam, sectionId);
              },
              onDelete: () => _deleteExam(context, exam),
              onToggleStatus: () => _toggleExamStatus(context, exam),
            );
          },
        );
      },
    );
  }
}