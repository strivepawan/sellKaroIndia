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
        appBar: AppBar(
          leading: const Icon(CupertinoIcons.chat_bubble),
          title: _isSearching
              ? TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: localizations.searchHint),
                  autofocus: true,
                  style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                  onChanged: (val) {
                    _searchList.clear();
                    for (var i in _list) {
                      if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                          i.email.toLowerCase().contains(val.toLowerCase())) {
                        _searchList.add(i);
                        setState(() {
                          _searchList;
                        });
                      }
                    }
                  },
                )
              : Text(localizations.chatTitle),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              },
              icon: Icon(
                _isSearching ? CupertinoIcons.clear_circled_solid : Icons.search,
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
                          style: const TextStyle(fontSize: 20),
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
                        return ChatUserCard(
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
