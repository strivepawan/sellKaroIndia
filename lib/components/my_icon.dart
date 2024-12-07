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
          borderRadius: BorderRadius.circular(8),
          boxShadow:const  [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 4, // Blur radius
              offset: Offset(0, 1), // Offset for the shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:const Color.fromARGB(232, 244, 243, 243), // Example background color
                  shape: BoxShape.circle, // Circular shape
                  border: Border.all(
                    color: Colors.white, // Border color
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(
                      iconData,
                      color: const Color(0xFF00BF63), // Icon color
                      size: 32, // Adjust the icon size as needed
                    ),
                  ),
                ),
              ),
            ),
             // Space between icon and text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                row2Text,
                style: GoogleFonts.nunito(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Example text color
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
