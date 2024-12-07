import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../chatApp/helper/my_date_util.dart';
import '../chatApp/models/chat_user.dart';

class ViewProfileScreenById extends StatefulWidget {
  final String userId;

  const ViewProfileScreenById({super.key, required this.userId});

  @override
  State<ViewProfileScreenById> createState() => _ViewProfileScreenByIdState();
}

class _ViewProfileScreenByIdState extends State<ViewProfileScreenById> {
  late Future<ChatUser> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = fetchUserDetails(widget.userId);
  }

  Future<ChatUser> fetchUserDetails(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userSnapshot.exists) {
        throw Exception('User not found');
      }

      Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;
      return ChatUser.fromJson(data);
    } catch (error) {
      print('Error fetching user details: $error');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChatUser>(
      future: userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.white, title: const Text('Profile')),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.white, title: const Text('Profile')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.white, title: const Text('Profile')),
            body: const Center(child: Text('User not found')),
          );
        } else {
          ChatUser user = snapshot.data!;
          return GestureDetector(
            // for hiding keyboard
            onTap: FocusScope.of(context).unfocus,
            child: Scaffold(
              //app bar
              backgroundColor: Colors.white,
              appBar:
                  AppBar(backgroundColor: Colors.white, title: Text(user.name)),

              //user about
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Joined On: ',
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                  Text(
                      MyDateUtil.getLastMessageTime(
                          context: context,
                          time: user.createdAt,
                          showYear: true),
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 15)),
                ],
              ),

              //body
              body: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .05),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // for adding some space
                      SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .03),

                      //user profile picture
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * .1),
                        child: CachedNetworkImage(
                          width: MediaQuery.of(context).size.height * .2,
                          height: MediaQuery.of(context).size.height * .2,
                          fit: BoxFit.cover,
                          imageUrl: user.image,
                          errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  child: Icon(CupertinoIcons.person)),
                        ),
                      ),

                      // for adding some space
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .03),

                      // user email label
                      Text(user.email,
                          style: const TextStyle(
                              color: Colors.black87, fontSize: 16)),

                      // for adding some space
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .02),

                      //user about
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'About: ',
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                          Text(user.about,
                              style: const TextStyle(
                                  color: Colors.black54, fontSize: 15)),
                        ],
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
