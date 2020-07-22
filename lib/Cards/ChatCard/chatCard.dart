import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/ChatListModel/chatListModel.dart';
import 'package:chatapp_new/MainScreen/ChatPage/ChattingPage/chattingPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

String lastMessages = "";

class ChatCard extends StatefulWidget {
  final userData;
  final chat;
  final index;
  ChatCard(this.userData, this.chat, this.index);
  @override
  _ChatCardState createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  int index = 0, senderID = 0;
  bool isLoading = false;
  bool isSeen = false;
  var chatLists;
  String lastMsgs = "", daysAgo = "";

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    //print(widget.userData['id']);
    if (widget.chat.profilePic.contains("localhost")) {
      widget.chat.profilePic =
          widget.chat.profilePic.replaceAll("localhost", "http://10.0.2.2");
    } else {
      widget.chat.profilePic = widget.chat.profilePic;
    }

    setState(() {
      lastMessages = "${widget.chat.msg}";
      DateTime date1 = DateTime.parse("${widget.chat.createdAt}");

      daysAgo = DateFormat.yMMMd().format(date1);

      isSeen = lastSeen[widget.index];
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //_showItemDialog(message);
        print("${message['data']['msg']}");
        setState(() {
          String sender = "${message['data']['con_id']}";
          senderID = int.parse(sender);
          print(senderID);
          lastMsgs = message['data']['msg'];
          isSeen = true;

          print("lastMsgs");
          print(lastMsgs);
          //print("msg:" + lastMessages);
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSeen) {
            chatUnseenNum--;
            if (chatUnseenNum != 0) {
              chatUnseenNum--;
              if (chatUnseenNum < 0) {
                chatUnseenNum = 0;
              }
            }
          }
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChattingPage(
                    widget.chat,
                    widget.chat.id,
                    widget.chat.sender,
                    widget.chat.reciever,
                    widget.userData,
                    widget.index)));
      },
      child: Column(
        children: <Widget>[
          ////// <<<<< Divider 1 >>>>> //////
          widget.index == 0
              ? Container()
              : Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 0, left: 65, right: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.grey[350],
                      border: Border.all(width: 0.1, color: Colors.grey[350]))),
          Container(
            padding: EdgeInsets.only(top: 0, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              //border: Border.all(width: 0.8, color: Colors.grey[300]),
              // boxShadow: [
              //   BoxShadow(
              //     blurRadius: 16.0,
              //     color: Colors.grey[300],
              //     //offset: Offset(3.0, 4.0),
              //   ),
              // ],
            ),
            margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    //color: Colors.red,
                    margin: EdgeInsets.only(left: 5, right: 10, top: 5),
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Container(
                        //   margin: EdgeInsets.only(right: 10, top: 5),
                        //   //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                        //   padding: EdgeInsets.all(1.0),
                        //   child: CircleAvatar(
                        //     radius: 20.0,
                        //     backgroundColor: Colors.white,
                        //     backgroundImage: widget.chat.profilePic == "" ||
                        //             widget.chat.profilePic == null
                        //         ? AssetImage('assets/images/man.png')
                        //         : NetworkImage("${widget.chat.profilePic}"),
                        //   ),
                        //   decoration: new BoxDecoration(
                        //     color: Colors.grey[300], // border color
                        //     shape: BoxShape.circle,
                        //   ),
                        // ),
                        Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10, top: 0),
                              height: 52,
                              width: 52,
                              //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                              padding: EdgeInsets.all(5.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl: "${widget.chat.profilePic}",
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Image.asset("assets/images/user.png",
                                          fit: BoxFit.cover),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            widget.chat.isOnline == 1
                                ? Container(
                                    margin: EdgeInsets.only(left: 35, top: 5),
                                    //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                    padding: EdgeInsets.all(1.0),
                                    child: CircleAvatar(
                                      radius: 4.0,
                                      backgroundColor: Colors.greenAccent,
                                      //backgroundImage: AssetImage('assets/user.png'),
                                    ),
                                    decoration: new BoxDecoration(
                                      color: Colors.greenAccent, // border color
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${widget.chat.firstName[0].toUpperCase() + widget.chat.firstName.substring(1)} ${widget.chat.lastName[0].toUpperCase() + widget.chat.lastName.substring(1)}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'Oswald',
                                    fontWeight: isSeen
                                        ? FontWeight.w600
                                        : FontWeight.w300),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 3),
                                child: Text(
                                  lastMsgs == ""
                                      ? widget.userData['id'] ==
                                                  widget.chat.msgSender ||
                                              widget.userData['id'] == senderID
                                          ? "${lastMsg[widget.index]}"
                                          : "${lastMsg[widget.index]}"
                                      : "$lastMsgs",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                      color: isSeen
                                          ? Colors.black87
                                          : Colors.black45),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 15, top: 10),
                      child: Text(
                        daysAgo,
                        style: TextStyle(
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: Colors.black45),
                      ),
                    ),
                    isSeen
                        ? Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                                color: header,
                                borderRadius: BorderRadius.circular(5)),
                            margin: EdgeInsets.only(right: 20, top: 15),
                          )
                        : Container(
                            padding: EdgeInsets.only(
                                left: 5, right: 5, top: 2, bottom: 2),
                            margin: EdgeInsets.only(right: 20, top: 20),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
