import 'package:flutter/material.dart';

class BottomNavigationBarUpload extends StatelessWidget {
  final VoidCallback onNextPressed;
  final bool isLastStep;

  const BottomNavigationBarUpload({
    super.key,
    required this.onNextPressed,
    this.isLastStep = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration:const  BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26, // Shadow color
            blurRadius: 8, // Blur radius
            spreadRadius: -3, // Spread radius to limit the shadow to the top edges
            offset: Offset(0, -4), // Offset the shadow upwards
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Move to Next Step', style: 
          TextStyle(fontSize: 16,
          fontWeight: FontWeight.bold)),
          const SizedBox(width: 16), // Adjust the width as per your requirement
          ElevatedButton(
            onPressed: onNextPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00BF63), // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ensure row size fits its content
              children: [
                Text(isLastStep ? 'Next' : 'Next', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
