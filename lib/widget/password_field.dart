import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'custom_text_field.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<bool> isVisibleNotifier;
  final String label;
  final IconData icon;
  final InputDecoration decoration;

  const PasswordField({
    super.key,
    required this.controller,
    required this.isVisibleNotifier,
    required this.label,
    required this.icon,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isVisibleNotifier,
      builder: (context, isVisible, _) => CustomTextField(
        controller: controller,
        hintText: label,
        isPassword: !isVisible,
        decoration: decoration.copyWith(
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: AppColors.primaryTeal,
              size: 20,
            ),
            onPressed: () => isVisibleNotifier.value = !isVisibleNotifier.value,
          ),
        ),
      ),
    );
  }
}