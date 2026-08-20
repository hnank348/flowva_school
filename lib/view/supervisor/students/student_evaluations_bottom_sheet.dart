import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/supervisor/student_evaluations/student_evaluations_cubit.dart';
import '../../../cubit/supervisor/student_evaluations/student_evaluations_state.dart';
import '../../../models/supervisor/student_points_summary_model.dart';
import '../../../widget/button.dart';
import '../../../app_localizations.dart';

class StudentEvaluationsBottomSheet extends StatelessWidget {
  final int studentId;
  final int semesterId;

  const StudentEvaluationsBottomSheet({
    super.key,
    required this.studentId,
    required this.semesterId,
  });

  static void show(BuildContext context, {required int studentId, required int semesterId}) {
    context.read<StudentEvaluationsCubit>().fetchSummary(
      studentId: studentId,
      semesterId: semesterId,
      tr: context.tr,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<StudentEvaluationsCubit>(),
        child: StudentEvaluationsBottomSheet(
          studentId: studentId,
          semesterId: semesterId,
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
        maxHeight: MediaQuery.of(context).size.height * 0.72,
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
                child: Icon(Icons.analytics_rounded, color: cs.primary, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.tr('evaluations_sheet_title'),
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
          const SizedBox(height: 14),
          Expanded(
            child: BlocBuilder<StudentEvaluationsCubit, StudentEvaluationsState>(
              builder: (context, state) {
                if (state is StudentEvaluationsLoading || state is StudentEvaluationsInitial) {
                  return Center(child: CircularProgressIndicator(color: cs.primary));
                }

                if (state is StudentEvaluationsError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline_rounded, size: 38, color: cs.error),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Cairo', color: cs.error, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                if (state is StudentEvaluationsLoaded) {
                  final summary = state.summary;
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSummaryScoreRow(summary, cs, isDark, context),
                        const SizedBox(height: 18),
                        Text(
                          context.tr('evaluations_categories_breakdown'),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (summary.byCategory.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 28),
                            child: Center(
                              child: Text(
                                context.tr('no_evaluations_yet'),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13.5,
                                  color: cs.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                        else
                          ...summary.byCategory.map((cat) => _buildCategoryCard(cat, cs, isDark)),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryScoreRow(
      StudentPointsSummaryModel summary,
      ColorScheme cs,
      bool isDark,
      BuildContext context,
      ) {
    return Row(
      children: [
        Expanded(
          child: _bentoScoreBox(
            title: context.tr('positive_points'),
            value: '+${summary.positive}',
            color: const Color(0xFF10B981),
            icon: Icons.thumb_up_alt_rounded,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _bentoScoreBox(
            title: context.tr('negative_points'),
            value: '-${summary.negative}',
            color: const Color(0xFFEF4444),
            icon: Icons.thumb_down_alt_rounded,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _bentoScoreBox(
            title: context.tr('total_points'),
            value: '${summary.total}',
            color: cs.primary,
            icon: Icons.workspace_premium_rounded,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _bentoScoreBox({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(isDark ? 0.35 : 0.25)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.25 : 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      PointCategoryBreakdown cat,
      ColorScheme cs,
      bool isDark,
      ) {
    final color = cat.isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(isDark ? 0.35 : 0.5)),
      ),
      child: Row(
        children: [
          Icon(
            cat.isPositive ? Icons.add_circle_outline_rounded : Icons.remove_circle_outline_rounded,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              cat.category,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${cat.isPositive ? '+' : '-'}${cat.total}',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}