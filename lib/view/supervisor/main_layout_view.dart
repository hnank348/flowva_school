import 'package:flowva_school/view/supervisor/attendance/attendance_view.dart';
import 'package:flowva_school/view/supervisor/exam_schedule_view.dart';
import 'package:flowva_school/view/supervisor/statistics_view.dart';
import 'package:flowva_school/view/mutual/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/supervisor/cubit_supervisor/navigation_cubit.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../../cubit/profile/profile_state.dart';
import '../../cubit/current_year/current_year_cubit.dart';
import '../../cubit/current_year/current_year_state.dart';
import '../../cubit/locale/locale_cubit.dart';
import '../../cubit/locale/locale_state.dart';
import '../../app_localizations.dart';
import 'weekly_schedule/weekly_schedule_view.dart';
import 'custom_bottom_navigation_bar.dart';

class MainLayoutView extends StatelessWidget {
  final String userToken;

  const MainLayoutView({super.key, required this.userToken});

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

    // 🌍 إضافة BlocBuilder للغة لإعادة بناء الواجهة بالكامل وتغيير النصوص والاتجاهات حياً
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        final isArabic = localeState.currentLanguage == 'AR';

        return Directionality(
          textDirection: localeState.textDirection,
          child: BlocBuilder<NavigationCubit, int>(
            builder: (context, currentIndex) {
              return Scaffold(
                backgroundColor: colorScheme.surface,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(145),
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 14,
                      right: 16,
                      left: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? null
                          : LinearGradient(
                        begin: isArabic ? Alignment.topRight : Alignment.topLeft,
                        end: isArabic ? Alignment.bottomLeft : Alignment.bottomRight,
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
                          Expanded(
                            child: BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, profileState) {
                                String displayName = context.tr('main_loading');
                                String? avatarUrl;

                                if (profileState is ProfileLoaded) {
                                  displayName = isArabic
                                      ? (profileState.user.fullNameAr.isNotEmpty
                                      ? profileState.user.fullNameAr
                                      : profileState.user.fullName)
                                      : (profileState.user.fullName.isNotEmpty
                                      ? profileState.user.fullName
                                      : profileState.user.fullNameAr);
                                  avatarUrl = profileState.user.avatarUrl;
                                } else if (profileState is ProfileError) {
                                  displayName = context.tr('main_profile_error');
                                }

                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? colorScheme.surfaceContainerLow
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          )
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(36),
                                        child: avatarUrl != null
                                            ? Image.network(
                                          avatarUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person,
                                              color: colorScheme.primary,
                                              size: 42,
                                            );
                                          },
                                        )
                                            : Center(
                                          child: Icon(
                                            Icons.person,
                                            color: colorScheme.primary,
                                            size: 42,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            displayName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: isDark ? colorScheme.onSurface : Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            context.tr('main_role_supervisor'),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: isDark
                                                  ? colorScheme.onSurfaceVariant
                                                  : Colors.white.withOpacity(0.9),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          BlocBuilder<CurrentYearCubit, CurrentYearState>(
                                            builder: (context, yearState) {
                                              String yearContent = '...';
                                              if (yearState is CurrentYearSuccess) {
                                                yearContent = yearState.currentYear.name;
                                              } else if (yearState is CurrentYearError) {
                                                yearContent = context.tr('main_year_error');
                                              }

                                              return Text(
                                                '${context.tr('main_academic_year')} $yearContent',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: isDark
                                                      ? colorScheme.primary
                                                      : Colors.white.withOpacity(0.75),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Cairo',
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 16),

                          // ⚙️ طرف الأزرار (الإعدادات والإشعارات - ينتقل للحافة المقابلة تلقائياً)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
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
                                      builder: (c) => SettingsView(userToken: userToken),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
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
                                      right: isArabic ? 6 : null,
                                      left: isArabic ? null : 6,
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
          ),
        );
      },
    );
  }
}