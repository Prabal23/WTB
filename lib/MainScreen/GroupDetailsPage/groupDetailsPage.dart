import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/PostCard/postCard.dart';
import 'package:chatapp_new/JSON_Model/GroupMemberModel/GroupMemberModel.dart';
import 'package:chatapp_new/JSON_Model/GroupPostModel/GroupPostModel.dart';
import 'package:chatapp_new/MainScreen/CommentPage/commentPage.dart';
import 'package:chatapp_new/MainScreen/CreateGroupPost/CreateGroupPost.dart';
import 'package:chatapp_new/MainScreen/CreatePost/createPost.dart';
import 'package:chatapp_new/MainScreen/FeedStatusEditPage/feedStatusEditPage.dart';
import 'package:chatapp_new/MainScreen/GroupCommentPage/GroupCommentPage.dart';
import 'package:chatapp_new/MainScreen/GroupMemberPage/groupMemberPage.dart';
import 'package:chatapp_new/MainScreen/GroupStatusEdit/GroupStatusEdit.dart';
import 'package:chatapp_new/MainScreen/InviteGroupMemberPage/inviteGroupMemberPage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/MyProfilePage/myProfilePage.dart';
import 'package:dio/dio.dart';
//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
//import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as Path;
import '../../main.dart';

List<String> isPostDelete = [];
List groupComCount = [];

class GroupDetailsPage extends StatefulWidget {
  final slug;
  GroupDetailsPage(this.slug);
  @override
  _GroupDetailsPageState createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var userData,
      memberList,
      groupPostList,
      groupDetails,
      editDOSList,
      editDONTSList;
  var file, file1;
  var userToken;
  bool _isLoaded = false;
  String pic = "", creator = "", banner = "", logo = "";
  String des = "", about = "", dos = "", donts = "";
  String firstHalf, firstAbout, daysAgo;
  String secondHalf, secondAbout;
  bool flag = true, view = true, isFollow = false;
  List imagePost = [];
  List dosList = [];
  List dontsList = [];
  int _current = 0;
  bool isDos = false;
  bool isDonts = false;
  bool doDontsSee = false;
  bool isAdmin = false;
  bool dosEdit = false;
  bool dontsEdit = false;
  bool isLogo = false;
  bool isBanner = false;
  TextEditingController dosController = new TextEditingController();
  TextEditingController dontsController = new TextEditingController();
  File logoImage, bannerImage;
  CancelToken token = CancelToken();
  var dio = new Dio();

  @override
  void initState() {
    setState(() {
      groupComCount.clear();
    });
    _getUserInfo();

    loadDetails();

    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
      pic = userData['profilePic'];
      _isLoaded = true;
    });

    var tokens = localStorage.getString('token');
    setState(() {
      userToken = tokens;
    });

    print(userData);
  }

  Future loadGroupMember(id) async {
    //await Future.delayed(Duration(seconds: 3));
    var postresponse = await CallApi().getData2('get/all-members/$id');
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
      if (memberList.allMembers[i].isAdmin == 1 &&
          memberList.allMembers[i].isCreator == 1) {
        setState(() {
          creator = memberList.allMembers[i].user.firstName +
              " " +
              memberList.allMembers[i].user.lastName;
        });
      }

      if (userData['id'] == memberList.allMembers[i].user_id) {
        setState(() {
          isFollow = true;
        });
      }

      if (userData['id'] == memberList.allMembers[i].user.id &&
          memberList.allMembers[i].isAdmin == 1) {
        setState(() {
          doDontsSee = true;
          isAdmin = true;
        });
      }
    }
  }

  Future loadGroupPosts(id) async {
    //await Future.delayed(Duration(seconds: 3));
    var postresponse = await CallApi().getData2('get/com_posts/$id');
    print(postresponse);
    var postcontent = postresponse.body;
    final posts = json.decode(postcontent);
    var postdata = GroupPostModel.fromJson(posts);

    // if (postdata != null) {
    //   setState(() {
    //     postList.feed.length += postdata.feed.length;
    //   });
    // }

    setState(() {
      groupPostList = postdata;
      _isLoaded = false;
    });
    print("groupPostList.communityPosts.length");
    print(groupPostList.communityPosts.length);

    for (int i = 0; i < groupPostList.communityPosts.length; i++) {
      groupComCount.add(
          {'count': groupPostList.communityPosts[i].meta.totalCommentsCount});
    }
  }

  Future loadDetails() async {
    //await Future.delayed(Duration(seconds: 3));
    var postresponse = await CallApi().getData2('get/community/${widget.slug}');
    print(postresponse);
    var postcontent = postresponse.body;
    final posts = json.decode(postcontent);
    //var postdata = GroupPostModel.fromJson(posts);

    // if (postdata != null) {
    //   setState(() {
    //     postList.feed.length += postdata.feed.length;
    //   });
    // }

    setState(() {
      groupDetails = posts;
      _isLoaded = false;
    });
    print("groupDetails");
    print(groupDetails);

    for (int i = 0; i < groupDetails['comData']['comrule'].length; i++) {
      if (groupDetails['comData']['comrule'][i]['type'] == 1) {
        dosList.add({
          'id': groupDetails['comData']['comrule'][i]['id'],
          'rule': groupDetails['comData']['comrule'][i]['rule'],
          'type': groupDetails['comData']['comrule'][i]['type'],
        });
      } else {
        dontsList.add({
          'id': groupDetails['comData']['comrule'][i]['id'],
          'rule': groupDetails['comData']['comrule'][i]['rule'],
          'type': groupDetails['comData']['comrule'][i]['type'],
        });
      }
    }

    print(dosList);
    print(dontsList);

    setState(() {
      about = groupDetails['comData']['about'];
      if (about.length > 150) {
        firstAbout = about.substring(0, 150);
        secondAbout = about.substring(150, about.length);
      } else {
        firstAbout = about;
        secondAbout = "";
      }
    });

    loadGroupMember(groupDetails['comData']['id']);
    loadGroupPosts(groupDetails['comData']['id']);
  }

  _pickBanner() async {
    file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        bannerImage = file;
        //bytes = await rootBundle.load(bannerImage.toString());
        uploadBanner();
        //_uploadImg(file);
      });
    }
  }

  _pickLogo() async {
    file1 = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file1 != null) {
      setState(() {
        logoImage = file1;
        //bytes = await rootBundle.load(bannerImage.toString());
        uploadLogo();
        //_uploadImg(file);
      });
    }
  }

  Future uploadBanner() async {
    setState(() {
      isBanner = true;
    });
    List<int> imageBytes = bannerImage.readAsBytesSync();
    banner = base64.encode(imageBytes);
    banner = 'data:image/png;base64,' + banner;

    var data = {
      'id': groupDetails['comData']['id'],
      'type': "groupCover",
      'file': banner
    };
    print(data);

    var res1 = await CallApi().postData1(data, 'group/imges');
    var body1 = json.decode(res1.body);
    print(body1);

    // setState(() {
    //   state1 = PhotoCrop.free;
    // });

    if (res1.statusCode == 200) {
      setState(() {
        isBanner = false;
      });
      _showMsg("Group Banner uploaded successfully!");
    }
  }

  Future uploadLogo() async {
    setState(() {
      isLogo = true;
    });
    List<int> imageBytes = logoImage.readAsBytesSync();
    logo = base64.encode(imageBytes);
    logo = 'data:image/png;base64,' + logo;

    var data = {
      'id': groupDetails['comData']['id'],
      'type': "groupLogo",
      'file': logo
    };
    print(data);

    var res1 = await CallApi().postData1(data, 'group/imges');
    var body1 = json.decode(res1.body);
    print(body1);

    // setState(() {
    //   state1 = PhotoCrop.free;
    // });

    if (res1.statusCode == 200) {
      setState(() {
        isLogo = false;
      });
      _showMsg("Group Logo uploaded successfully!");
    }
  }

  void _uploadImg(filePath) async {
    //print(object)
    String fileName = Path.basename(filePath.path);
    print("File base name: $fileName");

    try {
      FormData formData = new FormData.from({
        "file": new UploadFileInfo(filePath, fileName),
        "id": groupDetails['comData']['id'],
        'type': "groupCover",
      });
      // print(formData);
      print("filePath.existsSync()");
      print(filePath.existsSync());

      var response =
          await Dio().post(CallApi().url + 'group/imges?token=$userToken',
              data: formData,
              cancelToken: token,
              options: new Options(
                contentType:
                    ContentType.parse("application/x-www-form-urlencoded"),
              ), onSendProgress: (int sent, int total) {
        setState(() {
          // int imgPercent = ((sent / total) * 100).toInt();

          // print("percent");
          // print(imgPercent);
        });
      });

      print("response");
      print(response);
    } catch (e) {
      // print("Exception Caught: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
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
                          "Group Details",
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
        body: groupDetails == null
            ? Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          ////// <<<<< Cover Photo >>>>> //////
                          Stack(
                            children: <Widget>[
                              Container(
                                margin:
                                    EdgeInsets.only(top: 0, left: 0, right: 0),
                                child: Container(
                                  height: 220,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/placeholder_cover.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(0))),
                                  child: Container(
                                    height: 220,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        // image: DecorationImage(
                                        //   image: bannerImage != null
                                        //       ? FileImage(bannerImage)
                                        //       : NetworkImage(
                                        //           '${groupDetails['comData']['cover']}'),
                                        //   fit: BoxFit.cover,
                                        // ),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(0))),
                                    child: bannerImage != null
                                        ? Image.file(bannerImage)
                                        : CachedNetworkImage(
                                            imageUrl:
                                                "${groupDetails['comData']['cover']}",
                                            placeholder: (context, url) =>
                                                Center(
                                                    child:
                                                        Text("Please Wait...")),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              "assets/images/placeholder_cover.jpg",
                                              height: 40,
                                            ),

                                            // NetworkImage(
                                            //     widget.friend[index].profilePic
                                          ),
                                  ),
                                ),
                              ),
                              Container(
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(),
                                      Container(
                                        margin: EdgeInsets.only(right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  left: 20,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Column(
                                                      children: <Widget>[
                                                        Container(
                                                          height: 80,
                                                          width: 80,
                                                          decoration:
                                                              BoxDecoration(
                                                                  // color: Colors
                                                                  //     .white,
                                                                  image:
                                                                      DecorationImage(
                                                                    image: AssetImage(
                                                                        'assets/images/placeholder_cover.jpg'),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey),
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft:
                                                                          Radius.circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20),
                                                                      bottomLeft: Radius.circular(isAdmin ==
                                                                              false
                                                                          ? 20
                                                                          : 0),
                                                                      bottomRight: Radius.circular(isAdmin ==
                                                                              false
                                                                          ? 20
                                                                          : 0))),
                                                          child: Container(
                                                            height: 80,
                                                            width: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                                    // image:
                                                                    //     DecorationImage(
                                                                    //   image: logoImage !=
                                                                    //           null
                                                                    //       ? FileImage(
                                                                    //           logoImage)
                                                                    //       : NetworkImage(
                                                                    //           '${groupDetails['comData']['logo']}'),
                                                                    //   fit: BoxFit
                                                                    //       .cover,
                                                                    // ),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .grey),
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                20),
                                                                        topRight:
                                                                            Radius.circular(
                                                                                20),
                                                                        bottomLeft: Radius.circular(isAdmin ==
                                                                                false
                                                                            ? 20
                                                                            : 0),
                                                                        bottomRight: Radius.circular(isAdmin ==
                                                                                false
                                                                            ? 20
                                                                            : 0))),
                                                            child: logoImage !=
                                                                    null
                                                                ? Image.file(
                                                                    logoImage)
                                                                : Container(
                                                                    margin: EdgeInsets.only(
                                                                        left: 0,
                                                                        top: 0),
                                                                    height: 50,
                                                                    // width: 50,
                                                                    //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            0.0),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      child: isLogo
                                                                          ? CircularProgressIndicator()
                                                                          : CachedNetworkImage(
                                                                              imageUrl: "${groupDetails['comData']['logo']}",
                                                                              placeholder: (context, url) => Center(
                                                                                  child: Text(
                                                                                "Please Wait...",
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                              errorWidget: (context, url, error) => Image.asset("assets/images/no_image.png", fit: BoxFit.cover),
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                    ),
                                                                    decoration: new BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle
                                                                        //borderRadius: BorderRadius.circular(100),
                                                                        ),
                                                                  ),
                                                          ),
                                                        ),
                                                        isAdmin == false
                                                            ? Container()
                                                            : GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _pickLogo();
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                        width:
                                                                            80,
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                0),
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                5,
                                                                            top:
                                                                                5,
                                                                            bottom:
                                                                                5),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                header,
                                                                            borderRadius:
                                                                                BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                                                                        child: Container(
                                                                          child:
                                                                              Text(
                                                                            "Upload",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 14,
                                                                              fontFamily: 'BebasNeue',
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        )),
                                                              ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (isFollow == false) {
                                                    isFollow = true;
                                                    followUnfollow(1);
                                                  } else {
                                                    isFollow = false;
                                                    followUnfollow(2);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 0),
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 15,
                                                      top: 5,
                                                      bottom: 5),
                                                  decoration: BoxDecoration(
                                                      color: isFollow == false
                                                          ? header
                                                          : Colors.grey
                                                              .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15))),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        child: Icon(
                                                            isFollow == false
                                                                ? Icons.send
                                                                : Icons.remove,
                                                            color: Colors.white,
                                                            size: 14),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 3, left: 5),
                                                        child: Text(
                                                          isFollow == false
                                                              ? "Follow"
                                                              : "Unfollow",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'BebasNeue',
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            // isAdmin == false
                                            //     ? Container()
                                            //     :
                                            isAdmin == false
                                                ? Container()
                                                : GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _pickBanner();
                                                      });
                                                    },
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10),
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5,
                                                                right: 5,
                                                                top: 5,
                                                                bottom: 5),
                                                        decoration: BoxDecoration(
                                                            color: isBanner
                                                                ? Colors.white
                                                                : header,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            15))),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              child: isBanner
                                                                  ? CircularProgressIndicator()
                                                                  : Icon(
                                                                      Icons
                                                                          .image,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 14),
                                                            ),
                                                          ],
                                                        )),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),

                          ////// <<<<< Group by >>>>> //////
                          Container(
                            padding:
                                EdgeInsets.only(top: 0, left: 10, right: 0),
                            alignment: Alignment.centerLeft,
                            height: 30,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: Colors.grey[600]),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Group by ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  "$creator",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),

                          ////// <<<<< About Button >>>>> //////
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                margin: EdgeInsets.only(top: 15, bottom: 20),
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    // color: Colors.red
                                    ),
                                child: Column(
                                  children: <Widget>[
                                    ////// <<<<< Group Title >>>>> //////
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              "${groupDetails['comData']['name']}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 23,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          // Container(
                                          //     child: Icon(
                                          //   Icons.keyboard_arrow_right,
                                          //   color: Colors.black,
                                          //   size: 27,
                                          // ))
                                        ],
                                      ),
                                    ),

                                    ////// <<<<< Group Members >>>>> //////
                                    Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  "Total ${groupDetails['comData']['__meta__']['totalMembers_count']} Memebers",
                                                  style: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 15,
                                                      fontFamily: 'Oswald',
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                child: Row(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  GroupMemberPage(
                                                                      groupDetails[
                                                                          'comData'],
                                                                      userData)),
                                                        );
                                                      },
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 0),
                                                          padding: EdgeInsets
                                                              .only(
                                                                  left: 10,
                                                                  right: 10,
                                                                  top: 5,
                                                                  bottom: 5),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border: Border.all(
                                                                  color: header,
                                                                  width: 0.5),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15))),
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 3),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "View Members",
                                                                  style:
                                                                      TextStyle(
                                                                    color:
                                                                        header,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'BebasNeue',
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              2),
                                                                  child: Icon(
                                                                      Icons
                                                                          .chevron_right,
                                                                      color:
                                                                          header,
                                                                      size: 12),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  InviteGroupMemberPage(
                                                                      groupDetails[
                                                                          'comData'],
                                                                      userData)),
                                                        );
                                                      },
                                                      child: Container(
                                                          margin: EdgeInsets
                                                              .only(left: 5),
                                                          padding: EdgeInsets
                                                              .only(
                                                                  left: 10,
                                                                  right: 15,
                                                                  top: 5,
                                                                  bottom: 5),
                                                          decoration: BoxDecoration(
                                                              color: header,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15))),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                child: Icon(
                                                                    Icons.add,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 17),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 3),
                                                                child: Text(
                                                                  "ADD",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontFamily:
                                                                        'BebasNeue',
                                                                  ),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),

                          // Container(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: <Widget>[
                          //       ////// <<<<< Group Members Photo Button >>>>> //////
                          //       memberList == null
                          //           ? Container()
                          //           : memberList.allMembers.length == 0
                          //               ? Container(
                          //                   alignment: Alignment.topLeft,
                          //                   child: ClipOval(
                          //                     child: Image.asset(
                          //                       "assets/images/user.png",
                          //                       height: 40,
                          //                       width: 40,
                          //                       fit: BoxFit.cover,
                          //                     ),
                          //                   ),
                          //                 )
                          //               : GestureDetector(
                          //                   onTap: () {
                          //                     Navigator.push(
                          //                         context,
                          //                         MaterialPageRoute(
                          //                             builder: (context) =>
                          //                                 GroupMemberPage()));
                          //                   },
                          //                   child: Container(
                          //                     width: 160,
                          //                     margin: EdgeInsets.only(right: 10),
                          //                     alignment: Alignment.centerRight,
                          //                     // color: Colors.blue,
                          //                     child: Stack(
                          //                       children: <Widget>[
                          //                         memberList.allMembers.length == 1
                          //                             ? Container(
                          //                                 alignment:
                          //                                     Alignment.topLeft,
                          //                                 child: ClipOval(
                          //                                   child: Image.asset(
                          //                                     "assets/images/f9.jpg",
                          //                                     height: 40,
                          //                                     width: 40,
                          //                                     fit: BoxFit.cover,
                          //                                   ),
                          //                                 ),
                          //                               )
                          //                             : Container(),
                          //                         memberList.allMembers.length == 2
                          //                             ? Positioned(
                          //                                 left: 30,
                          //                                 child: Container(
                          //                                   alignment:
                          //                                       Alignment.topLeft,
                          //                                   child: ClipOval(
                          //                                     child: Image.asset(
                          //                                       "assets/images/f8.jpg",
                          //                                       height: 40,
                          //                                       width: 40,
                          //                                       fit: BoxFit.cover,
                          //                                     ),
                          //                                   ),
                          //                                 ),
                          //                               )
                          //                             : Container(),
                          //                         memberList.allMembers.length == 3
                          //                             ? Positioned(
                          //                                 left: 60,
                          //                                 child: Container(
                          //                                   alignment:
                          //                                       Alignment.topLeft,
                          //                                   child: ClipOval(
                          //                                     child: Image.asset(
                          //                                       "assets/images/man2.jpg",
                          //                                       height: 40,
                          //                                       width: 40,
                          //                                       fit: BoxFit.cover,
                          //                                     ),
                          //                                   ),
                          //                                 ),
                          //                               )
                          //                             : Container(),
                          //                         memberList.allMembers.length == 4
                          //                             ? Positioned(
                          //                                 left: 90,
                          //                                 child: Container(
                          //                                   alignment:
                          //                                       Alignment.topLeft,
                          //                                   child: ClipOval(
                          //                                     child: Image.asset(
                          //                                       "assets/images/f7.jpg",
                          //                                       height: 40,
                          //                                       width: 40,
                          //                                       fit: BoxFit.cover,
                          //                                     ),
                          //                                   ),
                          //                                 ),
                          //                               )
                          //                             : Container(),
                          //                         memberList.allMembers.length == 5
                          //                             ? Positioned(
                          //                                 left: 120,
                          //                                 child: Container(
                          //                                   alignment:
                          //                                       Alignment.topLeft,
                          //                                   child: ClipOval(
                          //                                     child: Stack(
                          //                                       children: <Widget>[
                          //                                         Image.asset(
                          //                                           "assets/images/f8.jpg",
                          //                                           height: 40,
                          //                                           width: 40,
                          //                                           fit: BoxFit.cover,
                          //                                         ),
                          //                                         memberList.allMembers
                          //                                                     .length >=
                          //                                                 5
                          //                                             ? Positioned(
                          //                                                 child:
                          //                                                     ClipOval(
                          //                                                   child: Container(
                          //                                                       height: 40,
                          //                                                       width: 40,
                          //                                                       color: Colors.black.withOpacity(0.3),
                          //                                                       child: Icon(
                          //                                                         Icons.more_horiz,
                          //                                                         color:
                          //                                                             Colors.white,
                          //                                                       )),
                          //                                                 ),
                          //                                               )
                          //                                             : Container()
                          //                                       ],
                          //                                     ),
                          //                                   ),
                          //                                 ),
                          //                               )
                          //                             : Container(),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ),

                          //       ////// <<<<< Invite Members Button >>>>> //////

                          //       GestureDetector(
                          //         onTap: () {
                          //           Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     InviteGroupMemberPage()),
                          //           );
                          //         },
                          //         child: Container(
                          //             padding: EdgeInsets.only(
                          //                 left: 10, right: 20, top: 10, bottom: 10),
                          //             //margin: EdgeInsets.only(left: 20, right: 20),
                          //             decoration: BoxDecoration(
                          //                 color: header,
                          //                 borderRadius:
                          //                     BorderRadius.all(Radius.circular(15))),
                          //             child: Row(
                          //               children: <Widget>[
                          //                 Container(
                          //                   child: Icon(Icons.add,
                          //                       color: Colors.white, size: 17),
                          //                 ),
                          //                 Container(
                          //                   margin: EdgeInsets.only(top: 3),
                          //                   child: Text(
                          //                     "Invite",
                          //                     style: TextStyle(
                          //                       color: Colors.white,
                          //                       fontSize: 17,
                          //                       fontFamily: 'BebasNeue',
                          //                     ),
                          //                     textAlign: TextAlign.center,
                          //                   ),
                          //                 ),
                          //               ],
                          //             )),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          ////// <<<<< Status/Photo post >>>>> //////
                          Container(
                            margin: EdgeInsets.only(top: 0),
                            padding: EdgeInsets.only(top: 0, bottom: 0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0)),
                            ),
                            child: Row(
                              children: <Widget>[
                                ////// <<<<< Profile >>>>> //////
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyProfilePage(userData)),
                                    );
                                  },
                                  child: Container(
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: 15, top: 0),
                                          height: 45,
                                          width: 45,
                                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                          padding: EdgeInsets.all(0.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                              imageUrl: "$pic",
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child: Text(
                                                          "Please Wait...")),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image.asset(
                                                      "assets/images/user.png",
                                                      fit: BoxFit.cover),
                                            ),
                                          ),
                                          decoration: new BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 45),
                                          padding: EdgeInsets.all(1.0),
                                          child: CircleAvatar(
                                            radius: 5.0,
                                            backgroundColor: Colors.greenAccent,
                                          ),
                                          decoration: new BoxDecoration(
                                            color: Colors.greenAccent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                ////// <<<<< Status/Photo field >>>>> //////
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateGroupPost(
                                                      userData,
                                                      groupDetails[
                                                          'comData'])));
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(bottom: 10, top: 4),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        //mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              margin: EdgeInsets.only(
                                                  left: 10, right: 10, top: 5),
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  border: Border.all(
                                                      color: Colors.grey[300],
                                                      width: 0.5),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(25))),
                                              child: TextField(
                                                enabled: false,
                                                //controller: phoneController,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: 'Oswald',
                                                ),
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Share your ideas to the world",
                                                  hintStyle: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 15,
                                                      fontFamily: 'Oswald',
                                                      fontWeight:
                                                          FontWeight.w300),
                                                  //labelStyle: TextStyle(color: Colors.white70),
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          10.0, 1, 20.0, 1),
                                                  border: InputBorder.none,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                ////// <<<<< Photo post >>>>> //////
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CreateGroupPost(
                                              userData,
                                              groupDetails['comData'])),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: back,
                                        border: Border.all(
                                            color: Colors.grey[300],
                                            width: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    margin: EdgeInsets.only(right: 15),
                                    padding: EdgeInsets.all(11),
                                    child: Icon(
                                      Icons.photo,
                                      color: header,
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ///////////// <<<<< END >>>>> ////////////

                          ////// <<<<< Divider 1 >>>>> //////
                          Container(
                              width: 50,
                              margin: EdgeInsets.only(
                                  top: 5, left: 25, right: 25, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  color: header,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 1.0,
                                      color: header,
                                      //offset: Offset(6.0, 7.0),
                                    ),
                                  ],
                                  border:
                                      Border.all(width: 0.5, color: header))),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 15, left: 20),
                            child: Text(
                              "About",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.normal),
                            )),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              margin: EdgeInsets.only(
                                  top: 10, left: 20, bottom: 10),
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
                        secondAbout == ""
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: new Text(firstAbout,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 13,
                                        fontFamily: "Oswald",
                                        fontWeight: FontWeight.w300)),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: new Text(
                                    view == false
                                        ? firstHalf + "..."
                                        : firstHalf + secondHalf,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 13,
                                        fontFamily: "Oswald",
                                        fontWeight: FontWeight.w300)),
                              ),
                        secondAbout == ""
                            ? Container()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(left: 20, top: 5),
                                child: new Text(
                                    view == false ? "Read more" : "",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: header,
                                        fontSize: 13,
                                        fontFamily: "Oswald",
                                        fontWeight: FontWeight.w400)),
                              ),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin:
                                EdgeInsets.only(top: 25, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Community DOS",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.normal),
                                ),
                                !doDontsSee
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isDos == false) {
                                              isDos = true;
                                            } else {
                                              isDos = false;
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              right: 5, left: 5, bottom: 5),
                                          child: Text(
                                              isDos ? "Cancel" : "+ Add",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: header,
                                                  fontSize: 13,
                                                  fontFamily: "Oswald",
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ),
                              ],
                            )),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 30,
                                margin: EdgeInsets.only(
                                    top: 10, left: 20, bottom: 10),
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
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 20, top: 5, right: 15),
                          child: Column(
                            children: List.generate(dosList.length, (index) {
                              return !isAdmin
                                  ? Container(
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            Icons.done,
                                            size: 16,
                                            color: header,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                  "${dosList[index]['rule']}",
                                                  style: TextStyle(
                                                      color: priceTag,
                                                      fontSize: 13,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Slidable(
                                      actionPane: SlidableDrawerActionPane(),
                                      //delegate: new SlidableDrawerDelegate(),
                                      actionExtentRatio: 0.20,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.done,
                                              size: 16,
                                              color: header,
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                    "${dosList[index]['rule']}",
                                                    style: TextStyle(
                                                        color: priceTag,
                                                        fontSize: 13,
                                                        fontFamily: "Oswald",
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      secondaryActions: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 0, bottom: 0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.5),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                topLeft: Radius.circular(0.0)),
                                          ),
                                          child: new IconSlideAction(
                                            //caption: 'Edit',
                                            color: Colors.transparent,
                                            icon: Icons.edit,
                                            onTap: () {
                                              setState(() {
                                                isDos = true;
                                                dosEdit = true;
                                                editDOSList = dosList[index];
                                                dosController.text =
                                                    dosList[index]['rule'];
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 0, bottom: 0),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                topLeft: Radius.circular(0.0)),
                                          ),
                                          child: new IconSlideAction(
                                            //caption: 'Delete',
                                            color: Colors.transparent,
                                            icon: Icons.delete,
                                            onTap: () {
                                              _deleteDosDialog(
                                                  dosList[index]['id'], index);
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                            }),
                          ),
                        ),
                        !isDos
                            ? Container()
                            : Container(
                                //height: 100,
                                padding: EdgeInsets.all(0),
                                margin: EdgeInsets.only(
                                    top: 5, left: 20, bottom: 5, right: 20),
                                decoration: BoxDecoration(
                                    // borderRadius:
                                    //     BorderRadius.all(Radius.circular(100.0)),
                                    borderRadius: new BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                        bottomRight: Radius.circular(5.0)),
                                    color: Colors.grey[100],
                                    border: Border.all(
                                        width: 0.5,
                                        color: Colors.black.withOpacity(0.2))),
                                child: Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(
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
                                              controller: dosController,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: 'Oswald',
                                              ),
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Type community dos here...",
                                                hintStyle: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w300),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        10.0, 5.0, 20.0, 5.0),
                                                border: InputBorder.none,
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  dos = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        addDOS();
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(right: 5),
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                              //color: back,
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Icon(
                                            dosEdit ? Icons.edit : Icons.add,
                                            color: header1,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin:
                                EdgeInsets.only(top: 25, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Community DONT'S",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.normal),
                                ),
                                !doDontsSee
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isDonts == false) {
                                              isDonts = true;
                                            } else {
                                              isDonts = false;
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              right: 5, left: 5, bottom: 5),
                                          child: Text(
                                              isDonts ? "Cancel" : "+ Add",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: header,
                                                  fontSize: 13,
                                                  fontFamily: "Oswald",
                                                  fontWeight: FontWeight.w400)),
                                        ),
                                      ),
                              ],
                            )),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 30,
                                margin: EdgeInsets.only(
                                    top: 10, left: 20, bottom: 10),
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
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 20, top: 5, right: 15),
                          child: Column(
                            children: List.generate(dontsList.length, (index) {
                              return !isAdmin
                                  ? Container(
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.redAccent,
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 5),
                                              child: Text(
                                                  "${dontsList[index]['rule']}",
                                                  style: TextStyle(
                                                      color: priceTag,
                                                      fontSize: 13,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Slidable(
                                      actionPane: SlidableDrawerActionPane(),
                                      //delegate: new SlidableDrawerDelegate(),
                                      actionExtentRatio: 0.20,
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.redAccent,
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(
                                                    "${dontsList[index]['rule']}",
                                                    style: TextStyle(
                                                        color: priceTag,
                                                        fontSize: 13,
                                                        fontFamily: "Oswald",
                                                        fontWeight:
                                                            FontWeight.w400)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      secondaryActions: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 0, bottom: 0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.5),
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                topLeft: Radius.circular(0.0)),
                                          ),
                                          child: new IconSlideAction(
                                            //caption: 'Edit',
                                            color: Colors.transparent,
                                            icon: Icons.edit,
                                            onTap: () {
                                              setState(() {
                                                isDonts = true;
                                                dontsEdit = true;
                                                editDONTSList =
                                                    dontsList[index];
                                                dontsController.text =
                                                    dontsList[index]['rule'];
                                              });
                                            },
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 0, bottom: 0),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(0.0),
                                                topLeft: Radius.circular(0.0)),
                                          ),
                                          child: new IconSlideAction(
                                            //caption: 'Delete',
                                            color: Colors.transparent,
                                            icon: Icons.delete,
                                            onTap: () {
                                              _deleteDontsDialog(
                                                  dontsList[index]['id'],
                                                  index);
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                            }),
                          ),
                        ),
                        !isDonts
                            ? Container()
                            : Container(
                                //height: 100,
                                padding: EdgeInsets.all(0),
                                margin: EdgeInsets.only(
                                    top: 5, left: 20, bottom: 5, right: 20),
                                decoration: BoxDecoration(
                                    // borderRadius:
                                    //     BorderRadius.all(Radius.circular(100.0)),
                                    borderRadius: new BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0),
                                        bottomLeft: Radius.circular(5.0),
                                        bottomRight: Radius.circular(5.0)),
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
                                            controller: dontsController,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Oswald',
                                            ),
                                            decoration: InputDecoration(
                                              hintText:
                                                  "Type community dont's here...",
                                              hintStyle: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w300),
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      10.0, 10.0, 20.0, 10.0),
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                donts = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        addDONTS();
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(right: 5),
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                              //color: back,
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          child: Icon(
                                            dontsEdit ? Icons.edit : Icons.add,
                                            color: header1,
                                          )),
                                    )
                                  ],
                                ),
                              ),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 25, left: 20),
                            child: Text(
                              "Discussions",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.normal),
                            )),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              margin: EdgeInsets.only(
                                  top: 10, left: 20, bottom: 10),
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
                        // Container(
                        //     alignment: Alignment.centerLeft,
                        //     margin:
                        //         EdgeInsets.only(top: 0, left: 20, bottom: 0),
                        //     child: Text(
                        //       postList.res.length == 0 ? "No posts" : "",
                        //       textAlign: TextAlign.start,
                        //       style: TextStyle(
                        //           color: Colors.black54,
                        //           fontSize: 13,
                        //           fontFamily: 'Oswald',
                        //           fontWeight: FontWeight.w400),
                        //     )),
                      ],
                    ),
                  ),
                  groupPostList == null
                      ? SliverToBoxAdapter(
                          child: Center(child: CircularProgressIndicator()))
                      : groupPostList.communityPosts.length == 0
                          ? SliverToBoxAdapter(
                              child: Container(
                                margin: EdgeInsets.only(left: 20, bottom: 20),
                                child: Text(
                                  "No posts!",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                              des =
                                  "${groupPostList.communityPosts[index].status}";
                              if (des.length > 150) {
                                firstHalf = des.substring(0, 150);
                                secondHalf = des.substring(150, des.length);
                              } else {
                                firstHalf = des;
                                secondHalf = "";
                              }
                              //_current = 0;
                              imagePost = [];

                              String imgs =
                                  groupPostList.communityPosts[index].images;
                              final images = json.decode(imgs);
                              var postImages = images;
                              print("postImages.length");
                              print(postImages.length);

                              for (int i = 0; i < postImages.length; i++) {
                                if (postImages[i]['file']
                                    .contains("127.0.0.1")) {
                                  postImages[i]['file'] = postImages[i]['file']
                                      .replaceAll("127.0.0.1", "10.0.2.2");
                                }
                                imagePost.add(postImages[i]['file']);
                              }

                              List day = [];

                              for (int i = 0;
                                  i < groupPostList.communityPosts.length;
                                  i++) {
                                DateTime date1 = DateTime.parse(
                                    "${groupPostList.communityPosts[i].created_at}");

                                print("date1");
                                print(date1);

                                String days = DateFormat.yMMMd().format(date1);
                                day.add(days);
                                print(day);
                              }

                              return isPostDelete.contains(
                                      "${groupPostList.communityPosts[index].id}")
                                  ? Container()
                                  : Container(
                                      padding:
                                          EdgeInsets.only(top: 5, bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        //border: Border.all(width: 0.8, color: Colors.grey[300]),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 5.0,
                                            color: Colors.grey[300],
                                            //offset: Offset(3.0, 4.0),
                                          ),
                                        ],
                                      ),
                                      margin: EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 20,
                                          right: 20),
                                      child: Column(children: <Widget>[
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              userData['id'] ==
                                                      groupPostList
                                                          .communityPosts[index]
                                                          .user
                                                          .id
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _statusModalBottomSheet(
                                                              context,
                                                              index,
                                                              userData,
                                                              groupPostList
                                                                      .communityPosts[
                                                                  index],
                                                              groupDetails[
                                                                  'comData']);
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
                                                            color:
                                                                Colors.black54,
                                                          )),
                                                    )
                                                  : Container(
                                                      margin: EdgeInsets.only(
                                                          top: 10),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          //color: Colors.yellow,
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 10),
                                          padding: EdgeInsets.only(right: 10),
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
                                                padding: EdgeInsets.all(0.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          "${groupPostList.communityPosts[index].user.profilePic}",
                                                      placeholder: (context,
                                                              url) =>
                                                          CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                              "assets/images/user.png",
                                                              fit:
                                                                  BoxFit.cover),
                                                      fit: BoxFit.cover),
                                                ),
                                                decoration: new BoxDecoration(
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
                                                          children: <Widget>[
                                                            Container(
                                                              child: Text(
                                                                "${groupPostList.communityPosts[index].user.firstName} ${groupPostList.communityPosts[index].user.lastName}",
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Oswald',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      ////// <<<<< Name & Interest end >>>>> //////

                                                      ////// <<<<< time job start >>>>> //////
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 3),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              child: Text(
                                                                "${day[index]}",
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
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .album,
                                                                        size:
                                                                            10,
                                                                        color: Colors
                                                                            .black54,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          "  ${groupPostList.communityPosts[index].user.jobTitle}",
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              color: header,
                                                                              fontFamily: 'Oswald',
                                                                              fontWeight: FontWeight.w400),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
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
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10, right: 15),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (groupPostList
                                                            .communityPosts[
                                                                index]
                                                            .isRead ==
                                                        null ||
                                                    groupPostList
                                                            .communityPosts[
                                                                index]
                                                            .isRead ==
                                                        "0") {
                                                  groupPostList
                                                      .communityPosts[index]
                                                      .isRead = "1";
                                                } else {
                                                  groupPostList
                                                      .communityPosts[index]
                                                      .isRead = "0";
                                                }
                                              });
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  child: des == ""
                                                      ? Container()
                                                      : secondHalf == ""
                                                          ? Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 20),
                                                              child: new Text(
                                                                  firstHalf,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .justify,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.7),
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          "Oswald",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300)),
                                                            )
                                                          : Container(
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 20),
                                                              child: new Text(
                                                                  groupPostList.communityPosts[index].isRead ==
                                                                              "0" ||
                                                                          groupPostList.communityPosts[index].isRead ==
                                                                              null
                                                                      ? firstHalf +
                                                                          "..."
                                                                      : firstHalf +
                                                                          secondHalf,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.7),
                                                                      fontSize:
                                                                          13,
                                                                      fontFamily:
                                                                          "Oswald",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300)),
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
                                                            left: 20, top: 5),
                                                        child: new Text(
                                                            groupPostList
                                                                            .communityPosts[
                                                                                index]
                                                                            .isRead ==
                                                                        "0" ||
                                                                    groupPostList
                                                                            .communityPosts[
                                                                                index]
                                                                            .isRead ==
                                                                        null
                                                                ? "Read more"
                                                                : "",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: header,
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    "Oswald",
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                        postImages.length == 0
                                            ? Container()
                                            : postImages.length == 1
                                                ? Container(
                                                    //color: Colors.red,
                                                    height: 200,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    margin: EdgeInsets.only(
                                                        top: 15,
                                                        left: 20,
                                                        right: 20),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      // image: DecorationImage(
                                                      //     image: //AssetImage("assets/images/friend7.jpg"),
                                                      //         NetworkImage(
                                                      //             "${postImages[0]['file']}"),
                                                      //     fit: BoxFit
                                                      //         .contain)),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "${postImages[0]['file']}",
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child: Text(
                                                                  "Please Wait...")),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        "assets/images/placeholder_cover.jpg",
                                                        height: 40,
                                                      ),

                                                      // NetworkImage(
                                                      //     widget.friend[index].profilePic
                                                    ))
                                                : Stack(
                                                    children: <Widget>[
                                                      Column(
                                                        children: <Widget>[
                                                          Container(
                                                              height: 200,
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        top:
                                                                            10),
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                child:
                                                                    CarouselSlider(
                                                                  height: 200.0,
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
                                                                      Duration(
                                                                          seconds:
                                                                              2),
                                                                  autoPlayAnimationDuration:
                                                                      Duration(
                                                                          milliseconds:
                                                                              2000),
                                                                  pauseAutoPlayOnTouch:
                                                                      Duration(
                                                                          seconds:
                                                                              10),
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  onPageChanged:
                                                                      (index) {
                                                                    setState(
                                                                        () {
                                                                      _current =
                                                                          index;
                                                                    });
                                                                  },
                                                                  items: imagePost
                                                                      .map(
                                                                          (imgUrl) {
                                                                    return Builder(
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return CachedNetworkImage(
                                                                          imageUrl:
                                                                              imgUrl,
                                                                          placeholder: (context, url) =>
                                                                              Center(child: Text("Please Wait...")),
                                                                          errorWidget: (context, url, error) =>
                                                                              Image.asset(
                                                                            "assets/images/placeholder_cover.jpg",
                                                                            height:
                                                                                40,
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
                                                        margin: EdgeInsets.only(
                                                            top: 15, right: 20),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(5),
                                                              color: Colors
                                                                  .grey[500],
                                                              child: Text(
                                                                "${imagePost.length} Images",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        "Oswald"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
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
                                          margin:
                                              EdgeInsets.only(left: 20, top: 5),
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
                                                        if (groupPostList
                                                                .communityPosts[
                                                                    index]
                                                                .like !=
                                                            null) {
                                                          setState(() {
                                                            groupPostList
                                                                .communityPosts[
                                                                    index]
                                                                .like = null;
                                                            groupPostList
                                                                .communityPosts[
                                                                    index]
                                                                .meta
                                                                .totalLikesCount = groupPostList
                                                                    .communityPosts[
                                                                        index]
                                                                    .meta
                                                                    .totalLikesCount -
                                                                1;
                                                          });
                                                          likeButtonPressed(
                                                              index, -1);
                                                        } else {
                                                          setState(() {
                                                            groupPostList
                                                                .communityPosts[
                                                                    index]
                                                                .like = 1;
                                                            groupPostList
                                                                .communityPosts[
                                                                    index]
                                                                .meta
                                                                .totalLikesCount = groupPostList
                                                                    .communityPosts[
                                                                        index]
                                                                    .meta
                                                                    .totalLikesCount +
                                                                1;
                                                          });
                                                          likeButtonPressed(
                                                              index, 1);
                                                        }
                                                      },
                                                      child: Container(
                                                        child: Icon(
                                                          groupPostList
                                                                      .communityPosts[
                                                                          index]
                                                                      .like !=
                                                                  null
                                                              ? Icons.favorite
                                                              : Icons
                                                                  .favorite_border,
                                                          size: 20,
                                                          color: groupPostList
                                                                      .communityPosts[
                                                                          index]
                                                                      .like !=
                                                                  null
                                                              ? Colors.redAccent
                                                              : Colors.black54,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 3),
                                                    child: Text(
                                                        "${groupPostList.communityPosts[index].meta.totalLikesCount}",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Oswald',
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            color:
                                                                Colors.black54,
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
                                                            GroupCommentPage(
                                                                groupPostList
                                                                    .communityPosts[
                                                                        index]
                                                                    .id,
                                                                index)),
                                                  );
                                                },
                                                child: Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 15),
                                                        padding:
                                                            EdgeInsets.all(3.0),
                                                        child: Icon(
                                                          Icons
                                                              .chat_bubble_outline,
                                                          size: 20,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 3),
                                                        child: Text(
                                                            groupComCount[index]
                                                                        [
                                                                        'count'] ==
                                                                    null
                                                                ? ""
                                                                : "${groupComCount[index]['count']}",
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
                                                ),
                                              ),
                                              // Row(
                                              //   children: <Widget>[
                                              //     Container(
                                              //       margin: EdgeInsets.only(
                                              //           left: 15),
                                              //       padding:
                                              //           EdgeInsets.all(3.0),
                                              //       child: Icon(
                                              //         Icons.people_outline,
                                              //         size: 20,
                                              //         color: Colors.black54,
                                              //       ),
                                              //     ),
                                              //     Container(
                                              //       margin: EdgeInsets.only(
                                              //           left: 3),
                                              //       child: Text(
                                              //           groupPostList
                                              //                       .communityPosts[
                                              //                           index]
                                              //                       .meta
                                              //                       .totalFollowCount ==
                                              //                   null
                                              //               ? ""
                                              //               : "${groupPostList.communityPosts[index].meta.totalFollowCount}",
                                              //           style: TextStyle(
                                              //               fontFamily:
                                              //                   'Oswald',
                                              //               fontWeight:
                                              //                   FontWeight.w300,
                                              //               color:
                                              //                   Colors.black54,
                                              //               fontSize: 12)),
                                              //     )
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    );
                            },
                                  childCount:
                                      groupPostList.communityPosts.length)),
                ],
              ));
  }

  void likeButtonPressed(index, type) async {
    setState(() {
      //_isLoading = true;
    });
    print("object");

    var data = {
      'id': '${groupPostList.communityPosts[index].id}',
      'type': type,
    };

    print(data);
    print("354353445345345");

    var res = await CallApi().postData1(data, 'group/add/like');
    var body = json.decode(res.body);

    print(body);

    if (res.statusCode == 200) {
      print("Done");
    }

    setState(() {
      //_isLoading = false;
    });
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  void _statusModalBottomSheet(
      context, int index, var userData, var feeds, var groupList) {
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupStatusEdit(
                                feeds, userData, index, groupList)))
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
                    _showDeleteDialog(feeds.id, userData)
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<Null> _showDeleteDialog(int id, userData) async {
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
                                deleteStatus(id, userData);
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

  Future addDOS() async {
    if (dosEdit) {
      var data = {
        'rule': dos,
        'id': editDOSList['id'],
      };
      print(data);

      var res = await CallApi().postData1(data, 'community/edit-dos');
      print("res.body");
      print(res.body);
      //var body = json.decode(res.body);

      if (res.statusCode == 200) {
        setState(() {
          dosController.text = "";
          editDOSList['rule'] = dos;
          isDos = false;
          dosEdit = false;
        });
      } else {
        _showMsg("Something went wrong!");
      }
    } else {
      var data = {
        'rule': dos,
        'community_id': groupDetails['comData']['id'],
        'type': 1
      };
      print(data);

      var res = await CallApi().postData1(data, 'community/add/dos_dont');
      print("res.body");
      print(res.body);
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        setState(() {
          //dosList.add("$id");
          dosController.text = "";
          dosList.add({
            'id': body['id'],
            'rule': body['rule'],
            'type': body['type'],
          });
        });
      } else {
        _showMsg("Something went wrong!");
      }
    }

    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => FeedPage()));
  }

  Future addDONTS() async {
    if (dontsEdit) {
      var data = {
        'rule': donts,
        'id': editDONTSList['id'],
      };
      print(data);

      var res = await CallApi().postData1(data, 'community/edit-dos');
      print("res.body");
      print(res.body);
      //var body = json.decode(res.body);

      if (res.statusCode == 200) {
        setState(() {
          dontsController.text = "";
          editDONTSList['rule'] = donts;
          isDonts = false;
          dontsEdit = false;
        });
      } else {
        _showMsg("Something went wrong!");
      }
    } else {
      var data = {
        'rule': donts,
        'community_id': groupDetails['comData']['id'],
        'type': 0
      };
      print(data);

      var res = await CallApi().postData1(data, 'community/add/dos_dont');
      print("res.body");
      print(res.body);
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        setState(() {
          dontsController.text = "";
          dontsList.add({
            'id': body['id'],
            'rule': body['rule'],
            'type': body['type'],
          });
        });
      } else {
        _showMsg("Something went wrong!");
      }
    }

    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => FeedPage()));
  }

  Future deleteStatus(int id, userData) async {
    var data = {'id': id, 'user_id': userData['id']};

    print(data);

    var res = await CallApi().postData1(data, 'post/com_post_delete');
    print("res.body");
    print(res.body);
    //var body = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        isPostDelete.add("$id");
      });
    } else {
      _showMsg("Something went wrong!");
    }
    print(isDelete);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (_) => FeedPage()));
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
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void followUnfollow(int number) async {
    //await Future.delayed(Duration(seconds: 3));
    var data = {
      'type': number == 1 ? "follow" : "unfollow",
      'id': groupDetails['comData']['id'],
      'name': groupDetails['comData']['name'],
      'slug': groupDetails['comData']['slug'],
    };

    print(data);
    var postresponse = await CallApi().postData1(data, 'com/follow');
    print(postresponse);
    var postcontent = postresponse.body;
    print("postcontent");
    print(postcontent);

    // setState(() {
    //   groupList = posts;
    //   loading = false;
    // });
  }

  Future<Null> _deleteDosDialog(id, index) async {
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
                          "Are you sure to remove this DOS?",
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
                                  deleteDOS(id, index);
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

  void deleteDOS(id, index) async {
    //await Future.delayed(Duration(seconds: 3));
    var data = {
      'id': id,
    };

    print(data);
    var postresponse = await CallApi().postData1(data, 'community/delete-dos');
    print(postresponse);
    var postcontent = postresponse.body;
    print("postcontent");
    print(postcontent);

    if (postresponse.statusCode == 200) {
      Navigator.pop(context);
      setState(() {
        dosList.removeAt(index);
      });
    }

    // setState(() {
    //   groupList = posts;
    //   loading = false;
    // });
  }

  Future<Null> _deleteDontsDialog(id, index) async {
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
                          "Are you sure to remove this DONT'S?",
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
                                  deleteDONTS(id, index);
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

  void deleteDONTS(id, index) async {
    //await Future.delayed(Duration(seconds: 3));
    var data = {
      'id': id,
    };

    print(data);
    var postresponse = await CallApi().postData1(data, 'community/delete-dos');
    print(postresponse);
    var postcontent = postresponse.body;
    print("postcontent");
    print(postcontent);

    if (postresponse.statusCode == 200) {
      Navigator.pop(context);
      setState(() {
        dontsList.removeAt(index);
      });
    }

    // setState(() {
    //   groupList = posts;
    //   loading = false;
    // });
  }
}
