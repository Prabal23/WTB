import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/FriendReqModel/friendReqModel.dart';
import 'package:chatapp_new/MainScreen/BottomNavigationPage/AllShopPage/AllShopPage.dart';
import 'package:chatapp_new/MainScreen/BottomNavigationPage/FeedPage/feedPage.dart';
import 'package:chatapp_new/MainScreen/BottomNavigationPage/FriendsPage/friendsPage.dart';
import 'package:chatapp_new/MainScreen/BottomNavigationPage/MarketplacePage/marketplacePage.dart';
import 'package:chatapp_new/MainScreen/BottomNavigationPage/MorePage/morePage.dart';
import 'package:chatapp_new/MainScreen/ChatPage/chatPage.dart';
import 'package:chatapp_new/MainScreen/CheckPage/CheckPage.dart';
import 'package:chatapp_new/MainScreen/NotifyPage/notifyPage.dart';
import 'package:chatapp_new/MainScreen/SearchPage/searchPage.dart';
import 'package:chatapp_new/MainScreen/StatusDetailsPage/StatusDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:adhara_socket_io/adhara_socket_io.dart';
import '../../main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class MyHomePage extends StatefulWidget {
  final page;
  MyHomePage(this.page);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final pageOptions = [
    FeedPage(),
    FriendsPage(),
    //GroupPage(),
    MarketplacePage(),
    AllShopPage(),
    MorePage(),
  ];

  //bool isLoading = false;
  var userData;
  int id = 0;
  int currentIndex = selectedPage;
  //SocketIOManager manager;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    //firebaseCheck();
    _getUserInfo();
    setState(() {
      currentIndex = widget.page;
    });
    //manager = SocketIOManager();
    getSocketIO();
    loadRequests();
    showUser();
    super.initState();
  }

  Future loadRequests() async {
    var reqresponse = await CallApi().getData2('get/friend');
    var reqcontent = reqresponse.body;
    final req = json.decode(reqcontent);
    var reqdata = FriendReqModel.fromJson(req);
    //print(reqdata);

    setState(() {
      reqList = reqdata;
      frndNum = reqList.pending.length;
      //page2 = 1;
    });
  }

  void _getUserInfo() async {
    // setState(() {
    //  isLoading = true;
    // });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
      id = userData['id'];
      //isLoading = false;
    });

    //print("${userData['shop_id']}");
  }

  void getSocketIO() async {
    // SocketIO socket = await manager.createInstance(SocketOptions(
    //     //Socket IO server URI
    //     // 'https://www.dynamyk.biz/',
    //     'http://10.0.2.2:8080/',
    //     nameSpace: "/",
    //     //Query params - can be used for authentication
    //     // query: {
    //     //   "auth": "--SOME AUTH STRING---",
    //     //   "info": "new connection from adhara-socketio",
    //     //   "timestamp": DateTime.now().toString()
    //     // },
    //     //Enable or disable platform channel logging
    //     enableLogging: false,
    //     transports: [
    //       Transports.WEB_SOCKET /*, Transports.POLLING*/
    //     ] //Enable required transport
    //     ));
    // socket.onConnect((data) {
    //   print("connected...");
    //   print(data);
    //   // sendMessage(identifier);
    //   // socket.emit("send-request", [
    //   //   {"msg": "new message"}
    //   // ]);
    // });

    // print("receive_friend_request_user_$id");
    // socket.on("receive_friend_request_user_$id", (data) {
    //   print("response");
    //   print(data);
    //   setState(() {
    //     pagess = data.toString();
    //   });
    // });
    // socket.connect();

    //sockets[driverId.toString()] = socket;
  }

  Future showUser() async {
    //await Future.delayed(Duration(seconds: 3));
    var postresponse = await CallApi().getData2('initData');
    var postcontent = postresponse.body;
    final body = json.decode(postcontent);
    print(body['user']);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('user', json.encode(body['user']));

    setState(() {
      chatUnseenNum = body['msgNotiCount'];
      notifyNum = body['noti'];
    });

    print("chatUnseenNum");
    print(chatUnseenNum);
  }

  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<bool> _onWillPop() async {
    return (SystemChannels.platform.invokeMethod('SystemNavigator.pop')) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        //backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          //iconTheme: IconThemeData(color: header),
          //elevation: 1,
          automaticallyImplyLeading: false,
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
                          "Tradister",
                          style: TextStyle(
                              color: header,
                              fontSize: 17,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.normal),
                        )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );

                    //_showMsg("Coming Soon");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        //color: sub_white,
                        borderRadius: BorderRadius.circular(15)),
                    margin: EdgeInsets.only(right: 10),
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.search,
                      color: Colors.black45.withOpacity(0.4),
                      size: 18,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotifyPage()),
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            //color: sub_white,
                            borderRadius: BorderRadius.circular(15)),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.black45.withOpacity(0.4),
                          size: 18,
                        ),
                      ),
                      notifyNum == 0
                          ? Container()
                          : Container(
                              padding: EdgeInsets.only(
                                  top: 1, bottom: 1, right: 5, left: 5),
                              margin: EdgeInsets.only(right: 10, left: 20),
                              decoration: BoxDecoration(
                                  color: header,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                "$notifyNum",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatPage(userData)),
                    );
                    //_showMsg("Coming Soon");
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            //color: sub_white,
                            borderRadius: BorderRadius.circular(15)),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.chat,
                          color: Colors.black45.withOpacity(0.4),
                          size: 18,
                        ),
                      ),
                      chatUnseenNum == 0
                          ? Container()
                          : Container(
                              padding: EdgeInsets.only(
                                  top: 1, bottom: 1, right: 5, left: 5),
                              margin: EdgeInsets.only(right: 0, left: 20),
                              decoration: BoxDecoration(
                                  color: header,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                "$chatUnseenNum",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[],
        ),
        //body: Text("lol")
        body: pageOptions[currentIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
              primaryColor: header,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.grey[500]))),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 20), title: SizedBox.shrink()),
              BottomNavigationBarItem(
                  icon: new Stack(children: <Widget>[
                    frndNum != 0
                        ? Container(
                            margin: EdgeInsets.only(top: 5, right: 17),
                            child: new Icon(
                              Icons.group,
                              size: 20,
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 5, right: 0),
                            child: new Icon(
                              Icons.group,
                              size: 20,
                            ),
                          ),
                    frndNum == 0
                        ? Positioned(
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 1, bottom: 1, right: 5, left: 5),
                              margin: EdgeInsets.only(
                                  right: 0, left: 0, bottom: 10),
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                          )
                        : Positioned(
                            left: 9,
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 1, bottom: 1, right: 5, left: 5),
                              margin: EdgeInsets.only(
                                  right: 0, left: 0, bottom: 10),
                              decoration: BoxDecoration(
                                  color: header,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                frndNum.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )
                  ]),
                  title: SizedBox.shrink()),
              // BottomNavigationBarItem(
              //     icon: Icon(Icons.supervised_user_circle, size: 20),
              //     title: SizedBox.shrink()),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart, size: 20),
                  title: SizedBox.shrink()),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_basket, size: 20),
                  title: SizedBox.shrink()),
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu, size: 20), title: SizedBox.shrink())
            ],
            onTap: (int _selectedPage) {
              setState(() {
                currentIndex = _selectedPage;
                selectedPage = _selectedPage;

                if (currentIndex == 1) {
                  frndNum = 0;
                }
              });
              //print(selectedPage);
            },
          ),
        ),
      ),
    );
  }
}
