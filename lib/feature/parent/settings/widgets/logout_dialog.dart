import 'package:flutter/material.dart';
import 'package:flowva_school/app_theme.dart'; 

class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutDialog({
    super.key, 
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dialogBackgroundColor = isDark ? AppColors.darkSurface : AppColors.backgroundColor;
    final primaryTextColor = isDark ? Colors.white : AppColors.primaryText; 
    final secondaryTextColor = isDark ? AppColors.darkSecondaryText : AppColors.secondaryText; 
    final buttonOutlineColor = isDark ? AppColors.darkOutlineColor : AppColors.outlineColor; 

    return Dialog(
      backgroundColor: dialogBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusExtraLarge), 
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLarge), 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.logout_rounded, 
              color: AppColors.errorRed, 
              size: 50,
            ), 
            const SizedBox(height: AppSizes.paddingMedium), 
            Text(
              "تسجيل الخروج",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: AppSizes.fontSizeSubtitle,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: AppSizes.paddingSmall), 
            Text(
              "هل أنت متأكد من رغبتك في تسجيل الخروج؟",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: AppSizes.fontSizeLabel, 
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: AppSizes.paddingLarge), 
            
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed, 
                minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge), 
                ),
              ),
              child: const Text(
                "تأكيد تسجيل الخروج",
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingMedium), 
            
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, AppSizes.buttonHeight), 
                side: BorderSide(color: buttonOutlineColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge), 
                ),
              ),
              child: Text(
                "إلغاء",
                style: TextStyle(
                  color: primaryTextColor, 
                  fontSize: AppSizes.fontSizeLabel + 1.0, 
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}