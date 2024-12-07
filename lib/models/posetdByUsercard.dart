import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../chat/chat_service.dart';
import 'view_profile_user_by_id.dart';

class PostByUsercard extends StatefulWidget {
  final String catDocid;
  final String adId;

  const PostByUsercard({super.key, required this.catDocid, required this.adId});

  @override
  _PostByUsercardState createState() => _PostByUsercardState();
}

class _PostByUsercardState extends State<PostByUsercard> {
  late Future<Map<String, dynamic>> userFuture;
  late String user;

  @override
  void initState() {
    super.initState();
    userFuture = fetchUserDetails(widget.catDocid, widget.adId);
  }

  Future<Map<String, dynamic>> fetchUserDetails(String catDocid, String adId) async {
    try {
      // Fetch the ad document to get the userId
      DocumentSnapshot adSnapshot = await FirebaseFirestore.instance
          .collection('category')
          .doc(catDocid)
          .collection('ads')
          .doc(adId)
          .get();

      if (!adSnapshot.exists) {
        throw Exception('Ad not found');
      }

      user = adSnapshot['userId'];
      
      // Fetch the user document using the userId
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user)
          .get();

      if (!userSnapshot.exists) {
        throw Exception('User not found');
      }

      return userSnapshot.data() as Map<String, dynamic>;
    } catch (error) {
      print('Error fetching user details: $error');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          Map<String, dynamic> userData = snapshot.data!;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewProfileScreenById(userId: user), // Pass the userId to ViewProfileScreen
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add horizontal padding for margins
              child: Card(
                color: const Color(0xFFEBEEF7),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * .03),
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.height * .05,
                          height: MediaQuery.of(context).size.height * .05,
                          fit: BoxFit.cover,
                          imageUrl: userData['image'],
                          errorWidget: (context, url, error) => const CircleAvatar(
                            child: Icon(CupertinoIcons.person),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Posted by',
                              style: TextStyle(
                                fontSize: 14,
                                // color: Colors.white,
                              ),
                            ),
                            Text(
                              userData['name']??'',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                // color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline_outlined, color: Colors.green),
                        onPressed: () {
                          // Navigate to chat screen or perform chat action
                          SendMessage(catDocid: widget.catDocid, adId: widget.adId).sendMessage(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
