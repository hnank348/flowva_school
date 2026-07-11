import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/cubit/supervisor/student/student_attendance_cubit.dart';

class AttendanceStatusChip extends StatelessWidget {
  final String studentId;
  final String label;
  final Color activeColor;
  final Color activeBg;
  final StudentAttendanceStatus buttonStatus;
  final StudentAttendanceStatus currentStatus;

  const AttendanceStatusChip({
    super.key,
    required this.studentId,
    required this.label,
    required this.activeColor,
    required this.activeBg,
    required this.buttonStatus,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentStatus == buttonStatus;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: () => context
            .read<StudentAttendanceCubit>()
            .updateAttendance(studentId, buttonStatus),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? activeBg.withOpacity(isDark ? 0.25 : 1.0)
                : (isDark
                ? colorScheme.surfaceContainer
                : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? activeColor.withOpacity(isDark ? 0.7 : 1.0)
                  : colorScheme.outlineVariant.withOpacity(0.4),
              width: isSelected ? 1.2 : 0.8,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? activeColor
                  : colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}