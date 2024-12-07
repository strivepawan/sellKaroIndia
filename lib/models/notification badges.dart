import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../bottomFile/chat.dart';
class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key});

  @override
  _NotificationIconState createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _notificationCount++;
      });
    });
  }

  void _navigateToChatScreen() {
    setState(() {
      _notificationCount = 0;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>const ChatBottom()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon:const Icon(Icons.notification_add_outlined),
          onPressed: _navigateToChatScreen,
        ),
        if (_notificationCount > 0)
          Positioned(
            right: 0,
            child: Container(
              padding:const  EdgeInsets.all(2),
              decoration: BoxDecoration(
                // color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints:const  BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Text(
                '$_notificationCount',
                style:const  TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
