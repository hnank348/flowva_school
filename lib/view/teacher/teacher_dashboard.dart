import 'package:flutter/material.dart';
import 'home_view.dart';
import 'schedule_view.dart';
import 'students_view.dart';
import 'classes_view.dart';
import 'chat_view.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key, required this.userToken});
  final String userToken;

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    HomeView(userToken: widget.userToken),
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
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'الجدول'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'الصفوف'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'الطلاب'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'المحادثات'),
          ],
        ),
      ),
    );
  }
}