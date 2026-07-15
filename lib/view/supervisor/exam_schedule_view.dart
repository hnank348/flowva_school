import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/supervisor/state_supervisor/exam_schedule_state.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_cubit.dart';
import 'package:flowva_school/cubit/supervisor/classes/classes_state.dart';

import '../../widget/supervisor/custom_section_semester_header.dart';

class ExamScheduleView extends StatelessWidget {
  const ExamScheduleView({super.key});

  void _showEditExamBottomSheet(BuildContext context, {String? subject, String? time, String? date, String? day}) {
    final subjectController = TextEditingController(text: subject ?? '');
    final timeController = TextEditingController(text: time ?? '');
    final dateController = TextEditingController(text: date ?? '');
    final dayController = TextEditingController(text: day ?? '');

    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return LayoutBuilder(
          builder: (context, sheetConstraints) {
            bool isWideScreen = sheetConstraints.maxWidth > 600;

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                width: isWideScreen ? 650 : double.infinity,
                margin: isWideScreen
                    ? EdgeInsets.symmetric(horizontal: (sheetConstraints.maxWidth - 650) / 2)
                    : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: 16,
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      subject == null ? 'إضافة مادة لجدول الامتحان' : 'تعديل مادة الامتحان',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                        color: isDark ? colorScheme.primary : const Color(0xFF234E52),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    if (isWideScreen) ...[
                      Row(
                        children: [
                          Expanded(child: _buildInputField(context, label: 'اسم المادة', controller: subjectController, icon: Icons.book_outlined)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInputField(context, label: 'اليوم (مثال: الأحد)', controller: dayController, icon: Icons.today_rounded)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: _buildInputField(context, label: 'التاريخ', controller: dateController, icon: Icons.calendar_month_outlined)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInputField(context, label: 'الزمن / الوقت', controller: timeController, icon: Icons.access_time_rounded)),
                        ],
                      ),
                    ] else ...[
                      _buildInputField(context, label: 'اسم المادة', controller: subjectController, icon: Icons.book_outlined),
                      const SizedBox(height: 14),
                      _buildInputField(context, label: 'اليوم (مثال: الأحد)', controller: dayController, icon: Icons.today_rounded),
                      const SizedBox(height: 14),
                      _buildInputField(context, label: 'التاريخ', controller: dateController, icon: Icons.calendar_month_outlined),
                      const SizedBox(height: 14),
                      _buildInputField(context, label: 'الزمن / الوقت', controller: timeController, icon: Icons.access_time_rounded),
                    ],

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? colorScheme.primary : const Color(0xFF234E52),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              context.read<ExamScheduleCubit>().saveExamSchedule();
                              Navigator.pop(bottomSheetContext);
                            },
                            child: const Text('حفظ البيانات', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colorScheme.outlineVariant),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => Navigator.pop(bottomSheetContext),
                            child: Text('إلغاء', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14, fontFamily: 'Cairo')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInputField(BuildContext context, {required String label, required TextEditingController controller, required IconData icon}) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: 'Cairo', color: colorScheme.onSurfaceVariant, fontSize: 13),
        prefixIcon: Icon(icon, color: colorScheme.primary),
        filled: true,
        fillColor: colorScheme.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.4))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: colorScheme.primary)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 1️⃣ الاستماع لحالة الغرف/الشعب القادمة من الباك اند
    return BlocBuilder<ClassesCubit, ClassesState>(
      builder: (context, classState) {

        // التعامل مع حالة التحميل من السيرفر
        if (classState is ClassesLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // التعامل مع حالة الخطأ من السيرفر
        if (classState is ClassesError) {
          return Scaffold(
            body: Center(
              child: Text(
                classState.message,
                style: TextStyle(fontFamily: 'Cairo', color: colorScheme.error),
              ),
            ),
          );
        }

        // في حال تم جلب البيانات بنجاح ClassesLoaded
        if (classState is ClassesLoaded) {
          final activeSections = classState.classDetails.sections;
          final selectedSection = classState.selectedSection;

          return BlocBuilder<ExamScheduleCubit, ExamScheduleState>(
            builder: (context, examState) {
              return Container(
                color: colorScheme.surface,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),

                    AttendanceSectionHeader(
                      selectedSection: selectedSection,
                      sections: activeSections,
                      onSectionChanged: (newSection) {
                        context.read<ClassesCubit>().selectSection(newSection);
                        context.read<ExamScheduleCubit>().changeClass(newSection.name);
                      },
                      onExportPdfPressed: () {
                        // TODO: منطق تصدير PDF لجدول الامتحان
                      },
                    ),
                    const SizedBox(height: 16),

                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTopButton('اعتماد الجدول', const Color(0xFF1E3A8A), Colors.white, icon: Icons.check_circle_outline, onTap: () {}),
                            const SizedBox(width: 6),
                            _buildTopButton('إضافة مادة', const Color(0xFF319795), Colors.white, icon: Icons.add, onTap: () => _showEditExamBottomSheet(context)),
                          ],
                        ),
                        Text(
                          'جدول امتحانات ${selectedSection?.name}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface, fontFamily: 'Cairo'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, mainConstraints) {
                          int crossAxisCount = 1;
                          if (mainConstraints.maxWidth > 900) {
                            crossAxisCount = 3;
                          } else if (mainConstraints.maxWidth > 600) {
                            crossAxisCount = 2;
                          }

                          double childAspectRatio = mainConstraints.maxWidth > 900
                              ? 2.5
                              : (mainConstraints.maxWidth > 600 ? 2.2 : 3.4);

                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: childAspectRatio,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              _buildExamCard(context, 'الرياضيات', '08:00 - 10:00', '2026/06/01', 'الأحد', const Color(0xFF3B82F6)),
                              _buildExamCard(context, 'اللغة العربية', '08:00 - 10:00', '2026/06/02', 'الاثنين', const Color(0xFF22C55E)),
                              _buildExamCard(context, 'العلوم العامة', '08:00 - 09:30', '2026/06/03', 'الثلاثاء', const Color(0xFFF97316)),
                              _buildExamCard(context, 'التربية الإسلامية', '08:00 - 09:30', '2026/06/04', 'الأربعاء', const Color(0xFF06B6D4)),
                              _buildExamCard(context, 'اللغة الإنجليزية', '08:00 - 10:00', '2026/06/05', 'الخميس', const Color(0xFFEAB308)),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildTopButton(String text, Color bg, Color txt, {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Icon(icon, color: txt, size: 14),
            const SizedBox(width: 4),
            Text(text, style: TextStyle(color: txt, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, String subject, String time, String date, String day, Color accentColor) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5), width: 1),
      ),
      color: colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: () => _showEditExamBottomSheet(context, subject: subject, time: time, date: date, day: day),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Container(
                width: 5,
                height: double.infinity,
                decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      subject,
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 12, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(time, style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? colorScheme.surfaceContainerHigh : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isDark ? colorScheme.onSurface : const Color(0xFF475569),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(date, style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}