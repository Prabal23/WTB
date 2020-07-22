import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/GroupCard/groupCard.dart';
import 'package:chatapp_new/JSON_Model/GroupModel/GroupModel.dart';
import 'package:chatapp_new/Loader/GroupLoader/groupLoader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';

import '../../main.dart';
import 'GroupAddPage/groupAddPage.dart';

class GroupPage extends StatefulWidget {
  @override
  GroupPageState createState() => GroupPageState();
}

class GroupPageState extends State<GroupPage> {
  SharedPreferences sharedPreferences;
  String theme = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;
  var userData, groupList;

  @override
  void initState() {
    sharedPrefcheck();
    _getUserInfo();
    loadGroups();
    //timerCheck();
    super.initState();
  }

  void sharedPrefcheck() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      //theme = sharedPreferences.getString("theme");
    });
    //print(theme);
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

  Future loadGroups() async {
    //await Future.delayed(Duration(seconds: 3));
    var postresponse =
        await CallApi().getData('get/search/Com?str=&type=&userType=');
    print(postresponse);
    var postcontent = postresponse.body;
    final posts = json.decode(postcontent);
    //var postdata = GroupModel.fromJson(posts);

    // if (postdata != null) {
    //   setState(() {
    //     postList.feed.length += postdata.feed.length;
    //   });
    // }

    setState(() {
      groupList = posts;
      loading = false;
    });
    print("groupList.length");
    print(groupList.length);
  }

  // void timerCheck() {
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = new Timer.periodic(
  //     oneSec,
  //     (Timer timer) => setState(
  //       () {
  //         if (_start < 1) {
  //           timer.cancel();
  //           setState(() {
  //             loading = false;
  //           });
  //         } else {
  //           _start = _start - 1;
  //         }
  //       },
  //     ),
  //   );
  // }

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
                        "Your Community",
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
      body: Container(
        margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 15, left: 20),
                      child: Text(
                        "Community List",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.normal),
                      )),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 30,
                        margin: EdgeInsets.only(top: 10, left: 20),
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
                            border:
                                Border.all(width: 0.5, color: Colors.black)),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerLeft,
                          margin:
                              EdgeInsets.only(top: 12, left: 20, bottom: 10),
                          child: Text(
                            loading
                                ? "Please wait..."
                                : groupList.length == 0
                                    ? "No Communities!"
                                    : "${groupList.length} communities",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w400),
                          )),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupAddPage()));
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            margin:
                                EdgeInsets.only(top: 12, right: 20, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Add Group",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: header,
                                      fontSize: 13,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w400),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  child:
                                      Icon(Icons.add, color: header, size: 17),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            loading
                ? SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : groupList.length == 0
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(top: 15),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.group,
                                    size: 50,
                                    color: Colors.black12,
                                  )),
                              Container(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.block,
                                    size: 80,
                                    color: Colors.black12,
                                  )),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        child: SliverPadding(
                          padding: EdgeInsets.only(left: 10, right: 10),

                          ////// <<<<< Gridview >>>>> //////
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 190.0,
                              mainAxisSpacing: 0.0,
                              crossAxisSpacing: 0.0,
                              childAspectRatio: 0.8,
                            ),
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return loading == false
                                  ? GroupCard(groupList[index])
                                  : GroupLoaderCard(); ////// <<<<< Loader >>>>> //////
                            }, childCount: groupList.length),
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
