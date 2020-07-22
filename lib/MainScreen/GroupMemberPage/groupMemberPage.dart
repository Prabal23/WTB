import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/AllMembersCard/allMembersCard.dart';
import 'package:chatapp_new/JSON_Model/GroupMemberModel/GroupMemberModel.dart';
import 'package:chatapp_new/Loader/FriendsLoader/friendLoader.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/FriendsProfilePage/friendsProfilePage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/MyProfilePage/myProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class GroupMemberPage extends StatefulWidget {
  final groupList;
  final userData;
  GroupMemberPage(this.groupList, this.userData);

  @override
  _GroupMemberPageState createState() => _GroupMemberPageState();
}

class _GroupMemberPageState extends State<GroupMemberPage> {
  var memberList, userData;
  String admin = "";
  bool loading = true;

  @override
  void initState() {
    _getUserInfo();

    super.initState();
  }

  Future loadGroupMember() async {
    //await Future.delayed(Duration(seconds: 3));
    var postresponse =
        await CallApi().getData2('get/all-members/${widget.groupList['id']}');
    print(postresponse);
    var postcontent = postresponse.body;
    final posts = json.decode(postcontent);
    var postdata = GroupMemberModel.fromJson(posts);

    // if (postdata != null) {
    //   setState(() {
    //     postList.feed.length += postdata.feed.length;
    //   });
    // }

    setState(() {
      memberList = postdata;
    });
    print("memberList.allMembers.length");
    print(memberList.allMembers.length);

    for (int i = 0; i < memberList.allMembers.length; i++) {
      if (userData['id'] == memberList.allMembers[i].user.id &&
          memberList.allMembers[i].isAdmin == 1) {
        admin =
            "${memberList.allMembers[i].user.firstName} ${memberList.allMembers[i].user.lastName}";
      }
    }

    print("admin");
    print(admin);

    setState(() {
      loading = false;
    });
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    setState(() {
      userData = user;
    });

    print(userData);
    loadGroupMember();
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
                        "Group Members",
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
        child: memberList == null
            ? Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: <Widget>[
                  ////// <<<<< All Friend Option >>>>> //////
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        ////// <<<<< Title >>>>> //////
                        // Container(
                        //     alignment: Alignment.centerLeft,
                        //     margin: EdgeInsets.only(top: 20, left: 20),
                        //     child: Text(
                        //       "List of members",
                        //       style: TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 18,
                        //           fontFamily: 'Oswald',
                        //           fontWeight: FontWeight.normal),
                        //     )),

                        // ////// <<<<< Divider 5 >>>>> //////
                        // Row(
                        //   children: <Widget>[
                        //     Container(
                        //       width: 30,
                        //       margin: EdgeInsets.only(top: 10, left: 20),
                        //       decoration: BoxDecoration(
                        //           borderRadius:
                        //               BorderRadius.all(Radius.circular(15.0)),
                        //           color: Colors.white,
                        //           boxShadow: [
                        //             BoxShadow(
                        //               blurRadius: 3.0,
                        //               color: Colors.black,
                        //               //offset: Offset(6.0, 7.0),
                        //             ),
                        //           ],
                        //           border:
                        //               Border.all(width: 0.5, color: Colors.black)),
                        //     ),
                        //   ],
                        // ),

                        ////// <<<<< Friend Number >>>>> //////
                        Container(
                          margin: EdgeInsets.only(top: 12, left: 20, bottom: 7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                  child: Text(
                                memberList == null
                                    ? "Please wait..."
                                    : "${memberList.allMembers.length}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w400),
                              )),
                              Container(
                                  margin: EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    " members",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w400),
                                  )),
                            ],
                          ),
                        ),

                        ////// <<<<< Divider 5 >>>>> //////
                        Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              margin:
                                  EdgeInsets.only(top: 0, left: 20, bottom: 12),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.white,
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

                  ////// <<<<< All Members Card >>>>> //////
                  //AllMembersCard(memberList.allMembers, userData, admin, widget.groupList),
                  Container(
                    child: memberList.allMembers == null
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FriendsProfilePage(
                                                      memberList
                                                          .allMembers[index]
                                                          .user
                                                          .userName,
                                                      1)));
                                    },

                                    ////// <<<<< Main Data >>>>> //////
                                    child: loading == false
                                        ? Container(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color: Colors.grey[300]),
                                            ),
                                            margin: EdgeInsets.only(
                                                top: 2.5,
                                                bottom: 2.5,
                                                left: 20,
                                                right: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                        top: 0),
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        ////// <<<<< Profile picture >>>>> //////
                                                        Stack(
                                                          children: <Widget>[
                                                            ////// <<<<< Picture >>>>> //////
                                                            // Container(
                                                            //   margin: EdgeInsets
                                                            //       .only(
                                                            //           right:
                                                            //               10),
                                                            //   padding:
                                                            //       EdgeInsets
                                                            //           .all(1.0),
                                                            //   child:
                                                            //       CircleAvatar(
                                                            //     radius: 30.0,
                                                            //     backgroundColor:
                                                            //         Colors
                                                            //             .white,
                                                            //     backgroundImage:
                                                            //         NetworkImage(
                                                            //             "${memberList.allMembers[index].user.profilePic}"),
                                                            //   ),
                                                            //   decoration:
                                                            //       new BoxDecoration(
                                                            //     color: Colors
                                                            //         .grey[300],
                                                            //     shape: BoxShape
                                                            //         .circle,
                                                            //   ),
                                                            // ),
                                                            Container(
                                                              height: 60,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(1.0),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: memberList
                                                                    .allMembers[
                                                                        index]
                                                                    .user
                                                                    .profilePic,
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Center(
                                                                        child:
                                                                            Text(
                                                                  "Wait...",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                )),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Image.asset(
                                                                  "assets/images/user.png",
                                                                  height: 40,
                                                                ),

                                                                // NetworkImage(
                                                                //     widget.friend[index].profilePic
                                                              ),
                                                              decoration:
                                                                  new BoxDecoration(
                                                                //color: Colors.grey[300],
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        ////// <<<<< User Name >>>>> //////
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                "${memberList.allMembers[index].user.firstName} ${memberList.allMembers[index].user.lastName}",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Oswald',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),

                                                              ////// <<<<< Role >>>>> //////
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 3),
                                                                child: Text(
                                                                  memberList.allMembers[index].isAdmin ==
                                                                              1 &&
                                                                          memberList.allMembers[index].isCreator ==
                                                                              1
                                                                      ? "Super Admin"
                                                                      : memberList.allMembers[index].isAdmin == 1 &&
                                                                              memberList.allMembers[index].isCreator == 0
                                                                          ? "Admin"
                                                                          : "Member",
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
                                                                          13,
                                                                      color: memberList.allMembers[index].isAdmin == 1 &&
                                                                              memberList.allMembers[index].isCreator ==
                                                                                  1
                                                                          ? header
                                                                          : Colors
                                                                              .black54),
                                                                ),
                                                              ),

                                                              ////// <<<<< Job Title >>>>> //////
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 3),
                                                                child: Text(
                                                                  "${memberList.allMembers[index].user.jobTitle}",
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Oswald',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black45),
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
                                                // Container(
                                                //     margin: EdgeInsets.only(
                                                //         right: 15),
                                                //     padding: EdgeInsets.only(
                                                //         left: 10,
                                                //         right: 10,
                                                //         top: 5,
                                                //         bottom: 5),
                                                //     decoration: BoxDecoration(
                                                //         color: header
                                                //             .withOpacity(0.7),
                                                //         borderRadius:
                                                //             BorderRadius
                                                //                 .circular(15),
                                                //         border: Border.all(
                                                //             color: header,
                                                //             width: 0.5)),
                                                //     child: Text("Message",
                                                //         textAlign:
                                                //             TextAlign.center,
                                                //         style: TextStyle(
                                                //             fontFamily:
                                                //                 'Oswald',
                                                //             fontWeight:
                                                //                 FontWeight.w400,
                                                //             color: Colors.white,
                                                //             fontSize: 12))),
                                              ],
                                            ),
                                          )

                                        ////// <<<<< Loader >>>>> //////
                                        : LoaderCard(),
                                  ),
                                  secondaryActions: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 5, bottom: 5),
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
                                          if (admin != "") {
                                            _showDeleteDialog(
                                                memberList.allMembers[index],
                                                index);
                                          } else {
                                            _showErrorDialog(
                                                memberList.allMembers[index],
                                                index);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }, childCount: memberList.allMembers.length),
                            ),
                          ),
                  )
                ],
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
      loadGroupMember();
    }

    // setState(() {
    //   groupList = posts;
    //   loading = false;
    // });
  }
}
