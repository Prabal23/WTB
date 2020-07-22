import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/NotificationCard/notificationCard.dart';
import 'package:chatapp_new/JSON_Model/NotifyModel/NotifyModel.dart';
import 'package:chatapp_new/Loader/NotificationLoader/notifyLoader.dart';
import 'package:chatapp_new/MainScreen/AllRequestPage/allRequestPage.dart';
import 'package:chatapp_new/MainScreen/FriendProfileReplyPage/FriendProfileReplyPage.dart';
import 'package:chatapp_new/MainScreen/GroupDetailsPage/groupDetailsPage.dart';
import 'package:chatapp_new/MainScreen/ProductDetails/productDetails.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/FriendsProfilePage/friendsProfilePage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/MyProfilePage/myProfilePage.dart';
import 'package:chatapp_new/MainScreen/ShopPage/shopPage.dart';
import 'package:chatapp_new/MainScreen/StatusDetailsPage/StatusDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';

import '../../main.dart';

class NotifyPage extends StatefulWidget {
  @override
  NotifyPageState createState() => NotifyPageState();
}

class NotifyPageState extends State<NotifyPage> {
  SharedPreferences sharedPreferences;
  String theme = "", daysAgo = "";
  Timer _timer;
  int _start = 3;
  int lastNotifyID;
  bool loading = true;
  var notifyList, userData;
  ScrollController _controller = new ScrollController();
  List notificationList = [];

  @override
  void initState() {
    _getUserInfo();
    loadNotification();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
      //_isLoaded = true;
    });

    //print("${userData['shop_id']}");
  }

  Future loadNotification() async {
    //await Future.delayed(Duration(seconds: 3));
    var postresponse = await CallApi().getData2('get-noti');
    print(postresponse);
    var postcontent = postresponse.body;
    final posts = json.decode(postcontent);
    var postdata = NotifyModel.fromJson(posts);

    setState(() {
      notifyList = postdata;
      for (int i = 0; i < notifyList.allNotification.length; i++) {
        //print(notifyList.allNotification[i].id);
        notificationList.add(notifyList.allNotification[i]);
        lastNotifyID = notifyList.allNotification[i].id;
        print(lastNotifyID);
      }

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
              loadMoreNotification(lastNotifyID);

              print("lastNotifyID 1");
              print(lastNotifyID);
            });
          }
          // you are at bottom position
        }
      });
    });
    print("notifyList.allNotification.length");
    print(notifyList.allNotification.length);

    setState(() {
      loading = false;
    });
  }

  Future loadMoreNotification(lastNotifyID) async {
    //await Future.delayed(Duration(seconds: 3));
    var postresponse1 = await CallApi().getData2('more-noti/$lastNotifyID');
    print(postresponse1);
    var postcontent1 = postresponse1.body;
    final posts1 = json.decode(postcontent1);
    var postdata1 = NotifyModel.fromJson(posts1);

    setState(() {
      notifyList = postdata1;
      lastNotifyID = "";
      int last = 0;
      for (int i = 0; i < notifyList.allNotification.length; i++) {
        print("notifyList.allNotification[i].id");
        print(notifyList.allNotification[i].id);
        notificationList.add(notifyList.allNotification[i]);
        last = notifyList.allNotification[i].id;
      }

      lastNotifyID = last;
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
              loadMoreNotification(lastNotifyID);

              print("lastNotifyID 1");
              print(lastNotifyID);
            });
          }
          // you are at bottom position
        }
      });

      print("lastNotifyID 23");
      print(lastNotifyID);
    });
    print("notifyList.allNotification.length");
    print(notifyList.allNotification.length);

    setState(() {
      loading = false;
    });
  }

  void makeSeen(id) async {
    var data = {
      'seen': 'Yes',
    };

    //print(data);

    var res = await CallApi().postData1(data, 'mark-as-red/$id');
    var body = json.decode(res.body);
    print("body");
    print(body);

    if (res.statusCode == 200) {
      print("ok");
    } else {
      print("not ok");
    }
  }

  Future<void> pageRoute(result) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('stid', result);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => StatusDetailsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ////// <<<<< Background color >>>>> //////
      backgroundColor: Colors.white,

      ////// <<<<< AppBar >>>>> //////
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        title: Container(
          margin: EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ////// <<<<< Title >>>>> //////
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Notification",
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
      ),

      ////// <<<<< Body >>>>> //////
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: loading
              ? Center(child: CircularProgressIndicator())
              : notificationList.length == 0
                  ? Center(
                      child: Container(
                        child: Text("No Notification Available!"),
                      ),
                    )
                  : Container(
                      child: ListView.builder(
                          controller: _controller,
                          itemCount: notificationList.length,
                          itemBuilder: (context, index) {
                            List day = [];
                            for (int i = 0; i < notificationList.length; i++) {
                              DateTime date1 = DateTime.parse(
                                  "${notificationList[i].created_at}");

                              daysAgo = DateFormat.yMMMd().format(date1);
                              day.add(daysAgo);
                            }
                            return loading == false
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        String url =
                                            notificationList[index].url;
                                        int number = '/'.allMatches(url).length;
                                        String result = "";
                                        if (number > 1) {
                                          if (number == 3) {
                                            var urlCheck = url.split("/");
                                            print(urlCheck);
                                            String first = urlCheck[0];
                                            String second = urlCheck[1];
                                            String third = urlCheck[2];
                                            String fourth = urlCheck[3];

                                            print(third);
                                            print(fourth);

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailsPage(
                                                            fourth)));
                                          } else {
                                            var urlCheck = url.split("/");
                                            String first = urlCheck[1];
                                            String second = urlCheck[2];

                                            if (second.contains("?")) {
                                              result = second.substring(
                                                  0, second.indexOf('?'));
                                            } else {
                                              result = second;
                                            }

                                            print(first);
                                            print(result);

                                            if (first == "community") {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          GroupDetailsPage(
                                                              result)));
                                            } else if (first == "shop") {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShopPage(result,
                                                              userData['id'])));
                                            } else if (first == "profile") {
                                              if (userData['userName'] ==
                                                  result) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyProfilePage(
                                                                userData)));
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FriendsProfilePage(
                                                                result, 2)));
                                              }
                                            } else {
                                              pageRoute(result);
                                            }
                                          }
                                        } else {
                                          url = url.replaceAll("/", "");

                                          print(url);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AllRequestPage()));
                                        }

                                        if (notifyNum != 0) {
                                          notifyNum--;
                                          if (notifyNum < 0) {
                                            notifyNum = 0;
                                          }
                                        }

                                        print(notifyNum);

                                        notificationList[index].seen = "Yes";

                                        makeSeen(notificationList[index].id);
                                      });
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(top: 0, bottom: 0),
                                      decoration: BoxDecoration(
                                        color:
                                            notificationList[index].seen == "No"
                                                ? Colors.grey.withOpacity(0.2)
                                                : Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 1.0,
                                            color: notificationList[index]
                                                        .seen ==
                                                    "No"
                                                ? Colors.grey.withOpacity(0.1)
                                                : Colors.black38
                                                    .withOpacity(0.3),
                                          ),
                                        ],
                                      ),
                                      margin: EdgeInsets.only(
                                          top: 2.5,
                                          bottom: 2.5,
                                          left: 10,
                                          right: 10),
                                      child: Container(
                                        margin: EdgeInsets.all(15),
                                        child: Row(
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                ////// <<<<< Picture >>>>> //////
                                                // Container(
                                                //   margin: EdgeInsets.only(right: 0, top: 0),
                                                //   padding: EdgeInsets.all(1.0),
                                                //   child: CircleAvatar(
                                                //     radius: 25.0,
                                                //     backgroundColor: Colors.transparent,
                                                //     backgroundImage: index % 2 == 0
                                                //         ? AssetImage('assets/images/man.png')
                                                //         : AssetImage('assets/images/man2.jpg'),
                                                //   ),
                                                //   decoration: new BoxDecoration(
                                                //     color: Colors.grey[300],
                                                //     shape: BoxShape.circle,
                                                //   ),
                                                // ),

                                                ////// <<<<< React Icon along with picture >>>>> //////
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 0, top: 0),
                                                  padding: EdgeInsets.all(4.0),
                                                  decoration: new BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          width: 0.4,
                                                          color: header)),
                                                  child: Icon(
                                                    Icons.notifications,
                                                    size: 15,
                                                    color: header,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text.rich(
                                                      TextSpan(
                                                        children: <TextSpan>[
                                                          ////// <<<<< Who reacted >>>>> //////
                                                          TextSpan(
                                                              text: notificationList[
                                                                              index]
                                                                          .name ==
                                                                      null
                                                                  ? ""
                                                                  : "${notificationList[index].name}",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Oswald',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              )),

                                                          ////// <<<<< Reacted for what >>>>> //////
                                                          TextSpan(
                                                              text:
                                                                  " ${notificationList[index].notiTxt}",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 15,
                                                                fontFamily:
                                                                    'Oswald',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              )),
                                                        ],
                                                      ),
                                                    ),

                                                    ////// <<<<< Time >>>>> //////
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 5),
                                                      child: Text(
                                                        "${day[index]}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black45,
                                                            fontFamily:
                                                                'Oswald',
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 12),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),

                                            ////// <<<<< More Icon >>>>> //////
                                            // Container(
                                            //     margin: EdgeInsets.only(
                                            //         left: 12, right: 0),
                                            //     child: Icon(
                                            //       Icons.more_horiz,
                                            //       color: Colors.black45,
                                            //     ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : NotifyLoaderCard();
                          }),
                    )
          //NotificationCard(notifyList.allNotification, loading),
          ),
    );
  }
}
