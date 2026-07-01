import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/supervisor/classes/classes_cubit.dart';
import '../../../cubit/supervisor/schedule/schedule_cubit.dart';
import '../../../cubit/supervisor/subjects/subjects_cubit.dart';
import '../../../cubit/supervisor/teachers/teachers_cubit.dart';
import '../../../cubit/supervisor/classes/classes_state.dart';
import '../../../cubit/supervisor/subjects/subjects_state.dart';
import '../../../cubit/supervisor/teachers/teachers_state.dart';
import '../../../cubit/locale/locale_cubit.dart';
import '../../../cubit/locale/locale_state.dart';
import '../../../models/supervisor/schedule_session_model.dart';
import '../../../app_localizations.dart';

class EditSessionBottomSheet {
  static void show(
      BuildContext context, {
        required int? sessionId,
        required int? currentSubjectId,
        required int? currentTeacherId,
        required String currentSubject,
        required String currentTeacher,
        required String currentRoom,
        required int sectionId,
        required String className,
        required String dayOfWeek,
        required int periodNumber,
        required int semesterId,
      }) {
    final subjectsCubit = BlocProvider.of<SubjectsCubit>(context);
    final teachersCubit = BlocProvider.of<TeachersCubit>(context);
    final scheduleCubit = BlocProvider.of<ScheduleCubit>(context);
    final classesCubit = BlocProvider.of<ClassesCubit>(context);
    final localeCubit = BlocProvider.of<LocaleCubit>(context);

    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (bottomSheetContext) {
        int? selectedSubjectId = currentSubjectId;
        int? selectedTeacherId = currentTeacherId;
        final roomController = TextEditingController(text: currentRoom);

        return MultiBlocProvider(
          providers: [
            BlocProvider<SubjectsCubit>.value(value: subjectsCubit),
            BlocProvider<TeachersCubit>.value(value: teachersCubit),
            BlocProvider<ScheduleCubit>.value(value: scheduleCubit),
            BlocProvider<ClassesCubit>.value(value: classesCubit),
            BlocProvider<LocaleCubit>.value(value: localeCubit),
          ],
          child: BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              final isArabic = localeState.currentLanguage == 'AR';

              return Directionality(
                textDirection: localeState.textDirection,
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 550),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    padding: EdgeInsets.only(
                      top: 16,
                      left: 24,
                      right: 24,
                      bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
                    ),
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setModalState) {
                        return SafeArea(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Center(
                                  child: Container(
                                    width: 45,
                                    height: 4.5,
                                    decoration: BoxDecoration(
                                      color: colorScheme.outlineVariant,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        sessionId == null ? Icons.add_box_rounded : Icons.edit_calendar_rounded,
                                        color: colorScheme.primary,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        sessionId == null
                                            ? '${context.tr('session_add_title')} $periodNumber - ${context.tr('session_semester')} $semesterId'
                                            : '${context.tr('session_edit_title')} $periodNumber - ${context.tr('session_semester')} $semesterId',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Cairo',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // 📚 Dropdown المواد الدراسية (تعريب وإنجليزي حسب اللغة)
                                BlocBuilder<SubjectsCubit, SubjectsState>(
                                  builder: (context, state) {
                                    if (state is SubjectsLoading) return _buildFieldLoading(context);
                                    if (state is SubjectsError) return _buildFieldError(context, state.errorMessage);
                                    if (state is SubjectsSuccess) {
                                      final hasSubject = state.subjects.any((s) => s.id == selectedSubjectId);
                                      if (!hasSubject) {
                                        selectedSubjectId = null;
                                      }

                                      return _buildModernDropdown<int>(
                                        context: context,
                                        value: selectedSubjectId,
                                        hint: context.tr('session_hint_subject'),
                                        icon: Icons.auto_stories_rounded,
                                        activeColor: const Color(0xFF3182CE),
                                        items: state.subjects.map((subject) {
                                          final subjectName = isArabic
                                              ? (subject.nameAr.isNotEmpty ? subject.nameAr : subject.name)
                                              : (subject.name.isNotEmpty ? subject.name : subject.nameAr);

                                          return DropdownMenuItem<int>(
                                            value: subject.id,
                                            child: Text(
                                              subjectName,
                                              style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setModalState(() {
                                            selectedSubjectId = value;
                                          });
                                        },
                                      );
                                    }
                                    return _buildFieldLoading(context);
                                  },
                                ),
                                const SizedBox(height: 16),

                                // 👨‍🏫 Dropdown المعلمون (تعريب وإنجليزي حسب اللغة)
                                BlocBuilder<TeachersCubit, TeachersState>(
                                  builder: (context, state) {
                                    List<DropdownMenuItem<int>> dropdownItems = [];
                                    String hintText = context.tr('session_hint_teacher');

                                    if (state is TeachersSuccess) {
                                      final hasTeacher = state.teachers.any((t) => t.id == selectedTeacherId);
                                      if (!hasTeacher) {
                                        selectedTeacherId = null;
                                      }

                                      dropdownItems = state.teachers.map((teacher) {
                                        final teacherName = isArabic
                                            ? (teacher.fullNameAr.isNotEmpty ? teacher.fullNameAr : teacher.fullName)
                                            : (teacher.fullName.isNotEmpty ? teacher.fullName : teacher.fullNameAr);

                                        return DropdownMenuItem<int>(
                                          value: teacher.id,
                                          child: Text(
                                            teacherName,
                                            style: const TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    } else if (state is TeachersLoading) {
                                      hintText = context.tr('session_loading_teachers');
                                    } else if (state is TeachersError) {
                                      hintText = context.tr('session_error_teachers');
                                    } else if (state is TeachersInitial) {
                                      context.read<TeachersCubit>().fetchTeachers();
                                      hintText = context.tr('session_init_teachers');
                                    }

                                    return _buildModernDropdown<int>(
                                      context: context,
                                      value: selectedTeacherId,
                                      hint: hintText,
                                      icon: Icons.supervisor_account_rounded,
                                      activeColor: const Color(0xFF805AD5),
                                      items: dropdownItems,
                                      onChanged: (value) {
                                        setModalState(() {
                                          selectedTeacherId = value;
                                        });
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),

                                TextFormField(
                                  controller: roomController,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: context.tr('session_label_room'),
                                    labelStyle: TextStyle(
                                      fontFamily: 'Cairo',
                                      color: colorScheme.onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.room_rounded,
                                      color: colorScheme.primary,
                                    ),
                                    filled: true,
                                    fillColor: colorScheme.surface,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: colorScheme.outlineVariant.withOpacity(0.6),
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: colorScheme.primary,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 28),

                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: colorScheme.primary,
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          elevation: 0,
                                        ),
                                        onPressed: () {
                                          if (selectedSubjectId == null || selectedTeacherId == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  context.tr('session_required_error'),
                                                  style: const TextStyle(fontFamily: 'Cairo'),
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          final classState = classesCubit.state;
                                          int extractedAcademicYearId = 2;
                                          if (classState is ClassesLoaded) {
                                            extractedAcademicYearId = classState.classDetails.academicYearId;
                                          }

                                          String startTime = '07:30:00';
                                          String endTime = '08:15:00';

                                          switch (periodNumber) {
                                            case 1:
                                              startTime = '07:30:00'; endTime = '08:15:00';
                                              break;
                                            case 2:
                                              startTime = '08:20:00'; endTime = '09:05:00';
                                              break;
                                            case 3:
                                              startTime = '09:35:00'; endTime = '10:20:00';
                                              break;
                                            case 4:
                                              startTime = '10:20:00'; endTime = '11:05:00';
                                              break;
                                            case 5:
                                              startTime = '11:30:00'; endTime = '12:15:00';
                                              break;
                                            case 6:
                                              startTime = '12:15:00'; endTime = '13:00:00';
                                              break;
                                          }

                                          final newSession = ScheduleSessionModel(
                                            id: sessionId ?? 0,
                                            roomNumber: roomController.text,
                                            dayOfWeek: dayOfWeek,
                                            periodNumber: periodNumber,
                                            startTime: startTime,
                                            endTime: endTime,
                                          );

                                          if (sessionId == null) {
                                            scheduleCubit.uploadNewSession(
                                              sectionId: sectionId,
                                              className: className,
                                              updatedSession: newSession,
                                              subjectId: selectedSubjectId!,
                                              teacherId: selectedTeacherId!,
                                              academicYearId: extractedAcademicYearId,
                                              semesterId: semesterId,
                                            );
                                          } else {
                                            scheduleCubit.updateSession(
                                              timetableId: sessionId,
                                              sectionId: sectionId,
                                              className: className,
                                              updatedSession: newSession,
                                              subjectId: selectedSubjectId!,
                                              teacherId: selectedTeacherId!,
                                              academicYearId: extractedAcademicYearId,
                                              semesterId: semesterId,
                                            );
                                          }

                                          Navigator.pop(bottomSheetContext);
                                        },
                                        child: Text(
                                          sessionId == null ? context.tr('session_btn_add') : context.tr('session_btn_save'),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      flex: 1,
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: colorScheme.outlineVariant,
                                            width: 1.5,
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(bottomSheetContext),
                                        child: Text(
                                          context.tr('session_btn_cancel'),
                                          style: TextStyle(
                                            color: colorScheme.onSurfaceVariant,
                                            fontSize: 15,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  static Widget _buildModernDropdown<T>({
    required BuildContext context,
    required T? value,
    required String hint,
    required IconData icon,
    required Color activeColor,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return DropdownButtonFormField<T>(
      value: value,
      dropdownColor: colorScheme.surfaceContainerLow,
      isExpanded: true,
      hint: Text(
        hint,
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          color: colorScheme.onSurfaceVariant,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      icon: Icon(
        Icons.arrow_drop_down_circle_outlined,
        color: colorScheme.onSurfaceVariant.withOpacity(0.6),
        size: 22,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: activeColor),
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withOpacity(0.6),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: activeColor, width: 2),
        ),
      ),
      items: items,
      onChanged: onChanged,
    );
  }

  static Widget _buildFieldLoading(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
          ),
        ),
      ),
    );
  }

  static Widget _buildFieldError(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: colorScheme.error,
          fontFamily: 'Cairo',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}