// import 'package:flutter/material.dart';

// class MyBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const MyBottomNavigationBar({
//     Key? key,
//     required this.currentIndex,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: const BorderRadius.all(Radius.circular(22)),
//           border: Border.all(color: Colors.black),
//           // Set the border color here
//         ),
//         child: ClipRRect(
//           borderRadius: const BorderRadius.all(Radius.circular(22)),
//           child: Container(
//             decoration: const ShapeDecoration(
//               color: Color(0xFF9EA8FF),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(22)),
//               ),
//             ),
//             child: BottomNavigationBar(
//               type: BottomNavigationBarType.fixed,
//               items:  <BottomNavigationBarItem>[
//               const  BottomNavigationBarItem(
//                   icon: Icon(Icons.home),
//                   label: 'Home',
//                 ),
//                 const  BottomNavigationBarItem(
//                   icon: Icon(Icons.chat),
//                   label: 'Chat',
//                 ),
//                 // Custom widget for the "Post Add" item
//                BottomNavigationBarItem(
//                   icon: Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.green, // Set the background color for the "Post Add" item
//                       // shape: BoxShape.circle,
//                     ),
//                     child: Icon(Icons.add,size: 32 ,), // Change icon color based on selection
//                   ),
//                   label: 'Post Add',
//                   backgroundColor: Colors.transparent,
//                 ),
//                 const  BottomNavigationBarItem(
//                   icon: Icon(Icons.person),
//                   label: 'Account',
//                 ),
//                 const BottomNavigationBarItem(
//                   icon: Icon(Icons.more),
//                   label: 'More',
//                 ),
//               ],
//               currentIndex: currentIndex,
//               selectedItemColor: Colors.black,
//               unselectedItemColor: Colors.black,
//               onTap: onTap,
//               backgroundColor: Colors.transparent,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
