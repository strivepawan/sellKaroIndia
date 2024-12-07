import 'package:flutter/material.dart';

class AddTagButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddTagButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        height: 55,
        decoration: BoxDecoration(
          color: const Color(0xFF00BF63), // Background color
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black), // Adding black border
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 8, // Blur radius
              spreadRadius: -3, // Spread radius to limit the shadow to the top edges
              offset: Offset(0, -4), // Offset the shadow upwards
            ),
          ],
        ),
        child: const Center(
          child: Text('Add', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
