import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/supervisor/state_supervisor/exam_schedule_state.dart';

class ExamScheduleView extends StatelessWidget {
  const ExamScheduleView({super.key});

  final List<String> supervisorClasses = const ['الصف الثالث - أ', 'الصف الثالث - ب', 'الصف الرابع - أ'];

  // --- دالة إظهار واجهة إضافة / تعديل مادة الامتحان (Responsive Bottom Sheet) ---
  void _showEditExamBottomSheet(BuildContext context, {String? subject, String? time, String? date, String? day}) {
    final subjectController = TextEditingController(text: subject ?? '');
    final timeController = TextEditingController(text: time ?? '');
    final dateController = TextEditingController(text: date ?? '');
    final dayController = TextEditingController(text: day ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        // نستخدم LayoutBuilder هنا ليعرف الـ BottomSheet كم مساحة العرض المتاحة له
        return LayoutBuilder(
          builder: (context, sheetConstraints) {
            bool isWideScreen = sheetConstraints.maxWidth > 600;

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                // على الشاشات الكبيرة جداً، نجعل للـ BottomSheet عرضاً أقصى لكي لا يتمدد بشكل قبيح
                width: isWideScreen ? 650 : double.infinity,
                margin: isWideScreen
                    ? EdgeInsets.symmetric(horizontal: (sheetConstraints.maxWidth - 650) / 2)
                    : EdgeInsets.zero,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
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
                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      subject == null ? 'إضافة مادة لجدول الامتحان' : 'تعديل مادة الامتحان',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: Color(0xFF234E52)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // --- التوزيع الذكي للحقول حسب عرض الشاشة ---
                    if (isWideScreen) ...[
                      // شاشات كبيرة: نعرض كل حقلين بجانب بعضهما في سطر واحد
                      Row(
                        children: [
                          Expanded(child: _buildInputField(label: 'اسم المادة', controller: subjectController, icon: Icons.book_outlined)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInputField(label: 'اليوم (مثال: الأحد)', controller: dayController, icon: Icons.today_rounded)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: _buildInputField(label: 'التاريخ', controller: dateController, icon: Icons.calendar_month_outlined)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInputField(label: 'الزمن / الوقت', controller: timeController, icon: Icons.access_time_rounded)),
                        ],
                      ),
                    ] else ...[
                      // شاشات صغيرة (جوال): حقول متتالية تحت بعضها
                      _buildInputField(label: 'اسم المادة', controller: subjectController, icon: Icons.book_outlined),
                      const SizedBox(height: 14),
                      _buildInputField(label: 'اليوم (مثال: الأحد)', controller: dayController, icon: Icons.today_rounded),
                      const SizedBox(height: 14),
                      _buildInputField(label: 'التاريخ', controller: dateController, icon: Icons.calendar_month_outlined),
                      const SizedBox(height: 14),
                      _buildInputField(label: 'الزمن / الوقت', controller: timeController, icon: Icons.access_time_rounded),
                    ],

                    const SizedBox(height: 24),

                    // --- أزرار التحكم الفليكسيبل ---
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF234E52),
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
                              side: BorderSide(color: Colors.grey[300]!),
                              padding: const EdgeInsets.symmetric(vertical: 14),
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
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12), // ريسبونسف مع اللمس
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF319795))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamScheduleCubit, ExamScheduleState>(
      builder: (context, state) {
        return Container(
          color: const Color(0xFFF8FAFC),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),

              // --- 1. شريط الكبسولات العلوي (يتجاوب تلقائياً مع السحب) ---
              Directionality(
                textDirection: TextDirection.rtl,
                child: SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: supervisorClasses.length,
                    itemBuilder: (context, index) {
                      final currentClass = supervisorClasses[index];
                      final isSelected = currentClass == state.selectedClass;

                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: InkWell(
                          onTap: () => context.read<ExamScheduleCubit>().changeClass(currentClass),
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

              const SizedBox(height: 16),

              // --- 2. صف العناوين وأزرار التحكم الفليكسيبل ---
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
                    'جدول امتحانات ${state.selectedClass}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontFamily: 'Cairo'),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // --- 3. عرض بطاقات الامتحانات العصرية (Dynamic Responsive Grid) ---
              Expanded(
                child: LayoutBuilder(
                  builder: (context, mainConstraints) {
                    // حساب عدد الأعمدة ديناميكياً: شاشة صغيرة = 1، تابلت = 2، شاشة واسعة/كمبيوتر = 3 أو 4
                    int crossAxisCount = 1;
                    if (mainConstraints.maxWidth > 900) {
                      crossAxisCount = 3;
                    } else if (mainConstraints.maxWidth > 600) {
                      crossAxisCount = 2;
                    }

                    // ضبط النسبة بين الطول والعرض لتبقى الكروت متناسقة
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
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1),
      ),
      color: Colors.white,
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
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
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
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(20)),
                    child: Text(day, style: const TextStyle(fontFamily: 'Cairo', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                  ),
                  const SizedBox(height: 6),
                  Text(date, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}