import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/supervisor/student_details/student_parents_cubit.dart';
import '../../../cubit/supervisor/student_details/student_parents_state.dart';
import '../../../models/supervisor/student_detail_model.dart';
import '../../../widget/button.dart';
import '../../../app_localizations.dart';

class ParentsBottomSheet extends StatelessWidget {
  final int studentId;

  const ParentsBottomSheet({super.key, required this.studentId});

  static void show(BuildContext context, int studentId) {
    context.read<StudentParentsCubit>().fetchParents(
      studentId: studentId,
      tr: context.tr,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<StudentParentsCubit>(),
        child: ParentsBottomSheet(studentId: studentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.65,
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
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
                      color: cs.primary.withOpacity(isDark ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.family_restroom_rounded,
                      color: cs.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      context.tr('parents_sheet_title'),
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
              const SizedBox(height: 12),
              Flexible(
                child: BlocBuilder<StudentParentsCubit, StudentParentsState>(
                  builder: (context, state) {
                    if (state is StudentParentsLoading || state is StudentParentsInitial) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 36),
                        child: Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          ),
                        ),
                      );
                    }

                    if (state is StudentParentsError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline_rounded, size: 38, color: cs.error),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 13,
                                color: cs.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Button(
                              text: context.tr('retry_btn'),
                              width: 150,
                              height: 42,
                              color: cs.primary,
                              colorText: Colors.white,
                              onPressed: () {
                                context.read<StudentParentsCubit>().fetchParents(
                                  studentId: studentId,
                                  tr: context.tr,
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is StudentParentsLoaded) {
                      final parents = state.parents;

                      if (parents.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person_off_outlined,
                                size: 44,
                                color: cs.onSurfaceVariant.withOpacity(0.4),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                context.tr('no_parents_found'),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13.5,
                                  color: cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: parents.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return _buildParentCard(context, parents[index], cs, isDark);
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParentCard(
      BuildContext context,
      ParentModel parent,
      ColorScheme cs,
      bool isDark,
      ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cs.outlineVariant.withOpacity(isDark ? 0.35 : 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: cs.primary.withOpacity(0.12),
                child: Icon(Icons.person_rounded, size: 20, color: cs.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  parent.fullName,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (parent.relationship.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    parent.relationship,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.phone_outlined, size: 15, color: cs.onSurfaceVariant),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  parent.phone != null && parent.phone!.isNotEmpty
                      ? parent.phone!
                      : context.tr('not_available'),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12.5,
                    color: cs.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (parent.isPrimaryContact) ...[
                const SizedBox(width: 6),
                _badgeTag(
                  label: context.tr('primary_contact_badge'),
                  icon: Icons.star_rounded,
                  color: const Color(0xFFF59E0B),
                  isDark: isDark,
                ),
              ],
              if (parent.canPickup) ...[
                const SizedBox(width: 6),
                _badgeTag(
                  label: context.tr('can_pickup_badge'),
                  icon: Icons.check_circle_outline_rounded,
                  color: const Color(0xFF10B981),
                  isDark: isDark,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _badgeTag({
    required String label,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.18 : 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}