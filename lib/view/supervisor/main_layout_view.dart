import 'package:flowva_school/view/supervisor/attendance_view.dart';
import 'package:flowva_school/view/supervisor/exam_schedule_view.dart';
import 'package:flowva_school/view/supervisor/statistics_view.dart';
import 'package:flowva_school/view/teacher/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/supervisor/cubit_supervisor/navigation_cubit.dart';
import 'weekly_schedule_view.dart';
import 'custom_bottom_navigation_bar.dart';

class MainLayoutView extends StatelessWidget {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const WeeklyScheduleView(),
      const ExamScheduleView(),
      const AttendanceView(),
      const StatisticsView(),
    ];

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FA),

          // --- الـ AppBar المطور والمحمي من الأسماء الطويلة ---
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(
              145,
            ), // زيادة طفيفة جداً لراحة العناصر بالأسفل
            child: Container(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 14,
                right: 20,
                left: 16,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFF319795), Color(0xFF4FD1C5)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // CrossAxisAlignment.end تجعل الأزرار تنزل للأسفل تلقائياً لتتماشى مع مستوى النصوص والصورة
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // --- جهة اليسار: الأزرار منزلة لأسفل البار ومحمية ---
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 60,
                      ), // نزول إضافي ناعم متناسق مع العين
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.settings_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(6),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => const SettingsView(),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.notifications_none_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(6),
                                onPressed: () {},
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // --- جهة اليمين: بيانات المستخدم والصورة الشخصية ---
                    // تغليف جهة اليمين بالكامل بـ Expanded يسمح للأسماء الطويلة بأخذ راحتها في المساحة المتبقية
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        textDirection: TextDirection.rtl,
                        children: [
                          // الحاوية الدائرية المكبرة للصورة الشخصية ثابتة بأبعادها (78x78)
                          Container(
                            width: 78,
                            height: 78,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                color: Color(0xFF234E52),
                                size: 46,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // نصوص الهوية والاسم مغلفة بـ Expanded لمنع حدوث الـ Overflow والخطأ الأصفر
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'أ. حنان خميس',
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow
                                      .ellipsis, // حماية ذكية تقطع النص بنقاط إذا تجاوز المساحة لـ يسار الشاشة
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  'الموجه العام',
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          body: SafeArea(child: pages[currentIndex]),

          bottomNavigationBar: CustomBottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<NavigationCubit>().changePage(index);
            },
          ),
        );
      },
    );
  }
}
