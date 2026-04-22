import 'package:flowva_school/view/auth/login/reset_password_view.dart';
import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../widget/button.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/password_field.dart';
import '../../../widget/field_styles.dart'; // استيراد كلاس الستايل الموحد

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isConfirmPasswordVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 0.5],
            colors: [AppColors.primaryTeal, Colors.white],
          ),
        ),
        child: Stack(
          children: [
            // صورة الخلفية السفلية
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Image.asset(
                  'assets/Images/new_password.png',
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // زر العودة (Back to Login)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(
                      color: AppColors.primaryTeal,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      "New Password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay'),
                    ),
                    const SizedBox(height: 30),

                    Card(
                      elevation: 10,
                      shadowColor: Colors.black12,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.paddingLarge),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/Images/logo.png',
                              height: 80,
                            ),
                            const SizedBox(height: 30),

                            // حقل كلمة المرور الجديدة
                            PasswordField(
                              controller: passwordController,
                              isVisibleNotifier: isPasswordVisible,
                              label: "New Password",
                              icon: Icons.lock_outline,
                              decoration: FieldStyles.authInputDecoration(
                                label: "New Password",
                                icon: Icons.lock_outline,
                              ),
                            ),

                            const SizedBox(height: 15),

                            // حقل تأكيد كلمة المرور
                            PasswordField(
                              controller: confirmPasswordController,
                              isVisibleNotifier: isConfirmPasswordVisible,
                              label: "Confirm Password",
                              icon: Icons.published_with_changes,
                              decoration: FieldStyles.authInputDecoration(
                                label: "Confirm Password",
                                icon: Icons.published_with_changes,
                              ),
                            ),

                            const SizedBox(height: 35),

                            Button(
                              text: "UPDATE",
                              color: AppColors.primaryTeal,
                              colorText: Colors.white,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return const ResetPasswordScreen();
                                }));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}