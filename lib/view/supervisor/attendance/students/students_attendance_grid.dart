import 'package:flutter/material.dart';
import 'package:flowva_school/cubit/supervisor/student/student_attendance_cubit.dart';
import 'package:flowva_school/models/supervisor/student_attendance_model.dart';
import 'package:flowva_school/models/supervisor/student_attendance_record_model.dart';
import '../../../../widget/supervisor/attendance_grid.dart';
import '../../../../widget/supervisor/attendance_types.dart';
import 'student_attendance_card.dart';
import 'student_attendance_record_card.dart';

class StudentsAttendanceGrid extends StatelessWidget {
  final List<StudentAttendanceModel>? students;
  final Map<String, StudentAttendanceStatus>? attendanceMap;
  final Map<String, String?>? noteMap;
  final List<StudentAttendanceRecord>? records;
  final Map<int, StudentAttendanceStatus>? editMap;
  final bool isTablet;
  final bool isViewMode;

  const StudentsAttendanceGrid.record({
    super.key,
    required List<StudentAttendanceModel> this.students,
    required Map<String, StudentAttendanceStatus> this.attendanceMap,
    this.noteMap,
    required this.isTablet,
  })  : records = null,
        editMap = null,
        isViewMode = false;

  const StudentsAttendanceGrid.view({
    super.key,
    required List<StudentAttendanceRecord> this.records,
    required Map<int, StudentAttendanceStatus> this.editMap,
    required this.isTablet,
  })  : students = null,
        attendanceMap = null,
        noteMap = null,
        isViewMode = true;

  static final _filters = [
    AttendanceFilterConfig<StudentAttendanceStatus>(
        labelKey: 'filter_all', color: const Color(0xFF64748B)),
    AttendanceFilterConfig<StudentAttendanceStatus>(
        labelKey: 'attendance_present',
        color: const Color(0xFF2DD4BF),
        status: StudentAttendanceStatus.present),
    AttendanceFilterConfig<StudentAttendanceStatus>(
        labelKey: 'attendance_absent',
        color: const Color(0xFFF87171),
        status: StudentAttendanceStatus.absent),
    AttendanceFilterConfig<StudentAttendanceStatus>(
        labelKey: 'attendance_late',
        color: const Color(0xFFFBBF24),
        status: StudentAttendanceStatus.late),
    AttendanceFilterConfig<StudentAttendanceStatus>(
        labelKey: 'attendance_excused',
        color: const Color(0xFFA78BFA),
        status: StudentAttendanceStatus.excused),
  ];

  StudentAttendanceStatus _recordToStatus(StudentAttendanceRecord r) {
    switch (r.statusId) {
      case 2: return StudentAttendanceStatus.absent;
      case 3: return StudentAttendanceStatus.late;
      case 4: return StudentAttendanceStatus.excused;
      default: return StudentAttendanceStatus.present;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isViewMode) {
      return AttendanceGrid<StudentAttendanceRecord, StudentAttendanceStatus>(
        items: records!,
        statusOf: (r) => editMap![r.id] ?? _recordToStatus(r),
        filters: _filters,
        isTablet: isTablet,
        mainAxisExtent: 145,
        emptyTextKey: 'filter_empty_students',
        itemBuilder: (context, record, status) => StudentAttendanceRecordCard(
          record: record,
        ),
      );
    }

    return AttendanceGrid<StudentAttendanceModel, StudentAttendanceStatus>(
      items: students!,
      statusOf: (s) =>
      attendanceMap![s.id.toString()] ?? StudentAttendanceStatus.present,
      filters: _filters,
      isTablet: isTablet,
      mainAxisExtent: 138,
      emptyTextKey: 'filter_empty_students',
      itemBuilder: (context, student, status) => StudentAttendanceCard(
        student: student,
        currentStatus: status,
        note: noteMap?[student.id.toString()],
      ),
    );
  }
}