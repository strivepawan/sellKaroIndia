import 'package:flutter/material.dart';



class NumberedInputTextField extends StatelessWidget {
  final int number;
  final String labelText;

  const NumberedInputTextField({
    Key? key,
    required this.number,
    required this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$number.',
              style:const  TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Divider(
                thickness: 1,
                color: Colors.black,
              ),
            ),
          ],
        ),
        
      ],
    );
  }
}
