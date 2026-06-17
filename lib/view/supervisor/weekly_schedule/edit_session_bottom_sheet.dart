import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/supervisor/classes/classes_cubit.dart';
import '../../../cubit/supervisor/schedule/schedule_cubit.dart';
import '../../../cubit/supervisor/subjects/subjects_cubit.dart';
import '../../../cubit/supervisor/teachers/teachers_cubit.dart';
import '../../../cubit/supervisor/classes/classes_state.dart';
import '../../../cubit/supervisor/subjects/subjects_state.dart';
import '../../../cubit/supervisor/teachers/teachers_state.dart';
import '../../../models/supervisor/schedule_session_model.dart';

class EditSessionBottomSheet {
  static void show(
      BuildContext context, {
        required String currentSubject,
        required String currentTeacher,
        required String currentRoom,
        required int sectionId,
        required String className,
        required String dayOfWeek,
        required int periodNumber,
        required int semesterId,
      }) {

    // جلب الـ Cubits من الـ Context الرئيسي قبل بناء الـ Bottom Sheet
    final subjectsCubit = BlocProvider.of<SubjectsCubit>(context);
    final teachersCubit = BlocProvider.of<TeachersCubit>(context);
    final scheduleCubit = BlocProvider.of<ScheduleCubit>(context);
    final classesCubit = BlocProvider.of<ClassesCubit>(context);

    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (bottomSheetContext) {

        // 🛠️ نقل المتغيرات إلى هنا لتصفيرها تماماً عند كل عملية فتح جديدة ومنع اختفاء الـ Hint Text
        int? selectedSubjectId;
        int? selectedTeacherId;
        final roomController = TextEditingController(text: currentRoom);

        // محاولة مطابقة الاسم الحالي لتحديد الـ ID الافتراضي في الـ Dropdown للحصة المحددة
        if (subjectsCubit.state is SubjectsSuccess) {
          final subs = (subjectsCubit.state as SubjectsSuccess).subjects;
          final match = subs.where((s) => s.name == currentSubject).toList();
          if (match.isNotEmpty) selectedSubjectId = match.first.id;
        }

        if (teachersCubit.state is TeachersSuccess) {
          final teachs = (teachersCubit.state as TeachersSuccess).teachers;
          final match = teachs.where((t) => t.fullNameAr == currentTeacher).toList();
          if (match.isNotEmpty) selectedTeacherId = match.first.id;
        }

        // تمرير الـ الـ Cubits الحالية الصالحة إلى الـ Sheet Context
        return MultiBlocProvider(
          providers: [
            BlocProvider<SubjectsCubit>.value(value: subjectsCubit),
            BlocProvider<TeachersCubit>.value(value: teachersCubit),
            BlocProvider<ScheduleCubit>.value(value: scheduleCubit),
            BlocProvider<ClassesCubit>.value(value: classesCubit),
          ],
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
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
                  return Column(
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.edit_calendar_rounded, color: colorScheme.primary, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'إعداد الحصة - الفصل الدراسي $semesterId',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // 📚 Dropdown المواد الدراسية
                      BlocBuilder<SubjectsCubit, SubjectsState>(
                        builder: (context, state) {
                          if (state is SubjectsLoading) return _buildFieldLoading(context);
                          if (state is SubjectsError) return _buildFieldError(context, state.errorMessage);
                          if (state is SubjectsSuccess) {
                            return _buildModernDropdown<int>(
                              context: context,
                              value: selectedSubjectId,
                              hint: "اختر المادة الدراسية الحالية",
                              icon: Icons.auto_stories_rounded,
                              activeColor: const Color(0xFF3182CE),
                              items: state.subjects.map((subject) {
                                return DropdownMenuItem<int>(
                                  value: subject.id,
                                  child: Text(
                                    subject.name,
                                    style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w600),
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

                      // 👨‍🏫 Dropdown المعلمون
                      BlocBuilder<TeachersCubit, TeachersState>(
                        builder: (context, state) {
                          List<DropdownMenuItem<int>> dropdownItems = [];
                          String hintText = "حدد المعلم / المعلمة للحصة";

                          if (state is TeachersSuccess) {
                            dropdownItems = state.teachers.map((teacher) {
                              return DropdownMenuItem<int>(
                                value: teacher.id,
                                child: Text(
                                  teacher.fullNameAr,
                                  style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              );
                            }).toList();
                          } else if (state is TeachersLoading) {
                            hintText = "جاري تحميل المعلمين...";
                          } else if (state is TeachersError) {
                            hintText = "فشل تحميل المعلمين";
                          } else if (state is TeachersInitial) {
                            context.read<TeachersCubit>().fetchTeachers();
                            hintText = "جاري تهيئة البيانات...";
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
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          labelText: 'رقم أو اسم القاعة',
                          labelStyle: TextStyle(fontFamily: 'Cairo', color: colorScheme.onSurfaceVariant, fontSize: 13),
                          prefixIcon: Icon(Icons.room_rounded, color: colorScheme.primary),
                          filled: true,
                          fillColor: colorScheme.surface,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.6), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: colorScheme.primary, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: () {
                                if (selectedSubjectId == null || selectedTeacherId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('الرجاء اختيار المادة الدراسية والمعلم أولاً', style: TextStyle(fontFamily: 'Cairo')),
                                    ),
                                  );
                                  return;
                                }

                                final classState = classesCubit.state;
                                int extractedAcademicYearId = 2;
                                if (classState is ClassesLoaded) {
                                  extractedAcademicYearId = classState.classDetails.academicYearId;
                                }

                                String startTime = '2026-01-09 07:30:00';
                                String endTime = '2026-01-01 20:15:00';

                                final newSession = ScheduleSessionModel(
                                  roomNumber: roomController.text,
                                  dayOfWeek: dayOfWeek,
                                  periodNumber: periodNumber,
                                  startTime: startTime,
                                  endTime: endTime,
                                );

                                scheduleCubit.uploadNewSession(
                                  sectionId: sectionId,
                                  className: className,
                                  updatedSession: newSession,
                                  subjectId: selectedSubjectId!,
                                  teacherId: selectedTeacherId!,
                                  academicYearId: extractedAcademicYearId,
                                  semesterId: semesterId,
                                );

                                Navigator.pop(bottomSheetContext);
                              },
                              child: const Text(
                                'حفظ التعديلات',
                                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: () => Navigator.pop(bottomSheetContext),
                              child: Text(
                                'إلغاء',
                                style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 15, fontFamily: 'Cairo'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
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
      hint: Text(hint, style: TextStyle(fontFamily: 'Cairo', fontSize: 13, color: colorScheme.onSurfaceVariant)),
      icon: Icon(Icons.arrow_drop_down_circle_outlined, color: colorScheme.onSurfaceVariant.withOpacity(0.6), size: 22),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: activeColor),
        filled: true,
        fillColor: colorScheme.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.6), width: 1.5),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
          strokeWidth: 3,
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