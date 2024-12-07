import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;
  final List<String> items;
  final String hintText;

  const CustomDropdownFormField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items.map((bathroom) {
        return DropdownMenuItem<String>(
          value: bathroom,
          child: Text(bathroom),
        );
      }).toList(),
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide:const BorderSide(
            color: Color(0xFFC3C3C3),
            width: 1)
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
    );
  }
}
