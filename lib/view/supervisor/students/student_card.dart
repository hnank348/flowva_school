import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/supervisor/student_details/student_parents_cubit.dart';
import '../../../cubit/supervisor/student_section/assign_student_cubit.dart';
import '../../../cubit/supervisor/student_section/transfer_student_cubit.dart';
import '../../../models/supervisor/student_model.dart';
import '../../../services/constant_api.dart';
import '../../../cubit/supervisor/student_details/student_details_cubit.dart';
import '../../../cubit/supervisor/student_evaluations/student_evaluations_cubit.dart';
import '../../../cubit/supervisor/student_evaluations/add_student_evaluation_cubit.dart';
import '../../../cubit/supervisor/students/students_cubit.dart';
import '../../../cubit/supervisor/inspection/current_inspection_cubit.dart';
import '../../../cubit/current_semester/current_semester_cubit.dart';
import '../../../cubit/current_year/current_year_cubit.dart';
import '../../../cubit/profile/profile_cubit.dart';
import '../../../view/supervisor/students/student_details_view.dart';
import '../../../view/supervisor/students/assign_student_bottom_sheet.dart';
import '../../../widget/custom_avatar.dart';
import '../../../app_localizations.dart';

class StudentCard extends StatelessWidget {
  final StudentModel student;
  final bool isArabic;

  const StudentCard({
    super.key,
    required this.student,
    required this.isArabic,
  });

  void _openDetails(BuildContext context) {
    final detailsCubit = context.read<StudentDetailsCubit>();
    final parentsCubit = context.read<StudentParentsCubit>();
    final evaluationsCubit = context.read<StudentEvaluationsCubit>();
    final addEvaluationCubit = context.read<AddStudentEvaluationCubit>();
    final transferCubit = context.read<TransferStudentCubit>();
    final assignCubit = context.read<AssignStudentCubit>();
    final studentsCubit = context.read<StudentsCubit>();
    final currentSemesterCubit = context.read<CurrentSemesterCubit>();
    final currentYearCubit = context.read<CurrentYearCubit>();
    final profileCubit = context.read<ProfileCubit>();
    final currentInspectionCubit = context.read<CurrentInspectionCubit>();

    detailsCubit.fetchStudentDetails(studentId: student.id, tr: context.tr);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: detailsCubit),
            BlocProvider.value(value: parentsCubit),
            BlocProvider.value(value: evaluationsCubit),
            BlocProvider.value(value: addEvaluationCubit),
            BlocProvider.value(value: transferCubit),
            BlocProvider.value(value: assignCubit),
            BlocProvider.value(value: studentsCubit),
            BlocProvider.value(value: currentSemesterCubit),
            BlocProvider.value(value: currentYearCubit),
            BlocProvider.value(value: profileCubit),
            BlocProvider.value(value: currentInspectionCubit),
          ],
          child: StudentDetailsView(studentId: student.id),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarUrl = ConstantApi.getImageUrl(student.photo);
    final isActive = student.status.toLowerCase() == 'active';
    final statusColor = isActive ? const Color(0xFF10B981) : cs.error;

    // 🟢 التحقق مما إذا كان الطالب مسجلاً بشعبة مسبقاً
    final bool hasSection = student.sectionName != null &&
        student.sectionName.toString().trim().isNotEmpty &&
        student.sectionName.toString().toLowerCase() != 'null';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark
            ? cs.surfaceContainerHigh.withOpacity(0.6)
            : cs.primary.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cs.outlineVariant.withOpacity(isDark ? 0.3 : 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: cs.primary.withOpacity(0.08),
          onTap: () => _openDetails(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox(
                  width: 52,
                  height: 52,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.primary.withOpacity(isDark ? 0.2 : 0.1),
                          border: Border.all(
                            color: cs.primary.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: CustomAvatar(
                          imageUrl: avatarUrl,
                          radius: 23,
                        ),
                      ),
                      PositionedDirectional(
                        bottom: 1,
                        end: 1,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: cs.surface, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.getDisplayName(isArabic),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (hasSection)
                            _BentoChip(
                              icon: Icons.class_outlined,
                              label: '${student.className} • ${student.sectionName}',
                              color: cs.primary,
                              isDark: isDark,
                            )
                          else
                            _BentoChip(
                              icon: Icons.warning_amber_rounded,
                              label: context.tr('no_section_assigned'),
                              color: const Color(0xFFEF4444),
                              isDark: isDark,
                            ),
                          if (student.phone != null && student.phone!.isNotEmpty)
                            _BentoChip(
                              icon: Icons.phone_outlined,
                              label: student.phone!,
                              color: cs.onSurfaceVariant,
                              isDark: isDark,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor.withOpacity(0.35)),
                      ),
                      child: Text(
                        context.tr(isActive ? 'student_status_active' : 'student_status_inactive'),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 🟢 إذا لم تكن لديه شعبة تظهر أيقونة الربط، وإذا كان لديه شعبة يظهر سهم التنقل
                    if (!hasSection)
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => AssignStudentBottomSheet.show(
                          context,
                          studentId: student.id,
                          studentName: student.getDisplayName(isArabic),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(isDark ? 0.2 : 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.person_add_alt_1_rounded,
                            size: 18,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      )
                    else
                      Icon(
                        isArabic
                            ? Icons.keyboard_arrow_left_rounded
                            : Icons.keyboard_arrow_right_rounded,
                        size: 20,
                        color: cs.onSurfaceVariant.withOpacity(0.5),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BentoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;

  const _BentoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}