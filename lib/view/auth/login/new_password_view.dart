import 'package:flowva_school/view/auth/login/reset_password_view.dart';
import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../widget/button.dart';
import '../../../widget/custom_text_field.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isConfirmPasswordVisible = ValueNotifier<bool>(false);

  InputDecoration _buildDecoration(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: AppColors.primaryTeal),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
      borderRadius: BorderRadius.circular(12),
    ),
  );

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

                            ValueListenableBuilder<bool>(
                              valueListenable: isPasswordVisible,
                              builder: (context, isVisible, _) => CustomTextField(
                                controller: passwordController,
                                hintText: "New Password",
                                isPassword: !isVisible,
                                decoration: _buildDecoration("New Password", Icons.lock_outline).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.primaryTeal),
                                    onPressed: () => isPasswordVisible.value = !isPasswordVisible.value,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),

                            ValueListenableBuilder<bool>(
                              valueListenable: isConfirmPasswordVisible,
                              builder: (context, isVisible, _) => CustomTextField(
                                controller: confirmPasswordController,
                                hintText: "Confirm Password",
                                isPassword: !isVisible,
                                decoration: _buildDecoration("Confirm Password", Icons.published_with_changes).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.primaryTeal),
                                    onPressed: () => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 35),

                            Button(
                              text: "UPDATE",
                              color: AppColors.primaryTeal,
                              colorText: Colors.white,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return ResetPasswordScreen();
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