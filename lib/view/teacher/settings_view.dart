import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'الحساب'),
          _buildSettingTile(context, 'الملف الشخصي', Icons.person, () {}),
          _buildSettingTile(context, 'تغيير كلمة المرور', Icons.lock, () {}),
          const Divider(height: 32),
          _buildSectionHeader(context, 'الإشعارات'),
          _buildSwitchTile(context, 'إشعارات الاختبارات', true, (value) {}),
          _buildSwitchTile(context, 'إشعارات الحضور', true, (value) {}),
          _buildSwitchTile(context, 'إشعارات الرسائل', true, (value) {}),
          const Divider(height: 32),
          _buildSectionHeader(context, 'المظهر'),
          _buildSwitchTile(context, 'الوضع الليلي', false, (value) {}),
          _buildSettingTile(context, 'حجم الخط', Icons.text_fields, () {}),
          const Divider(height: 32),
          _buildSectionHeader(context, 'اللغة'),
          _buildSettingTile(context, 'اللغة', Icons.language, () {}),
          const Divider(height: 32),
          _buildSectionHeader(context, 'عن التطبيق'),
          _buildSettingTile(context, 'الإصدار', Icons.info, () {}),
          _buildSettingTile(
            context,
            'سياسة الخصوصية',
            Icons.privacy_tip,
            () {},
          ),
          _buildSettingTile(
            context,
            'الأحكام والشروط',
            Icons.description,
            () {},
          ),
          const Divider(height: 32),
          _buildSettingTile(
            context,
            'تسجيل الخروج',
            Icons.logout,
            () {},
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color? color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;
    return ListTile(
      leading: Icon(icon, color: color ?? primary),
      title: Text(
        title,
        style: TextStyle(color: color ?? colorScheme.onSurface),
      ),
      trailing: Icon(
        Icons.arrow_back_ios,
        size: 16,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return SwitchListTile(
      secondary: Icon(Icons.notifications, color: colorScheme.primary),
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
