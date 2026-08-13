import 'package:flowva_school/app_theme.dart';
import 'package:flowva_school/feature/parent/notifications/cubit/notifications_cubit.dart';
import 'package:flowva_school/feature/parent/notifications/screens/notifications_screen.dart';
import 'package:flowva_school/feature/parent/profile/screens/parent_profile_screen.dart';
import 'package:flowva_school/feature/parent/settings/screens/parent_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/parent_navigation_cubit.dart';
import '../data/mock_attendance_data.dart';
import '../widgets/child_dashboard_card.dart';
import '../widgets/custom_dashboard_app_bar.dart';
import 'attendance_tracking_screen.dart';

class ChildrenListScreen extends StatelessWidget {
  const ChildrenListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final childrenList = MockAttendanceData.children;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundColor,
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              expandedHeight: 135,
              toolbarHeight: 135,
              floating: true, 
              snap: true,
              pinned: false, 
              flexibleSpace: FlexibleSpaceBar(
                background: CustomDashboardAppBar(
                  userName: 'أبو أحمد الخالد',
                  subtitle: 'ولي الأمر العام',
                  academicYear: '2025-2026',
                  description: 'اختر الابن لعرض بياناته ومتابعة أدائه الدراسي التراكمي والحضور الميداني.',
                  imageUrl: '',
                  hasNotifications: true,
                  onProfileTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const ParentProfileScreen(),
                      ),
                    );
                  },
                  onNotificationsTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => BlocProvider(
                          create: (context) => NotificationsCubit(),
                          child: const NotificationsScreen(),
                        ),
                      ),
                    );
                  },
                  onSettingsTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const ParentSettingsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.paddingMedium)),
            
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
              sliver: SliverGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: AppSizes.paddingMedium, 
                crossAxisSpacing: AppSizes.paddingMedium,
                childAspectRatio: 1.65, 
                children: [
                  _buildSummaryGridCard(context, 'إجمالي الأبناء', childrenList.length.toString(), Icons.school_outlined, Colors.blue),
                  _buildSummaryGridCard(context, 'متوسط المعدل', "94.6%", Icons.emoji_events_outlined, Colors.green),
                  _buildSummaryGridCard(context, 'متوسط الحضور', "96.6%", Icons.trending_up_rounded, Colors.purple),
                  _buildSummaryGridCard(context, 'الفصل الدراسي', "الثاني", Icons.calendar_today_rounded, Colors.orange),
                ],
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.paddingLarge)),
            
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final child = childrenList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.paddingMedium),
                      child: ChildDashboardCard(
                        child: child,
                        onViewDetails: () {
                          context.read<ParentNavigationCubit>().selectStudent(child.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => AttendanceTrackingScreen(studentName: child.name),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  childCount: childrenList.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSizes.paddingLarge)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryGridCard(BuildContext context, String title, String value, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingMedium - 2.0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLarge),
        border: Border.all(
          color: isDark ? AppColors.darkOutlineColor : AppColors.outlineColor, 
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withOpacity(0.2), 
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title, 
                  style: TextStyle(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText, 
                    fontSize: AppSizes.fontSizeLabel - 1.0, 
                    fontFamily: 'Cairo', 
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.bottomRight,
            child: Text(
              value, 
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold, 
                fontSize: AppSizes.fontSizeSubtitle, 
                fontFamily: 'Cairo',
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}