import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../api/apis.dart';
import '../helper/my_date_util.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';
import 'view_profile_screen.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  void setupInteractedMessage() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.title}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _sendMessage(String message) async {
    if (_textController.text.isNotEmpty) {
      if (_list.isEmpty) {
        // Send first message logic
        APIs.sendFirstMessage(widget.user, _textController.text, Type.text);
      } else {
        // Send regular message
        APIs.sendMessage(widget.user, _textController.text, Type.text);
      }

      // Send a notification
      _sendNotification(widget.user.pushToken, _textController.text);

      _textController.text = '';
    }
  }

  void _sendNotification(String token, String message) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=YOUR_SERVER_KEY',
        },
        body: json.encode({
          "to": token,
          "notification": {
            "title": "New Message",
            "body": message,
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Notification sent');
      } else {
        print('Failed to send notification');
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }



  List<Message> _list = [];
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showEmoji = false, _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
          backgroundColor: const Color(0xFF128C7E),
          elevation: 1,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/ggggg.jpg'),
              // Replace with your image path
              fit: BoxFit.cover, // Adjust to fill the screen
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5), // Adjust the opacity here
                BlendMode.darken, // Blend mode to apply the transparency
              ),
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: APIs.getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const SizedBox();
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            _list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                controller: _scrollController,
                                reverse: true,
                                itemCount: _list.length,
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height * .01),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(message: _list[index]);
                                },
                              );
                            } else {
                              return const Center(
                                child: Text('Say Hii! 👋',
                                    style: TextStyle(fontSize: 20, color: Colors.black54)),
                              );
                            }
                        }
                      },
                    ),
                  ),
                  if (_isUploading)
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  _chatInput(),
                  if (_showEmoji)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .35,
                      child: EmojiPicker(
                        textEditingController: _textController,
                        config: Config(
                          emojiTextStyle: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _appBar() {
    return SafeArea(
      child: InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(
          stream: APIs.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * .03),
                  child: CachedNetworkImage(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.height * .05,
                    height: MediaQuery.of(context).size.height * .05,
                    fit: BoxFit.cover,
                    imageUrl: list.isNotEmpty ? list[0].image : widget.user.image,
                    errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.isNotEmpty ? list[0].name : widget.user.name,
                      style: const TextStyle(
                          fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      list.isNotEmpty
                          ? (list[0].isOnline
                          ? 'Online'
                          : MyDateUtil.getLastActiveTime(
                          context: context, lastActive: list[0].lastActive))
                          : MyDateUtil.getLastActiveTime(
                          context: context, lastActive: widget.user.lastActive),
                      style: const TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * .01,
          horizontal: MediaQuery.of(context).size.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              elevation: 2,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(Icons.emoji_emotions, color: Color(0xFF128C7E), size: 25),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
                      for (var i in images) {
                        log('Image Path: ${i.path}');
                        setState(() => _isUploading = true);
                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(Icons.attach_file, color: Color(0xFF128C7E), size: 26),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        if (_list.isEmpty) {
                          APIs.sendFirstMessage(widget.user, _textController.text, Type.text);
                        } else {
                          APIs.sendMessage(widget.user, _textController.text, Type.text);
                        }
                        _textController.text = '';
                      }
                    },
                    icon: const Icon(Icons.send, color: Color(0xFF128C7E), size: 26),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
