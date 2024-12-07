
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
        bottomNavigationBar: Obx(
          () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.house_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline),
                selectedIcon: Icon(Icons.chat),
                label: 'Chat',
              ),
              NavigationDestination(
                icon: Icon(Icons.add, size: 32, color: Colors.green),
                label: 'Post',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_border_outlined),
                selectedIcon: Icon(Icons.favorite),
                label: 'Like',
              ),
              NavigationDestination(
                icon: Icon(Icons.my_library_add_outlined),
                selectedIcon: Icon(Icons.my_library_add),
                label: 'My Ads',
              ),
            ],
          ),
        ),
        body: Obx(() => controller.screen[controller.selectedIndex.value]),
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
    const AccountBottom()
  ];
}
