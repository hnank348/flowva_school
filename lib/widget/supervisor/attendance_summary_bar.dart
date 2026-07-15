import 'package:flutter/material.dart';
import 'attendance_types.dart';

class GenericAttendanceSummaryBar extends StatelessWidget {
  final List<AttendanceSummaryItem> items;

  const GenericAttendanceSummaryBar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: items.map((item) {
        // ✅ لون نص فاتح وواضح بالدارك مود (هون كانت المشكلة عند المعلم)
        final textColor = isDark
            ? Color.lerp(item.color, Colors.white, 0.4)!
            : item.color;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: item.bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: item.color.withOpacity(isDark ? 0.4 : 0.15),
                width: 0.8,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '${item.count}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.label,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}