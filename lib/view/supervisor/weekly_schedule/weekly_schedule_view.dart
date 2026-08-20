import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_localizations.dart';
import '../../../cubit/supervisor/classes/classes_cubit.dart';
import '../../../cubit/supervisor/schedule/schedule_cubit.dart';
import '../../../cubit/supervisor/subjects/subjects_cubit.dart';
import '../../../cubit/supervisor/teachers/teachers_cubit.dart';
import '../../../cubit/supervisor/classes/classes_state.dart';
import '../../../cubit/supervisor/schedule/schedule_state.dart';
import '../../../cubit/current_semester/current_semester_cubit.dart';
import '../../../cubit/current_semester/current_semester_state.dart';
import '../../../cubit/locale/locale_cubit.dart';
import '../../../cubit/locale/locale_state.dart';
import '../../../models/supervisor/schedule_session_model.dart';

import 'schedule_header_widget.dart';
import 'schedule_table_widget.dart';

class WeeklyScheduleView extends StatelessWidget {
  const WeeklyScheduleView({super.key});

  void _fetchScheduleOnly(
      BuildContext context,
      int sectionId,
      String sectionName,
      int semesterId,
      ) {
    context.read<ScheduleCubit>().fetchWeeklySchedule(
      sectionId,
      sectionName,
      semester: semesterId,
      tr: context.tr,
    );
  }

  Future<void> _refreshAll(
      BuildContext context,
      int? sectionId,
      String? sectionName,
      int semesterId,
      ) async {
    context.read<SubjectsCubit>().fetchSubjects(tr: context.tr);
    context.read<TeachersCubit>().fetchTeachers(tr: context.tr);

    if (sectionId != null && sectionName != null) {
      _fetchScheduleOnly(context, sectionId, sectionName, semesterId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<SubjectsCubit>().fetchSubjects(tr: context.tr);
        context.read<TeachersCubit>().fetchTeachers(tr: context.tr);
      }
    });

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return BlocListener<ScheduleCubit, ScheduleState>(
          listener: (context, state) {
            if (state is ScheduleActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  state.successMessage,
                  style: const TextStyle(fontFamily: 'Cairo'),
                ),
                backgroundColor: const Color(0xFF0F766E),
                behavior: SnackBarBehavior.floating,
              ));
            }
          },
          child: Directionality(
            textDirection: localeState.textDirection,
            child: Container(
              color: colorScheme.surface,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: BlocBuilder<ClassesCubit, ClassesState>(
                builder: (context, classState) {
                  return BlocBuilder<ScheduleCubit, ScheduleState>(
                    builder: (context, scheduleState) {
                      return BlocBuilder<CurrentSemesterCubit, CurrentSemesterState>(
                        builder: (context, semesterState) {
                          int currentSemesterId = 1;
                          if (semesterState is CurrentSemesterSuccess) {
                            currentSemesterId = semesterState.currentSemester.id;
                          }

                          final scheduleCubit = context.read<ScheduleCubit>();
                          if (classState is ClassesLoaded && classState.selectedSection != null) {
                            if (scheduleCubit.state is ScheduleInitial) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (context.mounted) {
                                  _fetchScheduleOnly(
                                    context,
                                    classState.selectedSection!.id,
                                    classState.selectedSection!.name,
                                    currentSemesterId,
                                  );
                                }
                              });
                            }
                          }

                          List<ScheduleSessionModel> activeSessions = [];
                          if (scheduleState is ScheduleLoaded) {
                            activeSessions = scheduleState.sessions;
                          }

                          int activeSectionId = 0;
                          String activeClassName = "";
                          if (classState is ClassesLoaded && classState.selectedSection != null) {
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
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            classState.message,
                                            style: TextStyle(
                                              fontFamily: 'Cairo',
                                              color: colorScheme.error,
                                              fontSize: 12,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.refresh, size: 18),
                                            color: colorScheme.primary,
                                            onPressed: () {
                                              context.read<ClassesCubit>().fetchClassesAndSections(tr: context.tr);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (classState is ClassesLoaded) {
                                    return ScheduleHeaderWidget(
                                      classState: classState,
                                      onSectionChanged: (newSection) {
                                        context.read<ClassesCubit>().selectSection(newSection);

                                        _fetchScheduleOnly(
                                          context,
                                          newSection.id,
                                          newSection.name,
                                          currentSemesterId,
                                        );
                                      },
                                      onExportPdfPressed: () {},
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: RefreshIndicator(
                                  color: colorScheme.primary,
                                  onRefresh: () => _refreshAll(
                                    context,
                                    activeSectionId != 0 ? activeSectionId : null,
                                    activeClassName.isNotEmpty ? activeClassName : null,
                                    currentSemesterId,
                                  ),
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
                                          child: SingleChildScrollView(
                                            physics: const AlwaysScrollableScrollPhysics(),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.error_outline,
                                                  color: colorScheme.error,
                                                  size: 40,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  scheduleState.message,
                                                  style: TextStyle(
                                                    fontFamily: 'Cairo',
                                                    color: colorScheme.error,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 12),
                                                ElevatedButton.icon(
                                                  onPressed: () {
                                                    if (activeSectionId != 0) {
                                                      _fetchScheduleOnly(
                                                        context,
                                                        activeSectionId,
                                                        activeClassName,
                                                        currentSemesterId,
                                                      );
                                                    }
                                                  },
                                                  icon: const Icon(Icons.refresh, size: 18),
                                                  label: const Text(
                                                    'إعادة المحاولة',
                                                    style: TextStyle(fontFamily: 'Cairo'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }

                                      return ScheduleTableWidget(
                                        key: ValueKey(
                                          '${activeSectionId}_${currentSemesterId}_${localeState.currentLanguage}',
                                        ),
                                        sessions: activeSessions,
                                        sectionId: activeSectionId,
                                        className: activeClassName,
                                        semesterId: currentSemesterId,
                                        currentLanguage: localeState.currentLanguage,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}