import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sell_karo_india/bottomFile/Like_screen.dart';
import 'package:sell_karo_india/bottomFile/account.dart';
import 'package:sell_karo_india/bottomFile/add_post.dart';
import 'package:sell_karo_india/bottomFile/chat.dart';
import 'package:sell_karo_india/homePages/home_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return WillPopScope(
      onWillPop: () async {
        if (controller.selectedIndex.value != 0) {
          controller.selectedIndex.value = 0;
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                indicatorColor: Colors.blueAccent.shade100.withOpacity(0.2),
                labelTextStyle: MaterialStateProperty.all(
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
              child: NavigationBar(
                height: 75,
                backgroundColor: Colors.white,
                elevation: 8,
                animationDuration: const Duration(milliseconds: 500),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                selectedIndex: controller.selectedIndex.value,
                onDestinationSelected: (index) {
                  controller.selectedIndex.value = index;
                },
                destinations: [
                  NavigationDestination(
                    icon: Icon(
                      Icons.house_outlined,
                      size: 30,
                      color: Colors.grey.shade600,
                    ),
                    selectedIcon: const Icon(
                      Icons.home,
                      size: 30,
                      color: Colors.blueAccent,
                    ),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.chat_bubble_outline,
                      size: 30,
                      color: Colors.grey.shade600,
                    ),
                    selectedIcon: const Icon(
                      Icons.chat,
                      size: 30,
                      color: Colors.blueAccent,
                    ),
                    label: 'Chat',
                  ),
                  NavigationDestination(
                    icon: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.green, Colors.lightGreenAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                    label: 'Add',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.favorite_border_outlined,
                      size: 30,
                      color: Colors.grey.shade600,
                    ),
                    selectedIcon: const Icon(
                      Icons.favorite,
                      size: 30,
                      color: Colors.pinkAccent,
                    ),
                    label: 'Like',
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.my_library_add_outlined,
                      size: 30,
                      color: Colors.grey.shade600,
                    ),
                    selectedIcon: const Icon(
                      Icons.my_library_add,
                      size: 30,
                      color: Colors.blueAccent,
                    ),
                    label: 'My Ads',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: controller.screen[controller.selectedIndex.value],
          ),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screen = [
    const HomeScreen(),
    const ChatBottom(),
    const AddPost(),
    LikeScreen(),
    const AccountBottom(),
  ];
}
