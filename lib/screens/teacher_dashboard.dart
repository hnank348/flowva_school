import 'package:flutter/material.dart';
import '../screens/home_view.dart';
import '../screens/schedule_view.dart';
import '../screens/students_view.dart';
import '../screens/classes_view.dart';
import '../screens/chat_view.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const ScheduleView(),
    const ClassesView(),
    const StudentsView(),
    const ChatView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'الجدول',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'الصفوف'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'الطلاب'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'المحادثات'),
          ],
        ),
      ),
    );
  }
}
