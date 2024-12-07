import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MyIcon extends StatelessWidget {
  final Function()? onTap;
  final String row2Text;
  final IconData iconData;

  const MyIcon({
    super.key,
    required this.onTap,
    required this.iconData,
    required this.row2Text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: const [
            BoxShadow(
              color: Colors.black12, // Softer shadow
              blurRadius: 8, // Larger blur radius for smoother shadow
              offset: Offset(0, 4), // Slight offset for depth effect
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0), // Padding around the icon
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F8), // Soft background color
                  shape: BoxShape.circle, // Circular shape
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey, // Shadow color
                      blurRadius: 4, // Soft shadow
                      offset: Offset(2, 2), // Shadow offset
                    ),
                  ],
                ),
                child: Center(
                  child: FaIcon(
                    iconData,
                    color: const Color(0xFF00BF63), // Icon color
                    size: 36, // Increased icon size for better visual balance
                  ),
                ),
              ),
            ),
            // Space between icon and text
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                row2Text,
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                    fontSize: 16, // Increased text size for better visibility
                    fontWeight: FontWeight.w600, // Slightly bolder text
                    color: Colors.black87, // Darker color for text contrast
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
