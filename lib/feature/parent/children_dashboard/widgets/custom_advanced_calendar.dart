import 'package:flutter/material.dart';
import '../../../../app_theme.dart';
import '../data/mock_attendance_data.dart';

class CustomAdvancedCalendar extends StatefulWidget {
  final Function(int month, int year) onMonthChanged;

  const CustomAdvancedCalendar({super.key, required this.onMonthChanged});

  @override
  State<CustomAdvancedCalendar> createState() => _CustomAdvancedCalendarState();
}

class _CustomAdvancedCalendarState extends State<CustomAdvancedCalendar> {
  int currentMonth = 6;
  int currentYear = 2026;
  final List<String> weekDays = ['أحد', 'إثنين', 'ثلاثاء', 'أربعاء', 'خميس'];

  List<DateTime> _generateBusinessDays() {
    List<DateTime> days = [];
    DateTime firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
    DateTime lastDayOfMonth = DateTime(currentYear, currentMonth + 1, 0);

    for (int i = 0; i < lastDayOfMonth.day; i++) {
      DateTime day = firstDayOfMonth.add(Duration(days: i));
      if (day.weekday != DateTime.friday && day.weekday != DateTime.saturday) {
        days.add(day);
      }
    }
    return days;
  }

  void _nextMonth() {
    setState(() {
      if (currentMonth == 12) {
        currentMonth = 1;
        currentYear++;
      } else {
        currentMonth++;
      }
      widget.onMonthChanged(currentMonth, currentYear);
    });
  }

  void _previousMonth() {
    setState(() {
      if (currentMonth == 1) {
        currentMonth = 12;
        currentYear--;
      } else {
        currentMonth--;
      }
      widget.onMonthChanged(currentMonth, currentYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final businessDays = _generateBusinessDays();

    final List<String> arabicMonths = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        border: Border.all(
          color: isDark ? AppColors.darkOutlineColor : AppColors.outlineColor, 
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: isDark ? Colors.white : AppColors.primaryText),
                onPressed: _previousMonth,
              ),
              Text(
                '${arabicMonths[currentMonth - 1]} $currentYear',
                style: TextStyle(
                  fontSize: AppSizes.fontSizeSubtitle - 2.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: isDark ? Colors.white : AppColors.primaryText,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: isDark ? Colors.white : AppColors.primaryText),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingMedium),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: AppSizes.fontSizeLabel ,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSizes.paddingSmall),
          Divider(color: isDark ? AppColors.darkOutlineColor : AppColors.outlineColor, height: 0.5),
          const SizedBox(height: AppSizes.paddingSmall),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: businessDays.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 7,
              childAspectRatio: 1.3,
            ),
            itemBuilder: (context, index) {
              final dayDate = businessDays[index];
              final int dayNumber = dayDate.day;

              final bool isSelected = dayNumber == 28 && currentMonth == 6;

              final dayLogs = MockAttendanceData.attendanceLogs.where((log) =>
                  log.day == dayNumber && log.month == currentMonth && log.year == currentYear).toList();

              List<Color> indicators = [];
              for (var log in dayLogs) {
                indicators.add(AppColors.getAttendanceStatusColor(context, log.status));
              }

              return Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? (isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal) 
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppSizes.borderRadiusSmall - 2.0),
                      ),
                      child: Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontSize: AppSizes.fontSizeLabel - 1.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: isSelected 
                              ? Colors.white 
                              : (isDark ? Colors.white : AppColors.primaryText),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicators.map((color) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      );
                    }).toList(),
                  )
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
