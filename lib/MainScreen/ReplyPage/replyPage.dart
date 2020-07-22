import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/CommentModel/commentModel.dart';
import 'package:chatapp_new/JSON_Model/Reply_Model/reply_Model.dart';
import 'package:chatapp_new/Loader/PostLoader/postLoader.dart';
import 'package:chatapp_new/MainScreen/CommentPage/commentPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

List<String> isDel = [];

class ReplyPage extends StatefulWidget {
  final comList;
  final statusID;
  final index;
  ReplyPage(this.comList, this.statusID, this.index);
  @override
  ReplyPageState createState() => ReplyPageState();
}

class ReplyPageState extends State<ReplyPage> {
  var repList;
  var userData;
  bool loading = true, isSubmit = false;
  TextEditingController repEditor = new TextEditingController();
  String reply = "";
  List replyList = [];

  @override
  void initState() {
    _getUserInfo();
    loadComments();
    //print(widget.comList.id);
    // print("widget.comList.comments.length");
    // print(widget.comList.user.userName);
    super.initState();
  }

  Future loadComments() async {
    //await Future.delayed(Duration(seconds: 3));

    setState(() {
      loading = true;
    });
    var represponse = await CallApi()
        .getData('load/prev-reply/${widget.comList['id']}?replay=1');
    var postcontent = represponse.body;
    final reply = json.decode(postcontent);
    var repdata = AllReplyModel.fromJson(reply);

    setState(() {
      repList = repdata;
      loading = false;
    });
    for (int i = 0; i < repList.replies.length; i++) {
      replyList.add({
        'id': "${repList.replies[i].id}",
        'replyTxt': repList.replies[i].replyTxt,
        'uId': repList.replies[i].user.id,
        'pic': repList.replies[i].user.profilePic,
        'fName': repList.replies[i].user.firstName,
        'lName': repList.replies[i].user.lastName,
        'created': repList.replies[i].created_at,
        'myLike': repList.replies[i].like,
        'totalLike': repList.replies[i].replay.totalLikeCount,
      });
    }
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
                        "Reply",
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
                : replyList.length == 0
                    ? Center(
                        child: Container(
                          child: Text(
                            "No replies",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      )
                    : CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 0, top: 20),
                              padding: EdgeInsets.only(right: 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ////// <<<<< pic start >>>>> //////
                                  // Container(
                                  //   margin: EdgeInsets.only(right: 10),
                                  //   padding: EdgeInsets.all(1.0),
                                  //   child: CircleAvatar(
                                  //     radius: 15.0,
                                  //     backgroundColor: Colors.white,
                                  //     backgroundImage: widget.comList['pic'] ==
                                  //                 "" ||
                                  //             widget.comList['pic'] == null
                                  //         ? AssetImage("assets/images/man2.jpg")
                                  //         : NetworkImage(
                                  //             "${widget.comList['pic']}"),
                                  //   ),
                                  //   decoration: new BoxDecoration(
                                  //     color: Colors.grey[300],
                                  //     shape: BoxShape.circle,
                                  //   ),
                                  // ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10, top: 0),
                                    height: 40,
                                    width: 40,
                                    //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                    padding: EdgeInsets.all(0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl: "${widget.comList['pic']}",
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ////// <<<<< Name start >>>>> //////
                                          Container(
                                            child: Text(
                                              "${widget.comList['fName']} ${widget.comList['lName']}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: header,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.bold),
                                            ),
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
                                                child: Text(
                                                  "${widget.comList['comment']}",
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              )),
                                          // Container(
                                          //   margin: EdgeInsets.only(
                                          //       left: 0, top: 0),
                                          //   child: Row(
                                          //     mainAxisAlignment:
                                          //         MainAxisAlignment.start,
                                          //     children: <Widget>[
                                          //       Container(
                                          //         margin:
                                          //             EdgeInsets.only(left: 0),
                                          //         child: Text("8h ago",
                                          //             style: TextStyle(
                                          //                 fontFamily: 'Oswald',
                                          //                 fontWeight:
                                          //                     FontWeight.w300,
                                          //                 color: Colors.black54,
                                          //                 fontSize: 12)),
                                          //       ),
                                          //       Container(
                                          //         margin:
                                          //             EdgeInsets.only(left: 15),
                                          //         child: Row(
                                          //           children: <Widget>[
                                          //             Container(
                                          //               padding:
                                          //                   EdgeInsets.all(3.0),
                                          //               child: GestureDetector(
                                          //                 onTap: () {
                                          //                   print(
                                          //                       widget.comList);
                                          //                   if (widget.comList
                                          //                           .like !=
                                          //                       null) {
                                          //                     setState(() {
                                          //                       widget.comList
                                          //                               .like =
                                          //                           null;
                                          //                     });
                                          //                     likeButtonPressed(
                                          //                         0);
                                          //                   } else {
                                          //                     setState(() {
                                          //                       widget.comList
                                          //                           .like = 1;
                                          //                     });
                                          //                     likeButtonPressed(
                                          //                         3);
                                          //                   }
                                          //                 },
                                          //                 child: Icon(
                                          //                   widget.comList
                                          //                               .like ==
                                          //                           null
                                          //                       ? Icons
                                          //                           .favorite_border
                                          //                       : Icons
                                          //                           .favorite,
                                          //                   size: 20,
                                          //                   color: widget
                                          //                               .comList
                                          //                               .like ==
                                          //                           null
                                          //                       ? Colors.black54
                                          //                       : Colors
                                          //                           .redAccent,
                                          //                 ),
                                          //               ),
                                          //             ),
                                          //             Container(
                                          //               margin: EdgeInsets.only(
                                          //                   left: 3),
                                          //               child: Text(
                                          //                   "${widget.comList.replay.totalLikeCount}",
                                          //                   style: TextStyle(
                                          //                       fontFamily:
                                          //                           'Oswald',
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w300,
                                          //                       color: Colors
                                          //                           .black54,
                                          //                       fontSize: 12)),
                                          //             )
                                          //           ],
                                          //         ),
                                          //       ),
                                          //       GestureDetector(
                                          //         onTap: () {
                                          //           // Navigator.push(
                                          //           //   context,
                                          //           //   MaterialPageRoute(
                                          //           //       builder: (context) => CommentPage()),
                                          //           // );
                                          //         },
                                          //         child: Container(
                                          //           child: Row(
                                          //             children: <Widget>[
                                          //               Container(
                                          //                 margin:
                                          //                     EdgeInsets.only(
                                          //                         left: 15),
                                          //                 padding:
                                          //                     EdgeInsets.all(
                                          //                         3.0),
                                          //                 child: Icon(
                                          //                   Icons
                                          //                       .chat_bubble_outline,
                                          //                   size: 20,
                                          //                   color:
                                          //                       Colors.black54,
                                          //                 ),
                                          //               ),
                                          //               Container(
                                          //                 margin:
                                          //                     EdgeInsets.only(
                                          //                         left: 3),
                                          //                 child: Text(
                                          //                     "${widget.comList.replay.totalReplyCount}",
                                          //                     style: TextStyle(
                                          //                         fontFamily:
                                          //                             'Oswald',
                                          //                         fontWeight:
                                          //                             FontWeight
                                          //                                 .w300,
                                          //                         color: Colors
                                          //                             .black54,
                                          //                         fontSize:
                                          //                             12)),
                                          //               )
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          CreatePostCard(replyList, widget.comList, userData,
                              widget.statusID, widget.index),
                        ],
                      ),

            ///// <<<<< Reply field start >>>>> //////

            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        ////// <<<<< Reply Box Text Field >>>>> //////
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
                                        controller: repEditor,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Oswald',
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Type a reply here...",
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
                                            reply = value;
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
                            setState(() {
                              repEditor.text = "";
                              replyList.add({
                                'id': null,
                                'replyTxt': reply,
                                'uId': userData['id'],
                                'pic': userData['profilePic'],
                                'fName': userData['firstName'],
                                'lName': userData['lastName'],
                                'created': userData['created_at'],
                                'myLike': null,
                                'totalLike': 0,
                              });
                            });
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

            ///// <<<<< Reply field end >>>>> //////
          ],
        ),
      ),
    );
  }

  void likeButtonPressed(type) async {
    setState(() {
      //_isLoading = true;
    });

    var data = {
      'id': '${widget.comList.id}',
      'type': type,
      'status_id': '${widget.comList.statusId}',
      'uid': '${widget.comList.userId}'
    };

    print(data);

    var res = await CallApi().postData1(data, 'add/com/like');
    var body = json.decode(res.body);

    print(body);

    setState(() {
      //_isLoading = false;
    });
  }

  void commentButton(index) {
    if (repEditor.text.isEmpty) {
      return _showMsg("Reply field is empty");
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
    var data = {
      'replyTxt': repEditor.text,
      'status_id': widget.statusID,
      'uid': widget.comList['uId'],
      'isEdit': false,
      'comment_id': widget.comList['id']
    };

    print(data);

    var res = await CallApi().postData1(data, 'add/reply');
    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      setState(() {
        repEditor.text = "";
        postReplyList[index]['count'] += 1;
        replyList.removeAt(replyList.length - 1);
        replyList.add({
          'id': "${body['reply']['id']}",
          'replyTxt': body['reply']['replyTxt'],
          'uId': body['reply']['user']['id'],
          'pic': body['reply']['user']['profilePic'],
          'fName': body['reply']['user']['firstName'],
          'lName': body['reply']['user']['lastName'],
          'created': body['reply']['user']['created_at'],
          'myLike': body['reply']['like'],
          'totalLike': body['reply']['__meta__']['totalLike_count'],
        });
      });
    } else if (body['success'] == false) {
      repEditor.text = "";
      postReplyList.removeAt(replyList.length - 1);
      replyList.removeAt(replyList.length - 1);
      postReplyList[index]['count'] -= 1;
    }

    setState(() {
      repEditor.text = "";
    });

    //loadComments();
  }
}

class CreatePostCard extends StatefulWidget {
  final repList;
  final comList;
  final userData;
  final statusID;
  final index;
  CreatePostCard(
      this.repList, this.comList, this.userData, this.statusID, this.index);

  @override
  CreatePostCardState createState() => CreatePostCardState();
}

class CreatePostCardState extends State<CreatePostCard> {
  String theme = "", reply = "";
  int idx = -1;
  bool loading = true;
  bool isEdit = false;
  bool isSubmit = false;
  TextEditingController editingController = new TextEditingController();

  @override
  void initState() {
    // for (int i = 0; i < widget.repList.length; i++) {
    //   editingController.text = widget.repList[i].replyTxt;
    //   reply = widget.repList[i].replyTxt;
    //   print(reply);
    // }
    super.initState();
  }

  Future<Null> _showDeleteDialog(int id, int index) async {
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
                                      reply = value;
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
                                  commentButton(
                                      widget.repList[index]['id'],
                                      widget.repList[index]['uId'],
                                      widget.repList[index]);
                                  widget.repList[index]['replyTxt'] = reply;
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

  Future deleteStatus(int id, int index) async {
    var data = {'id': id};

    print(data);

    var res = await CallApi().postData1(data, 'delete-reply');
    var body = json.decode(res.body);

    print(body);

    if (body == 1) {
      setState(() {
        //isDel.add("$id");
        idx = -1;
        postReplyList[widget.index]['count'] -= 1;
        widget.repList.removeAt(index);
      });
    } else {
      _showMsg("Something went wrong!");
    }
    print(isDel);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => FeedPage()));
  }

  void _statusModalBottomSheet(context, int index, var userData, var reply) {
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
                    _showEditDialog(reply, index),
                    idx = index
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => FeedStatusEditPost(
                    //             feed, widget.userData, index)))
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
                    _showDeleteDialog(reply['id'], index),
                    idx = index
                  },
                ),
              ],
            ),
          );
        });
  }

  void commentButton(int comID, int uID, repList) {
    if (editingController.text.isEmpty) {
      return _showMsg("Comment field is empty");
    } else {
      commentSend(comID, uID, repList);
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

  Future commentSend(int comId, int uID, repList) async {
    setState(() {
      isSubmit = true;
    });

    var data = {
      'replyTxt': editingController.text,
      'status_id': widget.statusID,
      'uid': uID,
      'isEdit': true,
      'comment_id': widget.comList['id'],
      'id': comId
    };

    //print(data);

    var res = await CallApi().postData1(data, 'add/reply');
    var body = json.decode(res.body);
    //print(body);

    if (body == "1" || body == 1) {
      setState(() {});
    } else {
      _showMsg("Something went wrong!");
    }

    setState(() {
      isSubmit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.only(bottom: 40),
      sliver: SliverList(
        delegate:
            (SliverChildBuilderDelegate((BuildContext context, int index) {
          String daysAgo = "";
          DateTime date1 =
              DateTime.parse("${widget.repList[index]['created']}");

          daysAgo = DateFormat.yMMMd().format(date1);
          return Container(
            padding: EdgeInsets.only(top: 0, bottom: 5),
            margin: EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 10),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ////// <<<<< Name start >>>>> //////
                              Container(
                                //color: Colors.yellow,
                                margin: EdgeInsets.only(
                                    left: 40, right: 0, bottom: 0, top: 20),
                                padding: EdgeInsets.only(right: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    ////// <<<<< pic start >>>>> //////
                                    // Container(
                                    //   margin: EdgeInsets.only(right: 10),
                                    //   //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                    //   padding: EdgeInsets.all(1.0),
                                    //   child: CircleAvatar(
                                    //     radius: 12.0,
                                    //     backgroundColor: Colors.white,
                                    //     backgroundImage: widget.repList[index]
                                    //                     ['pic'] ==
                                    //                 "" ||
                                    //             widget.repList[index]['pic'] ==
                                    //                 null
                                    //         ? AssetImage(
                                    //             "assets/images/man2.jpg")
                                    //         : NetworkImage(
                                    //             "${widget.repList[index]['pic']}"),
                                    //   ),
                                    //   decoration: new BoxDecoration(
                                    //     color: Colors.grey[300], // border color
                                    //     shape: BoxShape.circle,
                                    //   ),
                                    // ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(right: 10, top: 0),
                                      height: 30,
                                      width: 30,
                                      //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                      padding: EdgeInsets.all(0.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${widget.repList[index]['pic']}",
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  "assets/images/user.png",
                                                  fit: BoxFit.cover),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                    ),
                                    ////// <<<<< pic end >>>>> //////

                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            ////// <<<<< Name start >>>>> //////
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      "${widget.repList[index]['fName']} ${widget.repList[index]['lName']}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: header,
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                widget.userData['id'] !=
                                                        widget.repList[index]
                                                            ['uId']
                                                    ? Container()
                                                    : GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            if (idx == -1) {
                                                              _statusModalBottomSheet(
                                                                  context,
                                                                  index,
                                                                  widget
                                                                      .userData,
                                                                  widget.repList[
                                                                      index]);
                                                              reply = widget
                                                                          .repList[
                                                                      index]
                                                                  ['replyTxt'];
                                                              editingController
                                                                  .text = widget
                                                                          .repList[
                                                                      index]
                                                                  ['replyTxt'];
                                                              //idx = index;
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 15),
                                                            // color: Colors.blue,
                                                            child: Icon(
                                                              Icons.more_horiz,
                                                              color: Colors
                                                                  .black54,
                                                            )),
                                                      ),
                                              ],
                                            ),

                                            ////// <<<<< Name end >>>>> //////
                                            Container(
                                                margin: EdgeInsets.only(
                                                  left: 0,
                                                  right: 0,
                                                  top: 5,
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    ////// <<<<< Comment start >>>>> //////
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 0),
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child:
                                                          idx == index &&
                                                                  isEdit == true
                                                              ? Container(
                                                                  child: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Flexible(
                                                                        child:
                                                                            new ConstrainedBox(
                                                                          constraints:
                                                                              BoxConstraints(
                                                                            maxHeight:
                                                                                120.0,
                                                                          ),
                                                                          child:
                                                                              new SingleChildScrollView(
                                                                            scrollDirection:
                                                                                Axis.vertical,
                                                                            reverse:
                                                                                true,
                                                                            child:
                                                                                new TextField(
                                                                              maxLines: null,
                                                                              autofocus: true,
                                                                              controller: editingController,
                                                                              style: TextStyle(color: Colors.black, fontFamily: 'Oswald', fontSize: 13, fontWeight: FontWeight.w400),
                                                                              decoration: InputDecoration(
                                                                                hintText: "Type a comment here...",
                                                                                hintStyle: TextStyle(color: Colors.black54, fontSize: 13, fontFamily: 'Oswald', fontWeight: FontWeight.w300),
                                                                                contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 10.0),
                                                                                border: InputBorder.none,
                                                                              ),
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  reply = value;
                                                                                });
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        child:
                                                                            Row(
                                                                          children: <
                                                                              Widget>[
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  commentButton(widget.repList[index]['id'], widget.repList[index]['uId'], widget.repList[index]);
                                                                                  widget.repList[index]['replyTxt'] = reply;
                                                                                  isEdit = false;
                                                                                  idx = -1;
                                                                                });
                                                                              },
                                                                              child: Container(margin: EdgeInsets.only(right: 10), child: Icon(Icons.done, color: header, size: 18)),
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  isEdit = false;
                                                                                  idx = -1;
                                                                                });
                                                                              },
                                                                              child: Container(child: Icon(Icons.close, color: Colors.redAccent, size: 18)),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              : Container(
                                                                  child: Text(
                                                                    "${widget.repList[index]['replyTxt']}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .justify,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            "Oswald",
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                    ),

                                                    ////// <<<<< Comment end >>>>> //////
                                                  ],
                                                )),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 0, top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 0),
                                                    child: Text(daysAgo,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Oswald',
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 10)),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              if (widget.repList[
                                                                          index]
                                                                      [
                                                                      'myLike'] !=
                                                                  null) {
                                                                setState(() {
                                                                  widget.repList[
                                                                          index]
                                                                      [
                                                                      'myLike'] = null;
                                                                  widget.repList[
                                                                          index]
                                                                      [
                                                                      'totalLike']--;
                                                                });
                                                                replayLikePressed(
                                                                    index, 0);
                                                              } else {
                                                                setState(() {
                                                                  widget.repList[
                                                                          index]
                                                                      [
                                                                      'myLike'] = 1;
                                                                  widget.repList[
                                                                          index]
                                                                      [
                                                                      'totalLike']++;
                                                                });
                                                                replayLikePressed(
                                                                    index, 1);
                                                              }
                                                            },
                                                            child: Icon(
                                                              widget.repList[index]
                                                                          [
                                                                          'myLike'] ==
                                                                      null
                                                                  ? Icons
                                                                      .favorite_border
                                                                  : Icons
                                                                      .favorite,
                                                              size: 16,
                                                              color: widget.repList[
                                                                              index]
                                                                          [
                                                                          'myLike'] ==
                                                                      null
                                                                  ? Colors
                                                                      .black54
                                                                  : Colors
                                                                      .redAccent,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 3),
                                                          child: Text(
                                                              "${widget.repList[index]['totalLike']}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Oswald',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      10)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
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
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }, childCount: widget.repList.length)),
      ),
    );
  }

  void replayLikePressed(index, type) async {
    setState(() {
      //_isLoading = true;
    });

    var data = {
      'com_uid': '${widget.comList['uId']}',
      'comment_id': '${widget.comList['id']}',
      'id': '${widget.repList[index]['id']}',
      'type': type,
      'status_id': '${widget.statusID}',
      'uid': '${widget.repList[index]['uId']}',
    };

    print(data);

    var res = await CallApi().postData1(data, 'add/reply/like');
    var body = json.decode(res.body);

    print(body);

    setState(() {
      //_isLoading = false;
    });
  }
}
