import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/Feed_post_Model/feedPost_model.dart';
import 'package:chatapp_new/JSON_Model/FriendPostModel/FriendPostModel.dart';
import 'package:chatapp_new/JSON_Model/POST_Model/post_model.dart';
import 'package:chatapp_new/JSON_Model/User_Model/user_Model.dart';
import 'package:chatapp_new/MainScreen/ChatPage/ChattingPage/chattingPage.dart';
import 'package:chatapp_new/MainScreen/ChatPage/chatPage.dart';
import 'package:chatapp_new/MainScreen/FriendProfileCommentPage/FriendProfileCommentPage.dart';
import 'package:chatapp_new/MainScreen/HomePage/homePage.dart';
import 'package:chatapp_new/MainScreen/ProfileCommentPage/ProfileCommentPage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/MyProfilePage/myProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
//import 'package:adhara_socket_io/adhara_socket_io.dart';
import '../../../main.dart';

List fprofileComCount = [];

class FriendsProfilePage extends StatefulWidget {
  final userName;
  final no;
  FriendsProfilePage(this.userName, this.no);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<FriendsProfilePage> {
  SharedPreferences sharedPreferences;
  String theme = "", statusPic = "", result = "";
  bool loading = true;
  bool _isLoading = false;
  var conList, postList;
  List<String> allPic = [];
  int id = 0;
  int _current = 0;
  var userData;
  String des = "",
      about = "",
      dos = "",
      donts = "",
      sharePost = "",
      status = "Public";
  String firstHalf, firstAbout, daysAgo;
  String secondHalf, secondAbout;
  bool flag = true,
      view = true,
      isFollow = false,
      isFriend = false,
      isCancel = false;
  bool isSubmit = false;
  bool isPressed = false;
  bool isCancelPressed = false;
  List imagePost = [];
  //SocketIOManager manager;
  TextEditingController reasonController = new TextEditingController();
  TextEditingController chatController = new TextEditingController();

  @override
  void initState() {
    setState(() {
      fprofileComCount.clear();
    });
    _getUserInfo();
    loadConnection();
    //isChat();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    setState(() {
      userData = user;
      id = userData['id'];
      print(id);
    });
  }

  Future loadConnection() async {
    //await Future.delayed(Duration(seconds: 3));

    var response =
        await CallApi().getData('profile/${widget.userName}?tab=connection');
    var content = response.body;
    final collection = json.decode(content);
    var data = Connection.fromJson(collection);

    setState(() {
      conList = data;

      // if (conList.user.isFriend == null && conList.user.isRequestSent == null) {
      //   isFriend = false;
      //   isCancel = false;
      // } else if (conList.user.isFriend == null &&
      //     conList.user.isRequestSent != null) {
      //   if (conList.user.isRequestSent.status == 1) {
      //     isFriend = false;
      //     isCancel = true;
      //   } else {
      //     isFriend = false;
      //     isCancel = false;
      //   }
      // } else if (conList.user.isFriend != null &&
      //     conList.user.isRequestSent != null) {
      //   if (conList.user.isRequestSent.status != 2) {
      //     isFriend = true;
      //     isCancel = true;
      //   } else {
      //     isFriend = true;
      //     isCancel = false;
      //   }
      // } else {
      //   isFriend = true;
      //   isCancel = false;
      // }

      if (conList.user.isFriend == null) {
        if (conList.user.isRequestSent == null) {
          isFriend = false;
          isCancel = false;
        } else if (conList.user.isRequestSent != null) {
          if (conList.user.isRequestSent.status == 1) {
            if (id == conList.user.isRequestSent.following_id) {
              isFriend = true;
              isCancel = true;
            } else {
              isFriend = false;
              isCancel = true;
            }
          } else if (conList.user.isRequestSent.status == 2) {
            isFriend = true;
            isCancel = false;
          }
        }
      } else {
        isFriend = true;
        isCancel = false;
      }
      loading = false;
    });

    if (conList.user.profilePic.contains("localhost")) {
      conList.user.profilePic =
          conList.user.profilePic.replaceAll("localhost", "http://10.0.2.2");
    }

    loadPosts();
  }

  Future loadPosts() async {
    //await Future.delayed(Duration(seconds: 3));

    var postresponse =
        await CallApi().getData('profile/${widget.userName}?tab=post');
    var postcontent = postresponse.body;
    final posts = json.decode(postcontent);
    var postdata = FriendPostModel.fromJson(posts);

    setState(() {
      postList = postdata;
      allPic = [];
      for (int i = 0; i < postList.res.length; i++) {
        fprofileComCount
            .add({'count': postList.res[i].meta.totalCommentsCount});
      }
      loading = false;
    });
  }

  Future<Null> _showFriendDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 0, right: 10, top: 0),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey, width: 0.2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  result = value;
                                },
                                controller: reasonController,
                                autofocus: true,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'Oswald',
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      "Let the user know why you want to connect",
                                  hintStyle: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 15,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w300),
                                  //labelStyle: TextStyle(color: Colors.white70),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10.0, 0, 20.0, 0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        )),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 0, right: 5, top: 20, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey, width: 0.2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17,
                                      fontFamily: 'BebasNeue',
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                connectUser();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 5, right: 0, top: 20, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: header,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Text(
                                    "Connect",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'BebasNeue',
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future connectUser() async {
    setState(() {
      _isLoading = true;
      isPressed = true;
    });

    if (reasonController.text.isEmpty) {
      return _showMsg("Please enter a reason to connect");
    } else {
      var data = {
        'following_id': conList.user.id,
        'reason': result,
        //'title': 'Tradister',
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      };
      print(data);

      var res = await CallApi().postData1(data, 'add/friend');
      var body = json.decode(res.body);

      setState(() {
        if (res.statusCode == 200) {
          isCancel = true;
        } else {
          //_showMsg("Something went wrong!");
        }
        isPressed = false;
      });

      print(body);
    }

    setState(() {
      _isLoading = false;
    });
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

  Future<Null> _removeFriendDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 0, right: 10, top: 0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  result = value;
                                },
                                controller: reasonController,
                                autofocus: false,
                                enabled: false,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'Oswald',
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      "Do you want to remove from friend list?",
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w300),
                                  //labelStyle: TextStyle(color: Colors.white70),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10.0, 0, 20.0, 0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        )),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 0, right: 5, top: 20, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey, width: 0.2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Text(
                                    "NO",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17,
                                      fontFamily: 'BebasNeue',
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                removeUser();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 5, right: 0, top: 20, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: header,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Text(
                                    "YES",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'BebasNeue',
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future removeUser() async {
    setState(() {
      _isLoading = true;
      isPressed = true;
    });

    var data = {
      'id': conList.user.isFriend.id,
      'op': 2,
    };
    print(data);

    var res = await CallApi().postData1(data, 'remove/friend');
    var body = json.decode(res.body);

    print("body");
    print(body);

    setState(() {
      if (res.statusCode == 200) {
        isFriend = false;
        isPressed = false;
      }
      _isLoading = false;
    });
  }

  Future<Null> _cancelFriendDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 0, right: 10, top: 0),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  result = value;
                                },
                                controller: reasonController,
                                autofocus: false,
                                enabled: false,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'Oswald',
                                ),
                                decoration: InputDecoration(
                                  hintText: "Do you want to cancel request?",
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w300),
                                  //labelStyle: TextStyle(color: Colors.white70),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10.0, 0, 20.0, 0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        )),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 0, right: 5, top: 20, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey, width: 0.2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Text(
                                    "NO",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17,
                                      fontFamily: 'BebasNeue',
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                cancelUser();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 5, right: 0, top: 20, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: header,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Text(
                                    "YES",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'BebasNeue',
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future cancelUser() async {
    setState(() {
      _isLoading = true;
      isPressed = true;
    });

    var data = {
      'id': conList.user.id,
      'status': 4,
    };
    print(data);

    var res = await CallApi().postData1(data, 'accept/friend');
    var body = json.decode(res.body);

    print("body");
    print(body);

    setState(() {
      if (res.statusCode == 200) {
        isCancel = false;
        isPressed = false;
      }
      _isLoading = false;
    });
  }

  Future acceptReq() async {
    setState(() {
      isPressed = true;
    });
    var data = {
      'status': 2,
      'id': conList.user.isRequestSent.id,
    };

    print(data);

    var res = await CallApi().postData1(data, 'accept/friend');
    var body = json.decode(res.body);

    print(body);

    if (res.statusCode == 200) {
      setState(() {
        isFriend = true;
        isCancel = false;
        isPressed = false;
      });
    }
  }

  Future deleteReq() async {
    setState(() {
      isCancelPressed = true;
    });
    var data = {
      'op': 1,
      'id': conList.user.id,
    };

    print(data);

    var res = await CallApi().postData1(data, 'remove/friend');
    var body = json.decode(res.body);

    print(body);

    if (res.statusCode == 200) {
      setState(() {
        isFriend = false;
        isCancel = false;
        isCancelPressed = false;
      });
    }
  }

  Future<Null> _checkMsgDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(left: 0, right: 10, top: 0),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey, width: 0.2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              child: TextField(
                                onChanged: (value) {
                                  result = value;
                                },
                                controller: chatController,
                                autofocus: true,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontFamily: 'Oswald',
                                ),
                                decoration: InputDecoration(
                                  hintText: "Type your message...",
                                  hintStyle: TextStyle(
                                      color: Colors.black45,
                                      fontSize: 15,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w300),
                                  //labelStyle: TextStyle(color: Colors.white70),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(10.0, 0, 20.0, 0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        )),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 0, right: 5, top: 20, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey, width: 0.2),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 17,
                                      fontFamily: 'BebasNeue',
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                checkChat();
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 5, right: 0, top: 20, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: header,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Text(
                                    "GO",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'BebasNeue',
                                    ),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future checkChat() async {
    setState(() {
      loading = true;
    });

    var data = {
      'msg': chatController.text,
      'reciever': conList.user.id,
    };

    print(data);

    var res = await CallApi().postData1(data, 'insert-chat');
    var body = json.decode(res.body);
    var body1 = res.statusCode;
    print(body1);

    if (body1 == 200) {
      setState(() {
        print("body['chat']['con_id']");
        print(body['chat']['con_id']);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatPage(userData)));
      });
    } else {
      print("Something went wrong");
      //_showMsg(body['errorMessage']);
    }

    setState(() {
      loading = false;
    });

    //loadChatList();
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
                          "Profile Details",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
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
        body: conList == null || postList == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                        child: SingleChildScrollView(
                      child: Container(
                          child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 0, top: 15),
                            height: 140,
                            width: 140,
                            //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                            padding: EdgeInsets.all(5.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: "${conList.user.profilePic}",
                                placeholder: (context, url) =>
                                    Center(child: Text("Please Wait...")),
                                errorWidget: (context, url, error) =>
                                    Image.asset("assets/images/user.png",
                                        fit: BoxFit.cover),
                                fit: BoxFit.cover,
                              ),
                            ),
                            // CircleAvatar(
                            //   radius: 65.0,
                            //   backgroundColor:
                            //       Colors.transparent,
                            //   backgroundImage: widget
                            //               .userData[
                            //                   'profilePic']
                            //               .contains(
                            //                   "Female.jpeg") ||
                            //           widget.userData[
                            //                   'profilePic']
                            //               .contains(
                            //                   "Male.jpeg")
                            //       ? AssetImage(
                            //           "assets/images/user.png")
                            //       : NetworkImage(
                            //           "${widget.userData['profilePic']}"),
                            // ),
                            decoration: new BoxDecoration(
                              // color: Colors.grey[
                              //     300], // border color
                              //shape: BoxShape.circle,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          // SafeArea(
                          //   child: Stack(
                          //     children: <Widget>[
                          //       Center(
                          //         child: Container(
                          //           margin: EdgeInsets.only(right: 0, top: 15),
                          //           //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                          //           padding: EdgeInsets.all(5.0),
                          //           child: CircleAvatar(
                          //             radius: 65.0,
                          //             backgroundColor: Colors.white,
                          //             backgroundImage: NetworkImage(
                          //                 "${conList.user.profilePic}"),
                          //           ),
                          //           decoration: new BoxDecoration(
                          //             color: Colors.grey[300], // border color
                          //             shape: BoxShape.circle,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Container(
                              margin:
                                  EdgeInsets.only(top: 10, right: 20, left: 20),
                              child: Text(
                                "${conList.user.firstName} ${conList.user.lastName}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Oswald",
                                    color: Colors.black),
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                "${conList.user.jobTitle}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Oswald"),
                              )),
                          // Container(
                          //   margin: EdgeInsets.only(top: 5),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     children: <Widget>[
                          //       Expanded(
                          //         child: Container(
                          //           margin: EdgeInsets.only(
                          //               left: 15, top: 15, right: 5),
                          //           padding: EdgeInsets.all(5.0),
                          //           decoration: new BoxDecoration(
                          //               color: header.withOpacity(0.8),
                          //               border:
                          //                   Border.all(width: 0.5, color: header),
                          //               borderRadius:
                          //                   BorderRadius.all(Radius.circular(5))),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Icon(
                          //                 Icons.label_important,
                          //                 color: Colors.white,
                          //                 size: 15,
                          //               ),
                          //               Container(
                          //                 margin: EdgeInsets.only(left: 5),
                          //                 child: Text(
                          //                   "Timeline",
                          //                   style: TextStyle(
                          //                       color: Colors.white,
                          //                       fontFamily: "Oswald",
                          //                       fontWeight: FontWeight.w300,
                          //                       fontSize: 14),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: Container(
                          //           margin: EdgeInsets.only(
                          //               left: 5, right: 5, top: 15),
                          //           padding: EdgeInsets.all(5.0),
                          //           decoration: new BoxDecoration(
                          //               color: back_new.withOpacity(0.8),
                          //               border: Border.all(
                          //                   width: 0.5, color: Colors.white),
                          //               borderRadius:
                          //                   BorderRadius.all(Radius.circular(5))),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Icon(
                          //                 Icons.info_outline,
                          //                 color: Colors.black,
                          //                 size: 15,
                          //               ),
                          //               Container(
                          //                 margin: EdgeInsets.only(left: 5),
                          //                 child: Text(
                          //                   "About",
                          //                   style: TextStyle(
                          //                       color: Colors.black,
                          //                       fontFamily: "Oswald",
                          //                       fontWeight: FontWeight.w300,
                          //                       fontSize: 14),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: Container(
                          //           margin: EdgeInsets.only(
                          //               left: 5, right: 15, top: 15),
                          //           padding: EdgeInsets.all(5.0),
                          //           decoration: new BoxDecoration(
                          //               color: back_new.withOpacity(0.8),
                          //               border: Border.all(
                          //                   width: 0.5, color: Colors.white),
                          //               borderRadius:
                          //                   BorderRadius.all(Radius.circular(5))),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Icon(
                          //                 Icons.group,
                          //                 color: Colors.black,
                          //                 size: 17,
                          //               ),
                          //               Container(
                          //                 margin: EdgeInsets.only(left: 5),
                          //                 child: Text(
                          //                   "Friends",
                          //                   style: TextStyle(
                          //                       color: Colors.black,
                          //                       fontFamily: "Oswald",
                          //                       fontWeight: FontWeight.w300,
                          //                       fontSize: 14),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //   margin: EdgeInsets.only(top: 0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //     children: <Widget>[
                          //       Expanded(
                          //         child: Container(
                          //           margin: EdgeInsets.only(
                          //               left: 15, top: 10, right: 5),
                          //           padding: EdgeInsets.all(5.0),
                          //           decoration: new BoxDecoration(
                          //               color: back_new.withOpacity(0.8),
                          //               border: Border.all(
                          //                   width: 0.5, color: Colors.white),
                          //               borderRadius:
                          //                   BorderRadius.all(Radius.circular(5))),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Icon(
                          //                 Icons.photo,
                          //                 color: Colors.black,
                          //                 size: 15,
                          //               ),
                          //               Container(
                          //                 margin: EdgeInsets.only(left: 5),
                          //                 child: Text(
                          //                   "Photos",
                          //                   style: TextStyle(
                          //                       color: Colors.black,
                          //                       fontFamily: "Oswald",
                          //                       fontWeight: FontWeight.w300,
                          //                       fontSize: 14),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: Container(
                          //           margin: EdgeInsets.only(
                          //               left: 5, right: 5, top: 10),
                          //           padding: EdgeInsets.all(5.0),
                          //           decoration: new BoxDecoration(
                          //               color: back_new.withOpacity(0.8),
                          //               border: Border.all(
                          //                   width: 0.5, color: Colors.white),
                          //               borderRadius:
                          //                   BorderRadius.all(Radius.circular(5))),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Icon(
                          //                 Icons.event_available,
                          //                 color: Colors.black,
                          //                 size: 15,
                          //               ),
                          //               Container(
                          //                 margin: EdgeInsets.only(left: 5),
                          //                 child: Text(
                          //                   "Events",
                          //                   style: TextStyle(
                          //                       color: Colors.black,
                          //                       fontFamily: "Oswald",
                          //                       fontWeight: FontWeight.w300,
                          //                       fontSize: 14),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //       Expanded(
                          //         child: Container(
                          //           margin: EdgeInsets.only(
                          //               left: 5, right: 15, top: 10),
                          //           padding: EdgeInsets.all(5.0),
                          //           decoration: new BoxDecoration(
                          //               color: back_new.withOpacity(0.8),
                          //               border: Border.all(
                          //                   width: 0.5, color: Colors.white),
                          //               borderRadius:
                          //                   BorderRadius.all(Radius.circular(5))),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: <Widget>[
                          //               Icon(
                          //                 Icons.more_horiz,
                          //                 color: Colors.black,
                          //                 size: 17,
                          //               ),
                          //               Container(
                          //                 margin: EdgeInsets.only(left: 5),
                          //                 child: Text(
                          //                   "More",
                          //                   style: TextStyle(
                          //                       color: Colors.black,
                          //                       fontFamily: "Oswald",
                          //                       fontWeight: FontWeight.w300,
                          //                       fontSize: 14),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 30, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _checkMsgDialog();
                                    },
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 0),
                                                height: 50,
                                                //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Icons.chat,
                                                  color: header,
                                                ),
                                                decoration: new BoxDecoration(
                                                  color: header, // border color
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 0),
                                                height: 50,
                                                //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                padding: EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Icons.chat,
                                                  color: header,
                                                ),
                                                decoration: new BoxDecoration(
                                                  color: sub_white.withOpacity(
                                                      0.7), // border color
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text("Message",
                                              style: TextStyle(
                                                  color: header,
                                                  fontFamily: "Oswald",
                                                  fontSize: 13))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Stack(
                                        children: <Widget>[
                                          !isPressed
                                              ? GestureDetector(
                                                  onTap: () {
                                                    if (isFriend == false &&
                                                        isCancel == false) {
                                                      _showFriendDialog();
                                                    } else if (isFriend ==
                                                            false &&
                                                        isCancel == true) {
                                                      _cancelFriendDialog();
                                                    } else if (isFriend ==
                                                            true &&
                                                        isCancel == false) {
                                                      _removeFriendDialog();
                                                    } else if (isFriend ==
                                                            true &&
                                                        isCancel == true) {
                                                      acceptReq();
                                                    }
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 0),
                                                    height: 50,
                                                    //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child: Icon(
                                                      isFriend == false &&
                                                              isCancel == false
                                                          ? Icons.send
                                                          : isFriend == false &&
                                                                  isCancel ==
                                                                      true
                                                              ? Icons.close
                                                              : isFriend ==
                                                                          true &&
                                                                      isCancel ==
                                                                          true
                                                                  ? Icons.done
                                                                  : Icons
                                                                      .delete,
                                                      color: Colors.black38,
                                                      size: 15,
                                                    ),
                                                    decoration:
                                                        new BoxDecoration(
                                                      color: Colors.grey[
                                                          300], // border color
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  child:
                                                      CircularProgressIndicator()),
                                        ],
                                      ),
                                      Text(
                                          isFriend == false && isCancel == false
                                              ? "Add Friend"
                                              : isFriend == false &&
                                                      isCancel == true
                                                  ? "Cancel Request"
                                                  : isFriend == true &&
                                                          isCancel == true
                                                      ? "Accept Request"
                                                      : "Unfriend",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontFamily: "Oswald",
                                              fontSize: 13))
                                    ],
                                  ),
                                ),
                                isFriend == true && isCancel == true
                                    ? Expanded(
                                        child: isCancelPressed
                                            ? CircularProgressIndicator()
                                            : GestureDetector(
                                                onTap: () {
                                                  deleteReq();
                                                },
                                                child: Container(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 0),
                                                        height: 50,
                                                        //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                        padding: EdgeInsets.all(
                                                            10.0),
                                                        child: Icon(
                                                          Icons.close,
                                                          color: Colors.black38,
                                                          size: 15,
                                                        ),
                                                        decoration:
                                                            new BoxDecoration(
                                                          color: Colors.grey[
                                                              300], // border color
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 0),
                                                            child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.5),
                                                                    fontFamily:
                                                                        "Oswald",
                                                                    fontSize:
                                                                        12)),
                                                          ),
                                                          // widget.no == 1
                                                          //     ? Container()
                                                          //     : Icon(
                                                          //         Icons.arrow_drop_down,
                                                          //         color: Colors.black,
                                                          //         size: 14,
                                                          //       )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          Container(
                              width: 50,
                              margin: EdgeInsets.only(
                                  top: 25, left: 25, right: 25, bottom: 0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: header,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1.0,
                                      color: header,
                                      //offset: Offset(6.0, 7.0),
                                    ),
                                  ],
                                  border:
                                      Border.all(width: 0.5, color: header))),
                          //////// <<<<<< Basic Info start >>>>> ////////
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(top: 15, left: 20),
                                    child: Text(
                                      "Basic Information",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.normal),
                                    )),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                      margin: EdgeInsets.only(
                                          top: 10, left: 20, bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 3.0,
                                              color: Colors.black,
                                              //offset: Offset(6.0, 7.0),
                                            ),
                                          ],
                                          border: Border.all(
                                              width: 0.5, color: Colors.black)),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.email,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Email : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: conList.user.jobTitle !=
                                                          null
                                                      ? ' ${conList.user.email}'
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.work,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Work Type : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: conList.user.dayJob !=
                                                          null
                                                      ? ' ${conList.user.dayJob}'
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.account_box,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Gender : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: conList.user.gender !=
                                                          null
                                                      ? ' ${conList.user.gender}'
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 15, top: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.location_on,
                                        size: 17, color: Colors.black)),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "Country Name : ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text: " ${conList.user.country}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w400)),
                                        // can add more TextSpans here...
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 15, top: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.account_circle,
                                        size: 17, color: Colors.black)),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "Member Type : ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text: conList.user.userType != null
                                                ? ' ${conList.user.userType}'
                                                : '',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w400)),
                                        // can add more TextSpans here...
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: 50,
                              margin: EdgeInsets.only(
                                  top: 25, left: 25, right: 25, bottom: 0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: header,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1.0,
                                      color: header,
                                      //offset: Offset(6.0, 7.0),
                                    ),
                                  ],
                                  border:
                                      Border.all(width: 0.5, color: header))),
                          // Container(
                          //     alignment: Alignment.center,
                          //     width: MediaQuery.of(context).size.width,
                          //     padding: EdgeInsets.all(10),
                          //     decoration: BoxDecoration(
                          //         color: header.withOpacity(0.8),
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(5))),
                          //     margin: EdgeInsets.all(15),
                          //     child: Text("Edit Public Details",
                          //         style: TextStyle(
                          //             color: Colors.white,
                          //             fontFamily: "Oswald",
                          //             fontWeight: FontWeight.w300,
                          //             fontSize: 16))),

                          // Container(
                          //     width: 50,
                          //     margin: EdgeInsets.only(
                          //         top: 25, left: 25, right: 25, bottom: 0),
                          //     decoration: BoxDecoration(
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(15.0)),
                          //         color: header,
                          //         boxShadow: [
                          //           BoxShadow(
                          //             blurRadius: 1.0,
                          //             color: header,
                          //             //offset: Offset(6.0, 7.0),
                          //           ),
                          //         ],
                          //         border: Border.all(width: 0.5, color: header))),
                          // Container(
                          //   margin:
                          //       EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: <Widget>[
                          //           Text("Friends",
                          //               style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontSize: 20)),
                          //           Text(
                          //             "All Friends",
                          //             style: TextStyle(color: header, fontSize: 17),
                          //           )
                          //         ],
                          //       ),
                          //       Container(
                          //         margin: EdgeInsets.only(top: 3),
                          //         child: Text(
                          //           "250 Friends",
                          //           style: TextStyle(color: Colors.black54, fontSize: 15),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // // Container(
                          // //     alignment: Alignment.center,
                          // //     width: MediaQuery.of(context).size.width,
                          // //     padding: EdgeInsets.all(10),
                          // //     decoration: BoxDecoration(
                          // //         color: Colors.grey.withOpacity(0.2),
                          // //         borderRadius: BorderRadius.all(Radius.circular(5))),
                          // //     margin: EdgeInsets.all(10),
                          // //     child: Text("See All Friends",
                          // //         style: TextStyle(
                          // //             color: Colors.black,
                          // //             fontWeight: FontWeight.bold,
                          // //             fontSize: 16))),
                          // Container(
                          //     height: 2,
                          //     margin: EdgeInsets.only(top: 10, bottom: 20),
                          //     child: Divider(
                          //       color: Colors.grey[300],
                          //     )),
                          // Container(
                          //   margin:
                          //       EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: <Widget>[
                          //           Text("Photos",
                          //               style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontSize: 20)),
                          //           Text(
                          //             "See Photos",
                          //             style: TextStyle(color: header, fontSize: 17),
                          //           )
                          //         ],
                          //       ),
                          //       Container(
                          //         margin: EdgeInsets.only(top: 3),
                          //         child: Text(
                          //           "12 Albums",
                          //           style: TextStyle(color: Colors.black54, fontSize: 15),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //     height: 2,
                          //     margin: EdgeInsets.only(top: 10, bottom: 20),
                          //     child: Divider(
                          //       color: Colors.grey[300],
                          //     )),
                          // Container(
                          //   margin:
                          //       EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 10),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: <Widget>[
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: <Widget>[
                          //           Text("Events",
                          //               style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                   fontSize: 20)),
                          //           Text(
                          //             "See Events",
                          //             style: TextStyle(color: header, fontSize: 17),
                          //           )
                          //         ],
                          //       ),
                          //       Container(
                          //         margin: EdgeInsets.only(top: 3),
                          //         child: Text(
                          //           "3 Events This Week",
                          //           style: TextStyle(color: Colors.black54, fontSize: 15),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //     height: 2,
                          //     margin: EdgeInsets.only(top: 10, bottom: 20),
                          //     child: Divider(
                          //       color: Colors.grey[300],
                          //     )),
                          Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            //color: sub_white,
                            child: Container(
                              //color: Colors.white,

                              child: Column(
                                children: <Widget>[
                                  //////// <<<<<< Interest start >>>>> ////////
                                  Container(
                                      child: Column(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(
                                              top: 15, left: 20),
                                          child: Text(
                                            "Interests",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.normal),
                                          )),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 30,
                                              margin: EdgeInsets.only(
                                                  top: 10,
                                                  left: 20,
                                                  bottom: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                  color: Colors.black,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 3.0,
                                                      color: Colors.black,
                                                      //offset: Offset(6.0, 7.0),
                                                    ),
                                                  ],
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color: Colors.black)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(
                                                  top: 0, left: 20, bottom: 0),
                                              child: Text(
                                                conList.user.interestLists
                                                            .length ==
                                                        0
                                                    ? "No interests"
                                                    : conList.user.interestLists
                                                                .length ==
                                                            1
                                                        ? "${conList.user.interestLists.length} interest"
                                                        : "${conList.user.interestLists.length} interests",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        ],
                                      ),
                                    ],
                                  )),

                                  ///// <<<<< Selected Interest start >>>>> //////
                                  conList.user.interestLists.length != 0
                                      ? Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.only(left: 20),
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 15, left: 0),
                                          child: ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            scrollDirection: Axis.horizontal,
                                            itemCount: conList
                                                .user.interestLists.length,
                                            //separatorBuilder: (context, index) => Divider(),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  margin: EdgeInsets.only(
                                                      left: 0,
                                                      right: 5,
                                                      top: 8,
                                                      bottom: 8),
                                                  padding: EdgeInsets.only(
                                                      left: 10, right: 10),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        "${conList.user.interestLists[index].tag}",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Oswald',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ],
                                                  ));
                                            },
                                          ),
                                        )
                                      : Container(),

                                  ////// <<<<< Selected Interest end >>>>> //////
                                  Container(
                                      width: 50,
                                      margin: EdgeInsets.only(
                                          top: 20,
                                          left: 25,
                                          right: 25,
                                          bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                          color: header,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 1.0,
                                              color: header,
                                              //offset: Offset(6.0, 7.0),
                                            ),
                                          ],
                                          border: Border.all(
                                              width: 0.5, color: header))),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(
                                              top: 15, left: 20),
                                          child: Text(
                                            "Connections",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.normal),
                                          )),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            width: 30,
                                            margin: EdgeInsets.only(
                                                top: 10, left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0)),
                                                color: Colors.black,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 3.0,
                                                    color: Colors.black,
                                                    //offset: Offset(6.0, 7.0),
                                                  ),
                                                ],
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(
                                                  top: 12, left: 20, bottom: 0),
                                              child: Text(
                                                conList.res.length == 1
                                                    ? "${conList.res.length} connection"
                                                    : "${conList.res.length} connections",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     // Navigator.push(
                                          //     //     context,
                                          //     //     MaterialPageRoute(
                                          //     //         builder: (context) => GroupAddPage()));
                                          //   },
                                          //   child: Container(
                                          //       alignment: Alignment.centerLeft,
                                          //       margin: EdgeInsets.only(
                                          //           top: 12,
                                          //           right: 20,
                                          //           bottom: 0),
                                          //       child: Row(
                                          //         children: <Widget>[
                                          //           Text(
                                          //             "See all",
                                          //             textAlign:
                                          //                 TextAlign.start,
                                          //             style: TextStyle(
                                          //                 color: header,
                                          //                 fontSize: 13,
                                          //                 fontFamily: 'Oswald',
                                          //                 fontWeight:
                                          //                     FontWeight.w400),
                                          //           ),
                                          //           Container(
                                          //             margin: EdgeInsets.only(
                                          //                 top: 3),
                                          //             child: Icon(
                                          //                 Icons.chevron_right,
                                          //                 color: header,
                                          //                 size: 17),
                                          //           )
                                          //         ],
                                          //       )),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                    )),
                    SliverPadding(
                      padding: EdgeInsets.only(right: 20, left: 5),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 120.0,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                          childAspectRatio: 1.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FriendsProfilePage(
                                        conList.res[index].userName, 2)),
                              );
                            },
                            child: new Container(
                              margin: EdgeInsets.only(
                                  left: 15, right: 0, top: 5, bottom: 10),
                              padding: EdgeInsets.only(left: 0),
                              height: 100,
                              width: 90,
                              decoration: BoxDecoration(
                                // image: DecorationImage(
                                //   image: NetworkImage(
                                //       "${conList.res[index].profilePic}"),
                                //   fit: BoxFit.cover,
                                // ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(.5),
                                    //offset: Offset(6.0, 7.0),
                                  ),
                                ],
                                // border: Border.all(width: 0.2, color: Colors.grey)
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 110,
                                    width: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${conList.res[index].profilePic}",
                                        placeholder: (context, url) => Center(
                                          child: Text("Please Wait...",
                                              textAlign: TextAlign.center),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          "assets/images/user.png",
                                          height: 40,
                                        ),

                                        // NetworkImage(
                                        //     widget.friend[index].profilePic
                                      ),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(left: 0),
                                      padding: EdgeInsets.only(left: 0),
                                      height: 110,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      )),
                                  Container(
                                      alignment: Alignment.bottomLeft,
                                      margin: EdgeInsets.only(
                                          top: 10, left: 10, bottom: 5),
                                      child: Text(
                                        "${conList.res[index].firstName} ${conList.res[index].lastName}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w300),
                                      )),
                                ],
                              ),
                            ),
                          );
                        }, childCount: conList.res.length),
                      ),
                    ),
                    // SliverToBoxAdapter(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       Container(
                    //           width: 50,
                    //           margin: EdgeInsets.only(
                    //               top: 20, left: 25, right: 25, bottom: 20),
                    //           decoration: BoxDecoration(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(15.0)),
                    //               color: header,
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   blurRadius: 1.0,
                    //                   color: header,
                    //                   //offset: Offset(6.0, 7.0),
                    //                 ),
                    //               ],
                    //               border: Border.all(width: 0.5, color: header))),
                    //     ],
                    //   ),
                    // ),
                    // SliverPadding(
                    //   padding: EdgeInsets.only(right: 20, left: 5),
                    //   sliver: SliverGrid(
                    //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    //       maxCrossAxisExtent: 200.0,
                    //       mainAxisSpacing: 0.0,
                    //       crossAxisSpacing: 0.0,
                    //       childAspectRatio: 1.0,
                    //     ),
                    //     delegate: SliverChildBuilderDelegate(
                    //         (BuildContext context, int index) {
                    //       return GestureDetector(
                    //         onTap: () {
                    //           // Navigator.push(
                    //           //   context,
                    //           //   MaterialPageRoute(
                    //           //       builder: (context) => HotelSearchPage()),
                    //           // );
                    //         },
                    //         child: new Container(
                    //           margin: EdgeInsets.only(
                    //               left: 15, right: 0, top: 5, bottom: 10),
                    //           padding: EdgeInsets.only(left: 0),
                    //           height: 100,
                    //           width: 100,
                    //           decoration: BoxDecoration(
                    //             image: DecorationImage(
                    //               image: index == 0
                    //                   ? AssetImage("assets/images/f6.jpg")
                    //                   : AssetImage("assets/images/f7.jpg"),
                    //               fit: BoxFit.cover,
                    //             ),
                    //             borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    //             color: Colors.white,
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 blurRadius: 3.0,
                    //                 color: Colors.black.withOpacity(.5),
                    //                 //offset: Offset(6.0, 7.0),
                    //               ),
                    //             ],
                    //             // border: Border.all(width: 0.2, color: Colors.grey)
                    //           ),
                    //           child: Stack(
                    //             children: <Widget>[
                    //               Container(
                    //                   margin: EdgeInsets.only(left: 0),
                    //                   padding: EdgeInsets.only(left: 0),
                    //                   height: 160,
                    //                   width: 170,
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.black.withOpacity(0.3),
                    //                     borderRadius:
                    //                         BorderRadius.all(Radius.circular(5.0)),
                    //                   )),
                    //               Container(
                    //                   alignment: Alignment.bottomLeft,
                    //                   margin: EdgeInsets.only(
                    //                       top: 10, left: 10, bottom: 5),
                    //                   child: Text(
                    //                     index == 0 ? "Photos" : "Events",
                    //                     maxLines: 1,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: Colors.white,
                    //                         fontSize: 20,
                    //                         fontFamily: 'Oswald',
                    //                         fontWeight: FontWeight.bold),
                    //                   )),
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     }, childCount: 2),
                    //   ),
                    // ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 50,
                                  margin: EdgeInsets.only(
                                      top: 15, left: 25, right: 25, bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      color: header,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 1.0,
                                          color: header,
                                          //offset: Offset(6.0, 7.0),
                                        ),
                                      ],
                                      border: Border.all(
                                          width: 0.5, color: header))),
                            ],
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 15, left: 20),
                              child: Text(
                                "Timeline",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.normal),
                              )),
                          Row(
                            children: <Widget>[
                              Container(
                                width: 30,
                                margin: EdgeInsets.only(
                                    top: 10, left: 20, bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    color: Colors.black,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 3.0,
                                        color: Colors.black,
                                        //offset: Offset(6.0, 7.0),
                                      ),
                                    ],
                                    border: Border.all(
                                        width: 0.5, color: Colors.black)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    postList.res == null || postList.res.length == 0
                        ? SliverToBoxAdapter(
                            child: Container(
                              margin: EdgeInsets.only(left: 20, bottom: 20),
                              child: Text(
                                "No posts!",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          )
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              des = "${postList.res[index].activitytext}";
                              if (des.length > 150) {
                                firstHalf = des.substring(0, 150);
                                secondHalf = des.substring(150, des.length);
                              } else {
                                firstHalf = des;
                                secondHalf = "";
                              }

                              String sharedFirstText = "";
                              String sharedLastText = "";

                              if (postList.res[index].feedType == "Share") {
                                var text =
                                    "${postList.res[index].data.sharedTxt}";
                                if (text.length > 150) {
                                  sharedFirstText = text.substring(0, 150);
                                  sharedLastText =
                                      text.substring(150, text.length);
                                } else {
                                  sharedFirstText = text;
                                  sharedLastText = "";
                                }
                              }
                              //_current = 0;
                              imagePost = [];

                              print("postList.res[index].data.images");
                              print(postList.res[index].data.images);

                              var postImages = postList.res[index].data.images;
                              print("postImages.length");
                              print(postImages.length);

                              for (int i = 0; i < postImages.length; i++) {
                                if (postImages[i].file.contains("127.0.0.1")) {
                                  postImages[i].file = postImages[i]
                                      .file
                                      .replaceAll("127.0.0.1", "10.0.2.2");
                                }
                                imagePost.add(postImages[i].file);
                              }

                              List day = [];

                              for (int i = 0; i < postList.res.length; i++) {
                                DateTime date1 = DateTime.parse(
                                    "${postList.res[i].created_at}");

                                print("date1");
                                print(date1);

                                String days = DateFormat.yMMMd().format(date1);
                                day.add(days);
                                print(day);

                                print("fprofileComCount");
                                print(fprofileComCount);
                              }
                              return loading == false
                                  ? Container(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        //border: Border.all(width: 0.8, color: Colors.grey[300]),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 16.0,
                                            color: Colors.grey[300],
                                            //offset: Offset(3.0, 4.0),
                                          ),
                                        ],
                                      ),
                                      margin: EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 10,
                                          right: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            //color: Colors.yellow,
                                            margin: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                bottom: 10),
                                            padding: EdgeInsets.only(right: 10),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ////// <<<<< pic start >>>>> //////
                                                // Container(
                                                //   margin:
                                                //       EdgeInsets.only(right: 10),
                                                //   padding: EdgeInsets.all(1.0),
                                                //   child: CircleAvatar(
                                                //     radius: 20.0,
                                                //     backgroundColor: Colors.white,
                                                //     backgroundImage: postList
                                                //                 .res[index]
                                                //                 .fuser
                                                //                 .profilePic ==
                                                //             null
                                                //         ? AssetImage(
                                                //             "assets/images/man2.jpg")
                                                //         : NetworkImage(
                                                //             "${postList.res[index].fuser.profilePic}"),
                                                //   ),
                                                //   decoration: new BoxDecoration(
                                                //     color: Colors
                                                //         .grey[300], // border color
                                                //     shape: BoxShape.circle,
                                                //   ),
                                                // ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10, top: 0),
                                                  height: 40,
                                                  width: 40,
                                                  //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                  padding: EdgeInsets.all(0.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "${postList.res[index].fuser.profilePic}",
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                              "assets/images/user.png",
                                                              fit:
                                                                  BoxFit.cover),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                ),
                                                ////// <<<<< pic end >>>>> //////

                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        ////// <<<<< Name & Interest start >>>>> //////
                                                        Container(
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                child: Text(
                                                                  "${postList.res[index].fuser.firstName} ${postList.res[index].fuser.lastName}",
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          'Oswald',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                              ),
                                                              postList
                                                                          .res[
                                                                              index]
                                                                          .feedType ==
                                                                      "Share"
                                                                  ? Expanded(
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          " shared a post",
                                                                          maxLines:
                                                                              1,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.grey,
                                                                              fontFamily: 'Oswald',
                                                                              fontWeight: FontWeight.w400),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : postList.res[index].feedType ==
                                                                          "ComPost"
                                                                      ? Expanded(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Text(
                                                                              " has posted in ${postList.res[index].data.comName}",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(fontSize: 15, color: Colors.grey, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : postList.res[index].feedType ==
                                                                              "Shop"
                                                                          ? Expanded(
                                                                              child: Container(
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Text(
                                                                                      " has created a shop",
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(fontSize: 15, color: Colors.grey, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : postList.res[index].feedType == "Product"
                                                                              ? Container(
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        " has uploaded a new product",
                                                                                        maxLines: 1,
                                                                                        style: TextStyle(fontSize: 15, color: Colors.grey, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )
                                                                              : Container(),
                                                              postList.res[index]
                                                                          .interests ==
                                                                      null
                                                                  ? Container()
                                                                  : Expanded(
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          postList.res[index].interests == null
                                                                              ? ""
                                                                              : " - ${postList.res[index].interests}",
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: header,
                                                                              fontFamily: 'Oswald',
                                                                              fontWeight: FontWeight.w300),
                                                                        ),
                                                                      ),
                                                                    )
                                                            ],
                                                          ),
                                                        ),

                                                        ////// <<<<< Name & Interest end >>>>> //////

                                                        ////// <<<<< time job start >>>>> //////
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 3),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                child: Text(
                                                                  "${day[index]}",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Oswald',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .black54),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5),
                                                                  child: Text(
                                                                    "-  ${postList.res[index].fuser.jobTitle}",
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            header,
                                                                        fontFamily:
                                                                            'Oswald',
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                        ////// <<<<< time job end >>>>> //////
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          postList.res[index].feedType ==
                                                  "Share"
                                              ? sharedFirstText == "null"
                                                  ? Container()
                                                  : Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10, right: 15),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            if (postList
                                                                        .res[
                                                                            index]
                                                                        .isRead ==
                                                                    null ||
                                                                postList
                                                                        .res[
                                                                            index]
                                                                        .isRead ==
                                                                    "0") {
                                                              postList
                                                                  .res[index]
                                                                  .isRead = "1";
                                                            } else {
                                                              postList
                                                                  .res[index]
                                                                  .isRead = "0";
                                                            }
                                                          });
                                                        },
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              child: sharedLastText ==
                                                                      ""
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              20),
                                                                      child: new Text(
                                                                          sharedFirstText,
                                                                          textAlign: TextAlign
                                                                              .justify,
                                                                          style: TextStyle(
                                                                              color: Colors.black.withOpacity(0.7),
                                                                              fontSize: 13,
                                                                              fontFamily: "Oswald",
                                                                              fontWeight: FontWeight.w300)),
                                                                    )
                                                                  : Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              20),
                                                                      child: new Text(
                                                                          postList.res[index].isRead == "0" || postList.res[index].isRead == null
                                                                              ? sharedFirstText +
                                                                                  "..."
                                                                              : sharedLastText +
                                                                                  sharedFirstText,
                                                                          textAlign: TextAlign
                                                                              .start,
                                                                          style: TextStyle(
                                                                              color: Colors.black.withOpacity(0.7),
                                                                              fontSize: 13,
                                                                              fontFamily: "Oswald",
                                                                              fontWeight: FontWeight.w300)),
                                                                    ),
                                                            ),
                                                            secondHalf == ""
                                                                ? Container()
                                                                : Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            20,
                                                                        top: 5),
                                                                    child: new Text(
                                                                        postList.res[index].isRead == "0" || postList.res[index].isRead == null
                                                                            ? "Read more"
                                                                            : "",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        style: TextStyle(
                                                                            color:
                                                                                header,
                                                                            fontSize:
                                                                                13,
                                                                            fontFamily:
                                                                                "Oswald",
                                                                            fontWeight:
                                                                                FontWeight.w400)),
                                                                  )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                              : postList.res[index].feedType !=
                                                      "Status"
                                                  ? Container()
                                                  : Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10, right: 15),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            if (postList
                                                                        .res[
                                                                            index]
                                                                        .isRead ==
                                                                    null ||
                                                                postList
                                                                        .res[
                                                                            index]
                                                                        .isRead ==
                                                                    "0") {
                                                              postList
                                                                  .res[index]
                                                                  .isRead = "1";
                                                            } else {
                                                              postList
                                                                  .res[index]
                                                                  .isRead = "0";
                                                            }
                                                          });
                                                        },
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              child: secondHalf ==
                                                                      ""
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        if (postList.res[index].data.linkMeta !=
                                                                                null ||
                                                                            postList.res[index].data.linkMeta ==
                                                                                "") {
                                                                          _launchURL(postList
                                                                              .res[index]
                                                                              .data
                                                                              .linkMeta['og:url']);
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20),
                                                                        child: new Text(
                                                                            firstHalf,
                                                                            textAlign:
                                                                                TextAlign.justify,
                                                                            style: TextStyle(
                                                                              color: postList.res[index].data.linkMeta != null ? Colors.blueAccent : Colors.black.withOpacity(0.7),
                                                                              fontSize: 13,
                                                                              fontFamily: "Oswald",
                                                                              fontWeight: FontWeight.w300,
                                                                              decoration: postList.res[index].data.linkMeta != null ? TextDecoration.underline : TextDecoration.none,
                                                                            )),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              20),
                                                                      child: new Text(
                                                                          postList.res[index].isRead == "0" || postList.res[index].isRead == null
                                                                              ? firstHalf +
                                                                                  "..."
                                                                              : firstHalf +
                                                                                  secondHalf,
                                                                          textAlign: TextAlign
                                                                              .start,
                                                                          style: TextStyle(
                                                                              color: Colors.black.withOpacity(0.7),
                                                                              fontSize: 13,
                                                                              fontFamily: "Oswald",
                                                                              fontWeight: FontWeight.w300)),
                                                                    ),
                                                            ),
                                                            secondHalf == ""
                                                                ? Container()
                                                                : Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    margin: EdgeInsets.only(
                                                                        left:
                                                                            20,
                                                                        top: 5),
                                                                    child: new Text(
                                                                        postList.res[index].isRead == "0" || postList.res[index].isRead == null
                                                                            ? "Read more"
                                                                            : "",
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        style: TextStyle(
                                                                            color:
                                                                                header,
                                                                            fontSize:
                                                                                13,
                                                                            fontFamily:
                                                                                "Oswald",
                                                                            fontWeight:
                                                                                FontWeight.w400)),
                                                                  )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                          Container(
                                              child: Column(
                                            children: <Widget>[
                                              postList.res[index].data
                                                              .linkMeta !=
                                                          null ||
                                                      postList.res[index].data
                                                              .linkMeta ==
                                                          ""
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        _launchURL(postList
                                                                .res[index]
                                                                .data
                                                                .linkMeta[
                                                            'og:url']);
                                                        // Navigator.push(
                                                        //     context,
                                                        //     MaterialPageRoute(
                                                        //         builder: (context) => WebView(
                                                        //             feedList[index].data.linkMeta[
                                                        //                 'og:site_name'],
                                                        //             feedList[index]
                                                        //                 .data
                                                        //                 .linkMeta['og:url'])));
                                                      },
                                                      child: Container(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  16.0),
                                                          child: Container(
                                                            color: Colors
                                                                .grey[100],
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Image.network(
                                                                    "${postList.res[index].data.linkMeta['og:image']}",
                                                                    height: 120,
                                                                    width: 130,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                  ),
                                                                  Flexible(
                                                                      child:
                                                                          Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          postList
                                                                              .res[index]
                                                                              .data
                                                                              .linkMeta['og:title'],
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.normal,
                                                                              color: Colors.black,
                                                                              fontFamily: "Oswald"),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              4,
                                                                        ),
                                                                        Text(
                                                                            postList.res[index].data.linkMeta[
                                                                                'og:description'],
                                                                            maxLines:
                                                                                3,
                                                                            overflow: TextOverflow
                                                                                .ellipsis,
                                                                            style: TextStyle(
                                                                                color: Colors.black45,
                                                                                fontSize: 13,
                                                                                fontFamily: "Oswald",
                                                                                fontWeight: FontWeight.w400)),
                                                                        SizedBox(
                                                                          height:
                                                                              4,
                                                                        ),
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              // Image.network(
                                                                              //   feedList[index].data.linkMeta['favicon'],
                                                                              //   height: 12,
                                                                              //   width: 12,
                                                                              // ),
                                                                              // SizedBox(
                                                                              //   width: 4,
                                                                              // ),
                                                                              Expanded(child: Container(child: Text(postList.res[index].data.linkMeta['og:site_name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey, fontSize: 12))))
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : postList.res[index].data
                                                              .images.length ==
                                                          0
                                                      ? Container()
                                                      // : feedList[index]
                                                      //             .data
                                                      //             .images
                                                      //             .length ==
                                                      //         1
                                                      //     ? Container(
                                                      //         //color: Colors.red,
                                                      //         height: 500,
                                                      //         padding:
                                                      //             const EdgeInsets.all(
                                                      //                 0.0),
                                                      //         margin: EdgeInsets
                                                      //             .only(
                                                      //                 top:
                                                      //                     10),
                                                      //         decoration: BoxDecoration(
                                                      //             borderRadius: BorderRadius.circular(15),
                                                      //             image: DecorationImage(
                                                      //                 image: //AssetImage("assets/images/friend7.jpg"),
                                                      //                     NetworkImage("${feedList[index].data.images[0].file}"),
                                                      //                 fit: BoxFit.contain)),
                                                      //         child: null)
                                                      : postList.res[index]
                                                                  .feedType ==
                                                              "Share"
                                                          ? Container()
                                                          : Stack(
                                                              children: <
                                                                  Widget>[
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                        height:
                                                                            500,
                                                                        child:
                                                                            Container(
                                                                          margin: EdgeInsets.only(
                                                                              left: 10,
                                                                              right: 10,
                                                                              top: 10),
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          child:
                                                                              CarouselSlider(
                                                                            height:
                                                                                500.0,
                                                                            initialPage:
                                                                                0,
                                                                            enlargeCenterPage:
                                                                                false,
                                                                            autoPlay:
                                                                                false,
                                                                            reverse:
                                                                                false,
                                                                            viewportFraction:
                                                                                1.0,
                                                                            enableInfiniteScroll:
                                                                                true,
                                                                            autoPlayInterval:
                                                                                Duration(seconds: 2),
                                                                            autoPlayAnimationDuration:
                                                                                Duration(milliseconds: 2000),
                                                                            pauseAutoPlayOnTouch:
                                                                                Duration(seconds: 10),
                                                                            scrollDirection:
                                                                                Axis.horizontal,
                                                                            onPageChanged:
                                                                                (index) {
                                                                              setState(() {
                                                                                _current = index;
                                                                              });
                                                                            },
                                                                            items:
                                                                                imagePost.map((imgUrl) {
                                                                              return Builder(
                                                                                builder: (BuildContext context) {
                                                                                  return CachedNetworkImage(
                                                                                    imageUrl: imgUrl,
                                                                                    placeholder: (context, url) => Center(child: Text("Please Wait...")),
                                                                                    errorWidget: (context, url, error) => Image.asset(
                                                                                      "assets/images/placeholder_cover.jpg",
                                                                                      height: 40,
                                                                                    ),

                                                                                    // NetworkImage(
                                                                                    //     widget.friend[index].profilePic
                                                                                  );
                                                                                },
                                                                              );
                                                                            }).toList(),
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              15,
                                                                          right:
                                                                              20),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.all(5),
                                                                        color: Colors
                                                                            .grey[500],
                                                                        child:
                                                                            Text(
                                                                          "${imagePost.length} images",
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontFamily: "Oswald"),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                            ],
                                          )),
                                          postList.res[index].feedType ==
                                                  "Share"
                                              ? Container(
                                                  padding: EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        width: 0.8,
                                                        color:
                                                            Colors.grey[300]),
                                                    boxShadow: [
                                                      // BoxShadow(
                                                      //   blurRadius: 16.0,
                                                      //   color:
                                                      //       Colors.grey[300],
                                                      //   //offset: Offset(3.0, 4.0),
                                                      // ),
                                                    ],
                                                  ),
                                                  margin: EdgeInsets.only(
                                                      top: 25,
                                                      bottom: 15,
                                                      left: 20,
                                                      right: 20),
                                                  child: SingleChildScrollView(
                                                    child: Container(
                                                      //color: Colors.yellow,
                                                      margin: EdgeInsets.only(
                                                          left: 20,
                                                          right: 10,
                                                          bottom: 10),
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                ////// <<<<< pic start >>>>> //////

                                                                GestureDetector(
                                                                  onTap: () {
                                                                    // Navigator.push(
                                                                    //     context,
                                                                    //     MaterialPageRoute(
                                                                    //         builder: (context) => postList.res[index].data.fuser.userName == userData['userName']
                                                                    //             ? MyProfilePage(userData)
                                                                    //             : FriendsProfilePage(postList.res[index].data.fuser.userName, 2)));
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.only(
                                                                        right:
                                                                            10,
                                                                        top: 0),
                                                                    height: 40,
                                                                    width: 40,
                                                                    //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        imageUrl:
                                                                            "${postList.res[index].data.fuser.profilePic}",
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                CircularProgressIndicator(),
                                                                        errorWidget: (context, url, error) => Image.asset(
                                                                            "assets/images/user.png",
                                                                            fit:
                                                                                BoxFit.cover),
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                    decoration:
                                                                        new BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                    ),
                                                                  ),
                                                                ),
                                                                ////// <<<<< pic end >>>>> //////

                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        ////// <<<<< Name & Interest start >>>>> //////
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => postList.res[index].data.fuser.userName == userData['userName'] ? MyProfilePage(userData) : FriendsProfilePage(postList.res[index].data.fuser.userName, 2)));
                                                                                },
                                                                                child: Container(
                                                                                  child: Text(
                                                                                    "${postList.res[index].data.fuser.firstName} ${postList.res[index].data.fuser.lastName}",
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Container(
                                                                                  child: Text(
                                                                                    postList.res[index].data.interest == null ? "" : " - ${postList.res[index].data.interest}",
                                                                                    maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(fontSize: 14, color: header, fontFamily: 'Oswald', fontWeight: FontWeight.w300),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),

                                                                        ////// <<<<< Name & Interest end >>>>> //////

                                                                        ////// <<<<< time job start >>>>> //////
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(top: 3),
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Container(
                                                                                child: Text(
                                                                                  "${day[index]}",
                                                                                  maxLines: 1,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TextStyle(fontFamily: 'Oswald', fontWeight: FontWeight.w400, fontSize: 11, color: Colors.black54),
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                child: Container(
                                                                                  margin: EdgeInsets.only(left: 5),
                                                                                  child: Text(
                                                                                    "-  ${postList.res[index].data.fuser.jobTitle}",
                                                                                    maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(fontSize: 11, color: header, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        ////// <<<<< time job end >>>>> //////
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          postList
                                                                      .res[
                                                                          index]
                                                                      .data
                                                                      .feedType !=
                                                                  "Status"
                                                              ? Container()
                                                              : Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              20,
                                                                          right:
                                                                              15),
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        child: secondHalf ==
                                                                                ""
                                                                            ? Container(
                                                                                width: MediaQuery.of(context).size.width,
                                                                                margin: EdgeInsets.only(left: 0),
                                                                                child: new Text(firstHalf, textAlign: TextAlign.justify, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                              )
                                                                            : Container(
                                                                                width: MediaQuery.of(context).size.width,
                                                                                margin: EdgeInsets.only(left: 0),
                                                                                child: new Text(postList.res[index].data.isRead == "0" || postList.res[index].data.isRead == null ? firstHalf + "..." : firstHalf + secondHalf, textAlign: TextAlign.start, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                              ),
                                                                      ),
                                                                      Container()
                                                                    ],
                                                                  ),
                                                                ),
                                                          Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                left: 0,
                                                                right: 0,
                                                                top: 10,
                                                              ),
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  postList.res[index].data.images
                                                                              .length ==
                                                                          0
                                                                      ? Container()
                                                                      : Container(
                                                                          child:
                                                                              Stack(
                                                                            children: <Widget>[
                                                                              Column(
                                                                                children: <Widget>[
                                                                                  Container(
                                                                                      height: 500,
                                                                                      child: Container(
                                                                                        margin: EdgeInsets.only(left: 0, right: 0, top: 10),
                                                                                        width: MediaQuery.of(context).size.width,
                                                                                        child: CarouselSlider(
                                                                                          height: 500.0,
                                                                                          initialPage: 0,
                                                                                          enlargeCenterPage: false,
                                                                                          autoPlay: false,
                                                                                          reverse: false,
                                                                                          viewportFraction: 1.0,
                                                                                          enableInfiniteScroll: true,
                                                                                          autoPlayInterval: Duration(seconds: 2),
                                                                                          autoPlayAnimationDuration: Duration(milliseconds: 2000),
                                                                                          pauseAutoPlayOnTouch: Duration(seconds: 10),
                                                                                          scrollDirection: Axis.horizontal,
                                                                                          onPageChanged: (index) {
                                                                                            setState(() {
                                                                                              _current = index;
                                                                                            });
                                                                                          },
                                                                                          items: imagePost.map((imgUrl) {
                                                                                            return Builder(
                                                                                              builder: (BuildContext context) {
                                                                                                return CachedNetworkImage(
                                                                                                  imageUrl: imgUrl,
                                                                                                  placeholder: (context, url) => Center(child: Text("Please Wait...")),
                                                                                                  errorWidget: (context, url, error) => Image.asset(
                                                                                                    "assets/images/placeholder_cover.jpg",
                                                                                                    height: 40,
                                                                                                  ),

                                                                                                  // NetworkImage(
                                                                                                  //     widget.friend[index].profilePic
                                                                                                );
                                                                                              },
                                                                                            );
                                                                                          }).toList(),
                                                                                        ),
                                                                                      )),
                                                                                ],
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(top: 15, right: 0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                  children: <Widget>[
                                                                                    Container(
                                                                                      padding: EdgeInsets.all(5),
                                                                                      color: Colors.grey[500],
                                                                                      child: Text(
                                                                                        "${imagePost.length} images",
                                                                                        style: TextStyle(color: Colors.white, fontFamily: "Oswald"),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                  // Container(
                                                                  //     //color: Colors.red,
                                                                  //     height: 200,
                                                                  //     padding: const EdgeInsets.all(0.0),
                                                                  //     margin: EdgeInsets.only(top: 10),
                                                                  //     decoration: BoxDecoration(
                                                                  //         borderRadius: BorderRadius.circular(15),
                                                                  //         image: DecorationImage(
                                                                  //             image: //AssetImage("assets/images/friend7.jpg"),
                                                                  //                 NetworkImage("${feedList[index].data.images[0].file}"),
                                                                  //             fit: BoxFit.cover)),
                                                                  //     child: null),
                                                                  postList.res[index].data
                                                                              .feedType ==
                                                                          "Status"
                                                                      ? Container()
                                                                      : Container(
                                                                          margin:
                                                                              EdgeInsets.only(left: 0),
                                                                          child:
                                                                              Row(
                                                                            children: <Widget>[
                                                                              Expanded(
                                                                                child: Container(
                                                                                  margin: EdgeInsets.only(top: postList.res[index].data.images.length == 0 ? 0 : 10, right: 0, left: 0),
                                                                                  padding: EdgeInsets.all(5),
                                                                                  decoration: postList.res[index].data.images.length == 0
                                                                                      ? BoxDecoration()
                                                                                      : BoxDecoration(
                                                                                          color: Colors.white,
                                                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                          boxShadow: [
                                                                                            BoxShadow(
                                                                                              color: Colors.grey[300],
                                                                                              blurRadius: 17,
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                  child: GestureDetector(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        if (postList.res[index].isRead == null || postList.res[index].isRead == "0") {
                                                                                          postList.res[index].isRead = "1";
                                                                                        } else {
                                                                                          postList.res[index].isRead = "0";
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    child: Column(
                                                                                      children: <Widget>[
                                                                                        Container(
                                                                                          child: secondHalf == ""
                                                                                              ? Container(
                                                                                                  width: MediaQuery.of(context).size.width,
                                                                                                  margin: EdgeInsets.only(left: 5),
                                                                                                  child: new Text(firstHalf, textAlign: TextAlign.justify, style: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                                                )
                                                                                              : Container(
                                                                                                  width: MediaQuery.of(context).size.width,
                                                                                                  margin: EdgeInsets.only(left: postList.res[index].data.images.length == 0 ? 0 : 20),
                                                                                                  child: new Text(postList.res[index].isRead == "0" || postList.res[index].isRead == null ? firstHalf + "..." : firstHalf + secondHalf, textAlign: TextAlign.start, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                                                ),
                                                                                        ),
                                                                                        secondHalf == ""
                                                                                            ? Container()
                                                                                            : Container(
                                                                                                width: MediaQuery.of(context).size.width,
                                                                                                margin: EdgeInsets.only(left: postList.res[index].data.images.length == 0 ? 0 : 0, top: 5),
                                                                                                child: new Text(postList.res[index].isRead == "0" || postList.res[index].isRead == null ? "Read more" : "", textAlign: TextAlign.start, style: TextStyle(color: header, fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w400)),
                                                                                              )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                ],
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : postList.res[index].feedType ==
                                                      "Status"
                                                  ? Container()
                                                  : Container(
                                                      margin: EdgeInsets.only(
                                                          left: 20),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets.only(
                                                                  top: postList
                                                                              .res[index]
                                                                              .data
                                                                              .images
                                                                              .length ==
                                                                          0
                                                                      ? 0
                                                                      : 10,
                                                                  right: 20,
                                                                  left: 0),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              decoration: postList
                                                                          .res[
                                                                              index]
                                                                          .data
                                                                          .images
                                                                          .length ==
                                                                      0
                                                                  ? BoxDecoration()
                                                                  : BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10)),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color:
                                                                              Colors.grey[300],
                                                                          blurRadius:
                                                                              17,
                                                                        )
                                                                      ],
                                                                    ),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (postList.res[index].isRead ==
                                                                            null ||
                                                                        postList.res[index].isRead ==
                                                                            "0") {
                                                                      postList
                                                                          .res[
                                                                              index]
                                                                          .isRead = "1";
                                                                    } else {
                                                                      postList
                                                                          .res[
                                                                              index]
                                                                          .isRead = "0";
                                                                    }
                                                                  });
                                                                },
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child: secondHalf ==
                                                                              ""
                                                                          ? Container(
                                                                              width: MediaQuery.of(context).size.width,
                                                                              margin: EdgeInsets.only(left: 5),
                                                                              child: new Text(firstHalf, textAlign: TextAlign.justify, style: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                            )
                                                                          : Container(
                                                                              width: MediaQuery.of(context).size.width,
                                                                              margin: EdgeInsets.only(left: postList.res[index].data.images.length == 0 ? 0 : 20),
                                                                              child: new Text(postList.res[index].isRead == "0" || postList.res[index].isRead == null ? firstHalf + "..." : firstHalf + secondHalf, textAlign: TextAlign.start, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                            ),
                                                                    ),
                                                                    secondHalf ==
                                                                            ""
                                                                        ? Container()
                                                                        : Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            margin:
                                                                                EdgeInsets.only(left: postList.res[index].data.images.length == 0 ? 0 : 20, top: 5),
                                                                            child: new Text(postList.res[index].isRead == "0" || postList.res[index].isRead == null ? "Read more" : "",
                                                                                textAlign: TextAlign.start,
                                                                                style: TextStyle(color: header, fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w400)),
                                                                          )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 0,
                                                  top: 10),
                                              child: Divider(
                                                color: Colors.grey[400],
                                              )),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 20, top: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        if (postList.res[index]
                                                                .like !=
                                                            null) {
                                                          setState(() {
                                                            postList.res[index]
                                                                .like = null;
                                                          });
                                                          likeButtonPressed(
                                                              index, 0);
                                                        } else {
                                                          setState(() {
                                                            postList.res[index]
                                                                .like = 1;
                                                          });
                                                          likeButtonPressed(
                                                              index, 1);
                                                        }
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(3.0),
                                                        child: Icon(
                                                          postList.res[index]
                                                                      .like !=
                                                                  null
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border,
                                                          size: 20,
                                                          color: postList
                                                                      .res[
                                                                          index]
                                                                      .like !=
                                                                  null
                                                              ? Colors.redAccent
                                                              : Colors.black54,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 3),
                                                      child: Text(
                                                          postList
                                                                      .res[
                                                                          index]
                                                                      .meta
                                                                      .totalLikesCount ==
                                                                  null
                                                              ? ""
                                                              : "${postList.res[index].meta.totalLikesCount}",
                                                          style:
                                                              TextStyle(
                                                                  fontFamily:
                                                                      'Oswald',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      12)),
                                                    )
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                FriendProfileCommentPage(
                                                                    postList
                                                                        .res[
                                                                            index]
                                                                        .id,
                                                                    index)));
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 15),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3.0),
                                                          child: Icon(
                                                            Icons
                                                                .chat_bubble_outline,
                                                            size: 20,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 3),
                                                          child: Text(
                                                              fprofileComCount[
                                                                              index]
                                                                          [
                                                                          'count'] ==
                                                                      null
                                                                  ? ""
                                                                  : "${fprofileComCount[index]['count']}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Oswald',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      12)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _shareModalBottomSheet(
                                                        context,
                                                        index,
                                                        userData,
                                                        postList.res[index]);
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 15),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3.0),
                                                          child: Icon(
                                                            Icons.send,
                                                            size: 20,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 3),
                                                          child: Text(
                                                              postList
                                                                          .res[
                                                                              index]
                                                                          .meta
                                                                          .totalSharesCount ==
                                                                      null
                                                                  ? ""
                                                                  : "${postList.res[index].meta.totalSharesCount}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Oswald',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      12)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        //border: Border.all(width: 0.8, color: Colors.grey[300]),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 1.0,
                                            color: Colors.black38,
                                            //offset: Offset(6.0, 7.0),
                                          ),
                                        ],
                                      ),
                                      margin: EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 20,
                                          right: 20),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                //color: Colors.red,
                                                margin: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    top: 0),
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                      padding:
                                                          EdgeInsets.all(1.0),
                                                      child: Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[400],
                                                        highlightColor:
                                                            Colors.grey[200],
                                                        child: CircleAvatar(
                                                          radius: 20.0,
                                                          //backgroundColor: Colors.white,
                                                        ),
                                                      ),
                                                      decoration:
                                                          new BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey[400],
                                                          highlightColor:
                                                              Colors.grey[200],
                                                          child: Container(
                                                            width: 100,
                                                            height: 22,
                                                            child: Container(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 3),
                                                          child: Shimmer
                                                              .fromColors(
                                                            baseColor: Colors
                                                                .grey[400],
                                                            highlightColor:
                                                                Colors
                                                                    .grey[200],
                                                            child: Container(
                                                              width: 50,
                                                              height: 12,
                                                              child: Container(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 20,
                                                      bottom: 0),
                                                  child: Shimmer.fromColors(
                                                    baseColor: Colors.grey[400],
                                                    highlightColor:
                                                        Colors.grey[200],
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      height: 10,
                                                      child: Container(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )),
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 2,
                                                      bottom: 5),
                                                  child: Shimmer.fromColors(
                                                    baseColor: Colors.grey[400],
                                                    highlightColor:
                                                        Colors.grey[200],
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              100,
                                                      height: 10,
                                                      child: Container(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                            }, childCount: postList.res.length),
                          ),
                  ],
                ),
              ));
  }

  void _shareModalBottomSheet(context, int index, var userData, var feeds) {
    print("index");
    print(index);
    des = "${feeds.data.status}";
    if (des.length > 100) {
      firstHalf = des.substring(0, 100);
      secondHalf = des.substring(100, des.length);
    } else {
      firstHalf = des;
      secondHalf = "";
    }

    List imgList = [];

    for (int i = 0; i < feeds.data.images.length; i++) {
      if (feeds.data.images[i].file.contains("127.0.0.1")) {
        setState(() {
          feeds.data.images[i].file =
              feeds.data.images[i].file.replaceAll("127.0.0.1", "10.0.2.2");
        });
      }
      imgList.add(feeds.data.images[i].file);
    }

    print("feeds.created_at");
    print(feeds.created_at);

    DateTime date1 = DateTime.parse("${feeds.created_at}");

    print("date1");
    print(date1);

    String days = DateFormat.yMMMd().format(date1);

    print(days);

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.share,
                            color: Colors.black54,
                            size: 16,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              "Share this post",
                              style: TextStyle(fontFamily: "Oswald"),
                            ),
                          ),
                        ],
                      )),
                  Divider(),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10, top: 0, left: 20),
                          height: 50,
                          width: 50,
                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                          padding: EdgeInsets.all(0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: "${userData['profilePic']}",
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/user.png",
                                  fit: BoxFit.cover),
                              fit: BoxFit.cover,
                            ),
                          ),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 10, left: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "${userData['firstName']} ${userData['lastName']}",
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        _securityModalBottomSheet(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 0, right: 5, left: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0.3,
                                                color: Colors.black54),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Icon(
                                                status == "Public"
                                                    ? Icons.public
                                                    : Icons.group,
                                                size: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  status == "Public"
                                                      ? "Public"
                                                      : "Connections",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontFamily: "Oswald"),
                                                )),
                                            Icon(
                                              Icons.arrow_drop_down,
                                              size: 25,
                                              color: Colors.black54,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //height: 150,
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.only(
                        top: 20, left: 20, bottom: 5, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0)),
                      //color: Colors.grey[100],
                      //border: Border.all(width: 0.2, color: Colors.grey)
                    ),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: 100.0, maxHeight: 100.0),
                      child: new SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        //reverse: true,
                        child: Container(
                          //height: 100,
                          child: new TextField(
                            maxLines: null,
                            autofocus: false,
                            style: TextStyle(
                              color: Colors.black87,
                              fontFamily: 'Oswald',
                            ),
                            //controller: msgController,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: "Write something...",
                              hintStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w300),
                              contentPadding:
                                  EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                sharePost = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            //snackBar(context);
                            isSubmit == false ? statusShare(feeds.id) : null;
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20, top: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, top: 0),
                                    decoration: BoxDecoration(
                                        color: isSubmit == false
                                            ? header
                                            : Colors.grey[100],
                                        border: Border.all(
                                            color: Colors.grey, width: 0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Text(
                                      isSubmit == false
                                          ? "Share"
                                          : "Please wait...",
                                      style: TextStyle(
                                          color: isSubmit == false
                                              ? Colors.white
                                              : Colors.black26,
                                          fontSize: 15,
                                          fontFamily: 'BebasNeue',
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2.05,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      //border: Border.all(width: 0.8, color: Colors.grey[300]),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 16.0,
                          color: Colors.grey[300],
                          //offset: Offset(3.0, 4.0),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(
                        top: 5, bottom: 15, left: 10, right: 10),
                    child: SingleChildScrollView(
                      child: Container(
                        //color: Colors.yellow,
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        padding: EdgeInsets.only(right: 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ////// <<<<< pic start >>>>> //////
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: 10, top: 0, left: 0),
                                    height: 40,
                                    width: 40,
                                    //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                    padding: EdgeInsets.all(0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl: "${feeds.fuser.profilePic}",
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                "assets/images/user.png",
                                                fit: BoxFit.cover),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  ////// <<<<< pic end >>>>> //////

                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ////// <<<<< Name & Interest start >>>>> //////
                                          Container(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    "${feeds.fuser.firstName} ${feeds.fuser.lastName}",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      feeds.interests == null
                                                          ? ""
                                                          : " - ${feeds.interests}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: header,
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                          ////// <<<<< Name & Interest end >>>>> //////

                                          ////// <<<<< time job start >>>>> //////
                                          Container(
                                            margin: EdgeInsets.only(top: 3),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    days,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 11,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        child: Icon(
                                                          Icons.album,
                                                          size: 10,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          "  ${feeds.fuser.jobTitle}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color: header,
                                                              fontFamily:
                                                                  'Oswald',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          ////// <<<<< time job end >>>>> //////
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            feeds.feedType != "Status"
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.only(top: 20, right: 15),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: secondHalf == ""
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin:
                                                      EdgeInsets.only(left: 0),
                                                  child: new Text(firstHalf,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          fontSize: 13,
                                                          fontFamily: "Oswald",
                                                          fontWeight:
                                                              FontWeight.w300)),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin:
                                                      EdgeInsets.only(left: 0),
                                                  child: new Text(
                                                      feeds.isRead == "0" ||
                                                              feeds.isRead ==
                                                                  null
                                                          ? firstHalf + "..."
                                                          : firstHalf +
                                                              secondHalf,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          fontSize: 13,
                                                          fontFamily: "Oswald",
                                                          fontWeight:
                                                              FontWeight.w300)),
                                                ),
                                        ),
                                        Container()
                                      ],
                                    ),
                                  ),
                            Container(
                                margin: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 10,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    feeds.data.images.length == 0
                                        ? Container()
                                        : Stack(
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Container(
                                                      height: 500,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 10),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: CarouselSlider(
                                                          height: 500.0,
                                                          initialPage: 0,
                                                          enlargeCenterPage:
                                                              false,
                                                          autoPlay: false,
                                                          reverse: false,
                                                          viewportFraction: 1.0,
                                                          enableInfiniteScroll:
                                                              true,
                                                          autoPlayInterval:
                                                              Duration(
                                                                  seconds: 2),
                                                          autoPlayAnimationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      2000),
                                                          pauseAutoPlayOnTouch:
                                                              Duration(
                                                                  seconds: 10),
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          onPageChanged:
                                                              (index) {
                                                            setState(() {
                                                              _current = index;
                                                            });
                                                          },
                                                          items: imgList
                                                              .map((imgUrl) {
                                                            return Builder(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return CachedNetworkImage(
                                                                  imageUrl:
                                                                      imgUrl,
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Center(
                                                                          child:
                                                                              Text("Please Wait...")),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Image
                                                                          .asset(
                                                                    "assets/images/placeholder_cover.jpg",
                                                                    height: 40,
                                                                  ),

                                                                  // NetworkImage(
                                                                  //     widget.friend[index].profilePic
                                                                );
                                                              },
                                                            );
                                                          }).toList(),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: 15, right: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      color: Colors.grey[500],
                                                      child: Text(
                                                        "${imgList.length} images",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                "Oswald"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                    feeds.feedType == "Status"
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(left: 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: feeds.data.images
                                                                    .length ==
                                                                0
                                                            ? 0
                                                            : 10,
                                                        right: 0,
                                                        left: 0),
                                                    padding: EdgeInsets.all(5),
                                                    decoration: feeds
                                                                .data
                                                                .images
                                                                .length ==
                                                            0
                                                        ? BoxDecoration()
                                                        : BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey[300],
                                                                blurRadius: 17,
                                                              )
                                                            ],
                                                          ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (postList
                                                                      .feed[
                                                                          index]
                                                                      .isRead ==
                                                                  null ||
                                                              postList
                                                                      .feed[
                                                                          index]
                                                                      .isRead ==
                                                                  "0") {
                                                            postList.feed[index]
                                                                .isRead = "1";
                                                          } else {
                                                            postList.feed[index]
                                                                .isRead = "0";
                                                          }
                                                        });
                                                      },
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            child:
                                                                secondHalf == ""
                                                                    ? Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5),
                                                                        child: new Text(
                                                                            firstHalf,
                                                                            textAlign: TextAlign
                                                                                .justify,
                                                                            style: TextStyle(
                                                                                color: Colors.black.withOpacity(0.9),
                                                                                fontSize: 13,
                                                                                fontFamily: "Oswald",
                                                                                fontWeight: FontWeight.w300)),
                                                                      )
                                                                    : Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        margin: EdgeInsets.only(
                                                                            left: postList.feed[index].data.images.length == 0
                                                                                ? 0
                                                                                : 20),
                                                                        child: new Text(
                                                                            postList.feed[index].isRead == "0" || postList.feed[index].isRead == null
                                                                                ? firstHalf + "..."
                                                                                : firstHalf + secondHalf,
                                                                            textAlign: TextAlign.start,
                                                                            style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                      ),
                                                          ),
                                                          secondHalf == ""
                                                              ? Container()
                                                              : Container(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  margin: EdgeInsets.only(
                                                                      left: postList.feed[index].data.images.length ==
                                                                              0
                                                                          ? 0
                                                                          : 0,
                                                                      top: 5),
                                                                  child: new Text(
                                                                      postList.feed[index].isRead == "0" ||
                                                                              postList.feed[index].isRead ==
                                                                                  null
                                                                          ? "Read more"
                                                                          : "",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color:
                                                                              header,
                                                                          fontSize:
                                                                              13,
                                                                          fontFamily:
                                                                              "Oswald",
                                                                          fontWeight:
                                                                              FontWeight.w400)),
                                                                )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  void _securityModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.public),
                  title: new Text('Public',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontFamily: "Oswald")),
                  trailing: status == "Public"
                      ? Icon(Icons.done, color: header)
                      : Icon(Icons.done, color: Colors.transparent),
                  onTap: () => {
                    setState(() {
                      status = "Public";
                    }),
                    Navigator.pop(context)
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.lock_outline),
                  title: new Text('Connections',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontFamily: "Oswald")),
                  trailing: status == "Private"
                      ? Icon(Icons.done, color: header)
                      : Icon(Icons.done, color: Colors.transparent),
                  onTap: () => {
                    setState(() {
                      status = "Private";
                    }),
                    Navigator.pop(context)
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> statusShare(id) async {
    var data = {'sharedTxt': sharePost, "status_id": id};

    print(data);

    var res = await CallApi().postData1(data, 'share-status');
    print("res.body");
    print(res.body);
    print("res.statusCode");
    print(res.statusCode);
    //var body = json.decode(res.body);

    if (res.statusCode == 200) {
      print("oyeche");
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage(0)));
      setState(() {
        //isDelete.add("$id");
        //page1 = 0;
      });
    } else {
      Navigator.pop(context);
      _showMsg("Something went wrong!");
    }
  }

  void likeButtonPressed(index, type) async {
    setState(() {
      //_isLoading = true;
    });

    var data = {
      'id': '${postList.res[index].id}',
      'type': type,
      'uid': '${postList.res[index].userId}'
    };

    print(data);

    var res = await CallApi().postData1(data, 'add/like');
    var body = json.decode(res.body);

    print(body);
    //   if(body['success']){
    //   //   SharedPreferences localStorage = await SharedPreferences.getInstance();
    //   //   localStorage.remove('user');
    //   //   localStorage.setString('user', json.encode(body['user']));
    //   //  _showDialog('Information has been saved successfully!');
    //   print(body);

    //   }else{
    //     print('user is not updated');
    //   }

    setState(() {
      //_isLoading = false;
    });
  }

  _launchURL(link) async {
    var url = '$link';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
