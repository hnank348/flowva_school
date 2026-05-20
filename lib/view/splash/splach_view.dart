import 'dart:async';
import 'package:flowva_school/view/splash/welcome_view.dart';
import 'package:flutter/material.dart';

import '../../app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
          () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) =>  WelcomeView()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Images/logo.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),

          ],
        ),
      ),
    );
  }
}