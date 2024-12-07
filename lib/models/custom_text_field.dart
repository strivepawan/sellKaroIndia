import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final int maxLines;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:const  BorderSide(
            color: Color(0xFFC3C3C3), // Side edges color
            width: 1.0, // Border width
          ),
        ),
        contentPadding: const EdgeInsets.all(16.0),
      ),
    );
  }
}
