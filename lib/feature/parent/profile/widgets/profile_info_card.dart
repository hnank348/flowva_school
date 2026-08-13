import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';
import '../data/profile_static_data.dart';
import 'profile_info_tile.dart';

class ProfileInfoCard extends StatelessWidget {
  final ProfileModel profile;

  const ProfileInfoCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final outline = isDark ? AppColors.darkOutlineColor : AppColors.outlineColor.withOpacity(0.5);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge * 1.5),
        border: Border.all(color: outline, width: 1.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileInfoTile(
            icon: Icons.person_outline_rounded,
            label: 'الاسم الكامل',
            value: profile.fullName,
          ),
          Divider(height: 1, thickness: 1, color: outline),
          ProfileInfoTile(
            icon: Icons.phone_android_outlined,
            label: 'رقم الهاتف',
            value: profile.phone,
          ),
          Divider(height: 1, thickness: 1, color: outline),
          ProfileInfoTile(
            icon: Icons.cake_outlined,
            label: 'تاريخ الميلاد',
            value: profile.birthDate,
          ),
        ],
      ),
    );
  }
}