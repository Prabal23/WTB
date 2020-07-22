import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_new/Loader/GroupLoader/groupLoader.dart';
import 'package:chatapp_new/MainScreen/GroupDetailsPage/groupDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class GroupCard extends StatefulWidget {
  final groupList;
  GroupCard(this.groupList);
  @override
  GroupCardState createState() => GroupCardState();
}

class GroupCardState extends State<GroupCard> {
  SharedPreferences sharedPreferences;
  String theme = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      GroupDetailsPage(widget.groupList['slug'])));
        },
        child: Container(
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
          margin: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                padding: EdgeInsets.only(right: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ////// <<<<< Profile Picture >>>>> //////
                    // Container(
                    //   margin: EdgeInsets.only(top: 15),
                    //   padding: EdgeInsets.all(1.0),
                    //   child: CircleAvatar(
                    //     radius: 27.0,
                    //     backgroundColor: Colors.white,
                    //     backgroundImage:
                    //         NetworkImage('${widget.groupList['logo']}'),
                    //   ),
                    //   decoration: new BoxDecoration(
                    //     color: Colors.grey[300],
                    //     shape: BoxShape.circle,
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.only(left: 0, top: 0),
                      height: 50,
                      width: 50,
                      //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                      padding: EdgeInsets.all(0.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl: "${widget.groupList['logo']}",
                          placeholder: (context, url) => Center(
                              child: Text(
                            "Please Wait...",
                            textAlign: TextAlign.center,
                          )),
                          errorWidget: (context, url, error) => Image.asset(
                              "assets/images/no_image.png",
                              fit: BoxFit.cover),
                          fit: BoxFit.cover,
                        ),
                      ),
                      decoration: new BoxDecoration(shape: BoxShape.circle
                          //borderRadius: BorderRadius.circular(100),
                          ),
                    ),

                    ////// <<<<< Group Name >>>>> //////
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        "${widget.groupList['name']}",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w400),
                      ),
                    ),

                    ////// <<<<< Number of members >>>>> //////
                    Container(
                      margin: EdgeInsets.only(top: 3),
                      child: Text(
                        "${widget.groupList['__meta__']['totalMembers_count']} members",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
