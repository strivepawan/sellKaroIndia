import 'package:flutter/material.dart';

class ButtonSpecial extends StatelessWidget {
  final Function()? onTap;
  final String text;

    const ButtonSpecial({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding:const EdgeInsets.only(left: 8,right: 8,top: 18),
            // margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // color:const Color(0xFFE4E7FF),
              borderRadius: BorderRadius.circular(20),
              // border: Border.all(
              //   color: Colors.blue,
                
              // )
              
              ),
            child: Text(text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
             style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16),),
          ),
        ],
      ),
    );
  }
}