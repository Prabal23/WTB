import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/CommentModel/commentModel.dart';
import 'package:chatapp_new/Loader/PostLoader/postLoader.dart';
import 'package:chatapp_new/MainScreen/FriendProfileReplyPage/FriendProfileReplyPage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/FriendsProfilePage/friendsProfilePage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/MyProfilePage/myProfilePage.dart';
import 'package:chatapp_new/MainScreen/ReplyPage/replyPage.dart';
import 'package:chatapp_new/MainScreen/ReplyProfilePost/ReplyProfilePost.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

List<String> isDeleted = [];
List fprofileReplyList = [];

class FriendProfileCommentPage extends StatefulWidget {
  final feedId;
  final index;
  FriendProfileCommentPage(this.feedId, this.index);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<FriendProfileCommentPage> {
  var comList;
  var userData;
  bool loading = true, isSubmit = false;
  TextEditingController comEditor = new TextEditingController();
  ScrollController scrollController = new ScrollController();
  String com = "", totalLike = "";
  List commentList = [];

  @override
  void initState() {
    setState(() {
      fprofileReplyList.clear();
    });
    _getUserInfo();
    loadComments();
    //print(widget.feedId);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future loadComments() async {
    //await Future.delayed(Duration(seconds: 3));

    setState(() {
      loading = true;
    });
    var comresponse =
        await CallApi().getData('load/prev-com/${widget.feedId}?comid=1');
    var postcontent = comresponse.body;
    final comments = json.decode(postcontent);
    var comdata = AllCommentsModel.fromJson(comments);

    setState(() {
      comList = comdata;
      loading = false;
      totalLike = "1";

      for (int i = 0; i < comList.comments.length; i++) {
        fprofileReplyList
            .add({'count': comList.comments[i].replay.totalReplyCount});

        commentList.add({
          'id': "${comList.comments[i].id}",
          'comment': comList.comments[i].comment,
          'uId': comList.comments[i].user.id,
          'pic': comList.comments[i].user.profilePic,
          'fName': comList.comments[i].user.firstName,
          'lName': comList.comments[i].user.lastName,
          'created': comList.comments[i].created_at,
          'myLike': comList.comments[i].like,
          'totalLike': comList.comments[i].replay.totalLikeCount,
          'totalReply': comList.comments[i].replay.totalReplyCount,
        });
      }
    });
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
    });

    //print("${userData['shop_id']}");
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
                        "Comments",
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
      body: Container(
        child: Stack(
          children: <Widget>[
            loading
                ? Center(
                    child: Container(
                      child: Text(
                        "Please Wait...",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  )
                : commentList.length == 0
                    ? Center(
                        child: Container(
                          child: Text(
                            "No Comments",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      )
                    : CustomScrollView(
                        slivers: <Widget>[
                          Container(
                              child: CreatePostCard(commentList, widget.feedId,
                                  userData, widget.index)),
                        ],
                      ),

            ///// <<<<< Comment field start >>>>> //////

            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        ////// <<<<< Comment Box Text Field >>>>> //////
                        Flexible(
                          child: Container(
                            //height: 100,
                            padding: EdgeInsets.all(0),
                            margin: EdgeInsets.only(
                                top: 5, left: 10, bottom: 5, right: 10),
                            decoration: BoxDecoration(
                                // borderRadius:
                                //     BorderRadius.all(Radius.circular(100.0)),
                                borderRadius: new BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0)),
                                color: Colors.grey[100],
                                border: Border.all(
                                    width: 0.5,
                                    color: Colors.black.withOpacity(0.2))),
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: new ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 120.0,
                                    ),
                                    child: new SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      reverse: true,
                                      child: new TextField(
                                        maxLines: null,
                                        autofocus: false,
                                        controller: comEditor,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Oswald',
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Type a comment here...",
                                          hintStyle: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 15,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w300),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10.0, 10.0, 20.0, 10.0),
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            com = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        ////// <<<<< Comment Send Icon Button >>>>> //////
                        GestureDetector(
                          onTap: () {
                            commentButton(widget.index);
                            comEditor.text = "";
                            commentList.add({
                              'id': null,
                              'comment': com,
                              'uId': userData['id'],
                              'pic': userData['profilePic'],
                              'fName': userData['firstName'],
                              'lName': userData['lastName'],
                              'created': userData['created_at'],
                              'myLike': null,
                              'totalLike': 0,
                              'totalReply': 0,
                            });

                            fprofileReplyList.add({'count': 0});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: back,
                                borderRadius: BorderRadius.circular(25)),
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.send,
                              color: header,
                              size: 23,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ///// <<<<< Comment field end >>>>> //////
          ],
        ),
      ),
      //bottomNavigationBar:
    );
  }

  void commentButton(index) {
    if (comEditor.text.isEmpty) {
      return _showMsg("Comment field is empty");
    } else {
      commentSend(index);
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

  Future commentSend(index) async {
    setState(() {
      isSubmit = true;
    });

    var data = {
      'comment': comEditor.text,
      'status_id': widget.feedId,
      'id': null,
      'isEdit': false,
    };

    var res = await CallApi().postData1(data, 'add/comment');
    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      comEditor.text = "";
      fprofileComCount[index]['count'] += 1;
      commentList.removeAt(commentList.length - 1);
      //profileReplyList.removeAt(profileReplyList.length - 1);
      setState(() {
        setState(() {
          commentList.add({
            'id': "${body['comment']['id']}",
            'comment': body['comment']['comment'],
            'uId': body['comment']['user']['id'],
            'pic': body['comment']['user']['profilePic'],
            'fName': body['comment']['user']['firstName'],
            'lName': body['comment']['user']['lastName'],
            'created': body['comment']['created_at'],
            'myLike': body['comment']['like'],
            'totalLike': body['comment']['__meta__']['totalLike_count'],
            'totalReply': body['comment']['__meta__']['totalReply_count'],
          });
          fprofileReplyList
              .add({'count': body['comment']['__meta__']['totalLike_count']});
        });
      });
    } else if (body['success'] == false) {
      comEditor.text = "";
      fprofileReplyList.removeAt(fprofileReplyList.length - 1);
      commentList.removeAt(commentList.length - 1);
      fprofileComCount[index]['count'] -= 1;
    }

    setState(() {
      isSubmit = false;
    });

    //loadComments();
  }
}

class CreatePostCard extends StatefulWidget {
  final comList;
  final statusID;
  final userData;
  final index;
  CreatePostCard(this.comList, this.statusID, this.userData, this.index);

  @override
  CreatePostCardState createState() => CreatePostCardState();
}

class CreatePostCardState extends State<CreatePostCard> {
  String theme = "", comment = "";
  int totalLike, idx = -1;
  bool loading = true;
  bool isEdit = false;
  bool isSubmit = false;
  TextEditingController editingController = new TextEditingController();

  @override
  void initState() {
    //timerCheck();
    //print(widget.comList);
    // for (int i = 0; i < widget.comList.length; i++) {
    //   editingController.text = widget.comList[i].comment;
    //   // comment = widget.comList[i].comment;
    //   // print(widget.comList[i]);
    // }

    super.initState();
  }

  void _statusModalBottomSheet(context, int index, var userData, var feed) {
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
                    _showEditDialog(feed, index),
                    setState(() {
                      idx = index;
                    }),
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
                  onTap: () => {
                    Navigator.pop(context),
                    _showDeleteDialog(feed['id'], index),
                    idx = index
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<Null> _showDeleteDialog(int id, index) async {
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
                                deleteStatus(id, index);
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

  Future<Null> _showEditDialog(feed, index) async {
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
                      //height: 100,
                      padding: EdgeInsets.all(0),
                      margin:
                          EdgeInsets.only(top: 5, left: 0, bottom: 5, right: 0),
                      decoration: BoxDecoration(
                          // borderRadius:
                          //     BorderRadius.all(Radius.circular(100.0)),
                          borderRadius: new BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                          color: Colors.grey[100],
                          border: Border.all(
                              width: 0.5,
                              color: Colors.black.withOpacity(0.2))),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: new ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 120.0,
                              ),
                              child: new SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                reverse: true,
                                child: new TextField(
                                  maxLines: null,
                                  autofocus: false,
                                  controller: editingController,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Oswald',
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Type a comment here...",
                                    hintStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w300),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        10.0, 10.0, 20.0, 10.0),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      comment = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                  isEdit = false;
                                  idx = -1;
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 0, right: 10, top: 20, bottom: 0),
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
                                  Navigator.of(context).pop();
                                  commentButton(widget.comList[index]['id']);
                                  widget.comList[index]['comment'] = comment;
                                  isEdit = false;
                                  idx = -1;
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 10, right: 0, top: 20, bottom: 0),
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

  Future deleteStatus(int id, index) async {
    var data = {'id': id};

    print(data);

    var res = await CallApi().postData1(data, 'delete-comment');
    var body = json.decode(res.body);

    print(body);

    if (body == 1) {
      setState(() {
        fprofileComCount[widget.index]['count'] -= 1;
        idx = -1;
        //isDeleted.add("$id");
        fprofileComCount.removeAt(widget.index);
        widget.comList.removeAt(index);
        //isDeleted.add("$id");
      });
    } else {
      _showMsg("Something went wrong!");
    }
    print(isDeleted);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => FeedPage()));
  }

  void commentButton(int comID) {
    if (editingController.text.isEmpty) {
      return _showMsg("Comment field is empty");
    } else {
      commentSend(comID);
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

  Future commentSend(int comId) async {
    setState(() {
      isSubmit = true;
    });

    var data = {
      'comment': editingController.text,
      'status_id': widget.statusID,
      'id': comId,
      'isEdit': true,
    };

    print(data);

    var res = await CallApi().postData1(data, 'add/comment');
    var body = json.decode(res.body);
    print(body);

    if (body == "1" || body == 1) {
      setState(() {});
    } else {
      _showMsg("Something went wrong!");
    }
    // if (body['success'] == true) {
    //   editingController.text = "";
    // } else if (body['success'] == false) {
    //   print(body['errorMessage']);
    //   _showMsg(body['errorMessage']);
    // }

    setState(() {
      isSubmit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SliverPadding(
        padding: EdgeInsets.only(bottom: 40),
        sliver: SliverList(
          delegate:
              (SliverChildBuilderDelegate((BuildContext context, int index) {
            String daysAgo = "";
            DateTime date1 =
                DateTime.parse("${widget.comList[index]['created']}");

            daysAgo = DateFormat.yMMMd().format(date1);

            return Container(
              padding: EdgeInsets.only(top: 0, bottom: 5),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.circular(15),
              //   //border: Border.all(width: 0.8, color: Colors.grey[300]),
              //   boxShadow: [
              //     BoxShadow(
              //       blurRadius: 1.0,
              //       color: Colors.black38,
              //       //offset: Offset(6.0, 7.0),
              //     ),
              //   ],
              // ),
              margin: EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 0, right: 0, bottom: 0),
                    padding: EdgeInsets.only(right: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ////// <<<<< pic start >>>>> //////
                        Container(
                          margin: EdgeInsets.only(right: 10, top: 0),
                          height: 35,
                          width: 35,
                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                          padding: EdgeInsets.all(0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: "${widget.comList[index]['pic']}",
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
                        ////// <<<<< pic end >>>>> //////

                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ////// <<<<< Name start >>>>> //////
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                          "${widget.comList[index]['fName']} ${widget.comList[index]['lName']}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: header,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    widget.userData['id'] !=
                                            widget.comList[index]['uId']
                                        ? Container(
                                            margin: EdgeInsets.only(top: 10),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (idx == -1) {
                                                  _statusModalBottomSheet(
                                                      context,
                                                      index,
                                                      widget.userData,
                                                      widget.comList[index]);
                                                  comment =
                                                      widget.comList[index]
                                                          ['comment'];
                                                  editingController.text =
                                                      widget.comList[index]
                                                          ['comment'];
                                                  //idx = index;
                                                }
                                              });
                                            },
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(right: 15),
                                                // color: Colors.blue,
                                                child: Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.black54,
                                                )),
                                          ),
                                  ],
                                ),

                                ////// <<<<< Name end >>>>> //////
                                Container(
                                    margin: EdgeInsets.only(
                                      left: 0,
                                      right: 20,
                                      top: 3,
                                    ),
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: idx == index && isEdit == true
                                          ? Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    child: new ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxHeight: 120.0,
                                                      ),
                                                      child:
                                                          new SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        reverse: true,
                                                        child: new TextField(
                                                          maxLines: null,
                                                          autofocus: true,
                                                          controller:
                                                              editingController,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Oswald',
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                                "Type a comment here...",
                                                            hintStyle: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    'Oswald',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .fromLTRB(
                                                                        0.0,
                                                                        10.0,
                                                                        20.0,
                                                                        10.0),
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              comment = value;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        GestureDetector(
                                                          onTap: () {
                                                            commentButton(widget
                                                                    .comList[
                                                                index]['id']);
                                                            widget.comList[
                                                                        index][
                                                                    'comment'] =
                                                                comment;
                                                            isEdit = false;
                                                            idx = -1;
                                                          },
                                                          child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          10),
                                                              child: Icon(
                                                                  Icons.done,
                                                                  color: header,
                                                                  size: 18)),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              isEdit = false;
                                                              idx = -1;
                                                            });
                                                          },
                                                          child: Container(
                                                              child: Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .redAccent,
                                                                  size: 18)),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(
                                              child: Text(
                                                "${widget.comList[index]['comment']}",
                                                textAlign: TextAlign.justify,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                    fontFamily: "OSwald",
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                    )),
                                Container(
                                  margin: EdgeInsets.only(left: 0, top: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(left: 0),
                                        child: Text(daysAgo,
                                            style: TextStyle(
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black54,
                                                fontSize: 12)),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 15),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.all(3.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  if (widget.comList[index]
                                                          ['myLike'] !=
                                                      null) {
                                                    setState(() {
                                                      widget.comList[index]
                                                          ['myLike'] = null;
                                                      print(
                                                          widget.comList[index]
                                                              ['totalLike']);
                                                      widget.comList[index]
                                                          ['totalLike'] -= 1;
                                                      print(
                                                          widget.comList[index]
                                                              ['totalLike']);
                                                    });
                                                    likeButtonPressed(index, 0);
                                                  } else {
                                                    setState(() {
                                                      widget.comList[index]
                                                          ['myLike'] = 1;
                                                      print(
                                                          widget.comList[index]
                                                              ['totalLike']);
                                                      widget.comList[index]
                                                          ['totalLike'] += 1;
                                                      print(
                                                          widget.comList[index]
                                                              ['totalLike']);
                                                    });
                                                    likeButtonPressed(index, 1);
                                                  }
                                                },
                                                child: Icon(
                                                  widget.comList[index]
                                                              ['myLike'] ==
                                                          null
                                                      ? Icons.favorite_border
                                                      : Icons.favorite,
                                                  size: 20,
                                                  color: widget.comList[index]
                                                              ['myLike'] ==
                                                          null
                                                      ? Colors.black54
                                                      : Colors.redAccent,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 3),
                                              child: Text(
                                                  "${widget.comList[index]['totalLike']}",
                                                  style: TextStyle(
                                                      fontFamily: 'Oswald',
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black54,
                                                      fontSize: 12)),
                                            )
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FriendProfileReplyPage(
                                                        widget.comList[index],
                                                        widget.statusID,
                                                        index)),
                                          );
                                        },
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 15),
                                                padding: EdgeInsets.all(3.0),
                                                child: Icon(
                                                  Icons.chat_bubble_outline,
                                                  size: 20,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 3),
                                                child: Text(
                                                    fprofileReplyList.length ==
                                                            0
                                                        ? "0"
                                                        : "${fprofileReplyList[index]['count']}",
                                                    style: TextStyle(
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.black54,
                                                        fontSize: 12)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                fprofileReplyList.length == 0
                                    ? Container()
                                    : fprofileReplyList[index]['count'] == 0
                                        ? Container()
                                        : GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FriendProfileReplyPage(
                                                              widget.comList[
                                                                  index],
                                                              widget.statusID,
                                                              index)));
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.only(top: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text("View replies...",
                                                      style: TextStyle(
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black54,
                                                          fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                          ),

                                Divider()
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }, childCount: widget.comList.length)),
        ),
      ),
    );
  }

  void likeButtonPressed(index, type) async {
    setState(() {
      //_isLoading = true;
    });

    var data = {
      'id': '${widget.comList[index]['id']}',
      'type': type,
      'status_id': '${widget.statusID}',
      'uid': '${widget.userData['id']}'
    };

    print(data);

    var res = await CallApi().postData1(data, 'add/com/like');
    var body = json.decode(res.body);

    print(body);

    setState(() {
      //_isLoading = false;
    });
  }
}
