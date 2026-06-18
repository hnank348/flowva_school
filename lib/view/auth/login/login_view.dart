import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app_theme.dart';
import '../../../cubit/login/login_cubit.dart';
import '../../../cubit/login/login_state.dart';
import '../../../widget/button.dart';
import '../../../widget/custom_text_field.dart';
import '../../../widget/password_field.dart';
import '../../../widget/field_styles.dart';

import '../../../app_providers.dart';
import '../../supervisor/main_layout_view.dart';
import '../../teacher/teacher_dashboard.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);

  void _notify(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
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
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            _notify(context, state.message);

            final String token = state.data['token'] ?? '';
            final String userType = state.data['user']?['user_type'] ?? state.data['user_type'] ?? 'admin';

            Widget nextView;
            if (userType == "admin") {
              nextView = MainLayoutView(userToken: token);
            } else {
              nextView = const TeacherDashboard();
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: AppProviders.getProviders(token),
                  child: nextView,
                ),
              ),
            );
          }
          if (state is LoginError) {
            _notify(context, state.errorMessage, isError: true);
          }
        },
        child: Stack(
          children: [
            Container(
              height: screenHeight * 0.45,
              width: double.infinity,
              color: AppColors.primaryTeal,
            ),
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
                                CustomTextField(
                                  controller: _emailController,
                                  hintText: "Email",
                                  decoration: FieldStyles.authInputDecoration(
                                    label: "Email",
                                    icon: Icons.email_outlined,
                                  ),
                                ),
                                const SizedBox(height: 20),
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
                                const SizedBox(height: 20),

                                BlocBuilder<LoginCubit, LoginState>(
                                  builder: (context, state) {
                                    if (state is LoginLoading) {
                                      return const CircularProgressIndicator(
                                        color: AppColors.primaryTeal,
                                      );
                                    }
                                    return Button(
                                      text: "Login",
                                      color: AppColors.primaryTeal,
                                      colorText: Colors.white,
                                      onPressed: () {
                                        context.read<LoginCubit>().loginUser(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                      },
                                    );
                                  },
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
          ],
        ),
      ),
    );
  }
}