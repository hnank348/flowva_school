import 'package:flutter/material.dart';
import '../app_theme.dart';

class FieldStyles {
  static InputDecoration authInputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 13),
      prefixIcon: Icon(icon, color: AppColors.primaryTeal, size: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),

      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}