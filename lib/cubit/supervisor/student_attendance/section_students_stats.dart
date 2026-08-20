import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/supervisor/section_students_stats_model.dart';
import '../../../services/supervisor/student_attendance_service.dart';

abstract class SectionStudentsStatsState {
  const SectionStudentsStatsState();
}

class SectionStudentsStatsInitial extends SectionStudentsStatsState {
  const SectionStudentsStatsInitial();
}

class SectionStudentsStatsLoading extends SectionStudentsStatsState {
  const SectionStudentsStatsLoading();
}

class SectionStudentsStatsLoaded extends SectionStudentsStatsState {
  final SectionStudentsStatsModel stats;
  const SectionStudentsStatsLoaded(this.stats);
}

class SectionStudentsStatsError extends SectionStudentsStatsState {
  final String message;
  const SectionStudentsStatsError(this.message);
}

