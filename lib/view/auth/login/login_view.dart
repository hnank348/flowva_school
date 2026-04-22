import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../services/auth/login_services.dart';
import '../../../widget/footer.dart';
import '../../../widget/button.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/password_field.dart';
import '../../../widget/field_styles.dart';

import '../signup_view.dart';
import 'new_password_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);

  final LoginService _loginService = LoginService();
  bool _isLoading = false;

  // منطق تسجيل الدخول
  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _notify("Please fill in all fields", isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final result = await _loginService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (mounted) setState(() => _isLoading = false);

    if (result['success']) {
      _notify(result['message']);
    } else {
      _notify(result['message'], isError: true);
    }
  }

  // أداة عرض التنبيهات
  void _notify(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : AppColors.primaryTeal,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double cardWidth = MediaQuery.of(context).size.width > 600 ? 450 : double.infinity;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. الخلفية العلوية
          Container(
            height: screenHeight * 0.45,
            width: double.infinity,
            color: AppColors.primaryTeal,
          ),

          // 2. المحتوى الأساسي
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlayfairDisplay',
                    ),
                  ),
                  const SizedBox(height: 40),

                  Center(
                    child: SizedBox(
                      width: cardWidth,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // حقل الإيميل باستخدام FieldStyles
                              CustomTextField(
                                controller: _emailController,
                                hintText: "Email",
                                decoration: FieldStyles.authInputDecoration(
                                  label: "Email",
                                  icon: Icons.email_outlined,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // حقل الباسورد باستخدام FieldStyles و PasswordField
                              PasswordField(
                                controller: _passwordController,
                                isVisibleNotifier: _isPasswordVisible,
                                label: "Password",
                                icon: Icons.lock_outline,
                                decoration: FieldStyles.authInputDecoration(
                                  label: "Password",
                                  icon: Icons.lock_outline,
                                ),
                              ),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ForgetPasswordScreen())),
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              _isLoading
                                  ? const CircularProgressIndicator(color: AppColors.primaryTeal)
                                  : Button(
                                text: "Login",
                                color: AppColors.primaryTeal,
                                colorText: Colors.white,
                                onPressed: _handleLogin,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. التذييل (Footer)
          Align(
            alignment: Alignment.bottomCenter,
            child: Footer(
              leadingText: "Don't have an account? ",
              actionText: "Sign Up",
              backgroundColor: Colors.white,
              textColor: AppColors.primaryTeal,
              dividerColor: AppColors.primaryTeal,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SignUpScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}