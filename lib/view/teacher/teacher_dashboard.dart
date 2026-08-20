import 'package:flowva_school/app_localizations.dart';
import 'package:flowva_school/cubit/current_year/current_year_cubit.dart';
import 'package:flowva_school/cubit/current_year/current_year_state.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';
import 'package:flowva_school/cubit/logout/logout_cubit.dart';
import 'package:flowva_school/cubit/profile/profile_cubit.dart';
import 'package:flowva_school/cubit/profile/profile_state.dart';
import 'package:flowva_school/cubit/supervisor/cubit_supervisor/navigation_cubit.dart';
import 'package:flowva_school/notifications/cubit/notification_switch_cubit.dart';
import 'package:flowva_school/notifications/cubit/notifications_cubit.dart';
import 'package:flowva_school/view/mutual/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_view.dart';
import 'classes_view.dart';
import 'home_view.dart';
import 'schedule_view.dart';
import 'students_view.dart';
import 'teacher_bottom_navigation_bar.dart';
import 'teacher_notifications_screen.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key, required this.userToken});
  final String userToken;

  void _openSettings(BuildContext context) {
    final logoutCubit = context.read<LogoutCubit>();
    final notificationsCubit = context.read<NotificationsCubit>();
    final notificationSwitchCubit = context.read<NotificationSwitchCubit>();
    final profileCubit = context.read<ProfileCubit>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider<LogoutCubit>.value(value: logoutCubit),
            BlocProvider<NotificationsCubit>.value(value: notificationsCubit),
            BlocProvider<NotificationSwitchCubit>.value(
              value: notificationSwitchCubit,
            ),
            BlocProvider<ProfileCubit>.value(value: profileCubit),
          ],
          child: SettingsView(userToken: userToken),
        ),
      ),
    ).then((_) {
      profileCubit.fetchUserProfile(token: userToken);
    });
  }

  void _openNotifications(BuildContext context) {
    final notificationsCubit = context.read<NotificationsCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: notificationsCubit,
          child: const TeacherNotificationsScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = [
      HomeView(userToken: userToken),
      const ScheduleView(),
      const ClassesView(),
      const StudentsView(),
      const ChatView(),
    ];

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
                              begin: isArabic
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              end: isArabic
                                  ? Alignment.bottomLeft
                                  : Alignment.bottomRight,
                              colors: [
                                colorScheme.primary,
                                colorScheme.primary.withValues(alpha: 0.8),
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
                                  displayName = context.tr(
                                    'main_profile_error',
                                  );
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
                                            color: Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(36),
                                        child: avatarUrl != null
                                            ? Image.network(
                                                avatarUrl,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (context, err, stack) =>
                                                        Icon(
                                                          Icons.person,
                                                          color: colorScheme
                                                              .primary,
                                                          size: 42,
                                                        ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            displayName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: isDark
                                                  ? colorScheme.onSurface
                                                  : Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            context.tr('main_role_teacher'),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: isDark
                                                  ? colorScheme.onSurfaceVariant
                                                  : Colors.white.withValues(
                                                      alpha: 0.9,
                                                    ),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          BlocBuilder<
                                            CurrentYearCubit,
                                            CurrentYearState
                                          >(
                                            builder: (context, yearState) {
                                              String yearContent = '...';
                                              if (yearState
                                                  is CurrentYearSuccess) {
                                                yearContent =
                                                    yearState.currentYear.name;
                                              } else if (yearState
                                                  is CurrentYearError) {
                                                yearContent = context.tr(
                                                  'main_year_error',
                                                );
                                              }
                                              return Text(
                                                '${context.tr('main_academic_year')} $yearContent',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: isDark
                                                      ? colorScheme.primary
                                                      : Colors.white.withValues(
                                                          alpha: 0.75,
                                                        ),
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
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.settings_outlined,
                                    color: isDark
                                        ? colorScheme.onSurface
                                        : Colors.white,
                                    size: 22,
                                  ),
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.all(6),
                                  onPressed: () => _openSettings(context),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: Icon(
                                    Icons.notifications_none_rounded,
                                    color: isDark
                                        ? colorScheme.onSurface
                                        : Colors.white,
                                    size: 24,
                                  ),
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.all(6),
                                  onPressed: () => _openNotifications(context),
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
                bottomNavigationBar: TeacherBottomNavigationBar(
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
