import 'package:flutter/material.dart';
import 'package:flowva_school/models/supervisor/teacher_attendance_model.dart';
import 'package:flowva_school/models/supervisor/teacher_attendance_record_model.dart';
import 'package:flowva_school/cubit/supervisor/submit_teacher/teacher_attendance_state.dart';
import '../../../../widget/supervisor/attendance_grid.dart';
import '../../../../widget/supervisor/attendance_types.dart';
import 'teacher_attendance_card.dart';
import 'teacher_attendance_record_card.dart';

class TeachersAttendanceGrid extends StatelessWidget {
  final List<TeacherModel>? teachers;
  final Map<int, TeacherAttendanceStatus>? attendanceMap;
  final Map<int, String?>? noteMap;
  final List<TeacherAttendanceRecord>? records;
  final Map<int, TeacherAttendanceStatus>? editMap;
  final bool isTablet;
  final bool isViewMode;

  const TeachersAttendanceGrid.record({
    super.key,
    required List<TeacherModel> this.teachers,
    required Map<int, TeacherAttendanceStatus> this.attendanceMap,
    this.noteMap,
    required this.isTablet,
  })  : records = null,
        editMap = null,
        isViewMode = false;

  const TeachersAttendanceGrid.view({
    super.key,
    required List<TeacherAttendanceRecord> this.records,
    required Map<int, TeacherAttendanceStatus> this.editMap,
    required this.isTablet,
  })  : teachers = null,
        attendanceMap = null,
        noteMap = null,
        isViewMode = true;

  static const _filters = [
    AttendanceFilterConfig<TeacherAttendanceStatus>(
        labelKey: 'filter_all', color: Color(0xFF64748B)),
    AttendanceFilterConfig<TeacherAttendanceStatus>(
        labelKey: 'attendance_active',
        color: Color(0xFF0F766E),
        status: TeacherAttendanceStatus.active),
    AttendanceFilterConfig<TeacherAttendanceStatus>(
        labelKey: 'attendance_inactive',
        color: Color(0xFFDC2626),
        status: TeacherAttendanceStatus.inactive),
    AttendanceFilterConfig<TeacherAttendanceStatus>(
        labelKey: 'attendance_vacation',
        color: Color(0xFFD97706),
        status: TeacherAttendanceStatus.vacation),
    AttendanceFilterConfig<TeacherAttendanceStatus>(
        labelKey: 'attendance_transferred',
        color: Color(0xFF7C3AED),
        status: TeacherAttendanceStatus.transferred),
  ];

  TeacherAttendanceStatus _recordToStatus(TeacherAttendanceRecord r) {
    switch (r.statusId) {
      case 2: return TeacherAttendanceStatus.inactive;
      case 3: return TeacherAttendanceStatus.vacation;
      case 4: return TeacherAttendanceStatus.transferred;
      default: return TeacherAttendanceStatus.active;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isViewMode) {
      return AttendanceGrid<TeacherAttendanceRecord, TeacherAttendanceStatus>(
        items: records!,
        statusOf: (r) => editMap![r.id] ?? _recordToStatus(r),
        filters: _filters,
        isTablet: isTablet,
        mainAxisExtent: 145,
        emptyTextKey: 'filter_empty_teachers',
        itemBuilder: (context, record, status) => TeacherAttendanceRecordCard(
          record: record,
        ),
      );
    }

    return AttendanceGrid<TeacherModel, TeacherAttendanceStatus>(
      items: teachers!,
      statusOf: (t) => attendanceMap![t.id] ?? TeacherAttendanceStatus.active,
      filters: _filters,
      isTablet: isTablet,
      mainAxisExtent: 138,
      emptyTextKey: 'filter_empty_teachers',
      itemBuilder: (context, teacher, status) => TeacherAttendanceCard(
        teacher: teacher,
        currentStatus: status,
        note: noteMap?[teacher.id],
      ),
    );
  }
}