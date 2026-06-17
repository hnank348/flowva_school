import 'package:flowva_school/view/supervisor/attendance_view.dart';
import 'package:flowva_school/view/supervisor/exam_schedule_view.dart';
import 'package:flowva_school/view/supervisor/statistics_view.dart';
import 'package:flowva_school/view/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/supervisor/cubit_supervisor/navigation_cubit.dart';
import 'weekly_schedule/weekly_schedule_view.dart';
import 'custom_bottom_navigation_bar.dart';

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Widget> pages = [
      const WeeklyScheduleView(),
      const ExamScheduleView(),
      const AttendanceView(),
      const StatisticsView(),
    ];

    return BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
              backgroundColor: colorScheme.surface,
              appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(145),
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 14,
                      right: 20,
                      left: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? null
                          : LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withOpacity(0.8),
                        ],
                      ),
                      color: isDark ? colorScheme.surfaceContainer : null,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: SafeArea(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                      Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      IconButton(
                      icon: const Icon(
                      Icons.settings_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(6),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const SettingsView(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                    IconButton(
                    icon: const Icon(
                    Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                      onPressed: () {},
                    ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: colorScheme.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                        ],
                      ),
                    ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          textDirection: TextDirection.rtl,
                          children: [
                          Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            color: isDark
                                ? colorScheme.surfaceContainerLow
                                : Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              color: colorScheme.primary,
                              size: 46,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'أ. حنان خميس',
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark
                                      ? colorScheme.onSurface
                                      : Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                'الموجه العام',
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark
                                      ? colorScheme.onSurfaceVariant
                                      : Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                        ),
                          ],
                        ),
                      ),
                          ],
                      ),
                    ),
                  ),
              ),
            body: SafeArea(child: pages[currentIndex]),
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                context.read<NavigationCubit>().changePage(index);
              },
            ),
          );
        },
    );
  }
}