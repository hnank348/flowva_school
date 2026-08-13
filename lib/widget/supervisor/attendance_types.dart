import 'package:flutter/material.dart';

typedef AttendanceStatusStyle = ({
Color accent,
Color bg,
Color bgDark,
IconData icon,
});

typedef AttendanceSummaryItem = ({
String label,
int count,
Color color,
Color bg,
});

class AttendanceOption<T> {
  final String label;
  final T status;
  final Color accent;
  final Color bg;

  const AttendanceOption({
    required this.label,
    required this.status,
    required this.accent,
    required this.bg,
  });
}

/// ✅ ما عاد في حاجة لـ TFilter منفصل
/// status == null يعني "الكل"، وإلا يعني فلترة على حالة محددة
class AttendanceFilterConfig<TStatus> {
  final String labelKey;
  final Color color;
  final TStatus? status;

  const AttendanceFilterConfig({
    required this.labelKey,
    required this.color,
    this.status,
  });
}