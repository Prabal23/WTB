import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chatapp_new/MainScreen/GroupDetailsPage/groupDetailsPage.dart';
import 'package:chatapp_new/MainScreen/HomePage/homePage.dart';
import 'package:flutter/services.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/CategoryModel/categoryModel.dart';
import 'package:chatapp_new/MainScreen/CreatePost/createPost.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';
import 'package:multi_media_picker/multi_media_picker.dart';

import '../../main.dart';

class GroupStatusEditForm extends StatefulWidget {
  final feed;
  final userData;
  final index;
  final groupList;
  GroupStatusEditForm(this.feed, this.userData, this.index, this.groupList);

  @override
  _GroupStatusEditFormState createState() => _GroupStatusEditFormState();
}

class _GroupStatusEditFormState extends State<GroupStatusEditForm> {
  String post = '', chk = "";
  String interests = "";
  String status = "Public";
  Timer _timer, _postTimer;
  int _start = 3, line = 1, _postStart = 2;
  bool isLoading = true;
  var catList;
  bool isOpen = false;
  List<String> selectedCategory = [];
  var selectedCat;
  int maxImageNo = 5;
  List allImages = [];
  List images = [];
  List imagesBase64 = [];
  var img;
  bool selectSingleImage = false;
  bool isSubmit = false;
  TextEditingController statusController = new TextEditingController();

  @override
  void initState() {
    setState(() {
      statusController.text = widget.feed.status;
      post = widget.feed.status;
    });
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 70,
                height: 70,
                margin: EdgeInsets.only(top: 0, left: 20),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: widget.userData['profilePic'] == null
                            ? AssetImage("assets/images/man2.jpg")
                            : NetworkImage("${widget.userData['profilePic']}"),
                        fit: BoxFit.cover),
                    border: Border.all(color: Colors.grey, width: 0.1),
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
                                "${widget.userData['firstName']} ${widget.userData['lastName']}",
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
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
                              //_statusModalBottomSheet(context);
                            },
                            child: Container(
                              margin:
                                  EdgeInsets.only(top: 0, right: 5, left: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.3, color: Colors.black54),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                        status == "Public"
                                            ? "Public"
                                            : "Connections",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
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
                          Text(interests == "" ? "" : "-",
                              style: TextStyle(color: header, fontSize: 25)),
                          Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                interests == "" ? "" : "$interests",
                                style: TextStyle(
                                    color: header,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Oswald"),
                              )),
                          interests == ""
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      interests = "";
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 3),
                                      child: Icon(Icons.clear,
                                          size: 18, color: Colors.black45)),
                                )
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
          margin: EdgeInsets.only(top: 25, left: 20, bottom: 5, right: 20),
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(5.0),
                topRight: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0)),
            //color: Colors.grey[100],
            //border: Border.all(width: 0.2, color: Colors.grey)
          ),
          child: Row(
            children: <Widget>[
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 100.0,
                  ),
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
                        controller: statusController,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          hintText: "What do you want to say?",
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
                            post = value;
                            //widget.feed.status = post;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        ////// <<<<< Category dropdown end >>>>> //////
        GestureDetector(
          onTap: () {
            //snackBar(context);
            isSubmit == false ? statusUpload() : null;
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 20, top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(15),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                      decoration: BoxDecoration(
                          color: isSubmit == false ? header : Colors.grey[100],
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Text(
                        isSubmit == false ? "Post" : "Please wait...",
                        style: TextStyle(
                            color: isSubmit == false
                                ? Colors.white
                                : Colors.black26,
                            fontSize: 15,
                            fontFamily: 'BebasNeue',
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Future statusUpload() async {
    setState(() {
      isSubmit = false;
    });

    var data = {
      'id': widget.feed.id,
      'community_id': widget.feed.community_id,
      'user_id': widget.feed.user_id,
      'title': widget.feed.title,
      'status': post,
      'images': widget.feed.images,
      'interest': widget.feed.interest,
      'link': widget.feed.link,
      'link_meta': widget.feed.link_meta,
      'privacy': widget.feed.privacy,
      'type': widget.feed.type,
      'commentCount': widget.feed.commentCount,
      'shareCount': widget.feed.shareCount,
      'created_at': widget.feed.created_at,
      'updated_at': widget.feed.updated_at,
    };

    print(data);

    var res = await CallApi().postData1(data, 'post/com_post_edit');
    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      setState(() {
        isSubmit = false;
      });
    }

    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GroupDetailsPage(widget.groupList)));
  }
}
