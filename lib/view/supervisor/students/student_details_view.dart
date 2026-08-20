import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/locale/locale_cubit.dart';
import '../../../cubit/locale/locale_state.dart';
import '../../../cubit/current_semester/current_semester_cubit.dart';
import '../../../cubit/current_semester/current_semester_state.dart';
import '../../../cubit/supervisor/student_details/student_details_cubit.dart';
import '../../../cubit/supervisor/student_details/student_details_state.dart';
import '../../../cubit/supervisor/inspection/current_inspection_cubit.dart';
import '../../../cubit/supervisor/inspection/current_inspection_state.dart';
import '../../../services/constant_api.dart';
import '../../../widget/button.dart';
import '../../../app_localizations.dart';
import 'parents_bottom_sheet.dart';
import 'student_evaluations_bottom_sheet.dart';
import 'add_student_evaluation_bottom_sheet.dart';
import 'transfer_student_bottom_sheet.dart';
import 'assign_student_bottom_sheet.dart';
import 'student_details_components.dart';

class StudentDetailsView extends StatelessWidget {
  final int studentId;

  const StudentDetailsView({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        final isArabic = localeState.currentLanguage == 'AR';

        return Directionality(
          textDirection: localeState.textDirection,
          child: Scaffold(
            backgroundColor: cs.surface,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: isDark ? cs.surfaceContainerHigh : cs.primary,
              foregroundColor: isDark ? cs.onSurface : Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                context.tr('student_details_title'),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? cs.onSurface : Colors.white,
                ),
              ),
            ),
            body: BlocBuilder<StudentDetailsCubit, StudentDetailsState>(
              builder: (context, state) {
                if (state is StudentDetailsLoading || state is StudentDetailsInitial) {
                  return const DetailsSkeleton();
                }

                if (state is StudentDetailsError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline_rounded, size: 42, color: cs.error),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: cs.error,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Button(
                            text: context.tr('retry_btn'),
                            icon: Icons.refresh_rounded,
                            width: 150,
                            height: 44,
                            color: cs.primary,
                            colorText: Colors.white,
                            onPressed: () => context
                                .read<StudentDetailsCubit>()
                                .fetchStudentDetails(
                              studentId: studentId,
                              tr: context.tr,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is StudentDetailsLoaded) {
                  final student = state.student;
                  final avatarUrl = ConstantApi.getImageUrl(student.photo);

                  return Column(
                    children: [
                      StaticHeroHeader(
                        name: student.getDisplayName(isArabic),
                        studentCode: student.studentId,
                        status: student.status,
                        avatarUrl: avatarUrl,
                        cs: cs,
                        isDark: isDark,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // ─── الصف الأول: أولياء الأمور ونقل/تسكين الطالب ───
                              Row(
                                children: [
                                  Expanded(
                                    child: BentoActionTile(
                                      icon: Icons.family_restroom_rounded,
                                      label: context.tr('view_parents_btn'),
                                      color: cs.primary,
                                      isDark: isDark,
                                      onTap: () => ParentsBottomSheet.show(context, studentId),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: student.hasSection
                                        ? BentoActionTile(
                                      icon: Icons.swap_horiz_rounded,
                                      label: context.tr('transfer_student_btn'),
                                      color: const Color(0xFFF59E0B),
                                      isDark: isDark,
                                      onTap: () => TransferStudentBottomSheet.show(
                                        context,
                                        studentId: studentId,
                                        studentName: student.getDisplayName(isArabic),
                                        currentSectionId: student.section?.id,
                                      ),
                                    )
                                        : BentoActionTile(
                                      icon: Icons.person_add_alt_1_rounded,
                                      label: context.tr('assign_student_title'),
                                      color: const Color(0xFF6366F1),
                                      isDark: isDark,
                                      onTap: () => AssignStudentBottomSheet.show(
                                        context,
                                        studentId: studentId,
                                        studentName: student.getDisplayName(isArabic),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // ─── الصف الثاني: التقييمات (يظهر زر الإضافة فقط إذا وجدت مهمة جارية) ───
                              BlocBuilder<CurrentInspectionCubit, CurrentInspectionState>(
                                builder: (context, inspectionState) {
                                  final bool hasActiveInspection =
                                      inspectionState is CurrentInspectionLoaded &&
                                          inspectionState.program != null &&
                                          inspectionState.program!.isActiveOrPending;

                                  return Row(
                                    children: [
                                      Expanded(
                                        child: BentoActionTile(
                                          icon: Icons.analytics_rounded,
                                          label: context.tr('view_evaluations_btn'),
                                          color: const Color(0xFF3B82F6),
                                          isDark: isDark,
                                          onTap: () {
                                            final semesterState =
                                                context.read<CurrentSemesterCubit>().state;
                                            final semesterId = semesterState is CurrentSemesterSuccess
                                                ? semesterState.currentSemester.id
                                                : 1;
                                            StudentEvaluationsBottomSheet.show(
                                              context,
                                              studentId: studentId,
                                              semesterId: semesterId,
                                            );
                                          },
                                        ),
                                      ),
                                      if (hasActiveInspection) ...[
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: BentoActionTile(
                                            icon: Icons.add_task_rounded,
                                            label: context.tr('add_evaluation_title'),
                                            color: const Color(0xFF10B981),
                                            isDark: isDark,
                                            onTap: () => AddStudentEvaluationBottomSheet.show(
                                              context,
                                              studentId,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              ),

                              const SizedBox(height: 16),

                              // ─── بطاقة المعلومات الأكاديمية والشعبة ───
                              if (student.hasSection || student.academicYear != null) ...[
                                SectionCard(
                                  title: context.tr('academic_info_title'),
                                  icon: Icons.school_outlined,
                                  cs: cs,
                                  isDark: isDark,
                                  rows: [
                                    if (student.hasSection) ...[
                                      InfoRow(
                                        icon: Icons.class_outlined,
                                        label: context.tr('table_class'),
                                        value: '${student.section?.className} - ${student.section?.name}',
                                      ),
                                      InfoRow(
                                        icon: Icons.layers_outlined,
                                        label: context.tr('table_grade'),
                                        value: student.section?.grade ?? context.tr('not_available'),
                                      ),
                                    ],
                                    if (student.academicYear != null)
                                      InfoRow(
                                        icon: Icons.calendar_today_rounded,
                                        label: context.tr('academic_year_label'),
                                        value: student.academicYear!.name,
                                      ),
                                    if (student.enrollmentDate != null && student.enrollmentDate!.isNotEmpty)
                                      InfoRow(
                                        icon: Icons.how_to_reg_outlined,
                                        label: context.tr('enrollment_date_label'),
                                        value: student.enrollmentDate!,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],

                              // ─── بطاقة المعلومات الشخصية ───
                              SectionCard(
                                title: context.tr('student_basic_info'),
                                icon: Icons.badge_outlined,
                                cs: cs,
                                isDark: isDark,
                                rows: [
                                  InfoRow(icon: Icons.wc_rounded, label: context.tr('gender'), value: student.gender),
                                  InfoRow(icon: Icons.cake_outlined, label: context.tr('age'), value: '${student.age}'),
                                  InfoRow(icon: Icons.event_outlined, label: context.tr('birth_date'), value: student.dateOfBirth ?? context.tr('not_available')),
                                  if (student.nationalId != null && student.nationalId!.isNotEmpty)
                                    InfoRow(icon: Icons.fingerprint_rounded, label: context.tr('national_id_label'), value: student.nationalId!),
                                  InfoRow(icon: Icons.mail_outline_rounded, label: context.tr('email'), value: student.email ?? context.tr('not_available')),
                                  InfoRow(icon: Icons.phone_outlined, label: context.tr('phone'), value: student.phone ?? context.tr('not_available')),
                                  InfoRow(icon: Icons.bloodtype_outlined, label: context.tr('blood_type'), value: student.bloodType ?? context.tr('not_available')),
                                  InfoRow(
                                    icon: Icons.location_on_outlined,
                                    label: context.tr('address'),
                                    value: '${student.city ?? ''} ${student.address ?? ''}'.trim().isEmpty
                                        ? context.tr('not_available')
                                        : '${student.city ?? ''} ${student.address ?? ''}'.trim(),
                                  ),
                                  if (student.notes != null && student.notes!.trim().isNotEmpty)
                                    InfoRow(
                                      icon: Icons.notes_rounded,
                                      label: context.tr('optional_notes_label'),
                                      value: student.notes!.trim(),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      },
    );
  }
}