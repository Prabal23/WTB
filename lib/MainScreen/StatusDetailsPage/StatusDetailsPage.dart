import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/CommentModel/commentModel.dart';
import 'package:chatapp_new/JSON_Model/NewsFeedModel/NewsFeedModel.dart';
import 'package:chatapp_new/Loader/PostLoader/postLoader.dart';
import 'package:chatapp_new/Loader/StatusLoader/StatusLoader.dart';
import 'package:chatapp_new/MainScreen/BottomNavigationPage/FeedPage/feedPage.dart';
import 'package:chatapp_new/MainScreen/CommentPage/commentPage.dart';
import 'package:chatapp_new/MainScreen/FeedStatusEditPage/feedStatusEditPage.dart';
import 'package:chatapp_new/MainScreen/HomePage/homePage.dart';
import 'package:chatapp_new/MainScreen/ProductDetails/productDetails.dart';
import 'package:chatapp_new/MainScreen/ReplyPage/replyPage.dart';
import 'package:chatapp_new/MainScreen/StatusCommentPage/StatusCommentPage.dart';
import 'package:chatapp_new/MainScreen/StatusReplyPage/StatusReplyPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class StatusDetailsPage extends StatefulWidget {
  @override
  _StatusDetailsPageState createState() => _StatusDetailsPageState();
}

class _StatusDetailsPageState extends State<StatusDetailsPage> {
  SharedPreferences sharedPreferences;
  String theme = "", pic = "";
  bool loading = true;
  var userData, daysAgo;
  var comList;
  //var postList;
  List<String> tagList = [];
  List<Widget> list = [];
  bool _isLoading = true;
  int id = 0, lastID = 1, lastid1 = 0;
  String proPic = "", statusPic = "", status = "Public", sharePost = "";
  int likeCount;
  //SocketIOManager manager;
  bool likePressed = false, beta = false, isSubmit = false;
  //bool loading = true;
  List<String> allPic = [];
  ScrollController _controller = new ScrollController();
  final RefreshController _refreshController = RefreshController();
  String des = "";
  String firstHalf;
  String secondHalf;
  String com = "", totalLike = "";
  bool flag = true;
  bool _isHasData = false;
  bool toLast = false;
  List likes = [];
  List feedList = [];
  List imagePost = [];
  List commentList = [];
  int _current = 0;
  String comment = "";
  int idx = -1;
  bool isEdit = false;
  bool noPosts = false;
  TextEditingController editingController = new TextEditingController();
  TextEditingController comEditorCont = new TextEditingController();

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    setState(() {
      userData = user;
    });

    print(userData);

    var interests = userData['interests'];
    var shop = "${userData['shop_id']}";

    print("interests");
    print(interests);

    if (interests != null) {
      for (int i = 0; i < interests.length; i++) {
        tagList.add("${interests[i]['tag']}");
      }
    }

    SharedPreferences localStorage1 = await SharedPreferences.getInstance();
    localStorage1.setString('shop_id', shop);
    localStorage1.setStringList('tags', tagList.toList());
    pic = userData['profilePic'];
    id = userData['id'];

    if (pic.contains("localhost")) {
      pic = pic.replaceAll("localhost:3010/", "https://mobile.tradister.com/");
      pic = pic.replaceAll("localhost:8080/", "https://mobile.tradister.com/");
    } else {
      //pic = "http://10.0.2.2:3010" + pic;
    }

    loadPosts(1);
  }

  Future loadPosts(int number) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var stid = localStorage.getString('stid');
    var postresponse = await CallApi().getData('get/status/$stid?c=&r=');

    setState(() {
      var postcontent = postresponse.body;
      print("postcontent");
      print(postcontent);

      if (postcontent != "{}") {
        final posts = json.decode(postcontent);
        var postdata = FeedPosts.fromJson(posts);
        postList = postdata;
        //page1 = 0;
        _isHasData = true;

        for (int i = 0; i < postList.feed.length; i++) {
          print(postList.feed[i].id);
          print(postList.feed[i].data);
          feedList.add(postList.feed[i]);
          statusPostComCount
              .add({'count': feedList[i].meta.totalCommentsCount});
          lastID = postList.feed[i].id;
          print(lastID);
        }
        setState(() {
          _isLoading = false;
        });

        loadComments(postList.feed[0].id);
      } else {
        noPosts = true;
      }
    });

    //print(page1);
  }

  Future loadComments(id) async {
    //await Future.delayed(Duration(seconds: 3));

    setState(() {
      loading = true;
    });
    var comresponse = await CallApi().getData('load/prev-com/$id?comid=1');
    var postcontent = comresponse.body;
    final comments = json.decode(postcontent);
    var comdata = AllCommentsModel.fromJson(comments);

    setState(() {
      comList = comdata;
      loading = false;
      totalLike = "1";

      for (int i = 0; i < comList.comments.length; i++) {
        statusPostRepCount
            .add({'count': comList.comments[0].replay.totalReplyCount});

        commentList.add({
          'id': comList.comments[0].id,
          'comment': comList.comments[0].comment,
          'uId': comList.comments[0].user.id,
          'pic': comList.comments[0].user.profilePic,
          'fName': comList.comments[0].user.firstName,
          'lName': comList.comments[0].user.lastName,
          'created': comList.comments[0].created_at,
          'myLike': comList.comments[0].like,
          'totalLike': comList.comments[0].replay.totalLikeCount,
          'totalReply': comList.comments[0].replay.totalReplyCount,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
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
                        "Post Details",
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
      body:
          postList == null ||
                  statusPostRepCount == null ||
                  statusPostComCount == null
              ? Center(child: CircularProgressIndicator())
              : noPosts
                  ? Center(
                      child: Text(
                      "No posts related to this!",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ))
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      child: Container(
                        child: ListView.builder(
                            controller: _controller,
                            itemCount: feedList.length,
                            itemBuilder: (context, index) {
                              des = "${feedList[index].data.status}";
                              if (des.length > 150) {
                                firstHalf = des.substring(0, 150);
                                secondHalf = des.substring(150, des.length);
                              } else {
                                firstHalf = des;
                                secondHalf = "";
                              }

                              String sharedFirstText = "";
                              String sharedLastText = "";

                              if (feedList[index].feedType == "Share") {
                                var text = "${feedList[index].data.sharedTxt}";
                                if (text.length > 150) {
                                  sharedFirstText = text.substring(0, 150);
                                  sharedLastText =
                                      text.substring(150, text.length);
                                } else {
                                  sharedFirstText = text;
                                  sharedLastText = "";
                                }
                              }

                              for (int i = 0; i < feedList.length; i++) {
                                DateTime date1 = DateTime.parse(
                                    "${feedList[index].created_at}");
                                DateTime dateTimeNow = DateTime.now();

                                daysAgo = DateFormat.yMMMd().format(date1);

                                // daysAgo =
                                //     dateTimeNow.difference(date1).inDays;

                                print('$daysAgo');
                              }
                              var metaTxt;
                              imagePost = [];
                              _current = 0;

                              for (int i = 0;
                                  i < feedList[index].data.images.length;
                                  i++) {
                                if (feedList[index]
                                    .data
                                    .images[i]
                                    .file
                                    .contains("127.0.0.1")) {
                                  feedList[index].data.images[i].file =
                                      feedList[index]
                                          .data
                                          .images[i]
                                          .file
                                          .replaceAll("127.0.0.1", "10.0.2.2");
                                }

                                if (feedList[i].data.link != null) {
                                  var meta = feedList[i].data.linkMeta;

                                  print("meta");
                                  print(meta);

                                  metaTxt = meta;

                                  print("metaTxt");
                                  print(metaTxt);
                                }

                                imagePost
                                    .add(feedList[index].data.images[i].file);
                              }
                              return isDelete.contains("${feedList[index].id}")
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        if (feedList[index].feedType ==
                                            "Product") {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetailsPage(
                                                          feedList[index]
                                                              .sourceId)));
                                        }
                                      },
                                      child: Container(
                                        //constraints: BoxConstraints.tightFor(height:150.0),
                                        padding:
                                            EdgeInsets.only(top: 5, bottom: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          //border: Border.all(width: 0.8, color: Colors.grey[300]),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 16.0,
                                              color: Colors.grey[300],
                                              //offset: Offset(3.0, 4.0),
                                            ),
                                          ],
                                        ),
                                        margin: EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 10,
                                            right: 10),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                id == feedList[index].fuser.id
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            _statusModalBottomSheet(
                                                                context,
                                                                index,
                                                                userData,
                                                                feedList[
                                                                    index]);
                                                            //print(widget.feed[index].id);
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
                                                      )
                                                    : Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10),
                                                      ),
                                              ],
                                            ),
                                            Container(
                                              //color: Colors.yellow,
                                              margin: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 10),
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  ////// <<<<< pic start >>>>> //////
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10, top: 0),
                                                    height: 40,
                                                    width: 40,
                                                    //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "${feedList[index].fuser.profilePic}",
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.asset(
                                                                "assets/images/user.png",
                                                                fit: BoxFit
                                                                    .cover),
                                                      ),
                                                    ),
                                                    decoration:
                                                        new BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                  ),
                                                  ////// <<<<< pic end >>>>> //////

                                                  Expanded(
                                                    child: Container(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          ////// <<<<< Name & Interest start >>>>> //////
                                                          Container(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Text(
                                                                    "${feedList[index].fuser.firstName} ${feedList[index].fuser.lastName}",
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .black,
                                                                        fontFamily:
                                                                            'Oswald',
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ),
                                                                feedList[index]
                                                                            .feedType ==
                                                                        "Share"
                                                                    ? Expanded(
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Text(
                                                                            " shared a post",
                                                                            maxLines:
                                                                                1,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                color: Colors.grey,
                                                                                fontFamily: 'Oswald',
                                                                                fontWeight: FontWeight.w400),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : feedList[index].feedType ==
                                                                            "ComPost"
                                                                        ? Expanded(
                                                                            child:
                                                                                Container(
                                                                              child: Text(
                                                                                " has posted in ${feedList[index].data.comName}",
                                                                                maxLines: 1,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: TextStyle(fontSize: 15, color: Colors.grey, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : feedList[index].feedType ==
                                                                                "Shop"
                                                                            ? Expanded(
                                                                                child: Container(
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        " has created a shop",
                                                                                        maxLines: 1,
                                                                                        style: TextStyle(fontSize: 15, color: Colors.grey, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : feedList[index].feedType == "Product"
                                                                                ? Container(
                                                                                    child: Row(
                                                                                      children: <Widget>[
                                                                                        Text(
                                                                                          " has uploaded a new product",
                                                                                          maxLines: 1,
                                                                                          style: TextStyle(fontSize: 15, color: Colors.grey, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                : Container(),
                                                                feedList[index]
                                                                            .interests ==
                                                                        null
                                                                    ? Container()
                                                                    : Expanded(
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Text(
                                                                            feedList[index].interests == null
                                                                                ? ""
                                                                                : " - ${feedList[index].interests}",
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: header,
                                                                                fontFamily: 'Oswald',
                                                                                fontWeight: FontWeight.w300),
                                                                          ),
                                                                        ),
                                                                      )
                                                              ],
                                                            ),
                                                          ),

                                                          ////// <<<<< Name & Interest end >>>>> //////

                                                          ////// <<<<< time job start >>>>> //////
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 3),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  child: Text(
                                                                    "$daysAgo",
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
                                                                            11,
                                                                        color: Colors
                                                                            .black54),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    child: Text(
                                                                      "-  ${feedList[index].fuser.jobTitle}",
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              header,
                                                                          fontFamily:
                                                                              'Oswald',
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                          ////// <<<<< time job end >>>>> //////
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            feedList[index].feedType == "Share"
                                                ? sharedFirstText == "null"
                                                    ? Container()
                                                    : Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10, right: 15),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              if (feedList[index]
                                                                          .isRead ==
                                                                      null ||
                                                                  feedList[index]
                                                                          .isRead ==
                                                                      "0") {
                                                                feedList[index]
                                                                        .isRead =
                                                                    "1";
                                                              } else {
                                                                feedList[index]
                                                                        .isRead =
                                                                    "0";
                                                              }
                                                            });
                                                          },
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                child: sharedLastText ==
                                                                        ""
                                                                    ? Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20),
                                                                        child: new Text(
                                                                            sharedFirstText,
                                                                            textAlign: TextAlign
                                                                                .justify,
                                                                            style: TextStyle(
                                                                                color: Colors.black.withOpacity(0.7),
                                                                                fontSize: 13,
                                                                                fontFamily: "Oswald",
                                                                                fontWeight: FontWeight.w300)),
                                                                      )
                                                                    : Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20),
                                                                        child: new Text(
                                                                            feedList[index].isRead == "0" || feedList[index].isRead == null
                                                                                ? sharedFirstText + "..."
                                                                                : sharedLastText + sharedFirstText,
                                                                            textAlign: TextAlign.start,
                                                                            style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                      ),
                                                              ),
                                                              secondHalf == ""
                                                                  ? Container()
                                                                  : Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              20,
                                                                          top:
                                                                              5),
                                                                      child: new Text(
                                                                          feedList[index].isRead == "0" || feedList[index].isRead == null
                                                                              ? "Read more"
                                                                              : "",
                                                                          textAlign: TextAlign
                                                                              .start,
                                                                          style: TextStyle(
                                                                              color: header,
                                                                              fontSize: 13,
                                                                              fontFamily: "Oswald",
                                                                              fontWeight: FontWeight.w400)),
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                : feedList[index].feedType !=
                                                        "Status"
                                                    ? Container()
                                                    : Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10, right: 15),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              if (feedList[index]
                                                                          .isRead ==
                                                                      null ||
                                                                  feedList[index]
                                                                          .isRead ==
                                                                      "0") {
                                                                feedList[index]
                                                                        .isRead =
                                                                    "1";
                                                              } else {
                                                                feedList[index]
                                                                        .isRead =
                                                                    "0";
                                                              }
                                                            });
                                                          },
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                child: secondHalf ==
                                                                        ""
                                                                    ? GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          if (feedList[index].data.linkMeta != null ||
                                                                              feedList[index].data.linkMeta == "") {
                                                                            _launchURL(feedList[index].data.linkMeta['og:url']);
                                                                          }
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          margin:
                                                                              EdgeInsets.only(left: 20),
                                                                          child: new Text(
                                                                              firstHalf,
                                                                              textAlign: TextAlign.justify,
                                                                              style: TextStyle(
                                                                                color: feedList[index].data.linkMeta != null ? Colors.blueAccent : Colors.black.withOpacity(0.7),
                                                                                fontSize: 13,
                                                                                fontFamily: "Oswald",
                                                                                fontWeight: FontWeight.w300,
                                                                                decoration: feedList[index].data.linkMeta != null ? TextDecoration.underline : TextDecoration.none,
                                                                              )),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20),
                                                                        child: new Text(
                                                                            feedList[index].isRead == "0" || feedList[index].isRead == null
                                                                                ? firstHalf + "..."
                                                                                : firstHalf + secondHalf,
                                                                            textAlign: TextAlign.start,
                                                                            style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                      ),
                                                              ),
                                                              secondHalf == ""
                                                                  ? Container()
                                                                  : Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              20,
                                                                          top:
                                                                              5),
                                                                      child: new Text(
                                                                          feedList[index].isRead == "0" || feedList[index].isRead == null
                                                                              ? "Read more"
                                                                              : "",
                                                                          textAlign: TextAlign
                                                                              .start,
                                                                          style: TextStyle(
                                                                              color: header,
                                                                              fontSize: 13,
                                                                              fontFamily: "Oswald",
                                                                              fontWeight: FontWeight.w400)),
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                            Container(
                                                child: Column(
                                              children: <Widget>[
                                                feedList[index].data.linkMeta !=
                                                            null ||
                                                        feedList[index]
                                                                .data
                                                                .linkMeta ==
                                                            ""
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          _launchURL(
                                                              feedList[index]
                                                                      .data
                                                                      .linkMeta[
                                                                  'og:url']);
                                                          // Navigator.push(
                                                          //     context,
                                                          //     MaterialPageRoute(
                                                          //         builder: (context) => WebView(
                                                          //             feedList[index].data.linkMeta[
                                                          //                 'og:site_name'],
                                                          //             feedList[index]
                                                          //                 .data
                                                          //                 .linkMeta['og:url'])));
                                                        },
                                                        child: Container(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    16.0),
                                                            child: Container(
                                                              color: Colors
                                                                  .grey[100],
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Image
                                                                        .network(
                                                                      "${feedList[index].data.linkMeta['og:image']}",
                                                                      height:
                                                                          120,
                                                                      width:
                                                                          130,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                    Flexible(
                                                                        child:
                                                                            Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            feedList[index].data.linkMeta['og:title'],
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.normal,
                                                                                color: Colors.black,
                                                                                fontFamily: "Oswald"),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                4,
                                                                          ),
                                                                          Text(
                                                                              feedList[index].data.linkMeta['og:description'],
                                                                              maxLines: 3,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(color: Colors.black45, fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w400)),
                                                                          SizedBox(
                                                                            height:
                                                                                4,
                                                                          ),
                                                                          Container(
                                                                            child:
                                                                                Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                // Image.network(
                                                                                //   feedList[index].data.linkMeta['favicon'],
                                                                                //   height: 12,
                                                                                //   width: 12,
                                                                                // ),
                                                                                // SizedBox(
                                                                                //   width: 4,
                                                                                // ),
                                                                                Expanded(child: Container(child: Text(feedList[index].data.linkMeta['og:site_name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey, fontSize: 12))))
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : feedList[index]
                                                                .data
                                                                .images
                                                                .length ==
                                                            0
                                                        ? Container()
                                                        // : feedList[index]
                                                        //             .data
                                                        //             .images
                                                        //             .length ==
                                                        //         1
                                                        //     ? Container(
                                                        //         //color: Colors.red,
                                                        //         height: 500,
                                                        //         padding:
                                                        //             const EdgeInsets.all(
                                                        //                 0.0),
                                                        //         margin: EdgeInsets
                                                        //             .only(
                                                        //                 top:
                                                        //                     10),
                                                        //         decoration: BoxDecoration(
                                                        //             borderRadius: BorderRadius.circular(15),
                                                        //             image: DecorationImage(
                                                        //                 image: //AssetImage("assets/images/friend7.jpg"),
                                                        //                     NetworkImage("${feedList[index].data.images[0].file}"),
                                                        //                 fit: BoxFit.contain)),
                                                        //         child: null)
                                                        : Stack(
                                                            children: <Widget>[
                                                              Column(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                      height:
                                                                          500,
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                10,
                                                                            right:
                                                                                10,
                                                                            top:
                                                                                10),
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        child:
                                                                            CarouselSlider(
                                                                          height:
                                                                              500.0,
                                                                          initialPage:
                                                                              0,
                                                                          enlargeCenterPage:
                                                                              false,
                                                                          autoPlay:
                                                                              false,
                                                                          reverse:
                                                                              false,
                                                                          viewportFraction:
                                                                              1.0,
                                                                          enableInfiniteScroll:
                                                                              true,
                                                                          autoPlayInterval:
                                                                              Duration(seconds: 2),
                                                                          autoPlayAnimationDuration:
                                                                              Duration(milliseconds: 2000),
                                                                          pauseAutoPlayOnTouch:
                                                                              Duration(seconds: 10),
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          onPageChanged:
                                                                              (index) {
                                                                            setState(() {
                                                                              _current = index;
                                                                            });
                                                                          },
                                                                          items:
                                                                              imagePost.map((imgUrl) {
                                                                            return Builder(
                                                                              builder: (BuildContext context) {
                                                                                return CachedNetworkImage(
                                                                                  imageUrl: imgUrl,
                                                                                  placeholder: (context, url) => Center(child: Text("Please Wait...")),
                                                                                  errorWidget: (context, url, error) => Image.asset(
                                                                                    "assets/images/placeholder_cover.jpg",
                                                                                    height: 40,
                                                                                  ),

                                                                                  // NetworkImage(
                                                                                  //     widget.friend[index].profilePic
                                                                                );
                                                                              },
                                                                            );
                                                                          }).toList(),
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 15,
                                                                        right:
                                                                            20),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5),
                                                                      color: Colors
                                                                              .grey[
                                                                          500],
                                                                      child:
                                                                          Text(
                                                                        "${_current + 1}/${imagePost.length}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontFamily: "Oswald"),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                              ],
                                            )),
                                            feedList[index].feedType == "Share"
                                                ? Container(
                                                    padding: EdgeInsets.only(
                                                        top: 10, bottom: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                          width: 0.8,
                                                          color:
                                                              Colors.grey[300]),
                                                      boxShadow: [
                                                        // BoxShadow(
                                                        //   blurRadius: 16.0,
                                                        //   color:
                                                        //       Colors.grey[300],
                                                        //   //offset: Offset(3.0, 4.0),
                                                        // ),
                                                      ],
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        top: 5,
                                                        bottom: 15,
                                                        left: 20,
                                                        right: 20),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Container(
                                                        //color: Colors.yellow,
                                                        margin: EdgeInsets.only(
                                                            left: 20,
                                                            right: 20,
                                                            bottom: 10),
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10),
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  ////// <<<<< pic start >>>>> //////

                                                                  Container(
                                                                    margin: EdgeInsets.only(
                                                                        right:
                                                                            10,
                                                                        top: 0),
                                                                    height: 40,
                                                                    width: 40,
                                                                    //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        imageUrl:
                                                                            "${feedList[index].data.fuser.profilePic}",
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                CircularProgressIndicator(),
                                                                        errorWidget: (context, url, error) => Image.asset(
                                                                            "assets/images/user.png",
                                                                            fit:
                                                                                BoxFit.cover),
                                                                      ),
                                                                    ),
                                                                    decoration:
                                                                        new BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                    ),
                                                                  ),
                                                                  ////// <<<<< pic end >>>>> //////

                                                                  Expanded(
                                                                    child:
                                                                        Container(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          ////// <<<<< Name & Interest start >>>>> //////
                                                                          Container(
                                                                            child:
                                                                                Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: <Widget>[
                                                                                Container(
                                                                                  child: Text(
                                                                                    "${feedList[index].data.fuser.firstName} ${feedList[index].data.fuser.lastName}",
                                                                                    maxLines: 1,
                                                                                    style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    child: Text(
                                                                                      feedList[index].data.interest == null ? "" : " - ${feedList[index].data.interest}",
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: TextStyle(fontSize: 14, color: header, fontFamily: 'Oswald', fontWeight: FontWeight.w300),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),

                                                                          ////// <<<<< Name & Interest end >>>>> //////

                                                                          ////// <<<<< time job start >>>>> //////
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 3),
                                                                            child:
                                                                                Row(
                                                                              children: <Widget>[
                                                                                Container(
                                                                                  child: Text(
                                                                                    index % 2 == 0 ? "6 hr" : "Aug 7 at 5:34 PM",
                                                                                    maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(fontFamily: 'Oswald', fontWeight: FontWeight.w400, fontSize: 11, color: Colors.black54),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(left: 5),
                                                                                    child: Text(
                                                                                      "-  ${feedList[index].data.fuser.jobTitle}",
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: TextStyle(fontSize: 11, color: header, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          ////// <<<<< time job end >>>>> //////
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            feedList[index]
                                                                        .data
                                                                        .feedType !=
                                                                    "Status"
                                                                ? Container()
                                                                : Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: 20,
                                                                        right:
                                                                            15),
                                                                    child:
                                                                        Column(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                          child: secondHalf == ""
                                                                              ? Container(
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  margin: EdgeInsets.only(left: 0),
                                                                                  child: new Text(firstHalf, textAlign: TextAlign.justify, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                                )
                                                                              : Container(
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  margin: EdgeInsets.only(left: 0),
                                                                                  child: new Text(feedList[index].data.isRead == "0" || feedList[index].data.isRead == null ? firstHalf + "..." : firstHalf + secondHalf, textAlign: TextAlign.start, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                                ),
                                                                        ),
                                                                        Container()
                                                                      ],
                                                                    ),
                                                                  ),
                                                            Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  left: 0,
                                                                  right: 20,
                                                                  top: 10,
                                                                ),
                                                                child: Column(
                                                                  children: <
                                                                      Widget>[
                                                                    feedList[index].data.images.length ==
                                                                            0
                                                                        ? Container()
                                                                        : Stack(
                                                                            children: <Widget>[
                                                                              Column(
                                                                                children: <Widget>[
                                                                                  Container(
                                                                                      height: 500,
                                                                                      child: Container(
                                                                                        margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                                                                                        width: MediaQuery.of(context).size.width,
                                                                                        child: CarouselSlider(
                                                                                          height: 500.0,
                                                                                          initialPage: 0,
                                                                                          enlargeCenterPage: false,
                                                                                          autoPlay: false,
                                                                                          reverse: false,
                                                                                          viewportFraction: 1.0,
                                                                                          enableInfiniteScroll: true,
                                                                                          autoPlayInterval: Duration(seconds: 2),
                                                                                          autoPlayAnimationDuration: Duration(milliseconds: 2000),
                                                                                          pauseAutoPlayOnTouch: Duration(seconds: 10),
                                                                                          scrollDirection: Axis.horizontal,
                                                                                          onPageChanged: (index) {
                                                                                            setState(() {
                                                                                              _current = index;
                                                                                            });
                                                                                          },
                                                                                          items: imagePost.map((imgUrl) {
                                                                                            return Builder(
                                                                                              builder: (BuildContext context) {
                                                                                                return CachedNetworkImage(
                                                                                                  imageUrl: imgUrl,
                                                                                                  placeholder: (context, url) => Center(child: Text("Please Wait...")),
                                                                                                  errorWidget: (context, url, error) => Image.asset(
                                                                                                    "assets/images/placeholder_cover.jpg",
                                                                                                    height: 40,
                                                                                                  ),

                                                                                                  // NetworkImage(
                                                                                                  //     widget.friend[index].profilePic
                                                                                                );
                                                                                              },
                                                                                            );
                                                                                          }).toList(),
                                                                                        ),
                                                                                      )),
                                                                                ],
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(top: 15, right: 20),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                  children: <Widget>[
                                                                                    Container(
                                                                                      padding: EdgeInsets.all(5),
                                                                                      color: Colors.grey[500],
                                                                                      child: Text(
                                                                                        "${_current + 1}/${imagePost.length}",
                                                                                        style: TextStyle(color: Colors.white, fontFamily: "Oswald"),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                    feedList[index].data.feedType ==
                                                                            "Status"
                                                                        ? Container()
                                                                        : Container(
                                                                            margin:
                                                                                EdgeInsets.only(left: 0),
                                                                            child:
                                                                                Row(
                                                                              children: <Widget>[
                                                                                Expanded(
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(top: feedList[index].data.images.length == 0 ? 0 : 10, right: 0, left: 0),
                                                                                    padding: EdgeInsets.all(5),
                                                                                    decoration: feedList[index].data.images.length == 0
                                                                                        ? BoxDecoration()
                                                                                        : BoxDecoration(
                                                                                            color: Colors.white,
                                                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                            boxShadow: [
                                                                                              BoxShadow(
                                                                                                color: Colors.grey[300],
                                                                                                blurRadius: 17,
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                    child: GestureDetector(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          if (feedList[index].isRead == null || feedList[index].isRead == "0") {
                                                                                            feedList[index].isRead = "1";
                                                                                          } else {
                                                                                            feedList[index].isRead = "0";
                                                                                          }
                                                                                        });
                                                                                      },
                                                                                      child: Column(
                                                                                        children: <Widget>[
                                                                                          Container(
                                                                                            child: secondHalf == ""
                                                                                                ? Container(
                                                                                                    width: MediaQuery.of(context).size.width,
                                                                                                    margin: EdgeInsets.only(left: 5),
                                                                                                    child: new Text(firstHalf, textAlign: TextAlign.justify, style: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                                                  )
                                                                                                : Container(
                                                                                                    width: MediaQuery.of(context).size.width,
                                                                                                    margin: EdgeInsets.only(left: feedList[index].data.images.length == 0 ? 0 : 20),
                                                                                                    child: new Text(feedList[index].isRead == "0" || feedList[index].isRead == null ? firstHalf + "..." : firstHalf + secondHalf, textAlign: TextAlign.start, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                                                  ),
                                                                                          ),
                                                                                          secondHalf == ""
                                                                                              ? Container()
                                                                                              : Container(
                                                                                                  width: MediaQuery.of(context).size.width,
                                                                                                  margin: EdgeInsets.only(left: feedList[index].data.images.length == 0 ? 0 : 0, top: 5),
                                                                                                  child: new Text(feedList[index].isRead == "0" || feedList[index].isRead == null ? "Read more" : "", textAlign: TextAlign.start, style: TextStyle(color: header, fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w400)),
                                                                                                )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                  ],
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : feedList[index].feedType ==
                                                        "Status"
                                                    ? Container()
                                                    : Container(
                                                        margin: EdgeInsets.only(
                                                            left: 20),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: Container(
                                                                margin: EdgeInsets.only(
                                                                    top: feedList[index].data.images.length ==
                                                                            0
                                                                        ? 0
                                                                        : 10,
                                                                    right: 20,
                                                                    left: 0),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                decoration: feedList[index]
                                                                            .data
                                                                            .images
                                                                            .length ==
                                                                        0
                                                                    ? BoxDecoration()
                                                                    : BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10)),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                Colors.grey[300],
                                                                            blurRadius:
                                                                                17,
                                                                          )
                                                                        ],
                                                                      ),
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      if (feedList[index].isRead ==
                                                                              null ||
                                                                          feedList[index].isRead ==
                                                                              "0") {
                                                                        feedList[index].isRead =
                                                                            "1";
                                                                      } else {
                                                                        feedList[index].isRead =
                                                                            "0";
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        child: secondHalf ==
                                                                                ""
                                                                            ? Container(
                                                                                width: MediaQuery.of(context).size.width,
                                                                                margin: EdgeInsets.only(left: 5),
                                                                                child: new Text(firstHalf, textAlign: TextAlign.justify, style: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                              )
                                                                            : Container(
                                                                                width: MediaQuery.of(context).size.width,
                                                                                margin: EdgeInsets.only(left: feedList[index].data.images.length == 0 ? 0 : 20),
                                                                                child: new Text(feedList[index].isRead == "0" || feedList[index].isRead == null ? firstHalf + "..." : firstHalf + secondHalf, textAlign: TextAlign.start, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                              ),
                                                                      ),
                                                                      secondHalf ==
                                                                              ""
                                                                          ? Container()
                                                                          : Container(
                                                                              width: MediaQuery.of(context).size.width,
                                                                              margin: EdgeInsets.only(left: feedList[index].data.images.length == 0 ? 0 : 20, top: 5),
                                                                              child: new Text(feedList[index].isRead == "0" || feedList[index].isRead == null ? "Read more" : "", textAlign: TextAlign.start, style: TextStyle(color: header, fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w400)),
                                                                            )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 0,
                                                    top: 10),
                                                child: Divider(
                                                  color: Colors.grey[400],
                                                )),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(3.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            if (feedList[index]
                                                                    .like !=
                                                                null) {
                                                              setState(() {
                                                                feedList[index]
                                                                        .like =
                                                                    null;
                                                                // print(widget.feed[index].meta
                                                                //     .totalLikesCount);
                                                                // likeCount = widget
                                                                //     .feed[index].meta.totalLikesCount;
                                                                // //likeCount = likeCount - 1;
                                                                // print(widget.feed[index].meta
                                                                //     .totalLikesCount);
                                                                // print("bfg $likeCount");

                                                                feedList[index]
                                                                        .meta
                                                                        .totalLikesCount =
                                                                    feedList[index]
                                                                            .meta
                                                                            .totalLikesCount -
                                                                        1;
                                                                //likes.insert(index, likeCount);
                                                              });
                                                              likeButtonPressed(
                                                                  index, 0);
                                                              //print(likes);
                                                            } else {
                                                              setState(() {
                                                                feedList[index]
                                                                    .like = 1;
                                                                // print(widget.feed[index].meta
                                                                //     .totalLikesCount);
                                                                // likeCount = widget
                                                                //     .feed[index].meta.totalLikesCount;
                                                                // likeCount = likeCount + 1;
                                                                // print("bfg $likeCount");
                                                                feedList[index]
                                                                        .meta
                                                                        .totalLikesCount =
                                                                    feedList[index]
                                                                            .meta
                                                                            .totalLikesCount +
                                                                        1;
                                                                // likeCount = widget
                                                                //     .feed[index].meta.totalLikesCount;
                                                                // likeCount = likeCount + 1;
                                                                //likes.insert(index, likeCount);
                                                              });
                                                              likeButtonPressed(
                                                                  index, 1);
                                                              //print(likes);
                                                            }
                                                          },
                                                          child: Container(
                                                            child: Icon(
                                                              feedList[index]
                                                                          .like !=
                                                                      null
                                                                  //likePressed == true
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_border,
                                                              size: 20,
                                                              color: feedList[index]
                                                                          .like !=
                                                                      null
                                                                  //likePressed == true
                                                                  ? Colors
                                                                      .redAccent
                                                                  : Colors
                                                                      .black54,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 3),
                                                        child: Text(
                                                            "${feedList[index].meta.totalLikesCount}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Oswald',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 12)),
                                                      )
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                StatusCommentPage(
                                                                    feedList[
                                                                            index]
                                                                        .id,
                                                                    index)),
                                                      );
                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 15),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    3.0),
                                                            child: Icon(
                                                              Icons
                                                                  .chat_bubble_outline,
                                                              size: 20,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 3),
                                                            child: Text(
                                                                statusPostComCount[index]
                                                                            [
                                                                            'count'] ==
                                                                        null
                                                                    ? ""
                                                                    : "${statusPostComCount[index]['count']}",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Oswald',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        12)),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _shareModalBottomSheet(
                                                          context,
                                                          index,
                                                          userData,
                                                          feedList[index]);
                                                    },
                                                    child: Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 15),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    3.0),
                                                            child: Icon(
                                                              Icons.send,
                                                              size: 20,
                                                              color: Colors
                                                                  .black54,
                                                            ),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 3),
                                                            child: Text(
                                                                feedList[
                                                                                index]
                                                                            .meta
                                                                            .totalSharesCount ==
                                                                        null
                                                                    ? ""
                                                                    : "${feedList[index].meta.totalSharesCount}",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Oswald',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    color: Colors
                                                                        .black54,
                                                                    fontSize:
                                                                        12)),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 0,
                                                    top: 0),
                                                child: Divider(
                                                  color: Colors.grey[400],
                                                )),
                                            commentList.length == 0
                                                ? Container()
                                                : GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                StatusCommentPage(
                                                                    feedList[
                                                                            index]
                                                                        .id,
                                                                    index)),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 0, bottom: 5),
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
                                                      margin: EdgeInsets.only(
                                                          top: 0,
                                                          bottom: idx ==
                                                                  commentList
                                                                          .length -
                                                                      1
                                                              ? 20
                                                              : 0,
                                                          left: 50,
                                                          right: 10),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 0,
                                                                    right: 0,
                                                                    bottom: 0,
                                                                    top: 10),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 0),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                ////// <<<<< pic start >>>>> //////
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              0),
                                                                  height: 35,
                                                                  width: 35,
                                                                  //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              0.0),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl:
                                                                          "${commentList[index]['pic']}",
                                                                      placeholder:
                                                                          (context, url) =>
                                                                              CircularProgressIndicator(),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Image.asset(
                                                                              "assets/images/user.png",
                                                                              fit: BoxFit.cover),
                                                                    ),
                                                                  ),
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                  ),
                                                                ),

                                                                ////// <<<<< pic end >>>>> //////

                                                                Expanded(
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        ////// <<<<< Name start >>>>> //////
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: <Widget>[
                                                                              Expanded(
                                                                                child: Container(
                                                                                  child: Text(
                                                                                    "${commentList[index]['fName']} ${commentList[index]['lName']}",
                                                                                    maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(fontSize: 15, color: header, fontFamily: 'Oswald', fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              // Container(
                                                                              //   child: Row(
                                                                              //     mainAxisAlignment:
                                                                              //         MainAxisAlignment
                                                                              //             .end,
                                                                              //     children: <
                                                                              //         Widget>[
                                                                              //       userData['id'] !=
                                                                              //               commentList[index]['uId']
                                                                              //           ? Container(
                                                                              //               margin:
                                                                              //                   EdgeInsets.only(top: 10),
                                                                              //             )
                                                                              //           : GestureDetector(
                                                                              //               onTap:
                                                                              //                   () {
                                                                              //                 setState(() {
                                                                              //                   if (idx == -1) {
                                                                              //                     _statusModalBottomSheet(context, index,userData, commentList[index]);
                                                                              //                     comment = commentList[index]['comment'];
                                                                              //                     editingController.text = commentList[index]['comment'];
                                                                              //                     //idx = index;
                                                                              //                   }
                                                                              //                 });
                                                                              //               },
                                                                              //               child: Container(
                                                                              //                   margin: EdgeInsets.only(right: 15),
                                                                              //                   // color: Colors.blue,
                                                                              //                   child: Icon(
                                                                              //                     Icons.more_horiz,
                                                                              //                     color: Colors.black54,
                                                                              //                   )),
                                                                              //             ),
                                                                              //     ],
                                                                              //   ),
                                                                              // ),
                                                                            ],
                                                                          ),
                                                                        ),

                                                                        ////// <<<<< Name end >>>>> //////
                                                                        Container(
                                                                            margin:
                                                                                EdgeInsets.only(
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
                                                                                              constraints: BoxConstraints(
                                                                                                maxHeight: 120.0,
                                                                                              ),
                                                                                              child: new SingleChildScrollView(
                                                                                                scrollDirection: Axis.vertical,
                                                                                                reverse: true,
                                                                                                child: new TextField(
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
                                                                                                    //commentButton(commentList[index]['id']);
                                                                                                    commentList[index]['comment'] = comment;
                                                                                                    isEdit = false;
                                                                                                    idx = -1;
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
                                                                                        "${commentList[index]['comment']}",
                                                                                        textAlign: TextAlign.justify,
                                                                                        style: TextStyle(fontSize: 13, color: Colors.black, fontFamily: "OSwald", fontWeight: FontWeight.w400),
                                                                                      ),
                                                                                    ),
                                                                            )),
                                                                        Container(
                                                                          margin: EdgeInsets.only(
                                                                              left: 0,
                                                                              top: 5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: <Widget>[
                                                                              Container(
                                                                                margin: EdgeInsets.only(left: 0),
                                                                                child: Text("6h ago", style: TextStyle(fontFamily: 'Oswald', fontWeight: FontWeight.w300, color: Colors.black54, fontSize: 12)),
                                                                              ),
                                                                              Container(
                                                                                margin: EdgeInsets.only(left: 15),
                                                                                child: Row(
                                                                                  children: <Widget>[
                                                                                    Container(
                                                                                      padding: EdgeInsets.all(3.0),
                                                                                      child: GestureDetector(
                                                                                        onTap: () {
                                                                                          if (commentList[index]['myLike'] != null) {
                                                                                            setState(() {
                                                                                              commentList[index]['myLike'] = null;
                                                                                              print(commentList[index]['totalLike']);
                                                                                              commentList[index]['totalLike'] -= 1;
                                                                                              print(commentList[index]['totalLike']);
                                                                                            });
                                                                                            likeButtonPressed(index, 0);
                                                                                          } else {
                                                                                            setState(() {
                                                                                              commentList[index]['myLike'] = 1;
                                                                                              print(commentList[index]['totalLike']);
                                                                                              commentList[index]['totalLike'] += 1;
                                                                                              print(commentList[index]['totalLike']);
                                                                                            });
                                                                                            likeButtonPressed(index, 1);
                                                                                          }
                                                                                        },
                                                                                        child: Icon(
                                                                                          commentList[index]['myLike'] == null ? Icons.favorite_border : Icons.favorite,
                                                                                          size: 20,
                                                                                          color: commentList[index]['myLike'] == null ? Colors.black54 : Colors.redAccent,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      margin: EdgeInsets.only(left: 3),
                                                                                      child: Text("${commentList[index]['totalLike']}", style: TextStyle(fontFamily: 'Oswald', fontWeight: FontWeight.w300, color: Colors.black54, fontSize: 12)),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.push(
                                                                                    context,
                                                                                    MaterialPageRoute(builder: (context) => StatusReplyPage(commentList[index], stId, index)),
                                                                                  );
                                                                                },
                                                                                child: Container(
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Container(
                                                                                        margin: EdgeInsets.only(left: 15),
                                                                                        padding: EdgeInsets.all(3.0),
                                                                                        child: Icon(
                                                                                          Icons.chat_bubble_outline,
                                                                                          size: 20,
                                                                                          color: Colors.black54,
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        margin: EdgeInsets.only(left: 3),
                                                                                        child: Text("${statusPostRepCount[index]['count']}", style: TextStyle(fontFamily: 'Oswald', fontWeight: FontWeight.w300, color: Colors.black54, fontSize: 12)),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        statusPostRepCount[index]['count'] ==
                                                                                0
                                                                            ? Container()
                                                                            : GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => StatusReplyPage(commentList[index], stId, index)));
                                                                                },
                                                                                child: Container(
                                                                                  width: MediaQuery.of(context).size.width,
                                                                                  margin: EdgeInsets.only(top: 10),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                                    children: <Widget>[
                                                                                      Text("View replies...", style: TextStyle(fontFamily: 'Oswald', fontWeight: FontWeight.w400, color: Colors.black54, fontSize: 12)),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                        //Divider()
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
                                    );
                            }),
                      ),
                    ),
    );
  }

  void _statusModalBottomSheet(context, int index, var userData, var feeds) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                // Text('React to this post',
                //       style: TextStyle(fontWeight: FontWeight.normal)),
                feeds.feedType == "Share"
                    ? Container()
                    : new ListTile(
                        leading: new Icon(Icons.edit),
                        title: new Text('Edit',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: "Oswald")),
                        onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeedStatusEditPost(
                                      feeds, userData, index)))
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
                  onTap: () =>
                      {Navigator.pop(context), _showDeleteDialog(feeds.id)},
                ),
              ],
            ),
          );
        });
  }

  void _shareModalBottomSheet(context, int index, var userData, var feeds) {
    print("index");
    print(index);
    des = "${feeds.data.status}";
    if (des.length > 100) {
      firstHalf = des.substring(0, 100);
      secondHalf = des.substring(100, des.length);
    } else {
      firstHalf = des;
      secondHalf = "";
    }

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.share,
                            color: Colors.black54,
                            size: 16,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              "Share this post",
                              style: TextStyle(fontFamily: "Oswald"),
                            ),
                          ),
                        ],
                      )),
                  Divider(),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(top: 0, left: 20),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: userData['profilePic'] == null
                                      ? AssetImage("assets/images/man2.jpg")
                                      : NetworkImage(
                                          "${userData['profilePic']}"),
                                  fit: BoxFit.cover),
                              border:
                                  Border.all(color: Colors.grey, width: 0.1),
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
                                          "${userData['firstName']} ${userData['lastName']}",
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
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
                                        _securityModalBottomSheet(context);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: 0, right: 5, left: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0.3,
                                                color: Colors.black54),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                  status == "Public"
                                                      ? "Public"
                                                      : "Connections",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300,
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
                    margin: EdgeInsets.only(
                        top: 20, left: 20, bottom: 5, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(5.0)),
                      //color: Colors.grey[100],
                      //border: Border.all(width: 0.2, color: Colors.grey)
                    ),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: 100.0, maxHeight: 100.0),
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
                            //controller: msgController,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              hintText: "Write something...",
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
                                sharePost = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            //snackBar(context);
                            isSubmit == false ? statusShare(feeds.id) : null;
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20, top: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                        left: 20, right: 20, top: 0),
                                    decoration: BoxDecoration(
                                        color: isSubmit == false
                                            ? header
                                            : Colors.grey[100],
                                        border: Border.all(
                                            color: Colors.grey, width: 0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Text(
                                      isSubmit == false
                                          ? "Share"
                                          : "Please wait...",
                                      style: TextStyle(
                                          color: isSubmit == false
                                              ? Colors.white
                                              : Colors.black26,
                                          fontSize: 15,
                                          fontFamily: 'BebasNeue',
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2.05,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      //border: Border.all(width: 0.8, color: Colors.grey[300]),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 16.0,
                          color: Colors.grey[300],
                          //offset: Offset(3.0, 4.0),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(
                        top: 5, bottom: 15, left: 10, right: 10),
                    child: SingleChildScrollView(
                      child: Container(
                        //color: Colors.yellow,
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        padding: EdgeInsets.only(right: 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ////// <<<<< pic start >>>>> //////
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    padding: EdgeInsets.all(1.0),
                                    child: CircleAvatar(
                                      radius: 20.0,
                                      backgroundColor: Colors.white,
                                      backgroundImage: feeds.fuser.profilePic ==
                                              null
                                          ? AssetImage("assets/images/man2.jpg")
                                          : NetworkImage(
                                              "${feeds.fuser.profilePic}"),
                                    ),
                                    decoration: new BoxDecoration(
                                      color: Colors.grey[300], // border color
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  ////// <<<<< pic end >>>>> //////

                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ////// <<<<< Name & Interest start >>>>> //////
                                          Container(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    "${feeds.fuser.firstName} ${feeds.fuser.lastName}",
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    child: Text(
                                                      feeds.interests == null
                                                          ? ""
                                                          : " - ${feeds.interests}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: header,
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),

                                          ////// <<<<< Name & Interest end >>>>> //////

                                          ////// <<<<< time job start >>>>> //////
                                          Container(
                                            margin: EdgeInsets.only(top: 3),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    index % 2 == 0
                                                        ? "6 hr"
                                                        : "Aug 7 at 5:34 PM",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 11,
                                                        color: Colors.black54),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        child: Icon(
                                                          Icons.album,
                                                          size: 10,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          "  ${feeds.fuser.jobTitle}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 11,
                                                              color: header,
                                                              fontFamily:
                                                                  'Oswald',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          ////// <<<<< time job end >>>>> //////
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            feeds.feedType != "Status"
                                ? Container()
                                : Container(
                                    margin: EdgeInsets.only(top: 20, right: 15),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: secondHalf == ""
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin:
                                                      EdgeInsets.only(left: 0),
                                                  child: new Text(firstHalf,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          fontSize: 13,
                                                          fontFamily: "Oswald",
                                                          fontWeight:
                                                              FontWeight.w300)),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin:
                                                      EdgeInsets.only(left: 0),
                                                  child: new Text(
                                                      feeds.isRead == "0" ||
                                                              feeds.isRead ==
                                                                  null
                                                          ? firstHalf + "..."
                                                          : firstHalf +
                                                              secondHalf,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.7),
                                                          fontSize: 13,
                                                          fontFamily: "Oswald",
                                                          fontWeight:
                                                              FontWeight.w300)),
                                                ),
                                        ),
                                        Container()
                                      ],
                                    ),
                                  ),
                            Container(
                                margin: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 10,
                                ),
                                child: Column(
                                  children: <Widget>[
                                    feeds.data.images.length == 0
                                        ? Container()
                                        : Container(
                                            //color: Colors.red,
                                            height: 200,
                                            padding: const EdgeInsets.all(0.0),
                                            margin: EdgeInsets.only(top: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                    image: //AssetImage("assets/images/friend7.jpg"),
                                                        NetworkImage(
                                                            "${feeds.data.images[0].file}"),
                                                    fit: BoxFit.cover)),
                                            child: null),
                                    feeds.feedType == "Status"
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(left: 0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: feeds.data.images
                                                                    .length ==
                                                                0
                                                            ? 0
                                                            : 10,
                                                        right: 0,
                                                        left: 0),
                                                    padding: EdgeInsets.all(5),
                                                    decoration: feeds
                                                                .data
                                                                .images
                                                                .length ==
                                                            0
                                                        ? BoxDecoration()
                                                        : BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey[300],
                                                                blurRadius: 17,
                                                              )
                                                            ],
                                                          ),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (postList
                                                                      .feed[
                                                                          index]
                                                                      .isRead ==
                                                                  null ||
                                                              postList
                                                                      .feed[
                                                                          index]
                                                                      .isRead ==
                                                                  "0") {
                                                            postList.feed[index]
                                                                .isRead = "1";
                                                          } else {
                                                            postList.feed[index]
                                                                .isRead = "0";
                                                          }
                                                        });
                                                      },
                                                      child: Column(
                                                        children: <Widget>[
                                                          Container(
                                                            child:
                                                                secondHalf == ""
                                                                    ? Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5),
                                                                        child: new Text(
                                                                            firstHalf,
                                                                            textAlign: TextAlign
                                                                                .justify,
                                                                            style: TextStyle(
                                                                                color: Colors.black.withOpacity(0.9),
                                                                                fontSize: 13,
                                                                                fontFamily: "Oswald",
                                                                                fontWeight: FontWeight.w300)),
                                                                      )
                                                                    : Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        margin: EdgeInsets.only(
                                                                            left: postList.feed[index].data.images.length == 0
                                                                                ? 0
                                                                                : 20),
                                                                        child: new Text(
                                                                            postList.feed[index].isRead == "0" || postList.feed[index].isRead == null
                                                                                ? firstHalf + "..."
                                                                                : firstHalf + secondHalf,
                                                                            textAlign: TextAlign.start,
                                                                            style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                      ),
                                                          ),
                                                          secondHalf == ""
                                                              ? Container()
                                                              : Container(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  margin: EdgeInsets.only(
                                                                      left: postList.feed[index].data.images.length ==
                                                                              0
                                                                          ? 0
                                                                          : 0,
                                                                      top: 5),
                                                                  child: new Text(
                                                                      postList.feed[index].isRead == "0" ||
                                                                              postList.feed[index].isRead ==
                                                                                  null
                                                                          ? "Read more"
                                                                          : "",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color:
                                                                              header,
                                                                          fontSize:
                                                                              13,
                                                                          fontFamily:
                                                                              "Oswald",
                                                                          fontWeight:
                                                                              FontWeight.w400)),
                                                                )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  Future<Null> _showDeleteDialog(int id) async {
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
                                deleteStatus(id);
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

  Future deleteStatus(int id) async {
    var data = {'id': id};

    print(data);

    var res = await CallApi().postData1(data, 'delete-status');
    print("res.body");
    print(res.body);
    print("res.statusCode");
    print(res.statusCode);
    //var body = json.decode(res.body);

    if (res.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage(0)));
    } else {
      _showMsg("Something went wrong!");
    }
    print(isDelete);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => FeedPage()));
  }

  Future<void> statusShare(id) async {
    var data = {'sharedTxt': sharePost, "status_id": id};

    print(data);

    var res = await CallApi().postData1(data, 'share-status');
    print("res.body");
    print(res.body);
    print("res.statusCode");
    print(res.statusCode);
    //var body = json.decode(res.body);

    if (res.statusCode == 200) {
      print("oyeche");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage(0)));
      setState(() {
        //isDelete.add("$id");
        //page1 = 0;
      });
    } else {
      Navigator.pop(context);
      _showMsg("Something went wrong!");
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

  void likeButtonPressed(index, type) async {
    setState(() {
      //_isLoading = true;
    });
    print("object");

    var data = {
      'id': '${postList.feed[index].id}',
      'type': type,
      'uid': '${postList.feed[index].userId}'
    };

    print(data);
    print("354353445345345");

    var res = await CallApi().postData1(data, 'add/like');
    var body = json.decode(res.body);

    print(body);
    //   if(body['success']){
    //   //   SharedPreferences localStorage = await SharedPreferences.getInstance();
    //   //   localStorage.remove('user');
    //   //   localStorage.setString('user', json.encode(body['user']));
    //   //  _showDialog('Information has been saved successfully!');
    //   print(body);

    //   }else{
    //     print('user is not updated');
    //   }

    setState(() {
      //_isLoading = false;
    });
  }

  void _securityModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.public),
                  title: new Text('Public',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontFamily: "Oswald")),
                  trailing: status == "Public"
                      ? Icon(Icons.done, color: header)
                      : Icon(Icons.done, color: Colors.transparent),
                  onTap: () => {
                    setState(() {
                      status = "Public";
                    }),
                    Navigator.pop(context)
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.lock_outline),
                  title: new Text('Connections',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontFamily: "Oswald")),
                  trailing: status == "Private"
                      ? Icon(Icons.done, color: header)
                      : Icon(Icons.done, color: Colors.transparent),
                  onTap: () => {
                    setState(() {
                      status = "Private";
                    }),
                    Navigator.pop(context)
                  },
                ),
              ],
            ),
          );
        });
  }

  _launchURL(link) async {
    var url = '$link';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
