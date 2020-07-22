import 'dart:convert';
import 'dart:math';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/ChatCard/chatCard.dart';
import 'package:chatapp_new/JSON_Model/ChatListModel/chatListModel.dart';
import 'package:chatapp_new/Loader/ChatListLoader/chatListLoder.dart';
import 'package:chatapp_new/Loader/ChatLoader/chatLoader.dart';
import 'package:chatapp_new/MainScreen/AllFriendsPage/allFriendsPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../main.dart';
import 'ChattingPage/chattingPage.dart';
import 'dart:async';

class ChatPage extends StatefulWidget {
  final userData;
  ChatPage(this.userData);
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  String theme = "", lMsg = "";
  bool loading = false;
  bool isSeen = false;
  var chatLists, body;
  List chats = [];
  int conId = 0;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    loadChatList();
    lastMsg.clear();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        setState(() {
          lastMessages = message['data']['msg'];
        });
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
    super.initState();
  }

  Future loadChatList() async {
    var key = 'chat-list-user';
    await _getChatListData(key);

    setState(() {
      loading = true;
    });
    var response = await CallApi().getData2('get-chat-listing');
    body = json.decode(response.body);

    if (response.statusCode == 200) {
      _chatListState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }
    // var content = response.body;
    // final collection = json.decode(content);
    // var data = ChatListModel.fromJson(collection);

    //await Future.delayed(Duration(seconds: 3));

    setState(() {
      // chatLists = data;
      // loading = false;

      // for (int i = 0; i < chatLists.lists.length; i++) {
      //   chats.add({
      //     "id": chatLists.lists[i].id,
      //     "msg": chatLists.lists[i].msg,
      //     "fName": chatLists.lists[i].firstName,
      //     "lName": chatLists.lists[i].lastName,
      //     "proPic": chatLists.lists[i].profilePic,
      //     "msgSender": chatLists.lists[i].msgSender,
      //     "conversation": [],
      //   });
      // }
    });
    //print(chatLists.lists.length);
  }

  Future _getChatListData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localbestProductsData = localStorage.getString(key);
    if (localbestProductsData != null) {
      body = json.decode(localbestProductsData);
      _chatListState();
    }
  }

  void _chatListState() {
    var chats = ChatListModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      chatLists = chats.lists;
      loading = false;
      lastMsg = [];
      lastSeen = [];

      for (int i = 0; i < chatLists.length; i++) {
        lastMsg.add(chatLists[i].msg);
        if (chatLists[i].msgSender == widget.userData['id']) {
          isSeen = false;
        } else if (chatLists[i].msgSender != widget.userData['id']) {
          if (chatLists[i].seen == 0) {
            isSeen = false;
          } else {
            isSeen = true;
          }
        }
        lastSeen.add(isSeen);
      }

      print("lastMsg");
      print(lastMsg);
      print("lastSeen");
      print(lastSeen);
    });

    // print(productsData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Container(
          margin: EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    //color: Colors.black.withOpacity(0.5),
                  ),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Chat",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.normal),
                      )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AllFriendsPage()));
                },
                child: Container(
                    margin: EdgeInsets.only(right: 0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        // Container(
                        //   margin: EdgeInsets.only(right: 3),
                        //   child: Text(
                        //     "Edit",
                        //     style: TextStyle(
                        //         color: header,
                        //         fontSize: 15,
                        //         fontFamily: 'Oswald',
                        //         fontWeight: FontWeight.normal),
                        //   ),
                        // ),
                        Icon(Icons.person_add, color: header, size: 22)
                      ],
                    )),
              ),
            ],
          ),
        ),
        actions: <Widget>[],
      ),
      body: chatLists == null
          ? ChatListLoader()
          : CustomScrollView(
              slivers: <Widget>[
                chatLists.length == 0
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height,
                            child: Text("No Chats Available!"),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return ChatCard(
                              widget.userData, chatLists[index], index);
                        }, childCount: chatLists.length),
                      ),
              ],
            ),
    );
  }
}
