import 'package:flowva_school/app_theme.dart';
import 'package:flutter/material.dart';

class CustomDashboardAppBar extends StatelessWidget {
  final String userName;
  final String subtitle;
  final String academicYear;
  final String description;
  final String imageUrl;
  final bool hasNotifications;
  final VoidCallback onProfileTap;
  final VoidCallback onNotificationsTap;
  final VoidCallback onSettingsTap;

  const CustomDashboardAppBar({
    super.key,
    required this.userName,
    required this.subtitle,
    required this.academicYear,
    required this.description,
    required this.imageUrl,
    required this.hasNotifications,
    required this.onProfileTap,
    required this.onNotificationsTap,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onProfileTap,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white, 
                      child: imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.network(imageUrl, fit: BoxFit.cover, width: 50, height: 50),
                            )
                          : Icon(Icons.person, color: primaryColor, size: 35), 
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitle, 
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'السنة الدراسية: $academicYear', 
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 26),
                        onPressed: onNotificationsTap, 
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      if (hasNotifications)
                        Positioned(
                          top: 6,
                          right: 8,
                          child: Container(
                            width: 12,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 26),
                    onPressed: onSettingsTap,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.only(right: 8, left: 4),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                  fontFamily: 'Cairo',
                  height: 1.2, 
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}