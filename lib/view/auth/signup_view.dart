import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'waiting_view.dart';
import '../../widget/date.dart';
import '../../widget/footer.dart';
import '../../widget/custom_text_field.dart';
import '../../widget/button.dart';
import '../../widget/password_field.dart';
import '../../widget/field_styles.dart';
import 'login/login_view.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController(text: 'Male');
  final dobController = TextEditingController();
  final userTypeController = TextEditingController(text: 'Student');
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ValueNotifier<bool> isPasswordVisible = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isConfirmPasswordVisible = ValueNotifier<bool>(
    false,
  );
  final ValueNotifier<String> userTypeNotifier = ValueNotifier<String>(
    'Student',
  );
  final ValueNotifier<String> genderNotifier = ValueNotifier<String>('Male');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 0.5],
            colors: [Colors.white, AppColors.primaryTeal],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.primaryTeal,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay',
                        ),
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: Card(
                          elevation: 15,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ListView(
                              physics: const BouncingScrollPhysics(),
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller: firstNameController,
                                        hintText: "First Name",
                                        decoration:
                                            FieldStyles.authInputDecoration(
                                              label: "First Name",
                                              icon: Icons.person,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: CustomTextField(
                                        controller: lastNameController,
                                        hintText: "Last Name",
                                        decoration:
                                            FieldStyles.authInputDecoration(
                                              label: "Last Name",
                                              icon: Icons.person_outline,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                CustomTextField(
                                  controller: phoneController,
                                  hintText: "Phone",
                                  keyboardType: TextInputType.phone,
                                  decoration: FieldStyles.authInputDecoration(
                                    label: "Phone",
                                    icon: Icons.phone,
                                  ),
                                ),
                                const SizedBox(height: 15),

                                CustomTextField(
                                  controller: emailController,
                                  hintText: "Email",
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: FieldStyles.authInputDecoration(
                                    label: "Email",
                                    icon: Icons.email,
                                  ),
                                ),
                                const SizedBox(height: 15),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ValueListenableBuilder<String>(
                                        valueListenable: genderNotifier,
                                        builder: (context, val, _) =>
                                            DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              initialValue: val,
                                              decoration:
                                                  FieldStyles.authInputDecoration(
                                                    label: "Gender",
                                                    icon: Icons.wc,
                                                  ),
                                              items: ['Male', 'Female']
                                                  .map(
                                                    (e) => DropdownMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (v) {
                                                genderNotifier.value = v!;
                                                genderController.text = v;
                                              },
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ValueListenableBuilder<String>(
                                        valueListenable: userTypeNotifier,
                                        builder: (context, val, _) =>
                                            DropdownButtonFormField<String>(
                                              isExpanded: true,
                                              initialValue: val,
                                              decoration:
                                                  FieldStyles.authInputDecoration(
                                                    label: "User Type",
                                                    icon: Icons.badge,
                                                  ),
                                              items:
                                                  [
                                                        'Parent',
                                                        'Student',
                                                        'Teacher',
                                                      ]
                                                      .map(
                                                        (e) => DropdownMenuItem(
                                                          value: e,
                                                          child: Text(
                                                            e,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 13,
                                                                ),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                              onChanged: (v) {
                                                userTypeNotifier.value = v!;
                                                userTypeController.text = v;
                                              },
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                CustomTextField(
                                  controller: dobController,
                                  hintText: "Date of Birth",
                                  readOnly: true,
                                  onTap: () =>
                                      Date.selectDate(context, dobController),
                                  decoration: FieldStyles.authInputDecoration(
                                    label: "Date of Birth",
                                    icon: Icons.calendar_today,
                                  ),
                                ),
                                const SizedBox(height: 15),

                                PasswordField(
                                  controller: passwordController,
                                  isVisibleNotifier: isPasswordVisible,
                                  label: "Password",
                                  icon: Icons.lock,
                                  decoration: FieldStyles.authInputDecoration(
                                    label: "Password",
                                    icon: Icons.lock,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                PasswordField(
                                  controller: confirmPasswordController,
                                  isVisibleNotifier: isConfirmPasswordVisible,
                                  label: "Confirm Password",
                                  icon: Icons.lock_outline,
                                  decoration: FieldStyles.authInputDecoration(
                                    label: "Confirm Password",
                                    icon: Icons.lock_outline,
                                  ),
                                ),

                                const SizedBox(height: 25),

                                Button(
                                  text: "CREATE",
                                  color: Colors.white,
                                  colorText: AppColors.primaryTeal,
                                  colorOutline: AppColors.primaryTeal,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (c) => const WaitingScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
            Footer(
              leadingText: "Already have an account? ",
              actionText: "Log in",
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const LoginScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
