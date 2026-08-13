import 'package:flutter/material.dart';
import '../../../../app_theme.dart';
import '../data/mock_attendance_data.dart';
import '../widgets/attendance_kpi_cards.dart';
import '../widgets/attendance_progress_indicators.dart';
import '../widgets/custom_advanced_calendar.dart';

class AttendanceTrackingScreen extends StatelessWidget {
  final String studentName;

  const AttendanceTrackingScreen({super.key, required this.studentName});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const int currentMonth = 6;
    const int currentYear = 2026;

    final filteredLogs = MockAttendanceData.attendanceLogs.where((log) {
      return log.year == currentYear && log.month == currentMonth;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            'سجل حضور الطالب | $studentName',
            style: TextStyle(
              fontSize: AppSizes.fontSizeLabel + 1.5, 
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: isDark ? Colors.white : AppColors.primaryText,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.primaryText),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(AppSizes.paddingMedium),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(context, 'ملخص الحالة العامة التراكمية لطالب', Icons.analytics_outlined),
                      const SizedBox(height: AppSizes.paddingSmall + 4.0), 
                      const AttendanceKpiCards(),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(context, 'التقويم الشهري الذكي ومتابعة الحضور اليومي', Icons.calendar_month_outlined),
                      const SizedBox(height: AppSizes.paddingSmall + 4.0),
                      CustomAdvancedCalendar(
                        onMonthChanged: (month, year) {
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(AppSizes.paddingMedium),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(context, 'مؤشرات الانضباط ونسب التقدم الشهرية', Icons.donut_large_rounded),
                      const SizedBox(height: AppSizes.paddingSmall + 4.0),
                      const AttendanceProgressIndicators(),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.paddingSmall + 4.0),
                    child: _buildSectionHeader(context, 'سجل الحضور والغياب اليومي المفصل (آخر 10 أيام)', Icons.segment_rounded),
                  ),
                ),
              ),

              AttendanceLogsListView(filteredLogs: filteredLogs),

              const SliverToBoxAdapter(child: SizedBox(height: AppSizes.paddingLarge)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: AppSizes.fontSizeSubtitle, color: isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal),
        const SizedBox(width: AppSizes.paddingSmall),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppSizes.fontSizeLabel,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: isDark ? Colors.white : AppColors.primaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class AttendanceLogsListView extends StatelessWidget {
  final List<dynamic> filteredLogs;

  const AttendanceLogsListView({super.key, required this.filteredLogs});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (filteredLogs.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Text(
              'لا توجد سجلات حضور تفصيلية لهذا الشهر',
              style: TextStyle(
                fontFamily: 'Cairo', 
                color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText, 
                fontSize: AppSizes.fontSizeLabel - 1.0,
              ),
            ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final log = filteredLogs[index];
            return Container(
              margin: const EdgeInsets.only(bottom: AppSizes.paddingSmall),
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                border: Border.all(
                  color: isDark ? AppColors.darkOutlineColor : AppColors.outlineColor, 
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.paddingSmall),
                    decoration: BoxDecoration(
                      color: (log.statusColor as Color).withOpacity(0.2), 
                      shape: BoxShape.circle,
                    ),
                    child: Icon(log.icon, color: log.statusColor, size: 20),
                  ),
                  const SizedBox(width: AppSizes.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log.dayName, 
                          style: TextStyle(
                            fontSize: AppSizes.fontSizeLabel, 
                            fontWeight: FontWeight.bold, 
                            fontFamily: 'Cairo', 
                            color: isDark ? Colors.white : AppColors.primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall, vertical: 2),
                          decoration: BoxDecoration(
                            color: (log.statusColor as Color).withOpacity(0.2), 
                            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall / 2),
                          ),
                          child: Text(
                            log.status, 
                            style: TextStyle(
                              color: log.statusColor, 
                              fontSize: AppSizes.fontSizeLabel - 1.0, 
                              fontWeight: FontWeight.bold, 
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        log.time, 
                        style: TextStyle(
                          fontSize: AppSizes.fontSizeLabel - 1.0, 
                          fontWeight: FontWeight.bold, 
                          color: log.statusColor, 
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        log.dateStr, 
                        style: TextStyle(
                          fontSize: AppSizes.fontSizeLabel - 3.0, 
                          color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText, 
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          childCount: filteredLogs.length,
        ),
      ),
    );
  }
}
