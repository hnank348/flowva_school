import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/supervisor/cubit_supervisor/schedule_cubit_screen.dart';
import '../../cubit/supervisor/state_supervisor/schedule_state.dart';
import '../../models/supervisor/schedule_session_model.dart';

class WeeklyScheduleView extends StatelessWidget {
  const WeeklyScheduleView({super.key});

  final List<String> supervisorClasses = const ['الصف الثالث - أ', 'الصف الثالث - ب', 'الصف الرابع - أ'];

  // ميثود لمطابقة الأيام والحصص القادمة من الباكيند مع خلايا الجدول
  ScheduleSessionModel? _findSession(List<ScheduleSessionModel> sessions, String day, int period) {
    try {
      return sessions.firstWhere(
            (s) => s.dayOfWeek.trim().toLowerCase() == day.trim().toLowerCase() && s.periodNumber == period,
      );
    } catch (_) {
      return null;
    }
  }

  // --- دالة إظهار واجهة "تعديل الحصة" الأصلية ---
  void _showEditSessionBottomSheet(BuildContext context, String currentSubject, String currentTeacher, String currentRoom) {
    final subjectController = TextEditingController(text: currentSubject);
    final teacherController = TextEditingController(text: currentTeacher);
    final roomController = TextEditingController(text: currentRoom);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
            ),
            padding: EdgeInsets.only(
              top: 20,
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
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'تعديل تفاصيل الحصة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: Color(0xFF234E52)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                _buildInputField(label: 'اسم المادة', controller: subjectController, icon: Icons.book_outlined),
                const SizedBox(height: 14),
                _buildInputField(label: 'اسم المعلم / المعلمة', controller: teacherController, icon: Icons.person_outline_rounded),
                const SizedBox(height: 14),
                _buildInputField(label: 'رقم أو اسم القاعة', controller: roomController, icon: Icons.room_outlined),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF234E52),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          // استدعاء الميثود الأصلي من الكيوبيت الخاص بك دون تغيير اسمه
                          context.read<ScheduleCubitScreen>().updateSessionDetails(
                            subject: subjectController.text,
                            teacher: teacherController.text,
                            room: roomController.text,
                          );
                          Navigator.pop(bottomSheetContext);
                        },
                        child: const Text('حفظ التعديلات', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[300]!),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Navigator.pop(bottomSheetContext),
                        child: const Text('إلغاء', style: TextStyle(color: Color(0xFF64748B), fontSize: 14, fontFamily: 'Cairo')),
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
  }

  Widget _buildInputField({required String label, required TextEditingController controller, required IconData icon}) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontFamily: 'Cairo', color: Color(0xFF64748B), fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFF319795)),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF319795))),
      ),
    );
  }

  // ميثود أصلية لتوليد ألوان المواد للحفاظ على شكل التصميم
  Color _getSubjectColor(String? subjectName) {
    if (subjectName == null) return Colors.grey;
    if (subjectName.contains('رياضيات')) return const Color(0xFF3B82F6);
    if (subjectName.contains('عربية') || subjectName.contains('لغة عربية')) return const Color(0xFF22C55E);
    if (subjectName.contains('علوم')) return const Color(0xFFA855F7);
    if (subjectName.contains('إنجليزي')) return const Color(0xFFEAB308);
    if (subjectName.contains('إسلامية') || subjectName.contains('تربية إسلامية')) return const Color(0xFF06B6D4);
    if (subjectName.contains('اجتماعيات')) return const Color(0xFFF97316);
    return const Color(0xFF319795);
  }

  @override
  Widget build(BuildContext context) {
    // جلب بيانات الصف الأول تلقائياً عند الدخول إلى الواجهة لأول مرة كـ StatelessWidget
    final scheduleCubit = context.read<ScheduleCubitScreen>();
    if (scheduleCubit.state is ScheduleInitial) {
      scheduleCubit.changeClass(supervisorClasses.first);
    }

    return BlocBuilder<ScheduleCubitScreen, ScheduleStateScreen>(
      builder: (context, state) {
        // جلب قائمة الحصص الفعليّة ديناميكياً لتفادي أخطاء الـ Type Cast
        List<ScheduleSessionModel> activeSessions = [];

        try {
          if (state.runtimeType.toString().contains('Loaded')) {
            activeSessions = (state as dynamic).sessions ?? [];
          }
        } catch (_) {
          activeSessions = [];
        }

        // تفادي أخطاء جلب الصف الحالي المختار من الـ state
        String currentSelectedClass = supervisorClasses.first;
        try {
          currentSelectedClass = (state as dynamic).selectedClass ?? supervisorClasses.first;
        } catch (_) {
          currentSelectedClass = supervisorClasses.first;
        }

        return Container(
          color: const Color(0xFFF8FAFC),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // --- شريط الكبسولات العلوي الأصلي ---
              Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: supervisorClasses.length,
                    itemBuilder: (context, index) {
                      final currentClass = supervisorClasses[index];
                      final isSelected = currentClass == currentSelectedClass;

                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: InkWell(
                          onTap: () => context.read<ScheduleCubitScreen>().changeClass(currentClass),
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF234E52) : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!),
                            ),
                            child: Center(
                              child: Text(
                                currentClass,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // --- أزرار التحكم وعنوان الجدول الأصلي ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _buildTopButton('حفظ الجدول', const Color(0xFF1E3A8A), Colors.white),
                      const SizedBox(width: 6),
                      _buildTopButton('تصدير PDF', Colors.white, Colors.black87, hasBorder: true),
                    ],
                  ),
                  Text(
                    'جدول $currentSelectedClass',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontFamily: 'Cairo'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // حالة التحميل الدوارة إذا كان الـ Cubit يجلب البيانات حالياً
              if (state.runtimeType.toString().contains('Loading'))
                const Expanded(child: Center(child: CircularProgressIndicator(color: Color(0xFF234E52))))
              else
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double finalWidth = constraints.maxWidth > 750 ? constraints.maxWidth : 750.0;
                      final double cellWidth = finalWidth / 6;

                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            width: finalWidth,
                            padding: const EdgeInsets.only(bottom: 24),
                            child: Table(
                              defaultColumnWidth: FixedColumnWidth(cellWidth),
                              border: TableBorder.all(color: Colors.grey.withOpacity(0.15), width: 1),
                              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                              children: [
                                TableRow(
                                  decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
                                  children: const [
                                    Padding(padding: EdgeInsets.all(10.0), child: Text('الخميس', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'))),
                                    Padding(padding: EdgeInsets.all(10.0), child: Text('الأربعاء', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'))),
                                    Padding(padding: EdgeInsets.all(10.0), child: Text('الثلاثاء', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'))),
                                    Padding(padding: EdgeInsets.all(10.0), child: Text('الاثنين', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'))),
                                    Padding(padding: EdgeInsets.all(10.0), child: Text('الأحد', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'))),
                                    Padding(padding: EdgeInsets.all(10.0), child: Text('الوقت', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Cairo'))),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildDynamicCell(context, activeSessions, 'thursday', 1),
                                    _buildDynamicCell(context, activeSessions, 'wednesday', 1),
                                    _buildDynamicCell(context, activeSessions, 'tuesday', 1),
                                    _buildDynamicCell(context, activeSessions, 'monday', 1),
                                    _buildDynamicCell(context, activeSessions, 'sunday', 1),
                                    _buildTimeCell('الحصة الأولى', '8:15 - 7:30'),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildDynamicCell(context, activeSessions, 'thursday', 2),
                                    _buildDynamicCell(context, activeSessions, 'wednesday', 2),
                                    _buildDynamicCell(context, activeSessions, 'tuesday', 2),
                                    _buildDynamicCell(context, activeSessions, 'monday', 2),
                                    _buildDynamicCell(context, activeSessions, 'sunday', 2),
                                    _buildTimeCell('الحصة الثانية', '9:05 - 8:20'),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildRestCell(), _buildRestCell(), _buildRestCell(), _buildRestCell(), _buildRestCell(),
                                    _buildTimeCell('استراحة ١', '9:35 - 9:05'),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildDynamicCell(context, activeSessions, 'thursday', 3),
                                    _buildDynamicCell(context, activeSessions, 'wednesday', 3),
                                    _buildDynamicCell(context, activeSessions, 'tuesday', 3),
                                    _buildDynamicCell(context, activeSessions, 'monday', 3),
                                    _buildDynamicCell(context, activeSessions, 'sunday', 3),
                                    _buildTimeCell('الحصة الثالثة', '10:20 - 9:35'),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildDynamicCell(context, activeSessions, 'thursday', 4),
                                    _buildDynamicCell(context, activeSessions, 'wednesday', 4),
                                    _buildDynamicCell(context, activeSessions, 'tuesday', 4),
                                    _buildDynamicCell(context, activeSessions, 'monday', 4),
                                    _buildDynamicCell(context, activeSessions, 'sunday', 4),
                                    _buildTimeCell('الحصة الرابعة', '11:05 - 10:20'),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildRestCell(), _buildRestCell(), _buildRestCell(), _buildRestCell(), _buildRestCell(),
                                    _buildTimeCell('استراحة ٢', '11:30 - 11:05'),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildDynamicCell(context, activeSessions, 'thursday', 5),
                                    _buildDynamicCell(context, activeSessions, 'wednesday', 5),
                                    _buildDynamicCell(context, activeSessions, 'tuesday', 5),
                                    _buildDynamicCell(context, activeSessions, 'monday', 5),
                                    _buildDynamicCell(context, activeSessions, 'sunday', 5),
                                    _buildTimeCell('الحصة الخامسة', '12:15 - 11:30'),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildDynamicCell(context, activeSessions, 'thursday', 6),
                                    _buildDynamicCell(context, activeSessions, 'wednesday', 6),
                                    _buildDynamicCell(context, activeSessions, 'tuesday', 6),
                                    _buildDynamicCell(context, activeSessions, 'monday', 6),
                                    _buildDynamicCell(context, activeSessions, 'sunday', 6),
                                    _buildTimeCell('الحصة السادسة', '1:00 - 12:15'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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

  // ويدجت داخلي للتحقق ديناميكياً وعرض الحصة الحقيقية القادمة من السيرفر
  Widget _buildDynamicCell(BuildContext context, List<ScheduleSessionModel> sessions, String day, int period) {
    final session = _findSession(sessions, day, period);

    if (session != null) {
      return _buildGridSession(
        context,
        session.subject?.name ?? 'مادة غير معرفة',
        session.teacher?.fullName ?? 'بدون معلم',
        session.roomNumber ?? 'غير محدد',
        _getSubjectColor(session.subject?.name),
      );
    } else {
      return _buildEmptyDragCell(context);
    }
  }

  Widget _buildTopButton(String text, Color bg, Color txt, {bool hasBorder = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: hasBorder ? Border.all(color: Colors.grey[300]!) : null,
      ),
      child: Text(text, style: TextStyle(color: txt, fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
    );
  }

  Widget _buildGridSession(BuildContext context, String subject, String teacher, String room, Color color) {
    return InkWell(
      onTap: () => _showEditSessionBottomSheet(context, subject, teacher, room),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text(subject, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(teacher, style: const TextStyle(color: Colors.white70, fontSize: 9, fontFamily: 'Cairo'), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(4)),
              child: Text(room, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeCell(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          const SizedBox(height: 1),
          Text(time, style: const TextStyle(fontSize: 9, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRestCell() {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: const Color(0xFFFEFCE8), borderRadius: BorderRadius.circular(6)),
      child: const Text('استراحة', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFA16207), fontSize: 10, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEmptyDragCell(BuildContext context) {
    return InkWell(
      onTap: () => _showEditSessionBottomSheet(context, '', '', ''),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
        ),
        child: const Text(
          'اسحب مادة هنا',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 9, fontFamily: 'Cairo'),
          maxLines: 1,
        ),
      ),
    );
  }
}