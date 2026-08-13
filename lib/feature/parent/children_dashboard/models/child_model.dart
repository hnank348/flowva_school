import 'package:flutter/material.dart';
class ChildModel {
  final String id;
  final String name;
  final String grade;
  final String attendanceRate;
  final String gpa;
  final int totalMaterials;
  final String currentTerm;
  final String imageUrl;
  final bool isActive;

  const ChildModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.attendanceRate,
    required this.gpa,
    required this.totalMaterials,
    required this.currentTerm,
    required this.imageUrl,
    required this.isActive,
  });
}
