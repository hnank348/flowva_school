
import 'package:flowva_school/widget/button.dart';
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import '../auth/login/login_view.dart';
import '../auth/signup_view.dart';


class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});
  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/Images/logo.png', width: 110, height: 110),
                  Text(
                    "FLOWVA",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal,
                      fontFamily: 'PurplePurse',
                    ),
                  ),
                ],
              ),

              Image.asset('assets/Images/welcome.png', height: 300),

              Text(
                  "WELCOME TO FLOWVA",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Oswald'
                  )

              ),

              SizedBox(height: AppSizes.paddingMedium),

              Text(
                "Explore a unique educational world that combines creativity, knowledge, and ongoing support for your growth and success.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: AppSizes.fontSizeSubtitle,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlayfairDisplay'
                ),
              ),

             SizedBox(height:40),

             Button(text: "Login",
                 color: AppColors.primaryTeal,
                 colorText: Colors.white,
                 onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                   return LoginScreen();
                 }));}),

             SizedBox(height: AppSizes.paddingMedium),

             // Button(text: "Create an Account",
             //      color: Colors.white,
             //      colorText: AppColors.primaryTeal,
             //      colorOutline:AppColors.primaryTeal ,
             //      onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
             //        return SignUpScreen();
             //      }));}),

            ],
          ),
        ),
      ),
    );
  }
}