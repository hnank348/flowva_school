import 'package:flowva_school/view/supervisor/attendance/attendance_view.dart';
import 'package:flowva_school/view/supervisor/exam/exam_schedule_view.dart';
import 'package:flowva_school/view/supervisor/students/students_view.dart';
import 'package:flowva_school/view/mutual/settings/settings_view.dart';
import 'package:flowva_school/cubit/logout/logout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../services/api_service.dart';
import 'package:flowva_school/services/constant_api.dart';

import '../../cubit/supervisor/cubit_supervisor/navigation_cubit.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../../cubit/profile/profile_state.dart';
import '../../cubit/current_year/current_year_cubit.dart';
import '../../cubit/current_year/current_year_state.dart';
import '../../cubit/locale/locale_cubit.dart';
import '../../cubit/locale/locale_state.dart';
import '../../app_localizations.dart';

import '../../notifications/cubit/notifications_cubit.dart';
import '../../notifications/cubit/notifications_state.dart';
import '../../notifications/cubit/notification_switch_cubit.dart';

import '../../notifications/screens/supervisor_notifications_screen.dart';
import '../../widget/custom_avatar.dart';
import 'weekly_schedule/weekly_schedule_view.dart';
import 'custom_bottom_navigation_bar.dart';

class MainLayoutView extends StatelessWidget {
  final String userToken;

  const MainLayoutView({super.key, required this.userToken});

  Future<void> _syncFcmToken(BuildContext context) async {
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await messaging.getToken();
        if (token != null && token.isNotEmpty) {
          final apiService = ApiService();
          final response = await apiService.post(
            '${ConstantApi.baseApi}/users/fcm-token',
            data: {'fcm_token': token},
            tr: context.tr,
          );
          debugPrint('✅ [FCM Sync] Token sent successfully. Status: ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('❌ [FCM Sync Error]: $e');
    }
  }

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
            BlocProvider<NotificationSwitchCubit>.value(value: notificationSwitchCubit),
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
          child: const SupervisorNotificationsScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final notificationsCubit = context.read<NotificationsCubit>();
    if (notificationsCubit.state is NotificationsInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notificationsCubit.loadNotifications();
        _syncFcmToken(context);
      });
    }

    final List<Widget> pages = const [
      WeeklyScheduleView(),
      ExamScheduleView(),
      AttendanceView(),
      StudentsView(),
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
                                      padding: const EdgeInsets.all(2.5),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? colorScheme.surfaceContainerLow
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.08),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          )
                                        ],
                                      ),
                                      child: CustomAvatar(
                                        imageUrl: avatarUrl,
                                        radius: 34,
                                        backgroundColor: isDark
                                            ? colorScheme.surfaceContainer
                                            : colorScheme.primary.withOpacity(0.12),
                                        iconColor: colorScheme.primary,
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
                                  onPressed: () => _openSettings(context),
                                ),
                                const SizedBox(width: 4),
                                BlocBuilder<NotificationsCubit, NotificationsState>(
                                  builder: (context, notifState) {
                                    final unread = notifState is NotificationsLoaded
                                        ? notifState.unreadCount
                                        : 0;

                                    return Stack(
                                      clipBehavior: Clip.none,
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
                                          onPressed: () => _openNotifications(context),
                                        ),
                                        if (unread > 0)
                                          Positioned(
                                            top: 0,
                                            right: isArabic ? null : 0,
                                            left: isArabic ? 0 : null,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 4,
                                                vertical: 1,
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 16,
                                                minHeight: 16,
                                              ),
                                              decoration: BoxDecoration(
                                                color: colorScheme.error,
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: isDark
                                                      ? colorScheme.surfaceContainer
                                                      : colorScheme.primary,
                                                  width: 1.5,
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                unread > 99 ? '99+' : '$unread',
                                                style: TextStyle(
                                                  color: colorScheme.onError,
                                                  fontSize: 9,
                                                  height: 1.2,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Cairo',
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
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