import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart'; 
import '../widgets/settings_section_label.dart'; 
import '../widgets/settings_group_container.dart'; 
import '../widgets/settings_action_tile.dart'; 
import '../widgets/settings_toggle_tile.dart';
import '../widgets/logout_dialog.dart'; 

class ParentSettingsScreen extends StatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  State<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends State<ParentSettingsScreen> {
  bool _allNotifications = true; 
  bool _darkMode = false; 

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (BuildContext ctx) {
        return LogoutDialog(
          onConfirm: () {
            Navigator.pop(ctx); 
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; 
    final primaryColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal; 
    final outline = isDark ? AppColors.darkOutlineColor : AppColors.outlineColor.withOpacity(0.5); 

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundColor, 
        appBar: AppBar(
          backgroundColor: primaryColor, 
          elevation: 0, 
          centerTitle: true, 
          
          automaticallyImplyLeading: false, 
          
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          
          title: const Text(
            'الإعدادات',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(), 
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingMedium, 
                vertical: 20,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    const SettingsSectionLabel(label: 'الحساب'), 
                    SettingsGroupContainer(
                      children: [
                        SettingsActionTile(
                          icon: Icons.person_outline_rounded,
                          title: 'الملف الشخصي',
                          onTap: () {
                            Navigator.pushNamed(context, '/profile'); 
                          },
                        ),
                        Divider(height: 1, thickness: 1, color: outline), 
                        SettingsActionTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'تغيير كلمة المرور',
                          onTap: () {},
                        ), 
                      ],
                    ),

                    const SettingsSectionLabel(label: 'الإشعارات العامة'), 
                    SettingsGroupContainer(
                      children: [
                        SettingsToggleTile(
                          icon: Icons.notifications_none_outlined,
                          title: 'تفعيل كل الإشعارات',
                          value: _allNotifications,
                          onChanged: (val) => setState(() => _allNotifications = val),
                        ), 
                      ],
                    ),

                    const SettingsSectionLabel(label: 'التفضيلات والمظهر'), 
                    SettingsGroupContainer(
                      children: [
                        SettingsToggleTile(
                          icon: Icons.wb_sunny_outlined,
                          title: 'تشغيل الوضع الليلي',
                          value: _darkMode,
                          onChanged: (val) => setState(() => _darkMode = val),
                        ), 
                        Divider(height: 1, thickness: 1, color: outline), 
                        SettingsActionTile(
                          icon: Icons.language_rounded,
                          title: 'اللغة الحالية',
                          onTap: () {},
                        ), 
                      ],
                    ),

                    const SettingsSectionLabel(label: 'عن التطبيق'), 
                    SettingsGroupContainer(
                      children: [
                        SettingsActionTile(
                          icon: Icons.info_outline_rounded,
                          title: 'إصدار التطبيق',
                          trailingText: 'v1.0.0',
                          onTap: () {},
                        ), 
                        Divider(height: 1, thickness: 1, color: outline), 
                        SettingsActionTile(
                          icon: Icons.shield_outlined,
                          title: 'سياسة الخصوصية',
                          onTap: () {},
                        ),
                        Divider(height: 1, thickness: 1, color: outline),
                        SettingsActionTile(
                          icon: Icons.description_outlined,
                          title: 'الأحكام والشروط',
                          onTap: () {},
                        ), 
                      ],
                    ),

                    const SizedBox(height: AppSizes.paddingSmall), 

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white, 
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge * 1.5), 
                        border: Border.all(color: AppColors.errorRed.withOpacity(0.3), width: 1.2), 
                      ),
                      child: SettingsActionTile(
                        icon: Icons.logout_rounded,
                        title: 'تسجيل الخروج',
                        customColor: AppColors.errorRed,
                        onTap: () => _showLogoutConfirmationDialog(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}