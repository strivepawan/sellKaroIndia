import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../chatApp/api/apis.dart';
import '../../chatApp/models/chat_user.dart';
import '../../chatApp/screens/chat_screen.dart';

class SendMessage extends StatelessWidget {
  final String catDocid;
  final String adId;

  const SendMessage({Key? key, required this.catDocid, required this.adId}) : super(key: key);

  Future<void> sendMessage(BuildContext context) async {
    try {
      final adDetails = await APIs.getAdDetails(catDocid, adId);

      if (adDetails != null) {
        final postedUserCard = adDetails['userId'];

        if (postedUserCard == null) {
          print('Error: postedUserCard is null');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: postedUserCard is not available')),
          );
          return;
        }

        if (postedUserCard is String) {
          // Fetch user details from Firestore using the userId
          final userSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(postedUserCard)
              .get();

          if (userSnapshot.exists) {
            // Convert the fetched user details into a ChatUser object
            final userData = userSnapshot.data();
            final chatUser = ChatUser.fromJson(userData!);

            // Add the chat user to the sender's my_users collection
            final isAdded = await APIs.addChatUser(chatUser.email);
            if (!isAdded) {
              print('Error: Failed to add chat user to my_users');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error: Failed to add chat user')),
              );
              return;
            }

            // Navigate to the ChatScreen with the ChatUser object
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(user: chatUser),
              ),
            );
          } else {
            print('Error: User with userId $postedUserCard does not exist');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: User does not exist')),
            );
          }
        } else if (postedUserCard is Map<String, dynamic>) {
          // Convert the postedUserCard map directly into a ChatUser object
          final chatUser = ChatUser.fromMap(postedUserCard);

          // Add the chat user to the sender's my_users collection
          final isAdded = await APIs.addChatUser(chatUser.email);
          if (!isAdded) {
            print('Error: Failed to add chat user to my_users');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: Failed to add chat user')),
            );
            return;
          }

          // Navigate to the ChatScreen with the ChatUser object
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(user: chatUser),
            ),
          );
        } else {
          print('Error: postedUserCard is not a valid type');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: postedUserCard is not a valid type')),
          );
        }
      } else {
        print('Error: adDetails is null');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Failed to fetch ad details')),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => sendMessage(context),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
      ),
      child: const Text(
        'Send Message',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
