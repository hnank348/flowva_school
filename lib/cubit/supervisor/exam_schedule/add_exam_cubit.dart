import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowva_school/services/supervisor/exam_service.dart';
import '../../../models/supervisor/add_exam_request_model.dart';
import '../../../models/supervisor/exam_type_option.dart';
import 'add_exam_state.dart';

class AddExamCubit extends Cubit<AddExamState> {
  final ExamService _service;

  AddExamCubit(this._service) : super(const AddExamInitial());

  void updateTextData({
    String? nameEn,
    String? nameAr,
    String? room,
    String? totalMarks,
    String? passMarks,
    String? instructions,
  }) {
    emit(AddExamInitial(
      examType: state.examType,
      subjectId: state.subjectId,
      teacherId: state.teacherId,
      examDate: state.examDate,
      startTime: state.startTime,
      endTime: state.endTime,
      nameEn: nameEn ?? state.nameEn,
      nameAr: nameAr ?? state.nameAr,
      room: room ?? state.room,
      totalMarks: totalMarks ?? state.totalMarks,
      passMarks: passMarks ?? state.passMarks,
      instructions: instructions ?? state.instructions,
    ));
  }

  void setExamType(ExamTypeOption? type) => emit(_copy(examType: type));
  void setSubjectId(int? id) => emit(_copy(subjectId: id));
  void setTeacherId(int? id) => emit(_copy(teacherId: id));
  void setExamDate(DateTime? date) => emit(_copy(examDate: date));
  void setStartTime(TimeOfDay? time) => emit(_copy(startTime: time));
  void setEndTime(TimeOfDay? time) => emit(_copy(endTime: time));

  AddExamInitial _copy({
    ExamTypeOption? examType,
    int? subjectId,
    int? teacherId,
    DateTime? examDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return AddExamInitial(
      examType: examType ?? state.examType,
      subjectId: subjectId ?? state.subjectId,
      teacherId: teacherId ?? state.teacherId,
      examDate: examDate ?? state.examDate,
      startTime: startTime ?? state.startTime,
      endTime: endTime ?? state.endTime,
      nameEn: state.nameEn,
      nameAr: state.nameAr,
      room: state.room,
      totalMarks: state.totalMarks,
      passMarks: state.passMarks,
      instructions: state.instructions,
    );
  }

  Future<void> submit({
    required AddExamRequest request,
    required String Function(String key) tr,
  }) async {
    emit(AddExamLoading(
      examType: state.examType,
      subjectId: state.subjectId,
      teacherId: state.teacherId,
      examDate: state.examDate,
      startTime: state.startTime,
      endTime: state.endTime,
      nameEn: state.nameEn,
      nameAr: state.nameAr,
      room: state.room,
      totalMarks: state.totalMarks,
      passMarks: state.passMarks,
      instructions: state.instructions,
    ));

    try {
      await _service.createExam(
        request: request,
        tr: tr,
      );
      emit(const AddExamSuccess());
    } catch (e) {
      emit(AddExamError(
        e.toString().replaceAll("Exception: ", ""),
        examType: state.examType,
        subjectId: state.subjectId,
        teacherId: state.teacherId,
        examDate: state.examDate,
        startTime: state.startTime,
        endTime: state.endTime,
        nameEn: state.nameEn,
        nameAr: state.nameAr,
        room: state.room,
        totalMarks: state.totalMarks,
        passMarks: state.passMarks,
        instructions: state.instructions,
      ));
    }
  }

  void reset() => emit(const AddExamInitial());
}