import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Key key;
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final Size buttonSize;
  final Color borderColor;

  const CustomButton({
    required this.key,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.textColor,
    required this.buttonSize,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: key,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor, backgroundColor: color,
        fixedSize: buttonSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
