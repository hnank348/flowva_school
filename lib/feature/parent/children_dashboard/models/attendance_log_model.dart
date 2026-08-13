import 'package:flutter/material.dart';

class AttendanceLogModel {
  final int day;
  final int month;
  final int year;
  final String dayName;
  final String dateStr;
  final String status;
  final String time;
  final Color statusColor;
  final IconData icon;

  const AttendanceLogModel({
    required this.day,
    required this.month,
    required this.year,
    required this.dayName,
    required this.dateStr,
    required this.status,
    required this.time,
    required this.statusColor,
    required this.icon,
  });
}