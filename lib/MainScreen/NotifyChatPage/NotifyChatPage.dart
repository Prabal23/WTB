import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/ChatBubbleCard/FriendChatBubbleCard/friendChatBubble.dart';
import 'package:chatapp_new/Cards/ChatBubbleCard/MyChatBubbleCard/myChatBubble.dart';
import 'package:chatapp_new/JSON_Model/ConversationModel/conversationModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class NotifyChatPage extends StatefulWidget {
  final chatID;
  final picture;
  final fn;
  final ln;
  final sender;
  final receiver;
  final userData;
  final online;
  final conType;

  NotifyChatPage(this.chatID, this.picture, this.fn, this.ln, this.sender,
      this.receiver, this.userData, this.online, this.conType);

  @override
  _NotifyChatPageState createState() => _NotifyChatPageState();
}

class _NotifyChatPageState extends State<NotifyChatPage> {
  String result = '', msg = '', date = '', st = '';
  bool loading = false;
  var convLists, body;
  int receiver = 0;
  int lastChat = 1;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  TextEditingController msgController = new TextEditingController();
  ScrollController _scrollController = new ScrollController();

  int selected;
  var now = new DateTime.now();
  DateTime _date = DateTime.now();
  List messages = [];
  List msgssList = [];
  ScrollController _controller = new ScrollController();
  SharedPreferences sharedPreferences;
  String theme = "";
  //ScrollController _scrollController;
  bool _isOnTop = true;
  bool noMsg = false;

  @override
  void initState() {
    receiver = widget.receiver;
    if (widget.userData['id'] == widget.receiver) {
      receiver = widget.sender;
    } else {
      receiver = widget.receiver;
    }
    setState(() {
      date = DateFormat("MMM dd, yyyy").format(now);
    });

    sharedPrefcheck();
    loadChatList(lastChat);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        print("${message['data']['msg']}");
        print("messages.length");
        print(messages.length);
        setState(() {
          messages.add({
            "msg": "${message['data']['msg']}",
            "sender": receiver,
            "seen": widget.userData['id'],
          });

          //lastMessages = widget.chat.msg;
          print("messages.length");
          print(messages.length);
          _scrollToBottom(messages.length - 1);
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
    //_scrollToBottom();
    super.initState();
  }

  Future<void> initialChatList() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var msgJson = localStorage.getString('messages');
    List messagesss = json.decode(msgJson);
    setState(() {
      messages = messagesss;
    });
    print(messagesss);
    print(messages);
  }

  _scrollToBottom(int index) async {
    // _scrollController.animateTo(400.0 * index,
    //     duration: Duration(milliseconds: 100), curve: Curves.easeOut);
    // setState(() => _isOnTop = false);
    if (_controller.hasClients) {
      await _controller.animateTo(
        400.0 * index,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 300),
      );
      //   //setState(() => _isOnTop = false);
    }
  }

  void sharedPrefcheck() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      theme = sharedPreferences.getString("theme");
    });
    //print(theme);
  }

  Future loadChatList(lastChat) async {
    var key = 'chat-list-${widget.chatID}';
    await _getChatData(key);

    setState(() {
      loading = true;
    });
    var response =
        await CallApi().getData('get-chat/${widget.chatID}?id=$lastChat');
    body = json.decode(response.body);

    if (response.statusCode == 200) {
      _chatListState();

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(key, json.encode(body));
    }

    print(widget.userData['id']);
  }

  Future _getChatData(key) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var localbestProductsData = localStorage.getString(key);
    if (localbestProductsData != null) {
      body = json.decode(localbestProductsData);
      _chatListState();
    }
  }

  void _chatListState() {
    List msgss = [];

    var chats = ConversationModel.fromJson(body);
    if (!mounted) return;
    setState(() {
      convLists = chats.chats;
      loading = false;

      if (convLists.length == 0) {
        noMsg = true;
      }

      for (int i = 0; i < convLists.length; i++) {
        msgss.add({
          "msg": "${convLists[i].msg}",
          "sender": convLists[i].msgSender,
          "seen": convLists[i].seen,
        });

        lastChat = convLists[0].id;
      }

      print("lastChat");
      print(lastChat);

      print("msgssList");
      print(msgssList);

      // if (msgssList.length != 0) {
      //   for (int i = 0; i < msgssList.length; i++) {
      //     messages.add({
      //       "msg": "${msgssList[i]['msg']}",
      //       "sender": msgssList[i]['sender'],
      //       "seen": msgssList[i]['seen'],
      //     });
      //   }
      // }
      for (int i = 0; i < msgssList.length; i++) {
        msgss.add({
          "msg": "${msgssList[i]['msg']}",
          "sender": msgssList[i]['sender'],
          "seen": msgssList[i]['seen'],
        });
      }

      messages = msgss;
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
        //leading: BackButton(),
        title: Container(
          margin: EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 0),
                      //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                      padding: EdgeInsets.all(1.0),
                      child: CircleAvatar(
                        radius: 16.0,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            widget.picture == "" || widget.picture == null
                                ? AssetImage('assets/images/man.png')
                                : NetworkImage("${widget.picture}"),
                      ),
                      decoration: new BoxDecoration(
                        color: Colors.grey[300], // border color
                        shape: BoxShape.circle,
                      ),
                    ),
                    widget.online == 1
                        ? Container(
                            margin: EdgeInsets.only(left: 25, bottom: 5),
                            //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                            padding: EdgeInsets.all(1.0),
                            child: CircleAvatar(
                              radius: 3.0,
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
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    //color: Colors.black.withOpacity(0.5),
                  ),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${widget.fn[0].toUpperCase() + widget.fn.substring(1)} ${widget.ln[0].toUpperCase() + widget.ln.substring(1)}",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.normal),
                      )),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[],
      ),
      body: SafeArea(
        child: new Container(
            child: Column(
          children: <Widget>[
            loading == true
                ? CircularProgressIndicator()
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        msgssList = messages;
                        print(msgssList);
                        //messages.clear();
                        loadChatList(lastChat);
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: header,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.arrow_upward,
                          size: 18,
                          color: Colors.white,
                        )),
                  ),
            Expanded(
              child: Container(
                child: ListView.builder(
                    controller: _controller,
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) => Container(
                          child: widget.userData['id'] ==
                                  messages[index]['sender']
                              ? MyChatBubble(messages[index], widget.picture)
                              : FriendChatBubble(
                                  messages[index], widget.picture),

                          ////// <<<<< Friend Chat Bubble End >>>>> //////
                        )),
              ),
            ),
            Container(
              height: 2,
              child: Divider(
                color: Colors.grey[300],
              ),
            ),

            ////// <<<<< Message Box >>>>> //////
            Container(
              color: back,
              child: Row(
                children: <Widget>[
                  ////// <<<<< Message Box Attachment Icon >>>>> //////
                  // GestureDetector(
                  //   onTap: () {
                  //     emojiPicker();
                  //   },
                  //   child: Container(
                  //     margin: EdgeInsets.only(left: 10),
                  //     child: Text(
                  //       "🙂",
                  //       style: TextStyle(fontSize: 18),
                  //     ),
                  //   ),
                  // ),

                  ////// <<<<< Message Box Text Field >>>>> //////
                  Flexible(
                    child: Container(
                      //height: 100,
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.only(
                          top: 5, left: 10, bottom: 5, right: 10),
                      decoration: BoxDecoration(
                          // borderRadius:
                          //     BorderRadius.all(Radius.circular(100.0)),
                          borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                          color: Colors.grey[100],
                          border: Border.all(
                              width: 0.5,
                              color: Colors.black.withOpacity(0.2))),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: new ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 120.0,
                              ),
                              child: new SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                reverse: true,
                                child: new TextField(
                                  maxLines: null,
                                  autofocus: false,
                                  controller: msgController,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Oswald',
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Type a message here...",
                                    hintStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w300),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        10.0, 10.0, 20.0, 10.0),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      msg = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ////// <<<<< Message Send Icon Button >>>>> //////
                  GestureDetector(
                    onTap: () {
                      chatMsg();
                      setState(() {
                        msgController.text = "";
                        messages.add({
                          "msg": "$msg",
                          "sender": widget.userData['id'],
                          "seen": 0,
                        });
                        _scrollToBottom(messages.length - 1);
                      });

                      // if (msg != '') {
                      //   int dex = messages.length;
                      //   double idex = dex.toDouble();
                      //   print(idex);
                      //   setState(() {
                      //     //messages.insert(0, msg);
                      //     messages.add(msg);
                      //     //print("success");
                      //     msgController.text = '';
                      //     st = "2";
                      //     // _scrollController.animateTo(
                      //     //   idex,
                      //     //   curve: Curves.easeOut,
                      //     //   duration: const Duration(milliseconds: 300),
                      //     // );
                      //   });
                      // } else {}
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: back, borderRadius: BorderRadius.circular(25)),
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.send,
                        color: header,
                        size: 23,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  void chatMsg() {
    if (msgController.text.isEmpty) {
      //return _showMsg("Comment field is empty");
    } else {
      chatMsgSend();
    }
  }

  Future chatMsgSend() async {
    // setState(() {
    //   loading = true;
    // });

    var data = {
      'msg': msg,
      'con_id': widget.chatID,
      'conType': widget.conType,
      'reciever': receiver,
    };

    print(data);

    var res = await CallApi().postData1(data, 'insert-chat');
    //var body = json.decode(res.body);
    var body1 = res.statusCode;
    print(body1);

    if (body1 == 200) {
      print("messages.length");
      print(messages.length);
      setState(() {
        // messages.add({
        //   "msg": "$msg",
        //   "sender": widget.userData['id'],
        //   "seen": 0,
        // });
        // lastMsg[widget.index] = msg;
        print(lastMsg);
        print("messages.length");
        print(messages.length);
      });
    } else {
      print("Something went wrong");
      //_showMsg(body['errorMessage']);
    }

    setState(() {
      loading = false;
      _scrollToBottom(messages.length - 1);
    });

    //loadChatList();
  }
}
