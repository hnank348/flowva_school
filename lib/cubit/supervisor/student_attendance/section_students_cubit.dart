import 'package:flowva_school/cubit/supervisor/student_attendance/section_students_stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/supervisor/student_attendance_service.dart';

class SectionStudentsStatsCubit extends Cubit<SectionStudentsStatsState> {
  final StudentAttendanceService _service;

  SectionStudentsStatsCubit(this._service)
      : super(const SectionStudentsStatsInitial());

  Future<void> fetchStats({
    required int sectionId,
    required String Function(String key) tr,
  }) async {
    emit(const SectionStudentsStatsLoading());
    try {
      final stats = await _service.getSectionStudentsStats(
        sectionId: sectionId,
        tr: tr,
      );
      emit(SectionStudentsStatsLoaded(stats));
    } catch (e) {
      emit(SectionStudentsStatsError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}