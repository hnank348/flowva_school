import 'package:flowva_school/view/auth/login/new_password_view.dart';
import 'package:flowva_school/view/auth/signup_view.dart';
import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../widget/button.dart';
import '../../../widget/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // المتحكمات
  static final nameController = TextEditingController();
  static final emailController = TextEditingController();
  static final passwordController = TextEditingController();

  static final ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(
    false,
  );

  static InputDecoration _buildDecoration(String label, IconData icon) =>
      InputDecoration(
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
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.5, 0.5],
                  colors: [AppColors.primaryTeal, Colors.white],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLarge,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay'
                        ),
                      ),
                      const SizedBox(height: 80),
                      Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSizes.borderRadiusLarge,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.paddingLarge),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomTextField(
                                controller: nameController,
                                hintText: "Name",
                                decoration: _buildDecoration(
                                  "Name",
                                  Icons.person,
                                ),
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                controller: emailController,
                                hintText: "Email",
                                decoration: _buildDecoration(
                                  "Email",
                                  Icons.email,
                                ),
                              ),
                              const SizedBox(height: 15),

                              ValueListenableBuilder<bool>(
                                valueListenable: isPasswordVisible,
                                builder: (context, isVisible, _) =>
                                    CustomTextField(
                                      controller: passwordController,
                                      hintText: "Password",
                                      isPassword: !isVisible,
                                      decoration:
                                          _buildDecoration(
                                            "Password",
                                            Icons.lock,
                                          ).copyWith(
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                isVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: AppColors.primaryTeal,
                                              ),
                                              onPressed: () =>
                                                  isPasswordVisible.value =
                                                      !isPasswordVisible.value,
                                            ),
                                          ),
                                    ),
                              ),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return ForgetPasswordScreen();
                                    }));
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: AppColors.primaryTeal,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),

                              Button(
                                text: "LOGIN",
                                color: AppColors.primaryTeal,
                                colorText: Colors.white,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Column(
            children: [
              const Divider(
                color: AppColors.primaryTeal,
                thickness: 1.5,
                height: 0,
              ),
              Container(
                color: Colors.white,
                width: double.infinity,
                child: TextButton(
                  onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return SignUpScreen();
                  }));},
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: AppColors.primaryTeal, fontSize: 16),
                        ),
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
