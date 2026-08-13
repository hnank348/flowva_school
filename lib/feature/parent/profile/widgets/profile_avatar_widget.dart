import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String name;
  final String imageUrl;

  const ProfileAvatarWidget({
    super.key,
    required this.name,
    required this.imageUrl,
  });

  String _getArabicInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isNotEmpty && parts.first.isNotEmpty) {
      return parts.first[0];
    }
    return 'أ';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;

    return Column(
      children: [
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? AppColors.darkSurface : Colors.white,
            border: Border.all(color: primaryColor.withOpacity(0.35), width: 3),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.12),
                blurRadius: 14,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: ClipOval(
            child: imageUrl.isNotEmpty
                ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildInitials(primaryColor))
                : _buildInitials(primaryColor),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: AppSizes.fontSizeSubtitle,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.primaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildInitials(Color primaryColor) {
    return Center(
      child: Text(
        _getArabicInitials(name),
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 38,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }
}