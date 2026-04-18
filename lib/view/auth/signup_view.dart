import 'package:flowva_school/view/auth/otp_view.dart';
import 'package:flowva_school/widget/button.dart';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../../widget/custom_text_field.dart';
import 'login/login_view.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  // المتحكمات
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController(text: 'Boy');
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
  final ValueNotifier<String> genderNotifier = ValueNotifier<String>('Boy');

  InputDecoration _buildDecoration(String label, IconData icon) =>
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
    //  resizeToAvoidBottomInset: false,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingLarge,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.primaryTeal,
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PlayfairDisplay'
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: Card(
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.borderRadiusLarge,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                              AppSizes.paddingLarge,
                            ),
                            child: Scrollbar(
                             // thumbVisibility: true,
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  CustomTextField(
                                    controller: firstNameController,
                                    hintText: "First Name",
                                    decoration: _buildDecoration(
                                      "First Name",
                                      Icons.person,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                    controller: lastNameController,
                                    hintText: "Last Name",
                                    decoration: _buildDecoration(
                                      "Last Name",
                                      Icons.person_outline,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                    controller: phoneController,
                                    hintText: "Phone",
                                    keyboardType: TextInputType.phone,
                                    decoration: _buildDecoration(
                                      "Phone",
                                      Icons.phone,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextField(
                                    controller: emailController,
                                    hintText: "Email",
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: _buildDecoration(
                                      "Email",
                                      Icons.email,
                                    ),
                                  ),
                                  const SizedBox(height: 15),

                                  ValueListenableBuilder<String>(
                                    valueListenable: genderNotifier,
                                    builder: (context, selectedGender, _) =>
                                        DropdownButtonFormField<String>(
                                          initialValue: selectedGender,
                                          decoration: _buildDecoration(
                                            "Gender",
                                            Icons.wc,
                                          ),
                                          items: ['Boy', 'Girl']
                                              .map(
                                                (g) => DropdownMenuItem(
                                                  value: g,
                                                  child: Text(g),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (val) {
                                            genderNotifier.value = val!;
                                            genderController.text = val;
                                          },
                                        ),
                                  ),
                                  const SizedBox(height: 15),

                                  CustomTextField(
                                    controller: dobController,
                                    hintText: "Date of Birth",
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? picked = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                        builder: (context, child) => Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                                  primary:
                                                      AppColors.primaryTeal,
                                                ),
                                          ),
                                          child: child!,
                                        ),
                                      );
                                      if (picked != null) {
                                        dobController.text =
                                            "${picked.day}/${picked.month}/${picked.year}";
                                      }
                                    },
                                    decoration: _buildDecoration(
                                      "Date of Birth",
                                      Icons.calendar_today,
                                    ),
                                  ),
                                  const SizedBox(height: 15),

                                  ValueListenableBuilder<String>(
                                    valueListenable: userTypeNotifier,
                                    builder: (context, selectedType, _) =>
                                        DropdownButtonFormField<String>(
                                          initialValue: selectedType,
                                          decoration: _buildDecoration(
                                            "User Type",
                                            Icons.badge,
                                          ),
                                          items:
                                              ['Parent', 'Student', 'Teacher']
                                                  .map(
                                                    (t) => DropdownMenuItem(
                                                      value: t,
                                                      child: Text(t),
                                                    ),
                                                  )
                                                  .toList(),
                                          onChanged: (val) {
                                            userTypeNotifier.value = val!;
                                            userTypeController.text = val;
                                          },
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
                                                    color:
                                                        AppColors.primaryTeal,
                                                  ),
                                                  onPressed: () =>
                                                      isPasswordVisible.value =
                                                          !isPasswordVisible
                                                              .value,
                                                ),
                                              ),
                                        ),
                                  ),
                                  const SizedBox(height: 15),

                                  ValueListenableBuilder<bool>(
                                    valueListenable: isConfirmPasswordVisible,
                                    builder: (context, isVisible, _) =>
                                        CustomTextField(
                                          controller: confirmPasswordController,
                                          hintText: "Confirm Password",
                                          isPassword: !isVisible,
                                          decoration:
                                              _buildDecoration(
                                                "Confirm Password",
                                                Icons.lock_outline,
                                              ).copyWith(
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    isVisible
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color:
                                                        AppColors.primaryTeal,
                                                  ),
                                                  onPressed: () =>
                                                      isConfirmPasswordVisible
                                                              .value =
                                                          !isConfirmPasswordVisible
                                                              .value,
                                                ),
                                              ),
                                        ),
                                  ),
                                  const SizedBox(height: 30),
                                  Button(
                                    text: "CREATE",
                                    color: Colors.white,
                                    colorText: AppColors.primaryTeal,
                                    colorOutline: AppColors.primaryTeal,
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return OtpScreen();
                                    }));},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                const Divider(
                  color: Colors.white,
                  thickness: 1,
                  height: 0,
                ),
                Container(
                  color: AppColors.primaryTeal,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                      return LoginScreen();
                    }));},
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          TextSpan(
                            text: "Log in",
                            style: TextStyle(
                              color: Colors.white,
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
      ),
    );
  }
}
