import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Loader/FriendsLoader/friendLoader.dart';
import 'package:chatapp_new/MainScreen/GroupPage/groupPage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/FriendsProfilePage/friendsProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class AllMembersCard extends StatefulWidget {
  final allMembers;
  final userData;
  final admin;
  final groupList;
  AllMembersCard(this.allMembers, this.userData, this.admin, this.groupList);

  @override
  _AllMembersCardState createState() => _AllMembersCardState();
}

class _AllMembersCardState extends State<AllMembersCard> {
  SharedPreferences sharedPreferences;
  String theme = "";
  Timer _timer;
  int _start = 3;
  bool loading = false;
  List ids = [];

  @override
  void initState() {
    sharedPrefcheck();
    //timerCheck();
    super.initState();
  }

  void sharedPrefcheck() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      theme = sharedPreferences.getString("theme");
    });
    //print(theme);
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
    return Container(
      child: widget.allMembers == null
          ? SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: Text(
                  "Please wait...",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontFamily: 'Oswald',
                      fontWeight: FontWeight.w400),
                ),
              ),
            )
          : SliverPadding(
              padding: EdgeInsets.only(bottom: 25),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    //delegate: new SlidableDrawerDelegate(),
                    actionExtentRatio: 0.20,
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => FriendsProfilePage()));
                      },

                      ////// <<<<< Main Data >>>>> //////
                      child: loading == false
                          ? Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    width: 1.0, color: Colors.grey[300]),
                              ),
                              margin: EdgeInsets.only(
                                  top: 2.5, bottom: 2.5, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 20, right: 20, top: 0),
                                      padding: EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          ////// <<<<< Profile picture >>>>> //////
                                          Stack(
                                            children: <Widget>[
                                              ////// <<<<< Picture >>>>> //////
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 10),
                                                padding: EdgeInsets.all(1.0),
                                                child: CircleAvatar(
                                                  radius: 30.0,
                                                  backgroundColor: Colors.white,
                                                  backgroundImage: NetworkImage(
                                                      "${widget.allMembers[index].user.profilePic}"),
                                                ),
                                                decoration: new BoxDecoration(
                                                  color: Colors.grey[300],
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ],
                                          ),

                                          ////// <<<<< User Name >>>>> //////
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "${widget.allMembers[index].user.firstName} ${widget.allMembers[index].user.lastName}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontFamily: 'Oswald',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),

                                                ////// <<<<< Role >>>>> //////
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 3),
                                                  child: Text(
                                                    widget.allMembers[index]
                                                                    .isAdmin ==
                                                                1 &&
                                                            widget
                                                                    .allMembers[
                                                                        index]
                                                                    .isCreator ==
                                                                1
                                                        ? "Super Admin"
                                                        : widget
                                                                        .allMembers[
                                                                            index]
                                                                        .isAdmin ==
                                                                    1 &&
                                                                widget
                                                                        .allMembers[
                                                                            index]
                                                                        .isCreator ==
                                                                    0
                                                            ? "Admin"
                                                            : "Member",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 13,
                                                        color: widget
                                                                        .allMembers[
                                                                            index]
                                                                        .isAdmin ==
                                                                    1 &&
                                                                widget
                                                                        .allMembers[
                                                                            index]
                                                                        .isCreator ==
                                                                    1
                                                            ? header
                                                            : Colors.black54),
                                                  ),
                                                ),

                                                ////// <<<<< Job Title >>>>> //////
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 3),
                                                  child: Text(
                                                    "${widget.allMembers[index].user.jobTitle}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 12,
                                                        color: Colors.black45),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  ////// <<<<< Message Button >>>>> //////
                                  Container(
                                      margin: EdgeInsets.only(right: 15),
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 5,
                                          bottom: 5),
                                      decoration: BoxDecoration(
                                          color: header.withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: header, width: 0.5)),
                                      child: Text("Message",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                              fontSize: 12))),
                                ],
                              ),
                            )

                          ////// <<<<< Loader >>>>> //////
                          : LoaderCard(),
                    ),
                    secondaryActions: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0)),
                        ),
                        child: new IconSlideAction(
                          caption: 'Delete',
                          color: Colors.transparent,
                          icon: Icons.delete,
                          onTap: () {
                            if (widget.admin != "") {
                              _showDeleteDialog(
                                  widget.allMembers[index], index);
                            } else {
                              _showErrorDialog(widget.allMembers[index], index);
                            }
                          },
                        ),
                      ),
                    ],
                  );
                }, childCount: widget.allMembers.length),
              ),
            ),
    );
  }

  Future<Null> _showDeleteDialog(allMembers, ind) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
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
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          "Are you sure to remove ${allMembers.user.firstName} ${allMembers.user.lastName}?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
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
                                      color: Colors.grey.withOpacity(0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.white,
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
                                  deleteMember(allMembers);
                                });
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
                                    "Confirm",
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

  Future<Null> _showErrorDialog(allMembers, ind) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
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
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          "You are not authorized to remove ${allMembers.user.firstName} ${allMembers.user.lastName}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
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
                                      left: 0, right: 0, top: 20, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: header,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Text(
                                    "OK",
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

  void deleteMember(allMembers) async {
    //await Future.delayed(Duration(seconds: 3));
    var data = {
      'community_id': widget.groupList['id'],
      'id': allMembers.user.id,
    };

    print(data);
    var postresponse =
        await CallApi().postData1(data, 'community/remove/friends');
    print(postresponse);
    var postcontent = postresponse.body;
    print("postcontent");
    print(postcontent);

    if (postresponse.statusCode == 200) {
      Navigator.of(context).pop();
      setState(() {
        ids.add(allMembers.user.id);
      });
      print("ids");
      print(ids);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GroupPage()));
    }

    // setState(() {
    //   groupList = posts;
    //   loading = false;
    // });
  }
}
