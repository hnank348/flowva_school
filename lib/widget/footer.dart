import 'package:flutter/material.dart';
import '../app_theme.dart';

class Footer extends StatelessWidget {
  final String leadingText;
  final String actionText;
  final VoidCallback onPressed;

  final Color backgroundColor;
  final Color textColor;
  final Color dividerColor;

  const Footer({
    super.key,
    required this.leadingText,
    required this.actionText,
    required this.onPressed,
    this.backgroundColor = AppColors.primaryTeal,
    this.textColor = Colors.white,
    this.dividerColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(color: dividerColor, thickness: 1, height: 0),
        Container(
          color: backgroundColor,
          width: double.infinity,
          child: TextButton(
            onPressed: onPressed,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: leadingText,
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                  TextSpan(
                    text: actionText,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}