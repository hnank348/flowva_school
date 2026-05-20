import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../widget/button.dart';
import 'login_view.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
          child: Column(
            children: [
              const Spacer(flex: 2),

              Image.asset(
                'assets/Images/reset-password.png',
                width: double.infinity,
                height: 320,
                fit: BoxFit.contain,
              ),


              const Text(
                "Password Reset",
                style: TextStyle(
                  color: AppColors.primaryTeal,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GoogleSans',
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Your password has been reset successfully.\nNow login with your new password.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: AppSizes.fontSizeSubtitle,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlayfairDisplay',
                ),
              ),

              const Spacer(flex: 1),

              Button(
                text: "LOGIN",
                color: AppColors.primaryTeal,
                colorText: Colors.white,

                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return LoginScreen();
                  }));
                },
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}