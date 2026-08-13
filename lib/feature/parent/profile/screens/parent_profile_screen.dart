import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart';
import '../data/profile_static_data.dart';
import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_info_card.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;
    final labelColor = isDark ? AppColors.darkSecondaryText : AppColors.secondaryText.withOpacity(0.9);
    
    const profileData = ProfileStaticData.dummyProfile;

    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'الملف الشخصي',
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
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileAvatarWidget(
                      name: profileData.fullName,
                      imageUrl: profileData.avatarUrl,
                    ),
                    
                    const SizedBox(height: 32),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                        child: Text(
                          'البيانات الشخصية',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: AppSizes.fontSizeLabel + 1.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkOutlineColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ProfileInfoCard(profile: profileData),
                    
                    const SizedBox(height: 24),
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