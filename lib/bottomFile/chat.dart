import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../chatApp/api/apis.dart';
import '../chatApp/models/chat_user.dart';
import '../chatApp/widgets/chat_user_card.dart';

class ChatBottom extends StatefulWidget {
  const ChatBottom({Key? key}) : super(key: key);

  @override
  State<ChatBottom> createState() => _ChatBottomState();
}

class _ChatBottomState extends State<ChatBottom> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains('resume')) {
        APIs.updateActiveStatus(true);
      }
      if (message.toString().contains('pause')) {
        APIs.updateActiveStatus(false);
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white, // Custom AppBar color
          leading: const Icon(CupertinoIcons.chat_bubble, color: Colors.green),
          title: _isSearching
              ? TextField(
            decoration: InputDecoration(
              hintText: localizations.searchHint,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              prefixIcon: Icon(CupertinoIcons.search, color: Colors.white),
            ),
            autofocus: true,
            style: TextStyle(fontSize: 17, color: Colors.green),
            onChanged: (val) {
              _searchList.clear();
              for (var i in _list) {
                if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                    i.email.toLowerCase().contains(val.toLowerCase())) {
                  _searchList.add(i);
                  setState(() {});
                }
              }
            },
          )
              : Text(
            localizations.chatTitle,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.green),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(
                _isSearching ? CupertinoIcons.clear_circled_solid : Icons.search,
                color: Colors.green,
              ),
            ),
          ],
        ),
        body: StreamBuilder(
          stream: APIs.getMyUsersId(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                final userIds = snapshot.data?.docs.map((e) => e.id).toList() ?? [];
                return StreamBuilder(
                  stream: APIs.getAllUsers(userIds),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          localizations.noConnections,
                            style: TextStyle(fontWeight: FontWeight.w800,fontSize: 25,color: Colors.grey),
                        ),
                      );
                    }
                    final data = snapshot.data?.docs;
                    _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                    return ListView.builder(
                      itemCount: _isSearching ? _searchList.length : _list.length,
                      padding: EdgeInsets.only(top: mediaQuery.height * .01),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ChatUserCard(
                            user: _isSearching ? _searchList[index] : _list[index],
                            onMessageSent: () {
                              setState(() {
                                // Logic to update the state
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(localizations.messageSent),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
