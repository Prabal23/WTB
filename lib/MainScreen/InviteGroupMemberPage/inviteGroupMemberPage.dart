import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/AllFriendInviteCard/allFriendInviteCard.dart';
import 'package:chatapp_new/Cards/GroupFriendAddCard/groupFriendAddCard.dart';
import 'package:chatapp_new/JSON_Model/GroupFriendModel/GroupFriendModel.dart';
import 'package:chatapp_new/Loader/InviteFriendLoader/inviteFriendLoader.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class InviteGroupMemberPage extends StatefulWidget {
  final groupList;
  final userData;
  InviteGroupMemberPage(this.groupList, this.userData);

  @override
  _InviteGroupMemberPageState createState() => _InviteGroupMemberPageState();
}

class _InviteGroupMemberPageState extends State<InviteGroupMemberPage> {
  var friendNames;
  String name = "";
  bool loading = false;
  TextEditingController srcController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future friendList(name) async {
    setState(() {
      loading = true;
    });
    //await Future.delayed(Duration(seconds: 3));
    var postresponse =
        await CallApi().getData2('get/friends/${widget.groupList['id']}/$name');
    print(postresponse);
    var postcontent = postresponse.body;
    final posts = json.decode(postcontent);
    var postdata = GroupFriendModel.fromJson(posts);
    print("posts");
    print(posts);
    if (postresponse.statusCode == 200) {
      setState(() {
        loading = false;
        friendNames = postdata.nonAdedFriends;
        print("friendNames.length");
        print(friendNames.length);
      });
    }

    // setState(() {
    //   groupList = posts;
    //   loading = false;
    // });
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
                        "Invite Members",
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
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 10, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(10),
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 0),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Icon(Icons.search,
                                        color: Colors.black45, size: 20)),
                                Flexible(
                                  child: TextField(
                                    onChanged: (value) {
                                      setState(() {
                                        name = value;
                                      });
                                      friendList(name);
                                    },
                                    controller: srcController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Oswald',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Search friends",
                                      hintStyle: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 15,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      //labelStyle: TextStyle(color: Colors.white70),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 2.5, 20.0, 2.5),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(top: 10, left: 20),
                          child: Text(
                            "Suggested",
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
                            margin:
                                EdgeInsets.only(top: 10, left: 20, bottom: 10),
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
                ],
              ),
            ),
            //AllFriendInviteCard(),
            name == ""
                ? SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "Type to find friends...",
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
                : loading
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
                    : friendNames.length == 0
                        ? SliverToBoxAdapter(
                            child: Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Text(
                                "No friends found!",
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
                            padding: EdgeInsets.only(bottom: 15, top: 5),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return loading == false
                                    ? AllFriendInviteCard(friendNames[index], widget.userData, widget.groupList)
                                    : InviteFriendsLoaderCard();
                              }, childCount: friendNames.length),
                            ),
                          )
          ],
        ),
      ),
    );
  }
}
