import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  void _triggerFetchSchedule(
      BuildContext context,
      int sectionId,
      String sectionName,
      int semesterId,
      ) {
    context.read<ScheduleCubit>().fetchWeeklySchedule(
      sectionId,
      sectionName,
      semester: semesterId,
    );
    context.read<SubjectsCubit>().fetchSubjects();
    context.read<TeachersCubit>().fetchTeachers();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        return Directionality(
          textDirection: localeState.textDirection, // 🌍 تطبيق التوجه الصحيح بناءً على حالة الكيوبيت المشترك للغات
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
                                _triggerFetchSchedule(
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
                                    child: Text(
                                      classState.message,
                                      style: TextStyle(fontFamily: 'Cairo', color: colorScheme.error, fontSize: 12),
                                    ),
                                  );
                                } else if (classState is ClassesLoaded) {
                                  return ScheduleHeaderWidget(
                                    classState: classState,
                                    classesCubit: context.read<ClassesCubit>(),
                                    onSectionChanged: (newSection) {
                                      context.read<ClassesCubit>().selectSection(newSection);

                                      _triggerFetchSchedule(
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
                                        style: TextStyle(fontFamily: 'Cairo', color: colorScheme.error),
                                      ),
                                    );
                                  }

                                  // ✨ تمرير الـ Key واللغة لضمان التحديث اللحظي للجدول بالكامل
                                  return ScheduleTableWidget(
                                    key: ValueKey('${activeSectionId}_${currentSemesterId}_${localeState.currentLanguage}'),
                                    sessions: activeSessions,
                                    sectionId: activeSectionId,
                                    className: activeClassName,
                                    semesterId: currentSemesterId,
                                    currentLanguage: localeState.currentLanguage,
                                  );
                                },
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
        );
      },
    );
  }
}