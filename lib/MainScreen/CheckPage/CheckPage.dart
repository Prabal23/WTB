import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/MyDayCard/myDayCard.dart';
import 'package:chatapp_new/Cards/PostCard/postCard.dart';
import 'package:chatapp_new/JSON_Model/Feed_post_Model/feedPost_model.dart';
import 'package:chatapp_new/JSON_Model/NewsFeedModel/NewsFeedModel.dart';
import 'package:chatapp_new/Loader/PostLoader/postLoader.dart';
import 'package:chatapp_new/MainScreen/CommentPage/commentPage.dart';
import 'package:chatapp_new/MainScreen/CreatePost/createPost.dart';
import 'package:chatapp_new/MainScreen/EditPostPage/editPostPage.dart';
import 'package:chatapp_new/MainScreen/FeedStatusEditPage/feedStatusEditPage.dart';
import 'package:chatapp_new/MainScreen/ProductDetails/productDetails.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/FriendsProfilePage/friendsProfilePage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/MyProfilePage/myProfilePage.dart';
import 'package:chatapp_new/MainScreen/ShopPage/shopPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
//import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:back_button_interceptor/back_button_interceptor.dart';

import '../../main.dart';

List<String> isDelete = [];
int cc = 0;

class CheckPage extends StatefulWidget {
  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<CheckPage> with WidgetsBindingObserver {
  SharedPreferences sharedPreferences;
  String theme = "", pic = "";
  bool loading = true;
  var userData;
  //var postList;
  List<String> tagList = [];
  List<Widget> list = [];
  bool _isLoading = true;
  int id = 0, lastID = 1, lastid1 = 0;
  String proPic = "", statusPic = "", status = "Public", sharePost = "";
  int likeCount;
  //SocketIOManager manager;
  bool likePressed = false, beta = false, isSubmit = false;
  //bool loading = true;
  List<String> allPic = [];
  ScrollController _controller = new ScrollController();
  final RefreshController _refreshController = RefreshController();
  String des = "";
  String firstHalf;
  String secondHalf;
  bool flag = true;
  bool _isHasData = false;
  bool toLast = false;
  List likes = [];
  List feedList = [];

  @override
  void initState() {
    _getUserInfo();
    print(pageDirect);
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        if (_controller.position.pixels == 0) {
          setState(() {
            print("top");
          });
        }
        // you are at top position

        else {
          setState(() {
            print("bottom");
            loadPosts(lastID);

            print("lastID 1");
            print(lastID);
          });
        }
        // you are at bottom position
      }
    });
    super.initState();
  }

  void _getUserInfo() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    setState(() {
      userData = user;
    });

    var interests = userData['interests'];
    var shop = "${userData['shop_id']}";

    if (interests != null) {
      for (int i = 0; i < interests.length; i++) {
        tagList.add("${interests[i]['tag']}");
      }
    }

    SharedPreferences localStorage1 = await SharedPreferences.getInstance();
    localStorage1.setString('shop_id', shop);
    localStorage1.setStringList('tags', tagList.toList());
    pic = userData['profilePic'];
    id = userData['id'];

    if (pic.contains("localhost")) {
      pic = pic.replaceAll("localhost:3010/", "https://mobile.tradister.com/");
      pic = pic.replaceAll("localhost:8080/", "https://mobile.tradister.com/");
    } else {
      //pic = "http://10.0.2.2:3010" + pic;
    }

    loadPosts(1);
  }

  Future loadPosts(int number) async {
    //await Future.delayed(Duration(seconds: 3));
    if (page1 == 0 || _isHasData) {
      var postresponse =
          await CallApi().getData('feed?sid=$number&llid=1&lcid=1&lsid=1');

      setState(() {
        var postcontent = postresponse.body;
        final posts = json.decode(postcontent);
        var postdata = FeedPosts.fromJson(posts);
        postList = postdata;
        page1 = 0;
        _isHasData = true;

        for (int i = 0; i < postList.feed.length; i++) {
          print(postList.feed[i].id);
          feedList.add(postList.feed[i]);
          lastID = postList.feed[i].id;
          print(lastID);
        }
      });
    }

    setState(() {
      _isLoading = false;
    });
    //print(page1);
  }

  Future loadPosts1(int number) async {
    //await Future.delayed(Duration(seconds: 3));
    if (page1 == 0 || _isHasData) {
      var postresponse =
          await CallApi().getData('feed?sid=$number&llid=1&lcid=1&lsid=1');
      var postcontent = postresponse.body;
      final posts = json.decode(postcontent);
      var postdata = FeedPosts.fromJson(posts);

      setState(() {
        var postList1 = postdata;
        postList = postList1;
        //postList.feed.length += postList1.feed.length;
        _isHasData = true;

        for (int i = 0; i < postList.feed.length; i++) {
          feedList.add(postList.feed[i]);
          lastID = feedList[i].id;
          print(lastID);
        }
      });
    }
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
    //   // print(data);
    //   // sendMessage(identifier);
    //   // socket.emit("send-request", [
    //   //   {"msg": "new message"}
    //   // ]);
    // });

    // socket.on("receive_friend_request_user_29", (data) {
    //   print("response");
    //   print(data);
    // });
    // socket.connect();

    //sockets[driverId.toString()] = socket;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: beta
              ? Container(
                  child: SingleChildScrollView(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.transparent,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(20),
                            margin:
                                EdgeInsets.only(top: 5, left: 30, right: 30),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                color: Colors.grey[100],
                                border:
                                    Border.all(width: 0.5, color: Colors.grey)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                  padding: EdgeInsets.all(5.0),
                                  child: CircleAvatar(
                                    radius: 50.0,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        AssetImage('assets/images/icon.jpeg'),
                                  ),
                                  decoration: new BoxDecoration(
                                    color: Colors.white, // border color
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                top: 0,
                                                bottom: 0),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)),
                                                color: Colors.grey[100],
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Colors.grey[100])),
                                            child: Text(
                                              "This is a beta app with limited features",
                                              style: TextStyle(
                                                color: header,
                                                fontSize: 18,
                                                fontFamily: 'Oswald',
                                              ),
                                              textAlign: TextAlign.center,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ))
              : postList == null
                  ? PostLoaderCard()
                  : SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      //header: WaterDropMaterialHeader(),
                      onRefresh: () async {
                        await Future.delayed(Duration(seconds: 1));
                        setState(() {
                          page1 = 0;
                        });
                        //print(page1);
                        loadPosts(1);
                        _refreshController.refreshCompleted();
                      },
                      child: SingleChildScrollView(
                          child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.only(top: 0, bottom: 0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                            ),
                            child: Row(
                              children: <Widget>[
                                ////// <<<<< Profile >>>>> //////
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                //FriendsProfilePage("prabal23")),
                                                MyProfilePage(userData)));
                                  },
                                  child: Container(
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: 0, left: 15),
                                          padding: EdgeInsets.all(1.0),
                                          child: CircleAvatar(
                                            radius: 21.0,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage:
                                                pic == "" || pic == null
                                                    ? AssetImage(
                                                        'assets/images/man.png')
                                                    : NetworkImage("$pic"),
                                          ),
                                          decoration: new BoxDecoration(
                                            color: Colors.grey[300],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 45),
                                          padding: EdgeInsets.all(1.0),
                                          child: CircleAvatar(
                                            radius: 5.0,
                                            backgroundColor: Colors.greenAccent,
                                          ),
                                          decoration: new BoxDecoration(
                                            color: Colors.greenAccent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                ////// <<<<< Status/Photo field >>>>> //////
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreatePost(userData, 1)));
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(bottom: 10, top: 4),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        //mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10, top: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  border: Border.all(
                                                      color: Colors.grey[200],
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(25))),
                                              child: TextField(
                                                enabled: false,
                                                //controller: phoneController,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Oswald',
                                                ),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "What's in your mind?",
                                                  hintStyle: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 15,
                                                      fontFamily: 'Oswald',
                                                      fontWeight:
                                                          FontWeight.w300),
                                                  //labelStyle: TextStyle(color: Colors.white70),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          10.0, 1, 20.0, 1),
                                                  border: InputBorder.none,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                ////// <<<<< Photo post >>>>> //////
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreatePost(userData, 1)),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: back,
                                        border: Border.all(
                                            color: Colors.grey[100],
                                            width: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.all(11),
                                    child: Icon(
                                      Icons.photo,
                                      color: header,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //// <<<<< Divider 1 >>>>> //////
                          Container(
                              width: 50,
                              margin: EdgeInsets.only(
                                  top: 10, left: 25, right: 25, bottom: 15),
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
                          Container(
                            height: MediaQuery.of(context).size.height - 260,
                            child: Container(
                              child: ListView.builder(
                                  controller: _controller,
                                  itemCount: feedList.length,
                                  itemBuilder: (context, index) {
                                    des = "${feedList[index].data.status}";
                                    if (des.length > 150) {
                                      firstHalf = des.substring(0, 150);
                                      secondHalf =
                                          des.substring(150, des.length);
                                    } else {
                                      firstHalf = des;
                                      secondHalf = "";
                                    }

                                    String sharedFirstText = "";
                                    String sharedLastText = "";

                                    if (feedList[index].feedType == "Share") {
                                      var text =
                                          "${feedList[index].data.sharedTxt}";
                                      if (text.length > 150) {
                                        sharedFirstText =
                                            text.substring(0, 150);
                                        sharedLastText =
                                            text.substring(150, text.length);
                                      } else {
                                        sharedFirstText = text;
                                        sharedLastText = "";
                                      }
                                    }

                                    if (index + 1 == feedList.length) {
                                      //loadPosts1(postList.feed[index].id);
                                      //loadPosts(feedList[index].id);

                                      print("feedList[index].id");
                                      print(feedList[index].id);
                                    }

                                    for (int i = 0;
                                        i < feedList[index].data.images.length;
                                        i++) {
                                      if (feedList[index]
                                          .data
                                          .images[i]
                                          .file
                                          .contains("127.0.0.1")) {
                                        feedList[index].data.images[i].file =
                                            feedList[index]
                                                .data
                                                .images[i]
                                                .file
                                                .replaceAll(
                                                    "127.0.0.1", "10.0.2.2");
                                      }
                                    }
                                    return isDelete
                                            .contains("${feedList[index].id}")
                                        ? Container()
                                        : Container(
                                            //constraints: BoxConstraints.tightFor(height:150.0),
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
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
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    id ==
                                                            feedList[index]
                                                                .fuser
                                                                .id
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _statusModalBottomSheet(
                                                                    context,
                                                                    index,
                                                                    userData,
                                                                    feedList[
                                                                        index]);
                                                                //print(widget.feed[index].id);
                                                              });
                                                            },
                                                            child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            15),
                                                                // color: Colors.blue,
                                                                child: Icon(
                                                                  Icons
                                                                      .more_horiz,
                                                                  color: Colors
                                                                      .black54,
                                                                )),
                                                          )
                                                        : Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10),
                                                          ),
                                                  ],
                                                ),
                                                Container(
                                                  //color: Colors.yellow,
                                                  margin: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      bottom: 10),
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      ////// <<<<< pic start >>>>> //////
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 10),
                                                        padding:
                                                            EdgeInsets.all(1.0),
                                                        child: CircleAvatar(
                                                          radius: 20.0,
                                                          backgroundColor:
                                                              Colors.white,
                                                          backgroundImage: feedList[
                                                                          index]
                                                                      .fuser
                                                                      .profilePic ==
                                                                  null
                                                              ? AssetImage(
                                                                  "assets/images/man2.jpg")
                                                              : NetworkImage(
                                                                  "${feedList[index].fuser.profilePic}"),
                                                        ),
                                                        decoration:
                                                            new BoxDecoration(
                                                          color: Colors.grey[
                                                              300], // border color
                                                          shape:
                                                              BoxShape.circle,
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
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        "${feedList[index].fuser.firstName} ${feedList[index].fuser.lastName}",
                                                                        maxLines:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color: Colors
                                                                                .black,
                                                                            fontFamily:
                                                                                'Oswald',
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                      ),
                                                                    ),
                                                                    feedList[index].feedType ==
                                                                            "Share"
                                                                        ? Container(
                                                                            child:
                                                                                Text(
                                                                              " shared a post",
                                                                              maxLines: 1,
                                                                              style: TextStyle(fontSize: 15, color: Colors.grey, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                            ),
                                                                          )
                                                                        : feedList[index].feedType ==
                                                                                "ComPost"
                                                                            ? Container(
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Text(
                                                                                      " has posted in",
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(fontSize: 15, color: Colors.grey, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                    Text(
                                                                                      " ${feedList[index].data.comName}",
                                                                                      maxLines: 1,
                                                                                      style: TextStyle(fontSize: 15, color: header, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            : feedList[index].feedType == "Shop"
                                                                                ? Container(
                                                                                    child: Row(
                                                                                      children: <Widget>[
                                                                                        Text(
                                                                                          " has created a shop",
                                                                                          maxLines: 1,
                                                                                          style: TextStyle(fontSize: 15, color: Colors.grey, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                : feedList[index].feedType == "Product"
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
                                                                    // widget.feed[index].activityType ==
                                                                    //         "community"
                                                                    //     ? Container(
                                                                    //         child: Text(
                                                                    //           " has created a community",
                                                                    //           maxLines: 1,
                                                                    //           style: TextStyle(
                                                                    //               fontSize: 15,
                                                                    //               color: Colors.black54,
                                                                    //               fontFamily: 'Oswald',
                                                                    //               fontWeight:
                                                                    //                   FontWeight.w300),
                                                                    //         ),
                                                                    //       )
                                                                    //     : Container(),
                                                                    // widget.feed[index].shop != null &&
                                                                    //         widget.feed[index].product ==
                                                                    //             null
                                                                    //     ? Container(
                                                                    //         child: Text(
                                                                    //           " has created a shop",
                                                                    //           maxLines: 1,
                                                                    //           style: TextStyle(
                                                                    //               fontSize: 15,
                                                                    //               color: Colors.black54,
                                                                    //               fontFamily: 'Oswald',
                                                                    //               fontWeight:
                                                                    //                   FontWeight.w300),
                                                                    //         ),
                                                                    //       )
                                                                    //     : Container(),
                                                                    // widget.feed[index].shop != null &&
                                                                    //         widget.feed[index].product !=
                                                                    //             null
                                                                    //     ? Container(
                                                                    //         child: Text(
                                                                    //           " has uploaded a new product",
                                                                    //           maxLines: 1,
                                                                    //           style: TextStyle(
                                                                    //               fontSize: 15,
                                                                    //               color: Colors.black54,
                                                                    //               fontFamily: 'Oswald',
                                                                    //               fontWeight:
                                                                    //                   FontWeight.w300),
                                                                    //         ),
                                                                    //       )
                                                                    //     : Container(),
                                                                    // widget.feed[index].activityType ==
                                                                    //         "offer"
                                                                    //     ? Container(
                                                                    //         child: Text(
                                                                    //           " has created a offer",
                                                                    //           maxLines: 1,
                                                                    //           style: TextStyle(
                                                                    //               fontSize: 15,
                                                                    //               color: Colors.black54,
                                                                    //               fontFamily: 'Oswald',
                                                                    //               fontWeight:
                                                                    //                   FontWeight.w300),
                                                                    //         ),
                                                                    //       )
                                                                    //     : Container(),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          feedList[index].interests == null
                                                                              ? ""
                                                                              : " - ${feedList[index].interests}",
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
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 3),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        index % 2 ==
                                                                                0
                                                                            ? "6 hr"
                                                                            : "Aug 7 at 5:34 PM",
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'Oswald',
                                                                            fontWeight: FontWeight
                                                                                .w400,
                                                                            fontSize:
                                                                                11,
                                                                            color:
                                                                                Colors.black54),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              10),
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            child:
                                                                                Icon(
                                                                              Icons.album,
                                                                              size: 10,
                                                                              color: Colors.black54,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              "  ${feedList[index].fuser.jobTitle}",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(fontSize: 11, color: header, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                            ),
                                                                          ),
                                                                        ],
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
                                                feedList[index].feedType ==
                                                        "Share"
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10, right: 15),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              if (feedList[index]
                                                                          .isRead ==
                                                                      null ||
                                                                  feedList[index]
                                                                          .isRead ==
                                                                      "0") {
                                                                feedList[index]
                                                                        .isRead =
                                                                    "1";
                                                              } else {
                                                                feedList[index]
                                                                        .isRead =
                                                                    "0";
                                                              }
                                                            });
                                                          },
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                child: sharedLastText ==
                                                                        ""
                                                                    ? Container(
                                                                        width: MediaQuery.of(context)
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
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20),
                                                                        child: new Text(
                                                                            feedList[index].isRead == "0" || feedList[index].isRead == null
                                                                                ? sharedFirstText + "..."
                                                                                : sharedLastText + sharedFirstText,
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
                                                                          left:
                                                                              20,
                                                                          top:
                                                                              5),
                                                                      child: new Text(
                                                                          feedList[index].isRead == "0" || feedList[index].isRead == null
                                                                              ? "Read more"
                                                                              : "",
                                                                          textAlign: TextAlign
                                                                              .start,
                                                                          style: TextStyle(
                                                                              color: header,
                                                                              fontSize: 13,
                                                                              fontFamily: "Oswald",
                                                                              fontWeight: FontWeight.w400)),
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : feedList[index]
                                                                .feedType !=
                                                            "Status"
                                                        ? Container()
                                                        : Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    right: 15),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  if (feedList[index]
                                                                              .isRead ==
                                                                          null ||
                                                                      feedList[index]
                                                                              .isRead ==
                                                                          "0") {
                                                                    feedList[index]
                                                                            .isRead =
                                                                        "1";
                                                                  } else {
                                                                    feedList[index]
                                                                            .isRead =
                                                                        "0";
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
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            margin:
                                                                                EdgeInsets.only(left: 20),
                                                                            child: new Text(firstHalf,
                                                                                textAlign: TextAlign.justify,
                                                                                style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                          )
                                                                        : Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            margin:
                                                                                EdgeInsets.only(left: 20),
                                                                            child: new Text(feedList[index].isRead == "0" || feedList[index].isRead == null ? firstHalf + "..." : firstHalf + secondHalf,
                                                                                textAlign: TextAlign.start,
                                                                                style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                          ),
                                                                  ),
                                                                  secondHalf ==
                                                                          ""
                                                                      ? Container()
                                                                      : Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          margin: EdgeInsets.only(
                                                                              left: 20,
                                                                              top: 5),
                                                                          child: new Text(
                                                                              feedList[index].isRead == "0" || feedList[index].isRead == null ? "Read more" : "",
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(color: header, fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w400)),
                                                                        )
                                                                ],
                                                              ),
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
                                                        feedList[index]
                                                                    .data
                                                                    .images
                                                                    .length ==
                                                                0
                                                            ? Container()
                                                            : Container(
                                                                //color: Colors.red,
                                                                height: 200,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        0.0),
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                decoration: BoxDecoration(
                                                                    borderRadius: BorderRadius.circular(15),
                                                                    image: DecorationImage(
                                                                        image: //AssetImage("assets/images/friend7.jpg"),
                                                                            NetworkImage("${feedList[index].data.images[0].file}"),
                                                                        fit: BoxFit.contain)),
                                                                child: null)
                                                        ////// <<<<< Status start >>>>> //////
                                                        // Container(
                                                        //   margin: EdgeInsets.only(bottom: 10),
                                                        //   alignment: Alignment.centerLeft,
                                                        //   child: Text(
                                                        //     widget.feed[index].activityType == "community"
                                                        //         ? "${widget.feed[index].group.name}"
                                                        //         : widget.feed[index].shop != null &&
                                                        //                 widget.feed[index].product == null
                                                        //             ? "${widget.feed[index].shop.shopName}"
                                                        //             : widget.feed[index].shop != null &&
                                                        //                     widget.feed[index].product !=
                                                        //                         null
                                                        //                 ? "${widget.feed[index].product.productName}"
                                                        //                 : widget.feed[index]
                                                        //                             .activityType ==
                                                        //                         "offer"
                                                        //                     ? "${widget.feed[index].offer.title}"
                                                        //                     : widget.feed[index].status ==
                                                        //                             null
                                                        //                         ? ""
                                                        //                         : "${widget.feed[index].status}",
                                                        //     textAlign: TextAlign.justify,
                                                        //     style: TextStyle(
                                                        //         color: Colors.black,
                                                        //         fontWeight: FontWeight.w400),
                                                        //   ),
                                                        // ),

                                                        ////// <<<<< Status end >>>>> //////

                                                        ////// <<<<< Picture Start >>>>> //////
                                                        // widget.feed[index].activityType == "community"
                                                        // ? Container(
                                                        //     //color: Colors.red,
                                                        //     height: 200,
                                                        //     padding: const EdgeInsets.all(0.0),
                                                        //     margin: EdgeInsets.only(top: 10),
                                                        //     decoration: BoxDecoration(
                                                        //         borderRadius:
                                                        //             BorderRadius.circular(15),
                                                        //         image: DecorationImage(
                                                        //             image: //AssetImage("assets/images/friend7.jpg"),
                                                        //                 NetworkImage(
                                                        //                     "${widget.feed[index].group.logo}"),
                                                        //             fit: BoxFit.cover)),
                                                        //     child: null)
                                                        //     : widget.feed[index].shop != null &&
                                                        //             widget.feed[index].product == null
                                                        //         ? GestureDetector(
                                                        //             onTap: () {
                                                        //               Navigator.push(
                                                        //                   context,
                                                        //                   MaterialPageRoute(
                                                        //                       builder: (context) =>
                                                        //                           ShopPage(
                                                        //                               widget.feed[index]
                                                        //                                   .shop.id,
                                                        //                               widget.userData[
                                                        //                                   'id'])));
                                                        //             },
                                                        //             child: Container(
                                                        //                 //color: Colors.red,
                                                        //                 height: 200,
                                                        //                 padding:
                                                        //                     const EdgeInsets.all(0.0),
                                                        //                 margin: EdgeInsets.only(top: 10),
                                                        //                 decoration: BoxDecoration(
                                                        //                     borderRadius:
                                                        //                         BorderRadius.circular(15),
                                                        //                     image: DecorationImage(
                                                        //                         image: //AssetImage("assets/images/friend7.jpg"),
                                                        //                             NetworkImage(
                                                        //                                 "${widget.feed[index].shop.logo}"),
                                                        //                         fit: BoxFit.cover)),
                                                        //                 child: null),
                                                        //           )
                                                        //         : widget.feed[index].shop != null &&
                                                        //                 widget.feed[index].product != null
                                                        //             ? GestureDetector(
                                                        //                 onTap: () {
                                                        //                   Navigator.push(
                                                        //                       context,
                                                        //                       MaterialPageRoute(
                                                        //                           builder: (context) =>
                                                        //                               ProductDetailsPage(
                                                        //                                   widget
                                                        //                                       .feed[index]
                                                        //                                       .product
                                                        //                                       .id)));
                                                        //                 },
                                                        //                 child: Container(
                                                        //                     //color: Colors.red,
                                                        //                     height: 200,
                                                        //                     padding:
                                                        //                         const EdgeInsets.all(0.0),
                                                        //                     margin:
                                                        //                         EdgeInsets.only(top: 10),
                                                        //                     decoration: BoxDecoration(
                                                        //                         borderRadius:
                                                        //                             BorderRadius.circular(
                                                        //                                 15),
                                                        //                         image: DecorationImage(
                                                        //                             image: //AssetImage("assets/images/friend7.jpg"),
                                                        //                                 NetworkImage(
                                                        //                                     "${widget.feed[index].product.singleImage.image}"),
                                                        //                             fit: BoxFit.cover)),
                                                        //                     child: null),
                                                        //               )
                                                        //             : widget.feed[index].images == null
                                                        //                 ? Container()
                                                        //                 : widget.feed[index].images
                                                        //                             .length ==
                                                        //                         0
                                                        //                     ? Container()
                                                        //                     : widget.feed[index].images
                                                        //                                 .length ==
                                                        //                             1
                                                        //                         ? Container(
                                                        //                             //color: Colors.red,
                                                        //                             height: 200,
                                                        //                             padding:
                                                        //                                 const EdgeInsets
                                                        //                                     .all(0.0),
                                                        //                             margin:
                                                        //                                 EdgeInsets.only(
                                                        //                                     top: 10),
                                                        //                             decoration:
                                                        //                                 BoxDecoration(
                                                        //                                     borderRadius:
                                                        //                                         BorderRadius
                                                        //                                             .circular(
                                                        //                                                 15),
                                                        //                                     image: DecorationImage(
                                                        //                                         image: //AssetImage("assets/images/friend7.jpg"),
                                                        //                                             NetworkImage("${widget.feed[index].images[0].thum}"),
                                                        //                                         fit: BoxFit.cover)),
                                                        //                             child: null)
                                                        //                         : Container(
                                                        //                             height: widget
                                                        //                                         .feed[
                                                        //                                             index]
                                                        //                                         .images
                                                        //                                         .length <=
                                                        //                                     3
                                                        //                                 ? 100
                                                        //                                 : 200,
                                                        //                             child:
                                                        //                                 GridView.builder(
                                                        //                               //semanticChildCount: 2,
                                                        //                               gridDelegate:
                                                        //                                   SliverGridDelegateWithMaxCrossAxisExtent(
                                                        //                                 maxCrossAxisExtent:
                                                        //                                     100.0,
                                                        //                                 mainAxisSpacing:
                                                        //                                     0.0,
                                                        //                                 crossAxisSpacing:
                                                        //                                     0.0,
                                                        //                                 childAspectRatio:
                                                        //                                     1.0,
                                                        //                               ),
                                                        //                               //crossAxisCount: 2,
                                                        //                               itemBuilder: (BuildContext
                                                        //                                           context,
                                                        //                                       int indexes) =>
                                                        //                                   new Padding(
                                                        //                                 padding:
                                                        //                                     const EdgeInsets
                                                        //                                         .all(5.0),
                                                        //                                 child: Container(
                                                        //                                   height: 100,
                                                        //                                   //width: 50,
                                                        //                                   padding:
                                                        //                                       const EdgeInsets
                                                        //                                               .all(
                                                        //                                           5.0),
                                                        //                                   decoration: BoxDecoration(
                                                        //                                       border: Border.all(
                                                        //                                           width:
                                                        //                                               0.1,
                                                        //                                           color: Colors
                                                        //                                               .grey),
                                                        //                                       image: DecorationImage(
                                                        //                                           image: NetworkImage(
                                                        //                                               "${widget.feed[index].images[indexes].thum}"))),
                                                        //                                 ),
                                                        //                               ),
                                                        //                               itemCount: widget
                                                        //                                   .feed[index]
                                                        //                                   .images
                                                        //                                   .length,
                                                        //                             ),
                                                        //                           ),
                                                      ],
                                                    )),
                                                feedList[index].feedType ==
                                                        "Share"
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10,
                                                                bottom: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          border: Border.all(
                                                              width: 0.8,
                                                              color: Colors
                                                                  .grey[300]),
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
                                                            top: 5,
                                                            bottom: 15,
                                                            left: 20,
                                                            right: 20),
                                                        child:
                                                            SingleChildScrollView(
                                                          child: Container(
                                                            //color: Colors.yellow,
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    right: 20,
                                                                    bottom: 10),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      ////// <<<<< pic start >>>>> //////
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            right:
                                                                                10),
                                                                        padding:
                                                                            EdgeInsets.all(1.0),
                                                                        child:
                                                                            CircleAvatar(
                                                                          radius:
                                                                              20.0,
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                          backgroundImage: feedList[index].data.fuser.profilePic == null
                                                                              ? AssetImage("assets/images/man2.jpg")
                                                                              : NetworkImage("${feedList[index].data.fuser.profilePic}"),
                                                                        ),
                                                                        decoration:
                                                                            new BoxDecoration(
                                                                          color:
                                                                              Colors.grey[300], // border color
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                      ),
                                                                      ////// <<<<< pic end >>>>> //////

                                                                      Expanded(
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              ////// <<<<< Name & Interest start >>>>> //////
                                                                              Container(
                                                                                child: Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: <Widget>[
                                                                                    Container(
                                                                                      child: Text(
                                                                                        "${feedList[index].data.fuser.firstName} ${feedList[index].data.fuser.lastName}",
                                                                                        maxLines: 1,
                                                                                        style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Container(
                                                                                        child: Text(
                                                                                          feedList[index].data.interest == null ? "" : " - ${feedList[index].data.interest}",
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
                                                                                margin: EdgeInsets.only(top: 3),
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Container(
                                                                                      child: Text(
                                                                                        index % 2 == 0 ? "6 hr" : "Aug 7 at 5:34 PM",
                                                                                        maxLines: 1,
                                                                                        overflow: TextOverflow.ellipsis,
                                                                                        style: TextStyle(fontFamily: 'Oswald', fontWeight: FontWeight.w400, fontSize: 11, color: Colors.black54),
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      margin: EdgeInsets.only(left: 10),
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
                                                                                              "  ${feedList[index].data.fuser.jobTitle}",
                                                                                              maxLines: 1,
                                                                                              overflow: TextOverflow.ellipsis,
                                                                                              style: TextStyle(fontSize: 11, color: header, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
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
                                                                feedList[index]
                                                                            .data
                                                                            .feedType !=
                                                                        "Status"
                                                                    ? Container()
                                                                    : Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                20,
                                                                            right:
                                                                                15),
                                                                        child:
                                                                            Column(
                                                                          children: <
                                                                              Widget>[
                                                                            Container(
                                                                              child: secondHalf == ""
                                                                                  ? Container(
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      margin: EdgeInsets.only(left: 0),
                                                                                      child: new Text(firstHalf, textAlign: TextAlign.justify, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                                    )
                                                                                  : Container(
                                                                                      width: MediaQuery.of(context).size.width,
                                                                                      margin: EdgeInsets.only(left: 0),
                                                                                      child: new Text(feedList[index].data.isRead == "0" || feedList[index].data.isRead == null ? firstHalf + "..." : firstHalf + secondHalf, textAlign: TextAlign.start, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                                    ),
                                                                            ),
                                                                            Container()
                                                                          ],
                                                                        ),
                                                                      ),
                                                                Container(
                                                                    margin:
                                                                        EdgeInsets
                                                                            .only(
                                                                      left: 0,
                                                                      right: 20,
                                                                      top: 10,
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        feedList[index].data.images.length ==
                                                                                0
                                                                            ? Container()
                                                                            : Container(
                                                                                //color: Colors.red,
                                                                                height: 200,
                                                                                padding: const EdgeInsets.all(0.0),
                                                                                margin: EdgeInsets.only(top: 10),
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(15),
                                                                                    image: DecorationImage(
                                                                                        image: //AssetImage("assets/images/friend7.jpg"),
                                                                                            NetworkImage("${feedList[index].data.images[0].file}"),
                                                                                        fit: BoxFit.cover)),
                                                                                child: null),
                                                                        feedList[index].data.feedType ==
                                                                                "Status"
                                                                            ? Container()
                                                                            : Container(
                                                                                margin: EdgeInsets.only(left: 0),
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Expanded(
                                                                                      child: Container(
                                                                                        margin: EdgeInsets.only(top: feedList[index].data.images.length == 0 ? 0 : 10, right: 0, left: 0),
                                                                                        padding: EdgeInsets.all(5),
                                                                                        decoration: feedList[index].data.images.length == 0
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
                                                                                              if (feedList[index].isRead == null || feedList[index].isRead == "0") {
                                                                                                feedList[index].isRead = "1";
                                                                                              } else {
                                                                                                feedList[index].isRead = "0";
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
                                                                                                        margin: EdgeInsets.only(left: feedList[index].data.images.length == 0 ? 0 : 20),
                                                                                                        child: new Text(feedList[index].isRead == "0" || feedList[index].isRead == null ? firstHalf + "..." : firstHalf + secondHalf, textAlign: TextAlign.start, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                                                      ),
                                                                                              ),
                                                                                              secondHalf == ""
                                                                                                  ? Container()
                                                                                                  : Container(
                                                                                                      width: MediaQuery.of(context).size.width,
                                                                                                      margin: EdgeInsets.only(left: feedList[index].data.images.length == 0 ? 0 : 0, top: 5),
                                                                                                      child: new Text(feedList[index].isRead == "0" || feedList[index].isRead == null ? "Read more" : "", textAlign: TextAlign.start, style: TextStyle(color: header, fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w400)),
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
                                                    : feedList[index]
                                                                .feedType ==
                                                            "Status"
                                                        ? Container()
                                                        : Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 20),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: feedList[index].data.images.length ==
                                                                                0
                                                                            ? 0
                                                                            : 10,
                                                                        right:
                                                                            20,
                                                                        left:
                                                                            0),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    decoration: feedList[index].data.images.length ==
                                                                            0
                                                                        ? BoxDecoration()
                                                                        : BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10)),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.grey[300],
                                                                                blurRadius: 17,
                                                                              )
                                                                            ],
                                                                          ),
                                                                    child:
                                                                        GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          if (feedList[index].isRead == null ||
                                                                              feedList[index].isRead == "0") {
                                                                            feedList[index].isRead =
                                                                                "1";
                                                                          } else {
                                                                            feedList[index].isRead =
                                                                                "0";
                                                                          }
                                                                        });
                                                                      },
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            child: secondHalf == ""
                                                                                ? Container(
                                                                                    width: MediaQuery.of(context).size.width,
                                                                                    margin: EdgeInsets.only(left: 5),
                                                                                    child: new Text(firstHalf, textAlign: TextAlign.justify, style: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                                  )
                                                                                : Container(
                                                                                    width: MediaQuery.of(context).size.width,
                                                                                    margin: EdgeInsets.only(left: feedList[index].data.images.length == 0 ? 0 : 20),
                                                                                    child: new Text(feedList[index].isRead == "0" || feedList[index].isRead == null ? firstHalf + "..." : firstHalf + secondHalf, textAlign: TextAlign.start, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                                  ),
                                                                          ),
                                                                          secondHalf == ""
                                                                              ? Container()
                                                                              : Container(
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  margin: EdgeInsets.only(left: feedList[index].data.images.length == 0 ? 0 : 20, top: 5),
                                                                                  child: new Text(feedList[index].isRead == "0" || feedList[index].isRead == null ? "Read more" : "", textAlign: TextAlign.start, style: TextStyle(color: header, fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w400)),
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
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    3.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                if (feedList[
                                                                            index]
                                                                        .like !=
                                                                    null) {
                                                                  setState(() {
                                                                    feedList[index]
                                                                            .like =
                                                                        null;
                                                                    // print(widget.feed[index].meta
                                                                    //     .totalLikesCount);
                                                                    // likeCount = widget
                                                                    //     .feed[index].meta.totalLikesCount;
                                                                    // //likeCount = likeCount - 1;
                                                                    // print(widget.feed[index].meta
                                                                    //     .totalLikesCount);
                                                                    // print("bfg $likeCount");

                                                                    feedList[
                                                                            index]
                                                                        .meta
                                                                        .totalLikesCount = feedList[index]
                                                                            .meta
                                                                            .totalLikesCount -
                                                                        1;
                                                                    //likes.insert(index, likeCount);
                                                                  });
                                                                  likeButtonPressed(
                                                                      index, 0);
                                                                  //print(likes);
                                                                } else {
                                                                  setState(() {
                                                                    feedList[
                                                                            index]
                                                                        .like = 1;
                                                                    // print(widget.feed[index].meta
                                                                    //     .totalLikesCount);
                                                                    // likeCount = widget
                                                                    //     .feed[index].meta.totalLikesCount;
                                                                    // likeCount = likeCount + 1;
                                                                    // print("bfg $likeCount");
                                                                    feedList[
                                                                            index]
                                                                        .meta
                                                                        .totalLikesCount = feedList[index]
                                                                            .meta
                                                                            .totalLikesCount +
                                                                        1;
                                                                    // likeCount = widget
                                                                    //     .feed[index].meta.totalLikesCount;
                                                                    // likeCount = likeCount + 1;
                                                                    //likes.insert(index, likeCount);
                                                                  });
                                                                  likeButtonPressed(
                                                                      index, 1);
                                                                  //print(likes);
                                                                }
                                                              },
                                                              child: Container(
                                                                child: Icon(
                                                                  feedList[index]
                                                                              .like !=
                                                                          null
                                                                      //likePressed == true
                                                                      ? Icons
                                                                          .favorite
                                                                      : Icons
                                                                          .favorite_border,
                                                                  size: 20,
                                                                  color: feedList[index]
                                                                              .like !=
                                                                          null
                                                                      //likePressed == true
                                                                      ? Colors
                                                                          .redAccent
                                                                      : Colors
                                                                          .black54,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 3),
                                                            child: Text(
                                                                "${feedList[index].meta.totalLikesCount}",
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
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    CommentPage(
                                                                        feedList[index]
                                                                            .id,
                                                                        index)),
                                                          );
                                                        },
                                                        child: Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            15),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            3.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .chat_bubble_outline,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            3),
                                                                child: Text(
                                                                    feedList[index].meta.totalCommentsCount == null
                                                                        ? ""
                                                                        : "${feedList[index].meta.totalCommentsCount}",
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
                                                              feedList[index]);
                                                        },
                                                        child: Container(
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            15),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            3.0),
                                                                child: Icon(
                                                                  Icons.send,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .black54,
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            3),
                                                                child: Text(
                                                                    feedList[index].meta.totalSharesCount == null
                                                                        ? ""
                                                                        : "${feedList[index].meta.totalSharesCount}",
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
                                          );
                                  }),
                            ),
                          )
                        ],
                      )),
                    ),
        ),
      ),
    );
  }

  Widget listLoad(int id) {
    //loadPosts1(id);
    print(id);
    print(postList.feed.length);
    print("tumi baad");

    return null;
  }

  List<Widget> _showFeedList() {
    int checkIndex = 0;
    print("postList 1");
    print(postList);
    // print("postList.feed.length");
    // print(postList.feed.length);
    for (var d in postList.feed) {
      print("index");
      print(checkIndex);
      //print(d.data.status);
      des = "${d.data.status}";
      if (des.length > 150) {
        firstHalf = des.substring(0, 150);
        secondHalf = des.substring(150, des.length);
      } else {
        firstHalf = des;
        secondHalf = "";
      }

      setState(() {
        checkIndex++;
        if (checkIndex >= postList.feed.length) {
          checkIndex = postList.feed.length - 1;
          print("checkIndex 1");
          print(checkIndex);
        } else {
          int index = checkIndex;
          print(index);
          print(postList.feed.length);
          print("checkIndex 2");
          print(checkIndex);
          if (checkIndex + 1 == postList.feed.length) {
            //loadPosts1(d.id);
            print(checkIndex);
            print(postList.feed.length);
            print("tumi baad");
          }
        }

        // if (checkIndex + 1 == postList.feed.length) {
        //   //loadPosts1(d.id);
        //   //listLoad(d.id);
        //   print(checkIndex);
        //   print(postList.feed.length);
        //   print("tumi baad");
        // }
      });

      for (int i = 0; i < d.data.images.length; i++) {
        if (d.data.images[i].file.contains("localhost")) {
          setState(() {
            d.data.images[i].file =
                d.data.images[i].file.replaceAll("localhost", "10.0.2.2");
          });
        }
      }

      print("id");
      print(id);
      print("d.fuser.id");
      print(d.fuser.id);

      list.add(isDelete.contains("${d.id}")
          ? Container()
          : Container(
              child: isDelete.contains("${d.id}")
                  ? Container()
                  : Container(
                      padding: EdgeInsets.only(top: 5, bottom: 10),
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
                          top: 5, bottom: 5, left: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              id == d.fuser.id
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _statusModalBottomSheet(
                                              context, checkIndex, userData, d);
                                          //print(widget.feed[index].id);
                                        });
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(right: 15),
                                          // color: Colors.blue,
                                          child: Icon(
                                            Icons.more_horiz,
                                            color: Colors.black54,
                                          )),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(top: 10),
                                    ),
                            ],
                          ),
                          Container(
                            //color: Colors.yellow,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ////// <<<<< pic start >>>>> //////
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.all(1.0),
                                  child: CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.white,
                                    backgroundImage: d.fuser.profilePic == null
                                        ? AssetImage("assets/images/man2.jpg")
                                        : NetworkImage("${d.fuser.profilePic}"),
                                  ),
                                  decoration: new BoxDecoration(
                                    color: Colors.grey[300], // border color
                                    shape: BoxShape.circle,
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
                                                  "${d.fuser.firstName} ${d.fuser.lastName}",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontFamily: 'Oswald',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              // widget.feed[index].activityType ==
                                              //         "community"
                                              //     ? Container(
                                              //         child: Text(
                                              //           " has created a community",
                                              //           maxLines: 1,
                                              //           style: TextStyle(
                                              //               fontSize: 15,
                                              //               color: Colors.black54,
                                              //               fontFamily: 'Oswald',
                                              //               fontWeight:
                                              //                   FontWeight.w300),
                                              //         ),
                                              //       )
                                              //     : Container(),
                                              // widget.feed[index].shop != null &&
                                              //         widget.feed[index].product ==
                                              //             null
                                              //     ? Container(
                                              //         child: Text(
                                              //           " has created a shop",
                                              //           maxLines: 1,
                                              //           style: TextStyle(
                                              //               fontSize: 15,
                                              //               color: Colors.black54,
                                              //               fontFamily: 'Oswald',
                                              //               fontWeight:
                                              //                   FontWeight.w300),
                                              //         ),
                                              //       )
                                              //     : Container(),
                                              // widget.feed[index].shop != null &&
                                              //         widget.feed[index].product !=
                                              //             null
                                              //     ? Container(
                                              //         child: Text(
                                              //           " has uploaded a new product",
                                              //           maxLines: 1,
                                              //           style: TextStyle(
                                              //               fontSize: 15,
                                              //               color: Colors.black54,
                                              //               fontFamily: 'Oswald',
                                              //               fontWeight:
                                              //                   FontWeight.w300),
                                              //         ),
                                              //       )
                                              //     : Container(),
                                              // widget.feed[index].activityType ==
                                              //         "offer"
                                              //     ? Container(
                                              //         child: Text(
                                              //           " has created a offer",
                                              //           maxLines: 1,
                                              //           style: TextStyle(
                                              //               fontSize: 15,
                                              //               color: Colors.black54,
                                              //               fontFamily: 'Oswald',
                                              //               fontWeight:
                                              //                   FontWeight.w300),
                                              //         ),
                                              //       )
                                              //     : Container(),
                                              d.feedType == "ComPost"
                                                  ? Expanded(
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 2),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              "Posted in",
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey,
                                                                  fontFamily:
                                                                      'Oswald',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                child: Text(
                                                                  d.data.comName ==
                                                                          null
                                                                      ? ""
                                                                      : " ${d.data.comName}",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color:
                                                                          header,
                                                                      fontFamily:
                                                                          'Oswald',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: Container(
                                                        child: Text(
                                                          d.interests == null
                                                              ? ""
                                                              : " - ${d.interests}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: header,
                                                              fontFamily:
                                                                  'Oswald',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
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
                                                  "Aug 7 at 5:34 PM",
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
                                              Expanded(
                                                child: Container(
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
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            "  ${d.fuser.jobTitle}",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
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
                                                      ),
                                                    ],
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
                          d.feedType != "Status"
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(top: 10, right: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (d.isRead == null ||
                                            d.isRead == "0") {
                                          d.isRead = "1";
                                        } else {
                                          d.isRead = "0";
                                        }
                                      });
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: secondHalf == ""
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin:
                                                      EdgeInsets.only(left: 20),
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
                                                      EdgeInsets.only(left: 20),
                                                  child: new Text(
                                                      d.isRead == "0" ||
                                                              d.isRead == null
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
                                        secondHalf == ""
                                            ? Container()
                                            : Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: EdgeInsets.only(
                                                    left: 20, top: 5),
                                                child: new Text(
                                                    d.isRead == "0" ||
                                                            d.isRead == null
                                                        ? "Read more"
                                                        : "",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: header,
                                                        fontSize: 13,
                                                        fontFamily: "Oswald",
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              )
                                      ],
                                    ),
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
                                  d.data.images.length == 0
                                      ? Container()
                                      : Container(
                                          //color: Colors.red,
                                          height: 200,
                                          padding: const EdgeInsets.all(0.0),
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: DecorationImage(
                                                  image: //AssetImage("assets/images/friend7.jpg"),
                                                      NetworkImage(
                                                          "${d.data.images[0].file}"),
                                                  fit: BoxFit.cover)),
                                          child: null)
                                  ////// <<<<< Status start >>>>> //////
                                  // Container(
                                  //   margin: EdgeInsets.only(bottom: 10),
                                  //   alignment: Alignment.centerLeft,
                                  //   child: Text(
                                  //     widget.feed[index].activityType == "community"
                                  //         ? "${widget.feed[index].group.name}"
                                  //         : widget.feed[index].shop != null &&
                                  //                 widget.feed[index].product == null
                                  //             ? "${widget.feed[index].shop.shopName}"
                                  //             : widget.feed[index].shop != null &&
                                  //                     widget.feed[index].product !=
                                  //                         null
                                  //                 ? "${widget.feed[index].product.productName}"
                                  //                 : widget.feed[index]
                                  //                             .activityType ==
                                  //                         "offer"
                                  //                     ? "${widget.feed[index].offer.title}"
                                  //                     : widget.feed[index].status ==
                                  //                             null
                                  //                         ? ""
                                  //                         : "${widget.feed[index].status}",
                                  //     textAlign: TextAlign.justify,
                                  //     style: TextStyle(
                                  //         color: Colors.black,
                                  //         fontWeight: FontWeight.w400),
                                  //   ),
                                  // ),

                                  ////// <<<<< Status end >>>>> //////

                                  ////// <<<<< Picture Start >>>>> //////
                                  // widget.feed[index].activityType == "community"
                                  // ? Container(
                                  //     //color: Colors.red,
                                  //     height: 200,
                                  //     padding: const EdgeInsets.all(0.0),
                                  //     margin: EdgeInsets.only(top: 10),
                                  //     decoration: BoxDecoration(
                                  //         borderRadius:
                                  //             BorderRadius.circular(15),
                                  //         image: DecorationImage(
                                  //             image: //AssetImage("assets/images/friend7.jpg"),
                                  //                 NetworkImage(
                                  //                     "${widget.feed[index].group.logo}"),
                                  //             fit: BoxFit.cover)),
                                  //     child: null)
                                  //     : widget.feed[index].shop != null &&
                                  //             widget.feed[index].product == null
                                  //         ? GestureDetector(
                                  //             onTap: () {
                                  //               Navigator.push(
                                  //                   context,
                                  //                   MaterialPageRoute(
                                  //                       builder: (context) =>
                                  //                           ShopPage(
                                  //                               widget.feed[index]
                                  //                                   .shop.id,
                                  //                               widget.userData[
                                  //                                   'id'])));
                                  //             },
                                  //             child: Container(
                                  //                 //color: Colors.red,
                                  //                 height: 200,
                                  //                 padding:
                                  //                     const EdgeInsets.all(0.0),
                                  //                 margin: EdgeInsets.only(top: 10),
                                  //                 decoration: BoxDecoration(
                                  //                     borderRadius:
                                  //                         BorderRadius.circular(15),
                                  //                     image: DecorationImage(
                                  //                         image: //AssetImage("assets/images/friend7.jpg"),
                                  //                             NetworkImage(
                                  //                                 "${widget.feed[index].shop.logo}"),
                                  //                         fit: BoxFit.cover)),
                                  //                 child: null),
                                  //           )
                                  //         : widget.feed[index].shop != null &&
                                  //                 widget.feed[index].product != null
                                  //             ? GestureDetector(
                                  //                 onTap: () {
                                  //                   Navigator.push(
                                  //                       context,
                                  //                       MaterialPageRoute(
                                  //                           builder: (context) =>
                                  //                               ProductDetailsPage(
                                  //                                   widget
                                  //                                       .feed[index]
                                  //                                       .product
                                  //                                       .id)));
                                  //                 },
                                  //                 child: Container(
                                  //                     //color: Colors.red,
                                  //                     height: 200,
                                  //                     padding:
                                  //                         const EdgeInsets.all(0.0),
                                  //                     margin:
                                  //                         EdgeInsets.only(top: 10),
                                  //                     decoration: BoxDecoration(
                                  //                         borderRadius:
                                  //                             BorderRadius.circular(
                                  //                                 15),
                                  //                         image: DecorationImage(
                                  //                             image: //AssetImage("assets/images/friend7.jpg"),
                                  //                                 NetworkImage(
                                  //                                     "${widget.feed[index].product.singleImage.image}"),
                                  //                             fit: BoxFit.cover)),
                                  //                     child: null),
                                  //               )
                                  //             : widget.feed[index].images == null
                                  //                 ? Container()
                                  //                 : widget.feed[index].images
                                  //                             .length ==
                                  //                         0
                                  //                     ? Container()
                                  //                     : widget.feed[index].images
                                  //                                 .length ==
                                  //                             1
                                  //                         ? Container(
                                  //                             //color: Colors.red,
                                  //                             height: 200,
                                  //                             padding:
                                  //                                 const EdgeInsets
                                  //                                     .all(0.0),
                                  //                             margin:
                                  //                                 EdgeInsets.only(
                                  //                                     top: 10),
                                  //                             decoration:
                                  //                                 BoxDecoration(
                                  //                                     borderRadius:
                                  //                                         BorderRadius
                                  //                                             .circular(
                                  //                                                 15),
                                  //                                     image: DecorationImage(
                                  //                                         image: //AssetImage("assets/images/friend7.jpg"),
                                  //                                             NetworkImage("${widget.feed[index].images[0].thum}"),
                                  //                                         fit: BoxFit.cover)),
                                  //                             child: null)
                                  //                         : Container(
                                  //                             height: widget
                                  //                                         .feed[
                                  //                                             index]
                                  //                                         .images
                                  //                                         .length <=
                                  //                                     3
                                  //                                 ? 100
                                  //                                 : 200,
                                  //                             child:
                                  //                                 GridView.builder(
                                  //                               //semanticChildCount: 2,
                                  //                               gridDelegate:
                                  //                                   SliverGridDelegateWithMaxCrossAxisExtent(
                                  //                                 maxCrossAxisExtent:
                                  //                                     100.0,
                                  //                                 mainAxisSpacing:
                                  //                                     0.0,
                                  //                                 crossAxisSpacing:
                                  //                                     0.0,
                                  //                                 childAspectRatio:
                                  //                                     1.0,
                                  //                               ),
                                  //                               //crossAxisCount: 2,
                                  //                               itemBuilder: (BuildContext
                                  //                                           context,
                                  //                                       int indexes) =>
                                  //                                   new Padding(
                                  //                                 padding:
                                  //                                     const EdgeInsets
                                  //                                         .all(5.0),
                                  //                                 child: Container(
                                  //                                   height: 100,
                                  //                                   //width: 50,
                                  //                                   padding:
                                  //                                       const EdgeInsets
                                  //                                               .all(
                                  //                                           5.0),
                                  //                                   decoration: BoxDecoration(
                                  //                                       border: Border.all(
                                  //                                           width:
                                  //                                               0.1,
                                  //                                           color: Colors
                                  //                                               .grey),
                                  //                                       image: DecorationImage(
                                  //                                           image: NetworkImage(
                                  //                                               "${widget.feed[index].images[indexes].thum}"))),
                                  //                                 ),
                                  //                               ),
                                  //                               itemCount: widget
                                  //                                   .feed[index]
                                  //                                   .images
                                  //                                   .length,
                                  //                             ),
                                  //                           ),
                                ],
                              )),
                          d.feedType == "Status"
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: d.data.images.length == 0
                                                  ? 0
                                                  : 10,
                                              right: 20,
                                              left: 0),
                                          padding: EdgeInsets.all(5),
                                          decoration: d.data.images.length == 0
                                              ? BoxDecoration()
                                              : BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
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
                                                if (d.isRead == null ||
                                                    d.isRead == "0") {
                                                  d.isRead = "1";
                                                } else {
                                                  d.isRead = "0";
                                                }
                                              });
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  child: secondHalf == ""
                                                      ? Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          child: new Text(
                                                              firstHalf,
                                                              textAlign: TextAlign
                                                                  .justify,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.9),
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                        )
                                                      : Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          margin: EdgeInsets.only(
                                                              left: d.data.images
                                                                          .length ==
                                                                      0
                                                                  ? 0
                                                                  : 20),
                                                          child: new Text(
                                                              d.isRead ==
                                                                          "0" ||
                                                                      d.isRead ==
                                                                          null
                                                                  ? firstHalf +
                                                                      "..."
                                                                  : firstHalf +
                                                                      secondHalf,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.7),
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
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
                                                            left: d.data.images
                                                                        .length ==
                                                                    0
                                                                ? 0
                                                                : 20,
                                                            top: 5),
                                                        child: new Text(
                                                            d.isRead == "0" ||
                                                                    d.isRead ==
                                                                        null
                                                                ? "Read more"
                                                                : "",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: header,
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    "Oswald",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
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
                                  left: 20, right: 20, bottom: 0, top: 10),
                              child: Divider(
                                color: Colors.grey[400],
                              )),
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(3.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (d.like != null) {
                                            setState(() {
                                              d.like = null;
                                              // print(widget.feed[index].meta
                                              //     .totalLikesCount);
                                              // likeCount = widget
                                              //     .feed[index].meta.totalLikesCount;
                                              // //likeCount = likeCount - 1;
                                              // print(widget.feed[index].meta
                                              //     .totalLikesCount);
                                              // print("bfg $likeCount");

                                              d.meta.totalLikesCount =
                                                  d.meta.totalLikesCount - 1;
                                              //likes.insert(index, likeCount);
                                            });
                                            likeButtonPressed(checkIndex, 0);
                                            //print(likes);
                                          } else {
                                            setState(() {
                                              d.like = 1;
                                              // print(widget.feed[index].meta
                                              //     .totalLikesCount);
                                              // likeCount = widget
                                              //     .feed[index].meta.totalLikesCount;
                                              // likeCount = likeCount + 1;
                                              // print("bfg $likeCount");
                                              d.meta.totalLikesCount =
                                                  d.meta.totalLikesCount + 1;
                                              // likeCount = widget
                                              //     .feed[index].meta.totalLikesCount;
                                              // likeCount = likeCount + 1;
                                              //likes.insert(index, likeCount);
                                            });
                                            likeButtonPressed(checkIndex, 1);
                                            //print(likes);
                                          }
                                        },
                                        child: Container(
                                          child: Icon(
                                            d.like != null
                                                //likePressed == true
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 20,
                                            color: d.like != null
                                                //likePressed == true
                                                ? Colors.redAccent
                                                : Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 3),
                                      child: Text("${d.meta.totalLikesCount}",
                                          style: TextStyle(
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black54,
                                              fontSize: 12)),
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           CommentPage(d.id)),
                                    // );
                                  },
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          padding: EdgeInsets.all(3.0),
                                          child: Icon(
                                            Icons.chat_bubble_outline,
                                            size: 20,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 3),
                                          child: Text(
                                              d.meta.totalCommentsCount == null
                                                  ? ""
                                                  : "${d.meta.totalCommentsCount}",
                                              style: TextStyle(
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black54,
                                                  fontSize: 12)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      padding: EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.send,
                                        size: 20,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 3),
                                      child: Text(
                                          d.meta.totalSharesCount == null
                                              ? ""
                                              : "${d.meta.totalSharesCount}",
                                          style: TextStyle(
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black54,
                                              fontSize: 12)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )));
      // setState(() {
      //   checkIndex++;
      // });
    }

    return list;
  }

  void _statusModalBottomSheet(context, int index, var userData, var feeds) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                // Text('React to this post',
                //       style: TextStyle(fontWeight: FontWeight.normal)),
                feeds.feedType == "Share"
                    ? Container()
                    : new ListTile(
                        leading: new Icon(Icons.edit),
                        title: new Text('Edit',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: "Oswald")),
                        onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeedStatusEditPost(
                                      feeds, userData, index)))
                        },
                      ),
                new ListTile(
                  leading: new Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  title: new Text('Delete',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.redAccent,
                          fontFamily: "Oswald")),
                  onTap: () =>
                      {Navigator.pop(context), _showDeleteDialog(feeds.id)},
                ),
              ],
            ),
          );
        });
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
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(top: 0, left: 20),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: userData['profilePic'] == null
                                      ? AssetImage("assets/images/man2.jpg")
                                      : NetworkImage(
                                          "${userData['profilePic']}"),
                                  fit: BoxFit.cover),
                              border:
                                  Border.all(color: Colors.grey, width: 0.1),
                              borderRadius: BorderRadius.circular(15)),
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
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.all(1.0),
                                    child: CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: Colors.white,
                                      backgroundImage: feeds.fuser.profilePic ==
                                              null
                                          ? AssetImage("assets/images/man2.jpg")
                                          : NetworkImage(
                                              "${feeds.fuser.profilePic}"),
                                    ),
                                    decoration: new BoxDecoration(
                                      color: Colors.grey[300], // border color
                                      shape: BoxShape.circle,
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
                                                    index % 2 == 0
                                                        ? "6 hr"
                                                        : "Aug 7 at 5:34 PM",
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
                                        : Container(
                                            //color: Colors.red,
                                            height: 200,
                                            padding: const EdgeInsets.all(0.0),
                                            margin: EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                    image: //AssetImage("assets/images/friend7.jpg"),
                                                        NetworkImage(
                                                            "${feeds.data.images[0].file}"),
                                                    fit: BoxFit.cover)),
                                            child: null),
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

  bool _keyboardIsVisible() {
    return !(MediaQuery.of(context).viewInsets.bottom == 0.0);
  }

  Future<Null> _showDeleteDialog(int id) async {
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
                    // Container(
                    //     decoration: BoxDecoration(
                    //         border: Border.all(color: header, width: 1.5),
                    //         borderRadius: BorderRadius.circular(100),
                    //         color: Colors.white),
                    //     child: Icon(
                    //       Icons.done,
                    //       color: header,
                    //       size: 50,
                    //     )),
                    Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          "Want to delete the post?",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
                        )),
                    Row(
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
                                        color: Colors.grey, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "No",
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
                              setState(() {
                                Navigator.of(context).pop();
                                deleteStatus(id);
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 5, right: 0, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: header,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "Yes",
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future deleteStatus(int id) async {
    var data = {'id': id};

    print(data);

    var res = await CallApi().postData1(data, 'delete-status');
    print("res.body");
    print(res.body);
    print("res.statusCode");
    print(res.statusCode);
    //var body = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        isDelete.add("$id");
        page1 = 0;
      });
    } else {
      _showMsg("Something went wrong!");
    }
    print(isDelete);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => FeedPage()));
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
      setState(() {
        //isDelete.add("$id");
        //page1 = 0;
      });
    } else {
      _showMsg("Something went wrong!");
    }
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

  void likeButtonPressed(index, type) async {
    setState(() {
      //_isLoading = true;
    });
    print("object");

    var data = {
      'id': '${postList.feed[index].id}',
      'type': type,
      'uid': '${postList.feed[index].userId}'
    };

    print(data);
    print("354353445345345");

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
}

class CreatePostCard extends StatefulWidget {
  final feed;
  final userData;
  final uid;
  CreatePostCard(this.feed, this.userData, this.uid);
  @override
  CreatePostCardState createState() => CreatePostCardState();
}

class CreatePostCardState extends State<CreatePostCard> {
  SharedPreferences sharedPreferences;
  String theme = "", proPic = "", statusPic = "";
  int likeCount = 0;
  String des = "";
  String firstHalf;
  String secondHalf;
  bool flag = true;
  bool likePressed = false;
  //bool loading = true;
  List<String> allPic = [];
  List likes = [];

  @override
  void initState() {
    for (int i = 0; i < widget.feed.length; i++) {
      proPic = widget.feed[i].fuser.profilePic;
      // if (proPic.contains("localhost")) {
      //   setState(() {
      //     widget.feed[i].fuser.profilePic = widget.feed[i].fuser.profilePic
      //         .replaceAll("localhost:3010/", "https://mobile.tradelounge.co/");
      //         widget.feed[i].fuser.profilePic = widget.feed[i].fuser.profilePic
      //         .replaceAll("localhost:8080/", "https://mobile.tradelounge.co/");
      //   });
      //   print("widget.feed[i].fuser.profilePic");
      //   print(widget.feed[i].fuser.profilePic);
      // } else {
      //   setState(() {
      //     widget.feed[i].fuser.profilePic =
      //         "https://mobile.tradelounge.co/" + widget.feed[i].fuser.profilePic;
      //   });
      // }
      // print(widget.feed[i].fuser.profilePic);
      // int proid = widget.feed[i].fuser.id;
      // print(proid);
    }

    for (int i = 0; i < widget.feed.length; i++) {
      if (widget.feed[i].data.images != null) {
        for (int j = 0; j < widget.feed[i].data.images.length; j++) {
          statusPic = widget.feed[i].data.images[j].file;
          //print(statusPic);
          if (statusPic.contains("localhost")) {
            widget.feed[i].data.images[j].file = widget
                .feed[i].data.images[j].file
                .replaceAll("localhost", "http://10.0.2.2");
            statusPic = statusPic.replaceAll("localhost", "http://10.0.2.2");
            allPic.add(statusPic);
          }
          // if (!statusPic.contains("localhost")) {
          //   statusPic = "http://10.0.2.2:3010" + statusPic;
          // }
          print(widget.feed[i].data.images[j].file);
        }
      }
    }
    super.initState();
  }

  void _statusModalBottomSheet(context, int index, var userData, var feeds) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                // Text('React to this post',
                //       style: TextStyle(fontWeight: FontWeight.normal)),
                new ListTile(
                  leading: new Icon(Icons.edit),
                  title: new Text('Edit',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontFamily: "Oswald")),
                  onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedStatusEditPost(
                                feeds, widget.userData, index)))
                  },
                ),
                new ListTile(
                  leading: new Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  title: new Text('Delete',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.redAccent,
                          fontFamily: "Oswald")),
                  onTap: () =>
                      {Navigator.pop(context), _showDeleteDialog(feeds.id)},
                ),
              ],
            ),
          );
        });
  }

  Future<Null> _showDeleteDialog(int id) async {
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
                    // Container(
                    //     decoration: BoxDecoration(
                    //         border: Border.all(color: header, width: 1.5),
                    //         borderRadius: BorderRadius.circular(100),
                    //         color: Colors.white),
                    //     child: Icon(
                    //       Icons.done,
                    //       color: header,
                    //       size: 50,
                    //     )),
                    Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          "Want to delete the post?",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
                        )),
                    Row(
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
                                        color: Colors.grey, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "No",
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
                              setState(() {
                                Navigator.of(context).pop();
                                deleteStatus(id);
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 5, right: 0, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: header,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "Yes",
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future deleteStatus(int id) async {
    var data = {'id': id};

    print(data);

    var res = await CallApi().postData1(data, 'delete-status');
    //var body = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        isDelete.add("$id");
        loadPosts(1);
      });
    } else {
      _showMsg("Something went wrong!");
    }
    print(isDelete);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => FeedPage()));
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

  Future loadPosts(int number) async {
    //await Future.delayed(Duration(seconds: 3));
    // if (page1 == 0) {

    // }
    var postresponse =
        await CallApi().getData('feed?sid=$number&llid=1&lcid=1&lsid=1');
    print(postresponse);
    var postcontent = postresponse.body;
    final posts = json.decode(postcontent);
    var postdata = FeedPosts.fromJson(posts);

    setState(() {
      postList = postdata;
      page1 = 1;
    });

    for (int i = 0; i < postList.feed.length; i++) {
      proPic = postList.feed[i].fuser.profilePic;
      if (proPic.contains("localhost")) {
        setState(() {
          proPic = proPic.replaceAll("localhost", "http://10.0.2.2");
        });
      } else {
        setState(() {
          proPic = "http://10.0.2.2:3010" + proPic;
        });
      }
      // print(widget.feed[i].fuser.profilePic);
      // int proid = widget.feed[i].fuser.id;
      // print(proid);
    }

    for (int i = 0; i < postList.feed.length; i++) {
      print(postList.feed[i].data.images);
      if (postList.feed[i].data.images != null) {
        for (int j = 0; j < postList.feed[i].data.images.length; j++) {
          statusPic = postList.feed[i].data.images[j].file;
          if (statusPic.contains("localhost")) {
            statusPic = statusPic.replaceAll("localhost", "http://10.0.2.2");
            allPic.add(statusPic);
          }
          // if (!statusPic.contains("localhost")) {
          //   statusPic = "http://10.0.2.2:3010" + statusPic;
          // }

        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          des = "${widget.feed[index].data.status}";
          if (des.length > 150) {
            firstHalf = des.substring(0, 150);
            secondHalf = des.substring(150, des.length);
          } else {
            firstHalf = des;
            secondHalf = "";
          }

          if (index + 1 == widget.feed.length) {
            loadPosts(widget.feed[index].id);
            print("end");
          }

          for (int i = 0; i < widget.feed[index].data.images.length; i++) {
            if (widget.feed[index].data.images[0].file.contains("127.0.0.1")) {
              widget.feed[index].data.images[0].file = widget
                  .feed[index].data.images[0].file
                  .replaceAll("127.0.0.1", "10.0.2.2");
            }
          }
          return isDelete.contains("${widget.feed[index].id}")
              ? Container()
              : index + 1 == widget.feed.length
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      padding: EdgeInsets.only(top: 5, bottom: 10),
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
                          top: 5, bottom: 5, left: 10, right: 10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              widget.uid == widget.feed[index].fuser.id
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _statusModalBottomSheet(
                                              context,
                                              index,
                                              widget.userData,
                                              widget.feed[index]);
                                          //print(widget.feed[index].id);
                                        });
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(right: 15),
                                          // color: Colors.blue,
                                          child: Icon(
                                            Icons.more_horiz,
                                            color: Colors.black54,
                                          )),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(top: 10),
                                    ),
                            ],
                          ),
                          Container(
                            //color: Colors.yellow,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ////// <<<<< pic start >>>>> //////
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.all(1.0),
                                  child: CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Colors.white,
                                    backgroundImage: proPic == null
                                        ? AssetImage("assets/images/man2.jpg")
                                        : NetworkImage(
                                            "${widget.feed[index].fuser.profilePic}"),
                                  ),
                                  decoration: new BoxDecoration(
                                    color: Colors.grey[300], // border color
                                    shape: BoxShape.circle,
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
                                                  "${widget.feed[index].fuser.firstName} ${widget.feed[index].fuser.lastName}",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontFamily: 'Oswald',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              // widget.feed[index].activityType ==
                                              //         "community"
                                              //     ? Container(
                                              //         child: Text(
                                              //           " has created a community",
                                              //           maxLines: 1,
                                              //           style: TextStyle(
                                              //               fontSize: 15,
                                              //               color: Colors.black54,
                                              //               fontFamily: 'Oswald',
                                              //               fontWeight:
                                              //                   FontWeight.w300),
                                              //         ),
                                              //       )
                                              //     : Container(),
                                              // widget.feed[index].shop != null &&
                                              //         widget.feed[index].product ==
                                              //             null
                                              //     ? Container(
                                              //         child: Text(
                                              //           " has created a shop",
                                              //           maxLines: 1,
                                              //           style: TextStyle(
                                              //               fontSize: 15,
                                              //               color: Colors.black54,
                                              //               fontFamily: 'Oswald',
                                              //               fontWeight:
                                              //                   FontWeight.w300),
                                              //         ),
                                              //       )
                                              //     : Container(),
                                              // widget.feed[index].shop != null &&
                                              //         widget.feed[index].product !=
                                              //             null
                                              //     ? Container(
                                              //         child: Text(
                                              //           " has uploaded a new product",
                                              //           maxLines: 1,
                                              //           style: TextStyle(
                                              //               fontSize: 15,
                                              //               color: Colors.black54,
                                              //               fontFamily: 'Oswald',
                                              //               fontWeight:
                                              //                   FontWeight.w300),
                                              //         ),
                                              //       )
                                              //     : Container(),
                                              // widget.feed[index].activityType ==
                                              //         "offer"
                                              //     ? Container(
                                              //         child: Text(
                                              //           " has created a offer",
                                              //           maxLines: 1,
                                              //           style: TextStyle(
                                              //               fontSize: 15,
                                              //               color: Colors.black54,
                                              //               fontFamily: 'Oswald',
                                              //               fontWeight:
                                              //                   FontWeight.w300),
                                              //         ),
                                              //       )
                                              //     : Container(),
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    widget.feed[index]
                                                                .interests ==
                                                            null
                                                        ? ""
                                                        : " - ${widget.feed[index].interests}",
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
                                                  index % 2 == 0
                                                      ? "6 hr"
                                                      : "Aug 7 at 5:34 PM",
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
                                                        "  ${widget.feed[index].fuser.jobTitle}",
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
                                        )
                                        ////// <<<<< time job end >>>>> //////
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          widget.feed[index].feedType != "Status"
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(top: 10, right: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (widget.feed[index].isRead == null ||
                                            widget.feed[index].isRead == "0") {
                                          widget.feed[index].isRead = "1";
                                        } else {
                                          widget.feed[index].isRead = "0";
                                        }
                                      });
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: secondHalf == ""
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin:
                                                      EdgeInsets.only(left: 20),
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
                                                      EdgeInsets.only(left: 20),
                                                  child: new Text(
                                                      widget.feed[index]
                                                                      .isRead ==
                                                                  "0" ||
                                                              widget.feed[index]
                                                                      .isRead ==
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
                                        secondHalf == ""
                                            ? Container()
                                            : Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: EdgeInsets.only(
                                                    left: 20, top: 5),
                                                child: new Text(
                                                    widget.feed[index].isRead ==
                                                                "0" ||
                                                            widget.feed[index]
                                                                    .isRead ==
                                                                null
                                                        ? "Read more"
                                                        : "",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: header,
                                                        fontSize: 13,
                                                        fontFamily: "Oswald",
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              )
                                      ],
                                    ),
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
                                  widget.feed[index].data.images.length == 0
                                      ? Container()
                                      : Container(
                                          //color: Colors.red,
                                          height: 200,
                                          padding: const EdgeInsets.all(0.0),
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: DecorationImage(
                                                  image: //AssetImage("assets/images/friend7.jpg"),
                                                      NetworkImage(
                                                          "${widget.feed[index].data.images[0].file}"),
                                                  fit: BoxFit.cover)),
                                          child: null)
                                  ////// <<<<< Status start >>>>> //////
                                  // Container(
                                  //   margin: EdgeInsets.only(bottom: 10),
                                  //   alignment: Alignment.centerLeft,
                                  //   child: Text(
                                  //     widget.feed[index].activityType == "community"
                                  //         ? "${widget.feed[index].group.name}"
                                  //         : widget.feed[index].shop != null &&
                                  //                 widget.feed[index].product == null
                                  //             ? "${widget.feed[index].shop.shopName}"
                                  //             : widget.feed[index].shop != null &&
                                  //                     widget.feed[index].product !=
                                  //                         null
                                  //                 ? "${widget.feed[index].product.productName}"
                                  //                 : widget.feed[index]
                                  //                             .activityType ==
                                  //                         "offer"
                                  //                     ? "${widget.feed[index].offer.title}"
                                  //                     : widget.feed[index].status ==
                                  //                             null
                                  //                         ? ""
                                  //                         : "${widget.feed[index].status}",
                                  //     textAlign: TextAlign.justify,
                                  //     style: TextStyle(
                                  //         color: Colors.black,
                                  //         fontWeight: FontWeight.w400),
                                  //   ),
                                  // ),

                                  ////// <<<<< Status end >>>>> //////

                                  ////// <<<<< Picture Start >>>>> //////
                                  // widget.feed[index].activityType == "community"
                                  // ? Container(
                                  //     //color: Colors.red,
                                  //     height: 200,
                                  //     padding: const EdgeInsets.all(0.0),
                                  //     margin: EdgeInsets.only(top: 10),
                                  //     decoration: BoxDecoration(
                                  //         borderRadius:
                                  //             BorderRadius.circular(15),
                                  //         image: DecorationImage(
                                  //             image: //AssetImage("assets/images/friend7.jpg"),
                                  //                 NetworkImage(
                                  //                     "${widget.feed[index].group.logo}"),
                                  //             fit: BoxFit.cover)),
                                  //     child: null)
                                  //     : widget.feed[index].shop != null &&
                                  //             widget.feed[index].product == null
                                  //         ? GestureDetector(
                                  //             onTap: () {
                                  //               Navigator.push(
                                  //                   context,
                                  //                   MaterialPageRoute(
                                  //                       builder: (context) =>
                                  //                           ShopPage(
                                  //                               widget.feed[index]
                                  //                                   .shop.id,
                                  //                               widget.userData[
                                  //                                   'id'])));
                                  //             },
                                  //             child: Container(
                                  //                 //color: Colors.red,
                                  //                 height: 200,
                                  //                 padding:
                                  //                     const EdgeInsets.all(0.0),
                                  //                 margin: EdgeInsets.only(top: 10),
                                  //                 decoration: BoxDecoration(
                                  //                     borderRadius:
                                  //                         BorderRadius.circular(15),
                                  //                     image: DecorationImage(
                                  //                         image: //AssetImage("assets/images/friend7.jpg"),
                                  //                             NetworkImage(
                                  //                                 "${widget.feed[index].shop.logo}"),
                                  //                         fit: BoxFit.cover)),
                                  //                 child: null),
                                  //           )
                                  //         : widget.feed[index].shop != null &&
                                  //                 widget.feed[index].product != null
                                  //             ? GestureDetector(
                                  //                 onTap: () {
                                  //                   Navigator.push(
                                  //                       context,
                                  //                       MaterialPageRoute(
                                  //                           builder: (context) =>
                                  //                               ProductDetailsPage(
                                  //                                   widget
                                  //                                       .feed[index]
                                  //                                       .product
                                  //                                       .id)));
                                  //                 },
                                  //                 child: Container(
                                  //                     //color: Colors.red,
                                  //                     height: 200,
                                  //                     padding:
                                  //                         const EdgeInsets.all(0.0),
                                  //                     margin:
                                  //                         EdgeInsets.only(top: 10),
                                  //                     decoration: BoxDecoration(
                                  //                         borderRadius:
                                  //                             BorderRadius.circular(
                                  //                                 15),
                                  //                         image: DecorationImage(
                                  //                             image: //AssetImage("assets/images/friend7.jpg"),
                                  //                                 NetworkImage(
                                  //                                     "${widget.feed[index].product.singleImage.image}"),
                                  //                             fit: BoxFit.cover)),
                                  //                     child: null),
                                  //               )
                                  //             : widget.feed[index].images == null
                                  //                 ? Container()
                                  //                 : widget.feed[index].images
                                  //                             .length ==
                                  //                         0
                                  //                     ? Container()
                                  //                     : widget.feed[index].images
                                  //                                 .length ==
                                  //                             1
                                  //                         ? Container(
                                  //                             //color: Colors.red,
                                  //                             height: 200,
                                  //                             padding:
                                  //                                 const EdgeInsets
                                  //                                     .all(0.0),
                                  //                             margin:
                                  //                                 EdgeInsets.only(
                                  //                                     top: 10),
                                  //                             decoration:
                                  //                                 BoxDecoration(
                                  //                                     borderRadius:
                                  //                                         BorderRadius
                                  //                                             .circular(
                                  //                                                 15),
                                  //                                     image: DecorationImage(
                                  //                                         image: //AssetImage("assets/images/friend7.jpg"),
                                  //                                             NetworkImage("${widget.feed[index].images[0].thum}"),
                                  //                                         fit: BoxFit.cover)),
                                  //                             child: null)
                                  //                         : Container(
                                  //                             height: widget
                                  //                                         .feed[
                                  //                                             index]
                                  //                                         .images
                                  //                                         .length <=
                                  //                                     3
                                  //                                 ? 100
                                  //                                 : 200,
                                  //                             child:
                                  //                                 GridView.builder(
                                  //                               //semanticChildCount: 2,
                                  //                               gridDelegate:
                                  //                                   SliverGridDelegateWithMaxCrossAxisExtent(
                                  //                                 maxCrossAxisExtent:
                                  //                                     100.0,
                                  //                                 mainAxisSpacing:
                                  //                                     0.0,
                                  //                                 crossAxisSpacing:
                                  //                                     0.0,
                                  //                                 childAspectRatio:
                                  //                                     1.0,
                                  //                               ),
                                  //                               //crossAxisCount: 2,
                                  //                               itemBuilder: (BuildContext
                                  //                                           context,
                                  //                                       int indexes) =>
                                  //                                   new Padding(
                                  //                                 padding:
                                  //                                     const EdgeInsets
                                  //                                         .all(5.0),
                                  //                                 child: Container(
                                  //                                   height: 100,
                                  //                                   //width: 50,
                                  //                                   padding:
                                  //                                       const EdgeInsets
                                  //                                               .all(
                                  //                                           5.0),
                                  //                                   decoration: BoxDecoration(
                                  //                                       border: Border.all(
                                  //                                           width:
                                  //                                               0.1,
                                  //                                           color: Colors
                                  //                                               .grey),
                                  //                                       image: DecorationImage(
                                  //                                           image: NetworkImage(
                                  //                                               "${widget.feed[index].images[indexes].thum}"))),
                                  //                                 ),
                                  //                               ),
                                  //                               itemCount: widget
                                  //                                   .feed[index]
                                  //                                   .images
                                  //                                   .length,
                                  //                             ),
                                  //                           ),
                                ],
                              )),
                          widget.feed[index].feedType == "Status"
                              ? Container()
                              : Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: widget.feed[index].data
                                                          .images.length ==
                                                      0
                                                  ? 0
                                                  : 10,
                                              right: 20,
                                              left: 0),
                                          padding: EdgeInsets.all(5),
                                          decoration: widget.feed[index].data
                                                      .images.length ==
                                                  0
                                              ? BoxDecoration()
                                              : BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
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
                                                if (widget.feed[index].isRead ==
                                                        null ||
                                                    widget.feed[index].isRead ==
                                                        "0") {
                                                  widget.feed[index].isRead =
                                                      "1";
                                                } else {
                                                  widget.feed[index].isRead =
                                                      "0";
                                                }
                                              });
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  child: secondHalf == ""
                                                      ? Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          child: new Text(
                                                              firstHalf,
                                                              textAlign: TextAlign
                                                                  .justify,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.9),
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                        )
                                                      : Container(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          margin: EdgeInsets.only(
                                                              left: widget
                                                                          .feed[
                                                                              index]
                                                                          .data
                                                                          .images
                                                                          .length ==
                                                                      0
                                                                  ? 0
                                                                  : 20),
                                                          child: new Text(
                                                              widget.feed[index].isRead ==
                                                                          "0" ||
                                                                      widget.feed[index].isRead ==
                                                                          null
                                                                  ? firstHalf +
                                                                      "..."
                                                                  : firstHalf +
                                                                      secondHalf,
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.7),
                                                                  fontSize: 13,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
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
                                                            left: widget
                                                                        .feed[
                                                                            index]
                                                                        .data
                                                                        .images
                                                                        .length ==
                                                                    0
                                                                ? 0
                                                                : 20,
                                                            top: 5),
                                                        child: new Text(
                                                            widget.feed[index]
                                                                            .isRead ==
                                                                        "0" ||
                                                                    widget
                                                                            .feed[
                                                                                index]
                                                                            .isRead ==
                                                                        null
                                                                ? "Read more"
                                                                : "",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: header,
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    "Oswald",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
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
                                  left: 20, right: 20, bottom: 0, top: 10),
                              child: Divider(
                                color: Colors.grey[400],
                              )),
                          Container(
                            margin: EdgeInsets.only(left: 20, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(3.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (widget.feed[index].like != null) {
                                            setState(() {
                                              widget.feed[index].like = null;
                                              // print(widget.feed[index].meta
                                              //     .totalLikesCount);
                                              // likeCount = widget
                                              //     .feed[index].meta.totalLikesCount;
                                              // //likeCount = likeCount - 1;
                                              // print(widget.feed[index].meta
                                              //     .totalLikesCount);
                                              // print("bfg $likeCount");

                                              widget.feed[index].meta
                                                  .totalLikesCount = widget
                                                      .feed[index]
                                                      .meta
                                                      .totalLikesCount -
                                                  1;
                                              //likes.insert(index, likeCount);
                                            });
                                            likeButtonPressed(index, 0);
                                            //print(likes);
                                          } else {
                                            setState(() {
                                              widget.feed[index].like = 1;
                                              // print(widget.feed[index].meta
                                              //     .totalLikesCount);
                                              // likeCount = widget
                                              //     .feed[index].meta.totalLikesCount;
                                              // likeCount = likeCount + 1;
                                              // print("bfg $likeCount");
                                              widget.feed[index].meta
                                                  .totalLikesCount = widget
                                                      .feed[index]
                                                      .meta
                                                      .totalLikesCount +
                                                  1;
                                              // likeCount = widget
                                              //     .feed[index].meta.totalLikesCount;
                                              // likeCount = likeCount + 1;
                                              //likes.insert(index, likeCount);
                                            });
                                            likeButtonPressed(index, 1);
                                            //print(likes);
                                          }
                                        },
                                        child: Container(
                                          child: Icon(
                                            widget.feed[index].like != null
                                                //likePressed == true
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            size: 20,
                                            color:
                                                widget.feed[index].like != null
                                                    //likePressed == true
                                                    ? Colors.redAccent
                                                    : Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 3),
                                      child: Text(
                                          "${widget.feed[index].meta.totalLikesCount}",
                                          style: TextStyle(
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black54,
                                              fontSize: 12)),
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CommentPage(
                                              widget.feed[index].id, index)),
                                    );
                                  },
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(left: 15),
                                          padding: EdgeInsets.all(3.0),
                                          child: Icon(
                                            Icons.chat_bubble_outline,
                                            size: 20,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 3),
                                          child: Text(
                                              widget.feed[index].meta
                                                          .totalCommentsCount ==
                                                      null
                                                  ? ""
                                                  : "${widget.feed[index].meta.totalCommentsCount}",
                                              style: TextStyle(
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black54,
                                                  fontSize: 12)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      padding: EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.send,
                                        size: 20,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 3),
                                      child: Text(
                                          widget.feed[index].meta
                                                      .totalSharesCount ==
                                                  null
                                              ? ""
                                              : "${widget.feed[index].meta.totalSharesCount}",
                                          style: TextStyle(
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black54,
                                              fontSize: 12)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );

          ////// <<<<< Loader >>>>> //////
          //: PostLoaderCard();
        }, childCount: widget.feed.length),
      ),
    );
  }

  void likeButtonPressed(index, type) async {
    setState(() {
      //_isLoading = true;
    });
    print("object");

    var data = {
      'id': '${widget.feed[index].id}',
      'type': type,
      'uid': '${widget.feed[index].userId}'
    };

    print(data);
    print("354353445345345");

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
}
