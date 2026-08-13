import 'package:flowva_school/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app_localizations.dart';
import '../../../app_theme.dart';
import '../../../cubit/locale/locale_cubit.dart';
import '../../../cubit/locale/locale_state.dart';
import '../login/login_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        final localeCubit = context.read<LocaleCubit>();

        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLarge,
                vertical: AppSizes.paddingSmall,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/Images/logo.png',
                            width: 65,
                            height: 65,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "FLOWVA",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTeal,
                              fontFamily: 'PurplePurse',
                            ),
                          ),
                        ],
                      ),

                      // 🌐 زر تغيير اللغة بعد إصلاح شرط المقارنة
                      InkWell(
                        onTap: () {
                          final currentLang = localeState.currentLanguage.toString().toUpperCase();

                          if (currentLang.contains('AR')) {
                            localeCubit.changeLanguage('EN'); // 👈 حروف كبيرة
                          } else {
                            localeCubit.changeLanguage('AR'); // 👈 حروف كبيرة
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryTeal.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primaryTeal.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.language_rounded,
                                size: 18,
                                color: AppColors.primaryTeal,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                context.tr('welcome_lang_switch'),
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  Image.asset('assets/Images/welcome.png', height: 280),

                  const SizedBox(height: 16),

                  Text(
                    context.tr('welcome_title'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oswald',
                      color: AppColors.primaryText,
                    ),
                  ),

                  const SizedBox(height: AppSizes.paddingMedium),

                  Text(
                    context.tr('welcome_subtitle'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: AppSizes.fontSizeSubtitle,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PlayfairDisplay',
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 36),

                  Button(
                    text: context.tr('welcome_btn_login'),
                    color: AppColors.primaryTeal,
                    colorText: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppSizes.paddingMedium),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}