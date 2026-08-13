import 'package:flowva_school/view/mutual/settings/settings_layout_components.dart';
import 'package:flowva_school/view/mutual/settings/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/view/mutual/profile/profile_view.dart';
import 'package:flowva_school/cubit/theme/theme_cubit.dart';
import 'package:flowva_school/cubit/theme/theme_state.dart';
import 'package:flowva_school/cubit/locale/locale_cubit.dart';
import 'package:flowva_school/cubit/locale/locale_state.dart';

import 'package:flowva_school/notifications/cubit/notification_switch_cubit.dart';
import 'package:flowva_school/notifications/cubit/notifications_cubit.dart';

import '../../../app_localizations.dart';
import '../../../chat/screens/chat_screen.dart';
import 'new_password_view.dart';
import 'language_picker_bottom_sheet.dart';
import 'logout_tile.dart';

class SettingsView extends StatelessWidget {
  final String userToken;

  const SettingsView({super.key, required this.userToken});

  void _showLanguagePicker(BuildContext context, ColorScheme colorScheme, bool isDark, String currentLang) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? colorScheme.surfaceContainerHigh : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (_) => LanguagePickerBottomSheet(
        colorScheme: colorScheme,
        isDark: isDark,
        currentLang: currentLang,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark      = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: TranslatedText(
          'settings_title',
          style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft:  Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            final isDarkMode = themeState is DarkModeState;

            return BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, localeState) {
                final isArabic = localeState.currentLanguage == 'AR';
                final langLabel = isArabic ? 'العربية' : 'English';

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 600;

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 40 : 16,
                        vertical: 20,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Directionality(
                            textDirection: localeState.textDirection,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // ─── الحساب ───
                                SectionLabel(label: context.tr('settings_account')),
                                const SizedBox(height: 8),
                                SettingsGroup(
                                  isDark:      isDark,
                                  colorScheme: colorScheme,
                                  children: [
                                    SettingsTile(
                                      icon:  Icons.person_outline_rounded,
                                      title: context.tr('settings_profile'),
                                      colorScheme: colorScheme,
                                      isDark:      isDark,
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProfileView(userToken: userToken),
                                        ),
                                      ),
                                    ),
                                    SettingsDivider(colorScheme: colorScheme),
                                    // 🟢 إضافة خيار الرسائل هنا
                                    SettingsTile(
                                      icon:  Icons.chat_bubble_outline_rounded,
                                      title: context.tr('settings_messages'),
                                      colorScheme: colorScheme,
                                      isDark:      isDark,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ChatScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    SettingsDivider(colorScheme: colorScheme),
                                    SettingsTile(
                                      icon:  Icons.lock_outline_rounded,
                                      title: context.tr('settings_change_password'),
                                      colorScheme: colorScheme,
                                      isDark:      isDark,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ForgetPasswordScreen(userToken: userToken),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 22),

                                // ─── المظهر ───
                                SectionLabel(label: context.tr('settings_appearance')),
                                const SizedBox(height: 8),
                                SettingsGroup(
                                  isDark:      isDark,
                                  colorScheme: colorScheme,
                                  children: [
                                    SwitchTile(
                                      icon: isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_outlined,
                                      title: context.tr(isDarkMode ? 'settings_dark_mode_on' : 'settings_dark_mode_off'),
                                      value:       isDarkMode,
                                      colorScheme: colorScheme,
                                      isDark:      isDark,
                                      onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                                    ),
                                    SettingsDivider(colorScheme: colorScheme),
                                    SettingsTile(
                                      icon:  Icons.language_rounded,
                                      title: context.tr('settings_language'),
                                      trailing: BadgePill(
                                        label: langLabel,
                                        colorScheme: colorScheme,
                                      ),
                                      colorScheme: colorScheme,
                                      isDark:      isDark,
                                      onTap: () => _showLanguagePicker(
                                          context,
                                          colorScheme,
                                          isDark,
                                          localeState.currentLanguage
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 22),

                                // ─── الإشعارات (مربوط بالـ Cubit 100%) ───
                                SectionLabel(label: context.tr('settings_notifications')),
                                const SizedBox(height: 8),
                                SettingsGroup(
                                  isDark:      isDark,
                                  colorScheme: colorScheme,
                                  children: [
                                    BlocBuilder<NotificationSwitchCubit, bool>(
                                      builder: (context, isEnabled) {
                                        return SwitchTile(
                                          icon: isEnabled
                                              ? Icons.notifications_active_outlined
                                              : Icons.notifications_off_outlined,
                                          title: context.tr('settings_notifications_toggle'),
                                          value: isEnabled,
                                          colorScheme: colorScheme,
                                          isDark: isDark,
                                          onChanged: (val) {
                                            context.read<NotificationSwitchCubit>().toggleNotification(val);
                                            if (val) {
                                              context.read<NotificationsCubit>().loadNotifications();
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 22),

                                // ─── عن التطبيق ───
                                SectionLabel(label: context.tr('settings_about')),
                                const SizedBox(height: 8),
                                SettingsGroup(
                                  isDark:      isDark,
                                  colorScheme: colorScheme,
                                  children: [
                                    SettingsTile(
                                      icon:  Icons.info_outline_rounded,
                                      title: context.tr('settings_version'),
                                      trailing: Text(
                                        'v1.0.0',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: 12,
                                          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                                        ),
                                      ),
                                      colorScheme: colorScheme,
                                      isDark:      isDark,
                                      onTap:       () {},
                                    ),
                                    SettingsDivider(colorScheme: colorScheme),
                                    SettingsTile(
                                      icon:  Icons.privacy_tip_outlined,
                                      title: context.tr('settings_privacy'),
                                      colorScheme: colorScheme,
                                      isDark:      isDark,
                                      onTap:       () {},
                                    ),
                                    SettingsDivider(colorScheme: colorScheme),
                                    SettingsTile(
                                      icon:  Icons.description_outlined,
                                      title: context.tr('settings_terms'),
                                      colorScheme: colorScheme,
                                      isDark:      isDark,
                                      onTap:       () {},
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 22),

                                LogoutTile(
                                  colorScheme: colorScheme,
                                  isDark:      isDark,
                                  label:       context.tr('settings_logout'),
                                ),

                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}