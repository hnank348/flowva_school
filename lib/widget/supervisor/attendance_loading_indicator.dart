import 'package:flutter/material.dart';

class AttendanceLoadingIndicator extends StatelessWidget {
  const AttendanceLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: CircularProgressIndicator(color: cs.primary, strokeWidth: 2.5),
    );
  }
}