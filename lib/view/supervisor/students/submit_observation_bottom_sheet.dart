import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/locale/locale_cubit.dart';
import '../../../cubit/supervisor/inspection/current_inspection_cubit.dart';
import '../../../cubit/supervisor/inspection/current_inspection_state.dart';
import '../../../cubit/supervisor/inspection/submit_observation_cubit.dart';
import '../../../cubit/supervisor/inspection/submit_observation_state.dart';
import '../../../cubit/profile/profile_cubit.dart';
import '../../../cubit/profile/profile_state.dart';
import '../../../widget/button.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/field_styles.dart';
import '../../../app_localizations.dart';

class SubmitObservationBottomSheet extends StatefulWidget {
  final int programId;

  const SubmitObservationBottomSheet({super.key, required this.programId});

  static void show(BuildContext context, int programId) {
    final submitCubit = context.read<SubmitObservationCubit>();
    final currentCubit = context.read<CurrentInspectionCubit>();
    final profileCubit = context.read<ProfileCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: submitCubit),
          BlocProvider.value(value: currentCubit),
          BlocProvider.value(value: profileCubit),
        ],
        child: SubmitObservationBottomSheet(programId: programId),
      ),
    );
  }

  @override
  State<SubmitObservationBottomSheet> createState() => _SubmitObservationBottomSheetState();
}

class _SubmitObservationBottomSheetState extends State<SubmitObservationBottomSheet> {
  final _objectivesController = TextEditingController();
  String _selectedResult = 'good';

  @override
  void dispose() {
    _objectivesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: BoxDecoration(
          color: isDark ? cs.surfaceContainer : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(
            color: cs.outlineVariant.withOpacity(isDark ? 0.35 : 0.45),
          ),
        ),
        child: BlocConsumer<SubmitObservationCubit, SubmitObservationState>(
          listener: (context, state) {
            if (state is SubmitObservationSuccess) {
              context.read<CurrentInspectionCubit>().fetchCurrentProgram(tr: context.tr);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message, style: const TextStyle(fontFamily: 'Cairo')),
                  backgroundColor: const Color(0xFF10B981),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
            if (state is SubmitObservationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message, style: const TextStyle(fontFamily: 'Cairo')),
                  backgroundColor: cs.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 38,
                      height: 4,
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
                          color: cs.primary.withOpacity(isDark ? 0.12 : 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: cs.primary.withOpacity(isDark ? 0.25 : 0.15),
                          ),
                        ),
                        child: Icon(Icons.rate_review_rounded, color: cs.primary, size: 22),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          context.tr('submit_observation_title'),
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
                  CustomTextField(
                    controller: _objectivesController,
                    hintText: context.tr('objectives_hint'),
                    decoration: FieldStyles.authInputDecoration(
                      label: context.tr('objectives_label'),
                      icon: Icons.edit_note_rounded,
                    ).copyWith(
                      fillColor: cs.surfaceContainerLow,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _selectedResult,
                    dropdownColor: isDark ? cs.surfaceContainer : Colors.white,
                    decoration: FieldStyles.authInputDecoration(
                      label: context.tr('result_label'),
                      icon: Icons.grading_rounded,
                    ).copyWith(
                      fillColor: cs.surfaceContainerLow,
                      filled: true,
                    ),
                    items: [
                      DropdownMenuItem(value: 'excellent', child: Text(context.tr('result_excellent'))),
                      DropdownMenuItem(value: 'good', child: Text(context.tr('result_good'))),
                      DropdownMenuItem(value: 'acceptable', child: Text(context.tr('result_acceptable'))),
                      DropdownMenuItem(value: 'poor', child: Text(context.tr('result_poor'))),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedResult = val);
                    },
                  ),
                  const SizedBox(height: 20),
                  Button(
                    text: context.tr('submit_btn'),
                    icon: Icons.send_rounded,
                    isLoading: state is SubmitObservationLoading,
                    color: cs.primary,
                    colorText: isDark ? cs.surface : Colors.white,
                    height: 48,
                    onPressed: () {
                      final profileState = context.read<ProfileCubit>().state;
                      final counselorId = profileState is ProfileLoaded ? profileState.user.id : 1;

                      context.read<SubmitObservationCubit>().submitObservation(
                        programId: widget.programId,
                        objectives: _objectivesController.text.trim(),
                        result: _selectedResult,
                        tr: context.tr,
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CurrentInspectionCard extends StatelessWidget {
  const CurrentInspectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = context.read<LocaleCubit>().state.currentLanguage == 'AR';

    return BlocBuilder<CurrentInspectionCubit, CurrentInspectionState>(
      builder: (context, state) {
        if (state is CurrentInspectionLoading) {
          return Container(
            height: 70,
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (state is CurrentInspectionLoaded && state.program != null) {
          final program = state.program!;
          if (!program.isActiveOrPending) return const SizedBox.shrink();

          final isOngoing = program.status.toLowerCase() == 'ongoing';
          final badgeColor = isOngoing ? const Color(0xFF10B981) : const Color(0xFFF59E0B);

          return Container(
            decoration: BoxDecoration(
              color: isDark ? cs.surfaceContainerLow : cs.primary.withOpacity(0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: cs.outlineVariant.withOpacity(isDark ? 0.35 : 0.45),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.25 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(isDark ? 0.12 : 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.flag_rounded, color: cs.primary, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr('current_inspection_badge'),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: cs.primary,
                            ),
                          ),
                          Text(
                            program.getDisplayName(isArabic),
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: cs.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(isDark ? 0.16 : 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: badgeColor.withOpacity(0.35)),
                      ),
                      child: Text(
                        isOngoing
                            ? context.tr('status_ongoing')
                            : context.tr('status_pending'),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.meeting_room_outlined, size: 14, color: cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      '${program.section?.className ?? ''} - ${program.section?.name ?? ''}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.schedule_rounded, size: 14, color: cs.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Text(
                      '${program.startTime.substring(0, 5)} - ${program.endTime.substring(0, 5)}',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 🟢 أزرار الإجراءات وتغيير الحالة
                Row(
                  children: [
                    if (!isOngoing)
                      Expanded(
                        child: Button(
                          text: context.tr('start_inspection_btn'),
                          icon: Icons.play_arrow_rounded,
                          height: 38,
                          color: const Color(0xFFF59E0B),
                          colorText: Colors.white,
                          onPressed: () {
                            context.read<CurrentInspectionCubit>().updateStatus(
                              programId: program.id,
                              newStatus: 'ongoing',
                              tr: context.tr,
                            );
                          },
                        ),
                      )
                    else ...[
                      Expanded(
                        child: Button(
                          text: context.tr('complete_inspection_btn'),
                          icon: Icons.check_circle_rounded,
                          height: 38,
                          color: const Color(0xFF10B981),
                          colorText: Colors.white,
                          onPressed: () {
                            context.read<CurrentInspectionCubit>().updateStatus(
                              programId: program.id,
                              newStatus: 'completed',
                              tr: context.tr,
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(width: 8),
                    Expanded(
                      child: Button(
                        text: context.tr('add_observation_btn'),
                        icon: Icons.rate_review_rounded,
                        height: 38,
                        color: cs.primary,
                        colorText: isDark ? cs.surface : Colors.white,
                        onPressed: () => SubmitObservationBottomSheet.show(context, program.id),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}