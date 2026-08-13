import 'package:flowva_school/app_theme.dart';
import 'package:flowva_school/feature/parent/payments/screens/quick_payment_screen.dart';
import 'package:flowva_school/feature/parent/chat/screens/messages_screen.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; 
import '../cubit/parent_navigation_cubit.dart';
import 'children_list_screen.dart';
import 'package:flowva_school/feature/parent/bus_tracker/data/bus_tracker_repository.dart';
import 'package:flowva_school/feature/parent/bus_tracker/cubit/bus_tracker_cubit.dart';
import 'package:flowva_school/feature/parent/bus_tracker/screens/school_bus_tracker_screen.dart';

class ParentMainLayout extends StatelessWidget {
  const ParentMainLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimaryTeal : AppColors.primaryTeal;

    final List<Widget> screens = [
      const ChildrenListScreen(),
      const QuickPaymentScreen(), 
      BlocProvider(
        create: (context) => BusTrackerCubit(BusTrackerRepository()),
        child: const SchoolBusTrackerScreen(),
      ),
      const MessagesScreen(),
    ];

    return BlocProvider(
      create: (context) => ParentNavigationCubit(),
      child: BlocBuilder<ParentNavigationCubit, ParentNavigationState>(
        builder: (context, state) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: isDark ? AppColors.darkBackground : AppColors.backgroundColor,
              systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundColor,
                body: IndexedStack(
                  index: state.currentIndex,
                  children: screens,
                ),
                bottomNavigationBar: CurvedNavigationBar(
                  index: state.currentIndex,
                  height: 50,
                  items: const <Widget>[
                    Icon(Icons.school_rounded, size: 26, color: Colors.white),
                    Icon(Icons.account_balance_wallet_rounded, size: 26, color: Colors.white),
                    Icon(Icons.directions_bus_rounded, size: 26, color: Colors.white),
                    Icon(Icons.chat_bubble_rounded, size: 26, color: Colors.white),
                  ],
                  color: primaryColor,
                  buttonBackgroundColor: primaryColor,
                  backgroundColor: isDark ? AppColors.darkBackground : AppColors.backgroundColor,
                  animationCurve: Curves.easeInOut,
                  animationDuration: const Duration(milliseconds: 400),
                  onTap: (index) => context.read<ParentNavigationCubit>().changeIndex(index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
