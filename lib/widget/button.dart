import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    required this.color,
    required this.colorText,
    required this.onPressed,
    this.colorOutline,
  });

  final String text;
  final Color color;
  final Color colorText;
  final Color? colorOutline;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          maximumSize: const Size(330, 50),
          side: BorderSide(
            color: colorOutline ?? color,
            width: 2,
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: colorText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}