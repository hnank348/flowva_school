import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/supervisor/student_section/assign_student_cubit.dart';
import '../../../cubit/supervisor/student_section/assign_student_state.dart';
import '../../../cubit/supervisor/students/students_cubit.dart';
import '../../../cubit/supervisor/student_details/student_details_cubit.dart';
import '../../../cubit/current_semester/current_semester_cubit.dart';
import '../../../cubit/current_semester/current_semester_state.dart';
import '../../../cubit/current_year/current_year_cubit.dart';
import '../../../cubit/current_year/current_year_state.dart';
import '../../../models/mutual/section_item_model.dart';
import '../../../widget/button.dart';
import '../../../app_localizations.dart';

class AssignStudentBottomSheet extends StatelessWidget {
  final int studentId;
  final String studentName;

  const AssignStudentBottomSheet({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  static void show(
      BuildContext context, {
        required int studentId,
        required String studentName,
      }) {
    final assignCubit = context.read<AssignStudentCubit>();
    final studentsCubit = context.read<StudentsCubit>();
    final detailsCubit = context.read<StudentDetailsCubit>();
    final semesterCubit = context.read<CurrentSemesterCubit>();
    final yearCubit = context.read<CurrentYearCubit>();

    assignCubit.loadSections(tr: context.tr);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: assignCubit),
          BlocProvider.value(value: studentsCubit),
          BlocProvider.value(value: detailsCubit),
          BlocProvider.value(value: semesterCubit),
          BlocProvider.value(value: yearCubit),
        ],
        child: AssignStudentBottomSheet(
          studentId: studentId,
          studentName: studentName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.78,
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
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: BlocConsumer<AssignStudentCubit, AssignStudentState>(
        listener: (context, state) {
          if (state is AssignStudentSuccess) {
            final semesterState = context.read<CurrentSemesterCubit>().state;
            final semesterId = semesterState is CurrentSemesterSuccess
                ? semesterState.currentSemester.id
                : 1;

            context.read<StudentsCubit>().fetchStudents(semesterId: semesterId, tr: context.tr);
            context.read<StudentDetailsCubit>().fetchStudentDetails(studentId: studentId, tr: context.tr);

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: const Color(0xFF10B981),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state is AssignStudentError) {
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
          return Column(
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
                      color: const Color(0xFF6366F1).withOpacity(isDark ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF6366F1), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('assign_student_title'),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          studentName,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 12.5,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (state is AssignStudentLoadingSections)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 36),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is AssignStudentSectionsLoaded) ...[
                Text(
                  context.tr('select_target_section'),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                if (state.sections.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: Text(
                        context.tr('no_available_sections'),
                        style: TextStyle(fontFamily: 'Cairo', color: cs.onSurfaceVariant),
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.sections.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final sec = state.sections[index];
                        final isSelected = sec.id == state.selectedSection?.id;
                        return _buildSectionSelectCard(context, sec, isSelected, cs, isDark);
                      },
                    ),
                  ),
                const SizedBox(height: 18),
                Button(
                  text: context.tr('confirm_assign_btn'),
                  icon: Icons.check_circle_outline_rounded,
                  isLoading: state is AssignStudentSubmitting,
                  color: const Color(0xFF6366F1),
                  colorText: Colors.white,
                  height: 50,
                  onPressed: state.selectedSection != null
                      ? () {
                    final semesterState = context.read<CurrentSemesterCubit>().state;
                    final yearState = context.read<CurrentYearCubit>().state;

                    final semesterId = semesterState is CurrentSemesterSuccess
                        ? semesterState.currentSemester.id
                        : 1;
                    final yearId = yearState is CurrentYearSuccess
                        ? yearState.currentYear.id
                        : 1;

                    context.read<AssignStudentCubit>().assignStudent(
                      studentId: studentId,
                      semesterId: semesterId,
                      academicYearId: yearId,
                      tr: context.tr,
                    );
                  }
                      : null,
                ),
              ] else if (state is AssignStudentSubmitting)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 36),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionSelectCard(
      BuildContext context,
      SectionItemModel sec,
      bool isSelected,
      ColorScheme cs,
      bool isDark,
      ) {
    final borderColor = isSelected
        ? const Color(0xFF6366F1)
        : cs.outlineVariant.withOpacity(isDark ? 0.35 : 0.5);
    final bgColor = isSelected
        ? const Color(0xFF6366F1).withOpacity(isDark ? 0.18 : 0.08)
        : (isDark ? cs.surfaceContainerHigh : cs.surfaceContainerLow);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.read<AssignStudentCubit>().selectSection(sec),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: isSelected ? 1.8 : 1),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? const Color(0xFF6366F1) : cs.onSurfaceVariant,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sec.fullDisplayName,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  if (sec.roomNumber != null && sec.roomNumber!.isNotEmpty)
                    Text(
                      '${context.tr('table_room')}: ${sec.roomNumber}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11.5,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(isDark ? 0.18 : 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${context.tr('available_seats')}: ${sec.availableSeats}',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}