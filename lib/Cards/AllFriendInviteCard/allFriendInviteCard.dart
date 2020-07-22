import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Loader/FriendsLoader/friendLoader.dart';
import 'package:chatapp_new/Loader/InviteFriendLoader/inviteFriendLoader.dart';
import 'package:chatapp_new/MainScreen/GroupMemberPage/groupMemberPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class AllFriendInviteCard extends StatefulWidget {
  final friendNames;
  final userData;
  final groupList;
  AllFriendInviteCard(this.friendNames, this.userData, this.groupList);
  @override
  AllFriendInviteCardState createState() => AllFriendInviteCardState();
}

class AllFriendInviteCardState extends State<AllFriendInviteCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            blurRadius: 1.0,
            color: Colors.black38,
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Container(
              //color: Colors.red,
              margin: EdgeInsets.only(left: 15, right: 20, top: 0),
              padding: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ////// <<<<< Profile Picture >>>>> //////
                  Container(
                            height: 40,
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(1.0),
                            child: CachedNetworkImage(
                                    imageUrl: widget.friendNames.profilePic,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      "assets/images/user.png",
                                      height: 40,
                                    ),

                                    // NetworkImage(
                                    //     widget.friend[index].profilePic
                                  ),
                            decoration: new BoxDecoration(
                              //color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),

                  ////// <<<<< User Name >>>>> //////
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.friendNames.firstName +
                              " " +
                              widget.friendNames.lastName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ////// <<<<< Message Button >>>>> //////
          GestureDetector(
            onTap: () {
              inviteFriends();
            },
            child: Container(
                margin: EdgeInsets.only(right: 15),
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: header.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: header, width: 0.5)),
                child: Text("ADD",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 12))),
          ),
        ],
      ),
    );
  }

  void inviteFriends() async {
    //await Future.delayed(Duration(seconds: 3));
    var data = {
      'comId': widget.groupList['id'],
      'id': widget.friendNames.user_id,
    };

    print(data);
    var postresponse = await CallApi().postData1(data, 'add/friends_com');
    print(postresponse);
    var postcontent = postresponse.body;
    print("postcontent");
    print(postcontent);
    if (postresponse.statusCode == 200) {
      print("done");
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                GroupMemberPage(widget.groupList, widget.userData)),
      );
    }

    // setState(() {
    //   groupList = posts;
    //   loading = false;
    // });
  }
}
