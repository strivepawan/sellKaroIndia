import 'package:flutter/material.dart';

class MyInputTextField extends StatelessWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved; // Corrected argument type

  const MyInputTextField({
    Key? key,
    required this.labelText,
    this.validator,
    this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style:const  TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
         const  SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(),
            ),
            validator: validator,
            onSaved: onSaved,
          ),
        ],
      ),
    );
  }
}
