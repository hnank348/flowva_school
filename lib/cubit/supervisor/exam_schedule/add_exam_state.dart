import 'package:flutter/material.dart';
import '../../../models/supervisor/exam_type_option.dart';

abstract class AddExamState {
  final ExamTypeOption? examType;
  final int? subjectId;
  final int? teacherId;
  final DateTime? examDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String nameEn;
  final String nameAr;
  final String room;
  final String totalMarks;
  final String passMarks;
  final String instructions;

  const AddExamState({
    this.examType,
    this.subjectId,
    this.teacherId,
    this.examDate,
    this.startTime,
    this.endTime,
    this.nameEn = '',
    this.nameAr = '',
    this.room = '',
    this.totalMarks = '100',
    this.passMarks = '50',
    this.instructions = '',
  });
}

class AddExamInitial extends AddExamState {
  const AddExamInitial({
    super.examType,
    super.subjectId,
    super.teacherId,
    super.examDate,
    super.startTime,
    super.endTime,
    super.nameEn,
    super.nameAr,
    super.room,
    super.totalMarks,
    super.passMarks,
    super.instructions,
  });
}

class AddExamLoading extends AddExamState {
  const AddExamLoading({
    super.examType,
    super.subjectId,
    super.teacherId,
    super.examDate,
    super.startTime,
    super.endTime,
    super.nameEn,
    super.nameAr,
    super.room,
    super.totalMarks,
    super.passMarks,
    super.instructions,
  });
}

class AddExamSuccess extends AddExamState {
  const AddExamSuccess();
}

class AddExamError extends AddExamState {
  final String message;

  const AddExamError(
      this.message, {
        super.examType,
        super.subjectId,
        super.teacherId,
        super.examDate,
        super.startTime,
        super.endTime,
        super.nameEn,
        super.nameAr,
        super.room,
        super.totalMarks,
        super.passMarks,
        super.instructions,
      });
}