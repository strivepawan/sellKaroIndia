import 'package:flutter/material.dart';

class ShortenedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int maxLength; // Maximum length of characters to display

  const ShortenedText({
    Key? key,
    required this.text,
    required this.style,
    this.maxLength = 50, 
    required int maxLines, // Default value set to 12
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayedText =
        text.length <= maxLength ? text : text.substring(0, maxLength) + '...';
    return Text(
      displayedText,
      style: style,
      maxLines: 2,
    );
  }
}
