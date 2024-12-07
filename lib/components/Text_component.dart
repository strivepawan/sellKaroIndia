import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class TextComponent extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final IconData iconData; // Icon data for FontAwesomeIcon

  const TextComponent({
    super.key,
    required this.text,
    this.onTap,
    required this.iconData, // Required icon data parameter
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center align the content
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xE8F7FFFF), // Example background color
              shape: BoxShape.circle, // Circular shape
              border: Border.all(
                color: Colors.white, // Border color
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FaIcon(
                iconData,
                color:const Color(0xFF00BF63), // Icon color
                size: 32, // Adjust the icon size as needed
              ),
            ),
          ),
          const SizedBox(height: 8), // Space between icon and text
          Text(
            text,
            style:GoogleFonts.nunito(
              textStyle:const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Example text color
            ),
            )
          ),
        ],
      ),
    );
  }
}
