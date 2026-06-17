import 'package:flowva_school/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/theme/theme_cubit.dart';
import '../cubit/theme/theme_state.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkTheme ? colorScheme.surface : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'الإعدادات',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final themeCubit = context.read<ThemeCubit>();
          final isDark = state is DarkModeState;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildSectionHeader(context, 'الحساب'),
              _buildGroupContainer(context, [
                _buildSettingTile(
                  context,
                  'الملف الشخصي',
                  Icons.person_outline_rounded,
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const ProfileView()),
                  ),
                ),
                _buildDivider(context), // تم إبقاء فاصل واحد نظيف هنا
                _buildSettingTile(context, 'تغيير كلمة المرور', Icons.lock_outline_rounded, () {}),
              ]),

              const SizedBox(height: 24),

              _buildSectionHeader(context, 'الإشعارات العامة'),
              _buildGroupContainer(context, [
                _buildSwitchTile(
                  context,
                  'تفعيل كل الإشعارات',
                  Icons.notifications_active_outlined,
                  true,
                      (value) {},
                ),
              ]),

              const SizedBox(height: 24),

              _buildSectionHeader(context, 'التفضيلات والمظهر'),
              _buildGroupContainer(context, [
                _buildSwitchTile(
                  context,
                  isDark ? 'الوضع الليلي مفعّل' : 'تشغيل الوضع الليلي',
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_outlined,
                  isDark,
                      (value) {
                    themeCubit.toggleTheme();
                  },
                ),
                _buildDivider(context), // تم إبقاء فاصل واحد نظيف هنا
                _buildSettingTile(context, 'اللغة الحالية', Icons.language_rounded, () {}),
              ]),

              const SizedBox(height: 24),

              _buildSectionHeader(context, 'عن التطبيق'),
              _buildGroupContainer(context, [
                _buildSettingTile(context, 'إصدار التطبيق', Icons.info_outline_rounded, () {}, trailingText: 'v1.0.0'),
                _buildDivider(context),
                _buildSettingTile(context, 'سياسة الخصوصية', Icons.privacy_tip_outlined, () {}),
                _buildDivider(context),
                _buildSettingTile(context, 'الأحكام والشروط', Icons.description_outlined, () {}),
              ]),

              const SizedBox(height: 32),

              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.error.withOpacity(0.2), width: 1),
                ),
                child: _buildSettingTile(
                  context,
                  'تسجيل الخروج',
                  Icons.logout_rounded,
                      () {},
                  color: colorScheme.error,
                  showTrailingArrow: false,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildGroupContainer(BuildContext context, List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.15 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.4), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Divider(
      height: 1,
      thickness: 1,
      indent: 52,
      color: colorScheme.outlineVariant.withOpacity(0.4),
    );
  }

  Widget _buildSettingTile(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap, {
        Color? color,
        String? trailingText,
        bool showTrailingArrow = true,
      }) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color != null ? color.withOpacity(0.1) : primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color ?? primaryColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: color ?? colorScheme.onSurface,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: colorScheme.onSurfaceVariant),
            ),
          if (showTrailingArrow) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: colorScheme.onSurfaceVariant.withOpacity(0.6),
            ),
          ]
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
      BuildContext context,
      String title,
      IconData icon,
      bool value,
      ValueChanged<bool> onChanged,
      ) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;

    return SwitchListTile.adaptive(
      contentPadding: const EdgeInsets.only(left: 8, right: 16),
      secondary: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: value ? colorScheme.primary.withOpacity(0.15) : primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: value ? colorScheme.primary : primaryColor, size: 20),
      ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: KeyedSubtree(
          key: ValueKey<String>(title),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
      activeColor: colorScheme.primary,
      value: value,
      onChanged: onChanged,
    );
  }
}