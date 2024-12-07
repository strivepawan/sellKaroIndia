import 'package:flutter/material.dart';

class PostIcons extends StatelessWidget {
  final Function()? onTap;
  final String imagePath;
  final String text;

  const PostIcons({
    Key? key,
    required this.onTap,
    required this.imagePath,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(left: 12, top: 6, right: 12),
            decoration: BoxDecoration(
              // color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              imagePath,
              width: 80,
              height: 80,
              // color: Colors.white,
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
