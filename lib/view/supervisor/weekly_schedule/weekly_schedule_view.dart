import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/supervisor/classes/classes_cubit.dart';
import '../../../cubit/supervisor/schedule/schedule_cubit.dart';
import '../../../cubit/supervisor/subjects/subjects_cubit.dart';
import '../../../cubit/supervisor/teachers/teachers_cubit.dart';
import '../../../cubit/supervisor/classes/classes_state.dart';
import '../../../cubit/supervisor/schedule/schedule_state.dart';
import '../../../models/supervisor/schedule_session_model.dart';

import 'schedule_header_widget.dart';
import 'schedule_table_widget.dart';

class WeeklyScheduleView extends StatelessWidget {
  const WeeklyScheduleView({super.key});

  void _triggerFetchSchedule(
    BuildContext context,
    int sectionId,
    String sectionName,
    int semester,
  ) {
    context.read<ScheduleCubit>().fetchWeeklySchedule(
      sectionId,
      sectionName,
      semester: semester,
    );
    context.read<SubjectsCubit>().fetchSubjects();
    context.read<TeachersCubit>().fetchTeachers();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: BlocBuilder<ClassesCubit, ClassesState>(
        builder: (context, classState) {
          return BlocBuilder<ScheduleCubit, ScheduleState>(
            builder: (context, scheduleState) {
              int currentSemester = 1;
              List<ScheduleSessionModel> activeSessions = [];

              if (scheduleState is ScheduleLoaded) {
                currentSemester = scheduleState.selectedSemester;
                activeSessions = scheduleState.sessions;
              }

              int activeSectionId = 0;
              String activeClassName = "";
              if (classState is ClassesLoaded &&
                  classState.selectedSection != null) {
                activeSectionId = classState.selectedSection!.id;
                activeClassName = classState.selectedSection!.name;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  Builder(
                    builder: (context) {
                      if (classState is ClassesLoading) {
                        return SizedBox(
                          height: 38,
                          child: Center(
                            child: LinearProgressIndicator(
                              color: colorScheme.primary,
                            ),
                          ),
                        );
                      } else if (classState is ClassesError) {
                        return Center(
                          child: Text(
                            classState.message,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        );
                      } else if (classState is ClassesLoaded) {
                        return ScheduleHeaderWidget(
                          classState: classState,
                          classesCubit: context.read<ClassesCubit>(),
                          selectedSemester: currentSemester,
                          onSectionChanged: (newSection) {
                            _triggerFetchSchedule(
                              context,
                              newSection.id,
                              newSection.name,
                              currentSemester,
                            );
                          },
                          onSemesterChanged: (newSemester) {
                            if (classState.selectedSection != null) {
                              _triggerFetchSchedule(
                                context,
                                classState.selectedSection!.id,
                                classState.selectedSection!.name,
                                newSemester,
                              );
                            }
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (scheduleState is ScheduleLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                          );
                        } else if (scheduleState is ScheduleError) {
                          return Center(
                            child: Text(
                              scheduleState.message,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: colorScheme.error,
                              ),
                            ),
                          );
                        }

                        return ScheduleTableWidget(
                          key: ValueKey(
                            '${activeSectionId}_${currentSemester}_${activeSessions.length}',
                          ),
                          sessions: activeSessions,
                          sectionId: activeSectionId,
                          className: activeClassName,
                          semesterId: currentSemester,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
