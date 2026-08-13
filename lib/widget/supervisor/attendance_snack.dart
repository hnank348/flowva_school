import 'package:flutter/material.dart';

void showAttendanceSnack(BuildContext context, String msg, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Row(children: [
      Icon(
        color == const Color(0xFF0F766E)
            ? Icons.check_circle_rounded
            : Icons.error_outline_rounded,
        color: Colors.white,
        size: 18,
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(msg,
            style: const TextStyle(fontFamily: 'Cairo', fontSize: 13)),
      ),
    ]),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.all(16),
    duration: const Duration(seconds: 3),
  ));
}