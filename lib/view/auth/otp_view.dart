import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app_theme.dart';
import '../../../widget/button.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});
  static const String routeName = 'otp-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
          child: Column(
            children: [
              const Spacer(flex: 2),

              const Text(
                "Verification Code",
                style: TextStyle(
                  color: AppColors.primaryTeal,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PurplePurse',
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "The verification code has been sent to you successfully. Use it here.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: AppSizes.fontSizeSubtitle,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlayfairDisplay',
                ),
              ),

              const SizedBox(height: 40),

              // مربعات الـ OTP الأربعة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOtpBox(context, first: true, last: false),
                  _buildOtpBox(context, first: false, last: false),
                  _buildOtpBox(context, first: false, last: false),
                  _buildOtpBox(context, first: false, last: true),
                ],
              ),

              const SizedBox(height: 40),

              Button(
                text: "VERIFY",
                color: AppColors.primaryTeal,
                colorText: Colors.white,
                onPressed: () {
                  // منطق التحقق من الرمز
                },
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(BuildContext context, {required bool first, required bool last}) {
    return SizedBox(
      height: 70,
      width: 65,
      child: TextField(
        autofocus: true,
        onChanged: (value) {
          if (value.length == 1 && last == false) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && first == false) {
            FocusScope.of(context).previousFocus();
          }
        },
        showCursor: false,
        readOnly: false,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryTeal),
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: Colors.black12),
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 2, color: AppColors.primaryTeal),
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}