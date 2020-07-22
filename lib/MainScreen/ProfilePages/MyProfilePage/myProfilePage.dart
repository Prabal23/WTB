import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/BusinessModel/BusinessModel.dart';
import 'package:chatapp_new/JSON_Model/CategoryModel/categoryModel.dart';
import 'package:chatapp_new/JSON_Model/NewsFeedModel/NewsFeedModel.dart';
import 'package:chatapp_new/JSON_Model/POST_Model/post_model.dart';
import 'package:chatapp_new/JSON_Model/ProfilePostModel/ProfilePostModel.dart';
import 'package:chatapp_new/JSON_Model/User_Model/user_Model.dart';
import 'package:chatapp_new/MainScreen/AllFriendsPage/allFriendsPage.dart';
import 'package:chatapp_new/MainScreen/BusinessInfoPage/businessInfoPage.dart';
import 'package:chatapp_new/MainScreen/CommentPage/commentPage.dart';
import 'package:chatapp_new/MainScreen/CreatePost/createPost.dart';
import 'package:chatapp_new/MainScreen/EditPostPage/editPostPage.dart';
import 'package:chatapp_new/MainScreen/ProfileCommentPage/ProfileCommentPage.dart';
import 'package:chatapp_new/MainScreen/ProfileEditBasicPage/profileEditBasicPage.dart';
import 'package:chatapp_new/MainScreen/ProfileEditInterestPage/profileEditInterestPage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/FriendsProfilePage/friendsProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../../../main.dart';

List<String> isDelete = [];
List profileComCount = [];

class MyProfilePage extends StatefulWidget {
  final userData;
  MyProfilePage(this.userData);
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

enum PhotoCrop {
  free,
  picked,
  cropped,
}

class _MyProfilePageState extends State<MyProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  String theme = "",
      proPic = "",
      statusPic = "",
      image = "",
      fName = "",
      lName = "",
      verified = "",
      businessInfoProvided = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;
  bool isLoading = true;
  bool _isVerified = false;
  bool _isPending = false;
  bool _isBusiness = false;
  bool _isEmailChanged = false;
  bool _isResetCodeSent = false;
  bool _isChangedEmailSent = false;
  bool businessAllSee = false;
  bool isSubmit = false;
  PhotoCrop state;
  int id = 0;
  var conList, postList, catList;
  File imageFile;
  List<String> selectedCategory = [];
  List<String> allPic = [];
  List<String> isDeleteStat = [];
  List images = [];
  List imagesBase64 = [];
  List<Widget> list = [];
  List imagePost = [];
  int _current = 0, shopProvided = 0;
  var img;
  var selectedCat;
  var businessInfo;
  var userData;
  String des = "", sharePost = "", status = "Public";
  String firstHalf;
  String secondHalf;
  String daysAgo;
  bool flag = true;
  bool isImageLoading = false;
  TextEditingController emailResetCodeController = new TextEditingController();
  TextEditingController emailResetController = new TextEditingController();

  @override
  void initState() {
    setState(() {
      profileComCount.clear();
    });
    showUser();
    loadConnection();
    getBusinessInfo();
    _getUserInterest();
    state = PhotoCrop.free;
    // if (widget.userData['profilePic'].contains("localhost")) {
    //   widget.userData['profilePic'] = widget.userData['profilePic']
    //       .replaceAll("localhost", "http://10.0.2.2");
    // }
    super.initState();
  }

  Future showUser() async {
    setState(() {
      loading = true;
    });
    //await Future.delayed(Duration(seconds: 3));
    var postresponse = await CallApi().getData2('initData');
    var postcontent = postresponse.body;
    final body = json.decode(postcontent);
    print(body['user']);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('user', json.encode(body['user']));

    seeUser();
  }

  seeUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
    });
    image = user['profilePic'];
    fName = user['firstName'];
    lName = user['lastName'];
    shopProvided = widget.userData['isShopCreated'];
    verified = user['isUserVerified'];
    businessInfoProvided = user['isBusinessInfoProvided'];
    loading = false;

    // if (businessInfoProvided == "No") {
    //   setState(() {
    //     _isBusiness = false;
    //   });
    // } else {
    //   setState(() {
    //     _isBusiness = true;
    //   });
    //   if (verified == "No") {
    //     setState(() {
    //       _isPending = true;
    //       _isVerified = false;
    //     });
    //   } else if (verified == "Yes") {
    //     setState(() {
    //       _isPending = false;
    //       _isVerified = true;
    //     });
    //   } else {
    //     setState(() {
    //       _isPending = false;
    //       _isVerified = false;
    //     });
    //   }
    // }
  }

  Future verifyUser() async {
    setState(() {
      loading = true;
    });

    var data = {"type": "profile"};
    //await Future.delayed(Duration(seconds: 3));
    var verifyresponse = await CallApi().postData1(data, 'seller/verify');
    var verifycontent = verifyresponse.body;
    final body = json.decode(verifycontent);

    print(body);

    if (verifyresponse.statusCode == 200) {
      loadConnection();
    }

    setState(() {
      showUser();
      //loading = false;
    });
  }

  Future getBusinessInfo() async {
    //await Future.delayed(Duration(seconds: 3));

    var response = await CallApi()
        .getData('profile/${widget.userData['userName']}?tab=about');
    var content = response.body;

    if (content != null) {
      print(content);
      final collection = json.decode(content);
      var data = BusinessModel.fromJson(collection);

      setState(() {
        businessInfo = data;
        if (businessInfo.res != null) {
          if (businessInfo.res.files.length != 0) {
            for (int i = 0; i < businessInfo.res.files.length; i++) {
              images
                  .add({"portfolio": "${businessInfo.res.files[i].portfolio}"});
            }

            //images = allImages;
            img = images.toList();
            isLoading = false;
          }
        }
      });
    }

    //print(contList);
  }

  Future<Null> _pickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        state = PhotoCrop.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      // toolbarTitle: 'Cropper',
      // toolbarColor: Colors.black.withOpacity(0.5),
      // toolbarWidgetColor: Colors.white,
    );
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        // state = PhotoCrop.free;
        state = PhotoCrop.cropped;
      });
      uploadImage();
    }
  }

  Future uploadImage() async {
    setState(() {
      isImageLoading = true;
    });
    List<int> imageBytes = imageFile.readAsBytesSync();
    String logo = base64.encode(imageBytes);
    logo = 'data:image/png;base64,' + logo;

    var data = {
      'id': widget.userData['id'],
      'type': "profilePicture",
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
        isImageLoading = false;
      });
      _showMsg("Profile picture uploaded successfully!");
      widget.userData['profilePic'] = body1['file'];
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', json.encode(widget.userData));
    }
  }

  Future loadConnection() async {
    //await Future.delayed(Duration(seconds: 3));

    var response = await CallApi()
        .getData('profile/${widget.userData['userName']}?tab=connection');
    var content = response.body;
    final collection = json.decode(content);
    var data = Connection.fromJson(collection);

    setState(() {
      conList = data;
      if (businessInfoProvided == "No") {
        setState(() {
          _isBusiness = false;
        });
      } else {
        setState(() {
          _isBusiness = true;
        });
        if (conList.user.verified == null) {
          setState(() {
            _isPending = false;
            _isVerified = false;
          });
        } else if (conList.user.verified.status == "Pending") {
          setState(() {
            _isPending = true;
            _isVerified = false;
          });
        } else if (conList.user.verified.status == "Approved") {
          setState(() {
            _isPending = false;
            _isVerified = true;
          });
        }
      }
    });

    loadPosts();
  }

  Future loadPosts() async {
    //await Future.delayed(Duration(seconds: 3));

    var postresponse = await CallApi()
        .getData('profile/${widget.userData['userName']}?tab=post');
    var postcontent = postresponse.body;
    final posts = json.decode(postcontent);
    var postdata = FeedRes.fromJson(posts);

    setState(() {
      postList = postdata;
      allPic = [];
      for (int i = 0; i < postList.res.length; i++) {
        profileComCount.add({'count': postList.res[i].meta.totalCommentsCount});
      }
      loading = false;
    });

    print("allPic");
    print(allPic);
  }

  void _getUserInterest() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var tagJson = localStorage.getStringList('tags');
    List<String> tags = tagJson;
    for (int i = 0; i < tags.length; i++) {
      selectedCategory.add("${tags[i]}");
      selectedCat = selectedCategory.toList();
    }

    //print("${userData['shop_id']}");
  }

  void _statusModalBottomSheet(context, int index, var userData, var postList) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                // Text('React to this post',
                //       style: TextStyle(fontWeight: FontWeight.normal)),
                postList.feedType == "Share"
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
                                  builder: (context) => EditPost(
                                      postList, widget.userData, index)))
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
                    _showDeleteDialog(postList.res[index].id)
                  },
                ),
              ],
            ),
          );
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
    var body = json.decode(res.body);

    if (body == 1) {
      setState(() {
        isDeleteStat.add("$id");
      });
    } else {
      _showMsg("Something went wrong!");
    }
    print(isDeleteStat);
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

  Future<Null> _showCompleteDialog() async {
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
                          "Please provide your business information at first",
                          textAlign: TextAlign.center,
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
                                    left: 0, right: 0, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: header,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
                          "Profile",
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
        body: conList == null || postList == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                        child: SingleChildScrollView(
                      child: Container(
                          child: Column(
                        children: <Widget>[
                          SafeArea(
                            child: Stack(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    _pickImage();
                                  },
                                  child: Container(
                                    child: Center(
                                      child: Stack(
                                        children: <Widget>[
                                          state == PhotoCrop.free
                                              ? Container(
                                                  margin: EdgeInsets.only(
                                                      right: 0, top: 15),
                                                  height: 140,
                                                  width: 140,
                                                  //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                  padding: EdgeInsets.all(5.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          "${widget.userData['profilePic']}",
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child: Text(
                                                                  "Please Wait...")),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                              "assets/images/user.png",
                                                              fit:
                                                                  BoxFit.cover),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  // CircleAvatar(
                                                  //   radius: 65.0,
                                                  //   backgroundColor:
                                                  //       Colors.transparent,
                                                  //   backgroundImage: widget
                                                  //               .userData[
                                                  //                   'profilePic']
                                                  //               .contains(
                                                  //                   "Female.jpeg") ||
                                                  //           widget.userData[
                                                  //                   'profilePic']
                                                  //               .contains(
                                                  //                   "Male.jpeg")
                                                  //       ? AssetImage(
                                                  //           "assets/images/user.png")
                                                  //       : NetworkImage(
                                                  //           "${widget.userData['profilePic']}"),
                                                  // ),
                                                  decoration: new BoxDecoration(
                                                    // color: Colors.grey[
                                                    //     300], // border color
                                                    //shape: BoxShape.circle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                )
                                              : (state == PhotoCrop.picked ||
                                                      state ==
                                                          PhotoCrop.cropped)
                                                  ? Container(
                                                      margin: EdgeInsets.only(
                                                          right: 0, top: 15),
                                                      //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: CircleAvatar(
                                                          radius: 65.0,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          backgroundImage:
                                                              FileImage(
                                                                  imageFile)),
                                                      decoration:
                                                          new BoxDecoration(
                                                        color: Colors.grey[
                                                            300], // border color
                                                        shape: BoxShape.circle,
                                                      ),
                                                    )
                                                  : Container(
                                                      margin: EdgeInsets.only(
                                                          right: 0, top: 15),
                                                      //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: CircleAvatar(
                                                        radius: 65.0,
                                                        backgroundColor:
                                                            Colors.white,
                                                        backgroundImage: AssetImage(
                                                            'assets/images/man2.jpg'),
                                                      ),
                                                      decoration:
                                                          new BoxDecoration(
                                                        color: Colors.grey[
                                                            300], // border color
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: isImageLoading
                                                      ? Colors.white
                                                      : header,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.only(
                                                  left: 100, top: 120),
                                              child: isImageLoading
                                                  ? CircularProgressIndicator()
                                                  : Icon(
                                                      Icons.photo_camera,
                                                      color: Colors.white,
                                                      size: 20,
                                                    )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          state == PhotoCrop.picked
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              _cropImage();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  //shape: BoxShape.circle,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: Colors.grey[300]),
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 10,
                                                  right: 10),
                                              margin: EdgeInsets.only(
                                                  right: 5,
                                                  top: 20,
                                                  bottom: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.crop,
                                                      size: 15,
                                                      color: Colors.black87),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      child: Text("Crop",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontFamily:
                                                                  "Oswald"))),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                state = PhotoCrop.cropped;
                                              });
                                              uploadImage();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  //shape: BoxShape.circle,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: header),
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  left: 10,
                                                  right: 10),
                                              margin: EdgeInsets.only(
                                                  left: 5, top: 20, bottom: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(Icons.done,
                                                      size: 15,
                                                      color: Colors.white),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      child: Text("Done",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "Oswald"))),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                          Container(
                              margin:
                                  EdgeInsets.only(top: 10, right: 20, left: 20),
                              child: Text(
                                widget.userData['firstName'] != null &&
                                        widget.userData['lastName'] != null
                                    ? '${widget.userData['firstName']} ' +
                                        '${widget.userData['lastName']}'
                                    : '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Oswald",
                                    color: Colors.black),
                              )),
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                widget.userData['jobTitle'] != null
                                    ? '${widget.userData['jobTitle']}'
                                    : '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Oswald"),
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: SmoothStarRating(
                              allowHalfRating: false,
                              rating: conList.user.avgReview == null
                                  ? 0
                                  : conList.user.avgReview,
                              size: 17,
                              starCount: 5,
                              spacing: 1.0,
                              color: conList.user.avgReview == null
                                  ? Colors.grey
                                  : Colors.yellow[700],
                              //borderColor: Colors.teal[400],
                            ),
                          ),

                          ////// <<<<< Verify Button >>>>> //////
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (_isBusiness == false) {
                                  _showCompleteDialog();
                                } else {
                                  if (_isPending == false &&
                                      _isVerified == false) {
                                    verifyUser();
                                    _isPending = true;
                                    _isVerified = false;
                                  }
                                }
                              });
                            },
                            child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 5, right: 5, top: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                          color: _isVerified == true &&
                                                  _isPending == false
                                              ? header
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.only(right: 3),
                                            child: Text(
                                                _isPending == true &&
                                                        _isVerified == false
                                                    ? "Verification Pending"
                                                    : _isPending == false &&
                                                            _isVerified == false
                                                        ? "Verify"
                                                        : "Verified",
                                                style: TextStyle(
                                                    color: _isVerified ==
                                                                true &&
                                                            _isPending == false
                                                        ? Colors.white
                                                        : Colors.black54,
                                                    fontSize: 12,
                                                    fontFamily: "Oswald")),
                                          ),
                                          Icon(
                                              _isPending == false &&
                                                      _isVerified == true
                                                  ? Icons.verified_user
                                                  : Icons.info,
                                              color: _isPending == false &&
                                                      _isVerified == true
                                                  ? Colors.white
                                                  : Colors.black54,
                                              size: 13)
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 30, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreatePost(
                                                          widget.userData, 2)));
                                          //_showMsg("Coming Soon");
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 0),
                                          height: 50,
                                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                          padding: EdgeInsets.all(10.0),
                                          child: Icon(
                                            Icons.send,
                                            color: Colors.black38,
                                            size: 15,
                                          ),
                                          decoration: new BoxDecoration(
                                            color: Colors
                                                .grey[300], // border color
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Text("Create Post",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontFamily: "Oswald",
                                              fontSize: 13))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileBasisEditPage(
                                                          widget.userData)));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 0),
                                          height: 50,
                                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                          padding: EdgeInsets.all(10.0),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.black38,
                                            size: 15,
                                          ),
                                          decoration: new BoxDecoration(
                                            color: Colors
                                                .grey[300], // border color
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Text("Basic Information",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontFamily: "Oswald",
                                              fontSize: 13))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileInterestEditPage(
                                                          widget.userData)));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 0),
                                          height: 50,
                                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                          padding: EdgeInsets.all(9.0),
                                          child: Icon(
                                            Icons.label_important,
                                            color: Colors.black38,
                                            size: 17,
                                          ),
                                          decoration: new BoxDecoration(
                                            color: Colors
                                                .grey[300], // border color
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Text("Interest",
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontFamily: "Oswald",
                                              fontSize: 13))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BusinessInfoPage(
                                                          widget.userData)));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 0),
                                          height: 50,
                                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                          padding: EdgeInsets.all(9.0),
                                          child: Icon(
                                            Icons.business_center,
                                            color: Colors.black38,
                                            size: 17,
                                          ),
                                          decoration: new BoxDecoration(
                                            color: Colors
                                                .grey[300], // border color
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Text("Business Information",
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontFamily: "Oswald",
                                              fontSize: 13))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: 50,
                              margin: EdgeInsets.only(
                                  top: 25, left: 25, right: 25, bottom: 0),
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

                          //////// <<<<<< Basic Info start >>>>> ////////
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(top: 15, left: 20),
                                    child: Text(
                                      "Basic Information",
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
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
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.email,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Email : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: widget.userData[
                                                              'email'] !=
                                                          null
                                                      ? ' ${widget.userData['email']}'
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.work,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Work Type : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: widget.userData[
                                                              'dayJob'] !=
                                                          null
                                                      ? ' ${widget.userData['dayJob']}'
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.account_box,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Gender : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: widget.userData[
                                                              'gender'] !=
                                                          null
                                                      ? ' ${widget.userData['gender']}'
                                                      : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
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
                          Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 15, top: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.location_on,
                                        size: 17, color: Colors.black)),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "Country Name : ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text: " ${conList.user.country}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w400)),
                                        // can add more TextSpans here...
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 15, top: 10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.account_circle,
                                        size: 17, color: Colors.black)),
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: "Member Type : ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text: widget.userData['userType'] !=
                                                    null
                                                ? ' ${widget.userData['userType']}'
                                                : '',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontFamily: "Oswald",
                                                fontWeight: FontWeight.w400)),
                                        // can add more TextSpans here...
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                              width: 50,
                              margin: EdgeInsets.only(
                                  top: 20, left: 25, right: 25, bottom: 10),
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

                          //////// <<<<<< Interest start >>>>> ////////
                          Container(
                              child: Column(
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(top: 15, left: 20),
                                  child: Text(
                                    "Interests",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.normal),
                                  )),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                      margin: EdgeInsets.only(
                                          top: 10, left: 20, bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(
                                          top: 0, left: 20, bottom: 0),
                                      child: Text(
                                        selectedCategory.length == 0
                                            ? "No interests"
                                            : selectedCategory.length == 1
                                                ? "${selectedCategory.length} interest"
                                                : "${selectedCategory.length} interests",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                            ],
                          )),

                          ///// <<<<< Selected Interest start >>>>> //////
                          selectedCategory.length != 0
                              ? Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.only(left: 20),
                                  margin: EdgeInsets.only(
                                      top: 10, bottom: 15, left: 0),
                                  child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: selectedCategory.length,
                                    //separatorBuilder: (context, index) => Divider(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          margin: EdgeInsets.only(
                                              left: 0,
                                              right: 5,
                                              top: 8,
                                              bottom: 8),
                                          padding: EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "${selectedCat[index]}",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          ));
                                    },
                                  ),
                                )
                              : Container(),

                          ////// <<<<< Selected Interest end >>>>> //////

                          Container(
                              width: 50,
                              margin: EdgeInsets.only(
                                  top: 0, left: 25, right: 25, bottom: 10),
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
                          //////// <<<<<< Business Info start >>>>> ////////
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(top: 15, left: 20),
                                    child: Text(
                                      "Business Information",
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
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
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.work,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Business Name : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: businessInfo.res == null
                                                      ? ''
                                                      : businessInfo.res.name !=
                                                              null
                                                          ? ' ${businessInfo.res.name}'
                                                          : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.language,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Official Website : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: businessInfo.res == null
                                                      ? ''
                                                      : businessInfo.res
                                                                  .website !=
                                                              null
                                                          ? ' ${businessInfo.res.website}'
                                                          : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 15, top: 15),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.location_on,
                                              size: 17, color: Colors.black)),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: "Official Address : ",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: businessInfo.res == null
                                                      ? ''
                                                      : businessInfo.res
                                                                  .address !=
                                                              null
                                                          ? ' ${businessInfo.res.address}'
                                                          : '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              // can add more TextSpans here...
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                businessAllSee == false
                                    ? Container()
                                    : Container(
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 15, top: 15),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: Icon(
                                                          Icons.location_city,
                                                          size: 17,
                                                          color: Colors.black)),
                                                  Expanded(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "Operating Address : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                          TextSpan(
                                                              text: businessInfo
                                                                          .res ==
                                                                      null
                                                                  ? ''
                                                                  : businessInfo
                                                                              .res
                                                                              .operatingAddress !=
                                                                          null
                                                                      ? ' ${businessInfo.res.operatingAddress}'
                                                                      : '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                          // can add more TextSpans here...
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 15, top: 15),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: Icon(
                                                          Icons
                                                              .confirmation_number,
                                                          size: 17,
                                                          color: Colors.black)),
                                                  Expanded(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "Tax Number : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                          TextSpan(
                                                              text: businessInfo
                                                                          .res ==
                                                                      null
                                                                  ? ''
                                                                  : businessInfo
                                                                              .res
                                                                              .taxNumber !=
                                                                          null
                                                                      ? ' ${businessInfo.res.taxNumber}'
                                                                      : '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                          // can add more TextSpans here...
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 15, top: 15),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: Icon(
                                                          Icons.calendar_today,
                                                          size: 17,
                                                          color: Colors.black)),
                                                  Expanded(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "Year Established : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                          TextSpan(
                                                              text: businessInfo
                                                                          .res ==
                                                                      null
                                                                  ? ''
                                                                  : businessInfo
                                                                              .res
                                                                              .yearEstablished !=
                                                                          null
                                                                      ? ' ${businessInfo.res.yearEstablished}'
                                                                      : '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                          // can add more TextSpans here...
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 15, top: 15),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: Icon(Icons.group,
                                                          size: 17,
                                                          color: Colors.black)),
                                                  Expanded(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "No of Employees : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                          TextSpan(
                                                              text: businessInfo
                                                                          .res ==
                                                                      null
                                                                  ? ''
                                                                  : businessInfo
                                                                              .res
                                                                              .totalEmployies !=
                                                                          null
                                                                      ? ' ${businessInfo.res.totalEmployies}'
                                                                      : '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                          // can add more TextSpans here...
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 15, top: 15),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: Icon(
                                                          Icons.local_offer,
                                                          size: 17,
                                                          color: Colors.black)),
                                                  Expanded(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "About Business & Main Offerings : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                          TextSpan(
                                                              text: businessInfo
                                                                          .res ==
                                                                      null
                                                                  ? ''
                                                                  : businessInfo
                                                                              .res
                                                                              .businessOfferings !=
                                                                          null
                                                                      ? ' ${businessInfo.res.businessOfferings}'
                                                                      : '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                          // can add more TextSpans here...
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 15, top: 15),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10, top: 5),
                                                      child: Icon(
                                                          Icons.label_important,
                                                          size: 17,
                                                          color: Colors.black)),
                                                  Expanded(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "Business Certifications : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                          TextSpan(
                                                              text: businessInfo
                                                                          .res ==
                                                                      null
                                                                  ? ''
                                                                  : businessInfo
                                                                              .res
                                                                              .businessCertifications !=
                                                                          null
                                                                      ? ' ${businessInfo.res.businessCertifications}'
                                                                      : '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                          // can add more TextSpans here...
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 15, top: 15),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: Icon(
                                                          Icons.account_box,
                                                          size: 17,
                                                          color: Colors.black)),
                                                  Expanded(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "Director Name : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                          TextSpan(
                                                              text: businessInfo
                                                                          .res ==
                                                                      null
                                                                  ? ''
                                                                  : businessInfo
                                                                              .res
                                                                              .directorName !=
                                                                          null
                                                                      ? ' ${businessInfo.res.directorName}'
                                                                      : '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                          // can add more TextSpans here...
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 15, top: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: Icon(Icons.person,
                                                          size: 17,
                                                          color: Colors.black)),
                                                  Expanded(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "Contact Person Name : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                          TextSpan(
                                                              text: businessInfo
                                                                          .res ==
                                                                      null
                                                                  ? ''
                                                                  : businessInfo
                                                                              .res
                                                                              .contactPerson !=
                                                                          null
                                                                      ? ' ${businessInfo.res.contactPerson}'
                                                                      : '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                          // can add more TextSpans here...
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, right: 15, top: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          right: 10),
                                                      child: Icon(Icons.phone,
                                                          size: 17,
                                                          color: Colors.black)),
                                                  Expanded(
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  "Contact Person Number (Phone, Skype, WhatsApp) : ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300)),
                                                          TextSpan(
                                                              text: businessInfo
                                                                          .res ==
                                                                      null
                                                                  ? ''
                                                                  : businessInfo
                                                                              .res
                                                                              .contactNumber !=
                                                                          null
                                                                      ? ' ${businessInfo.res.contactNumber}'
                                                                      : '',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15,
                                                                  fontFamily:
                                                                      "Oswald",
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400)),
                                                          // can add more TextSpans here...
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                              ],
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (businessAllSee == false) {
                                  businessAllSee = true;
                                } else {
                                  businessAllSee = false;
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.centerRight,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(top: 10, right: 20),
                              padding: EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    businessAllSee == false
                                        ? "Show More"
                                        : "Show Less",
                                    style: TextStyle(
                                        color: header,
                                        fontSize: 13,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Container(
                                    //margin: EdgeInsets.only(top: 3),
                                    child: Icon(
                                      Icons.arrow_drop_down,
                                      color: header,
                                      size: 17,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),

                          Container(
                              width: 50,
                              margin: EdgeInsets.only(
                                  top: 20, left: 25, right: 25, bottom: 10),
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

                          Container(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      margin:
                                          EdgeInsets.only(top: 15, left: 20),
                                      child: Text(
                                        "Change Email",
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15.0)),
                                            color: Colors.black,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 3.0,
                                                color: Colors.black,
                                                //offset: Offset(6.0, 7.0),
                                              ),
                                            ],
                                            border: Border.all(
                                                width: 0.5,
                                                color: Colors.black)),
                                      ),
                                    ],
                                  ),
                                  _isResetCodeSent
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              bottom: 10, top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  //padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 0),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.7),
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 0.5),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: TextField(
                                                    controller: _isChangedEmailSent
                                                        ? emailResetController
                                                        : emailResetCodeController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontFamily: 'Oswald',
                                                    ),
                                                    decoration: InputDecoration(
                                                      hintText: _isChangedEmailSent
                                                          ? "Type new email here"
                                                          : "Type Email Reset Code",
                                                      hintStyle: TextStyle(
                                                          color: Colors.black38,
                                                          fontSize: 15,
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w300),
                                                      //labelStyle: TextStyle(color: Colors.white70),
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              10.0,
                                                              0.5,
                                                              5.0,
                                                              0.5),
                                                      border: InputBorder.none,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        )
                                      : Container(),
                                  Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          _isChangedEmailSent
                                              ? resetEmail()
                                              : _isResetCodeSent
                                                  ? resetCode()
                                                  : changingEmail();
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(5),
                                            margin: EdgeInsets.only(
                                                right: 0, left: 20, top: 5),
                                            decoration: BoxDecoration(
                                              color: _isEmailChanged
                                                  ? Colors.grey[500]
                                                  : header,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 5.0,
                                                  color: Colors.grey[300],
                                                  //offset: Offset(3.0, 4.0),
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              _isChangedEmailSent
                                                  ? "Submit"
                                                  : _isEmailChanged
                                                      ? "Please wait..."
                                                      : "Click to change email",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w300),
                                            )),
                                      ),
                                      _isResetCodeSent || _isEmailChanged
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isResetCodeSent = false;
                                                });
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  margin: EdgeInsets.only(
                                                      right: 15,
                                                      left: 5,
                                                      top: 5),
                                                  decoration: BoxDecoration(
                                                    color: header,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 5.0,
                                                        color: Colors.grey[300],
                                                        //offset: Offset(3.0, 4.0),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  )),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  _isResetCodeSent
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              right: 20, left: 20, top: 10),
                                          child: Text(
                                            _isChangedEmailSent
                                                ? "Your email has been verified. Type a new email here."
                                                : "We have sent you an email. Please check it out to know the reset code",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w300),
                                          ),
                                        )
                                      : Container()
                                ]),
                          ),

                          Container(
                            padding: EdgeInsets.only(top: 0, bottom: 10),
                            //color: sub_white,
                            child: Container(
                              //color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                      width: 50,
                                      margin: EdgeInsets.only(
                                          top: 20,
                                          left: 25,
                                          right: 25,
                                          bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                          color: header,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 1.0,
                                              color: header,
                                              //offset: Offset(6.0, 7.0),
                                            ),
                                          ],
                                          border: Border.all(
                                              width: 0.5, color: header))),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(
                                              top: 15, left: 20),
                                          child: Text(
                                            "Connections",
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
                                                top: 10, left: 20),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0)),
                                                color: Colors.black,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 3.0,
                                                    color: Colors.black,
                                                    //offset: Offset(6.0, 7.0),
                                                  ),
                                                ],
                                                border: Border.all(
                                                    width: 0.5,
                                                    color: Colors.black)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(
                                                  top: 12, left: 20, bottom: 0),
                                              child: Text(
                                                conList.res.length == 0
                                                    ? "No connections"
                                                    : conList.res.length == 1
                                                        ? "${conList.res.length} connection"
                                                        : "${conList.res.length} connections",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                          conList.res.length == 0
                                              ? Container()
                                              : GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AllFriendsPage()));
                                                  },
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      margin: EdgeInsets.only(
                                                          top: 12,
                                                          right: 20,
                                                          bottom: 0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                            "See all",
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                color: header,
                                                                fontSize: 13,
                                                                fontFamily:
                                                                    'Oswald',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 3),
                                                            child: Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                color: header,
                                                                size: 17),
                                                          )
                                                        ],
                                                      )),
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                    )),
                    SliverPadding(
                      padding: EdgeInsets.only(right: 20, left: 5),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 120.0,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                          childAspectRatio: 1.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FriendsProfilePage(
                                        conList.res[index].userName, 2)),
                              );
                            },
                            child: new Container(
                              margin: EdgeInsets.only(
                                  left: 15, right: 0, top: 5, bottom: 10),
                              padding: EdgeInsets.only(left: 0),
                              height: 100,
                              width: 90,
                              decoration: BoxDecoration(
                                // image: DecorationImage(
                                //   image: NetworkImage(
                                //       "${conList.res[index].profilePic}"),
                                //   fit: BoxFit.cover,
                                // ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3.0,
                                    color: Colors.black.withOpacity(.5),
                                    //offset: Offset(6.0, 7.0),
                                  ),
                                ],
                                // border: Border.all(width: 0.2, color: Colors.grey)
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 110,
                                    width: 100,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${conList.res[index].profilePic}",
                                        placeholder: (context, url) => Center(
                                            child: Text("Please Wait...")),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          "assets/images/user.png",
                                          height: 40,
                                        ),

                                        // NetworkImage(
                                        //     widget.friend[index].profilePic
                                      ),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(left: 0),
                                      padding: EdgeInsets.only(left: 0),
                                      height: 110,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.0)),
                                      )),
                                  Container(
                                      alignment: Alignment.bottomLeft,
                                      margin: EdgeInsets.only(
                                          top: 10, left: 10, bottom: 5),
                                      child: Text(
                                        "${conList.res[index].firstName} ${conList.res[index].lastName}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w300),
                                      )),
                                ],
                              ),
                            ),
                          );
                        }, childCount: conList.res.length),
                      ),
                    ),
                    // SliverToBoxAdapter(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       Container(
                    //           width: 50,
                    //           margin: EdgeInsets.only(
                    //               top: 20, left: 25, right: 25, bottom: 20),
                    //           decoration: BoxDecoration(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(15.0)),
                    //               color: header,
                    //               boxShadow: [
                    //                 BoxShadow(
                    //                   blurRadius: 1.0,
                    //                   color: header,
                    //                   //offset: Offset(6.0, 7.0),
                    //                 ),
                    //               ],
                    //               border:
                    //                   Border.all(width: 0.5, color: header))),
                    //     ],
                    //   ),
                    // ),
                    // SliverPadding(
                    //   padding: EdgeInsets.only(right: 20, left: 5),
                    //   sliver: SliverGrid(
                    //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    //       maxCrossAxisExtent: 200.0,
                    //       mainAxisSpacing: 0.0,
                    //       crossAxisSpacing: 0.0,
                    //       childAspectRatio: 1.0,
                    //     ),
                    //     delegate: SliverChildBuilderDelegate(
                    //         (BuildContext context, int index) {
                    //       return GestureDetector(
                    //         onTap: () {
                    //           // Navigator.push(
                    //           //   context,
                    //           //   MaterialPageRoute(
                    //           //       builder: (context) => HotelSearchPage()),
                    //           // );
                    //         },
                    //         child: new Container(
                    //           margin: EdgeInsets.only(
                    //               left: 15, right: 0, top: 5, bottom: 10),
                    //           padding: EdgeInsets.only(left: 0),
                    //           height: 100,
                    //           width: 100,
                    //           decoration: BoxDecoration(
                    //             image: DecorationImage(
                    //               image: index == 0
                    //                   ? AssetImage("assets/images/reviews.jpg")
                    //                   : AssetImage("assets/images/offers.jpg"),
                    //               fit: BoxFit.cover,
                    //             ),
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(5.0)),
                    //             color: Colors.white,
                    //             boxShadow: [
                    //               BoxShadow(
                    //                 blurRadius: 3.0,
                    //                 color: Colors.black.withOpacity(.5),
                    //                 //offset: Offset(6.0, 7.0),
                    //               ),
                    //             ],
                    //             // border: Border.all(width: 0.2, color: Colors.grey)
                    //           ),
                    //           child: Stack(
                    //             children: <Widget>[
                    //               // Container(
                    //               //     margin: EdgeInsets.only(left: 0),
                    //               //     padding: EdgeInsets.only(left: 0),
                    //               //     height: 160,
                    //               //     width: 170,
                    //               //     decoration: BoxDecoration(
                    //               //       color: Colors.black.withOpacity(0.3),
                    //               //       borderRadius: BorderRadius.all(
                    //               //           Radius.circular(5.0)),
                    //               //     )),
                    //               Container(
                    //                   alignment: Alignment.bottomLeft,
                    //                   margin: EdgeInsets.only(
                    //                       top: 10, left: 10, bottom: 5),
                    //                   child: Text(
                    //                     index == 0 ? "Review" : "Offers",
                    //                     maxLines: 1,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                         color: Colors.black,
                    //                         fontSize: 20,
                    //                         fontFamily: 'Oswald',
                    //                         fontWeight: FontWeight.bold),
                    //                   )),
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     }, childCount: 2),
                    //   ),
                    // ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: 50,
                                  margin: EdgeInsets.only(
                                      top: 15, left: 25, right: 25, bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      color: header,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 1.0,
                                          color: header,
                                          //offset: Offset(6.0, 7.0),
                                        ),
                                      ],
                                      border: Border.all(
                                          width: 0.5, color: header))),
                            ],
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 15, left: 20),
                              child: Text(
                                "Timeline",
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
                          Container(
                              alignment: Alignment.centerLeft,
                              margin:
                                  EdgeInsets.only(top: 0, left: 20, bottom: 0),
                              child: Text(
                                postList.res.length == 0 ? "No posts" : "",
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
                    SliverToBoxAdapter(
                        child: Container(
                      padding: EdgeInsets.only(top: 5, bottom: 12),
                      margin: EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        //children: _showFeedList()
                        children: List.generate(postList.res.length, (index) {
                          int checkIndex = 0;
                          print("postList 1");
                          print(postList);
                          print("index");
                          print(checkIndex);
                          //profileComCount.clear();
                          //print(d.data.status);
                          des = "${postList.res[index].data.status}";
                          if (des.length > 150) {
                            firstHalf = des.substring(0, 150);
                            secondHalf = des.substring(150, des.length);
                          } else {
                            firstHalf = des;
                            secondHalf = "";
                          }

                          String sharedFirstText = "";
                          String sharedLastText = "";

                          if (postList.res[index].feedType == "Share") {
                            var text = "${postList.res[index].data.sharedTxt}";
                            if (text.length > 150) {
                              sharedFirstText = text.substring(0, 150);
                              sharedLastText = text.substring(150, text.length);
                            } else {
                              sharedFirstText = text;
                              sharedLastText = "";
                            }
                          }

                          imagePost = [];
                          _current = 0;

                          setState(() {
                            checkIndex++;
                            if (checkIndex >= postList.res.length) {
                              checkIndex = postList.res.length - 1;
                              print("checkIndex 1");
                              print(checkIndex);
                            } else {
                              int index = checkIndex;
                              print(index);
                              print(postList.res.length);
                              print("checkIndex 2");
                              print(checkIndex);
                              if (checkIndex + 1 == postList.res.length) {
                                //loadPosts1(d.id);
                                print(checkIndex);
                                print(postList.res.length);
                              }
                            }

                            for (int i = 0; i < postList.res.length; i++) {
                              DateTime date1 = DateTime.parse(
                                  "${postList.res[index].created_at}");

                              daysAgo = DateFormat.yMMMd().format(date1);
                            }
                            print("profileComCount");
                            print(profileComCount);
                          });

                          for (int i = 0;
                              i < postList.res[index].data.images.length;
                              i++) {
                            if (postList.res[index].data.images[i].file
                                    .contains("localhost") ||
                                postList.res[index].data.images[i].file
                                    .contains("127.0.0.1")) {
                              setState(() {
                                postList.res[index].data.images[i].file =
                                    postList.res[index].data.images[i].file
                                        .replaceAll("localhost", "10.0.2.2");
                              });
                            }
                            if (postList.res[index].data.images[i].file
                                .contains("127.0.0.1")) {
                              setState(() {
                                postList.res[index].data.images[i].file =
                                    postList.res[index].data.images[i].file
                                        .replaceAll("127.0.0.1", "10.0.2.2");
                              });
                            }
                            imagePost
                                .add(postList.res[index].data.images[i].file);
                          }

                          List day = [];

                          for (int i = 0; i < postList.res.length; i++) {
                            DateTime date1 =
                                DateTime.parse("${postList.res[i].created_at}");

                            print("date1");
                            print(date1);

                            String days = DateFormat.yMMMd().format(date1);
                            day.add(days);
                            print(day);

                            print("fprofileComCount");
                            print(fprofileComCount);
                          }
                          return isDelete.contains("${postList.res[index].id}")
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.only(top: 5, bottom: 10),
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
                                      top: 5, bottom: 5, left: 10, right: 10),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _statusModalBottomSheet(
                                                    context,
                                                    checkIndex,
                                                    widget.userData,
                                                    postList.res[index]);
                                                //print(widget.feed[index].id);
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
                                          )
                                        ],
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
                                            // Container(
                                            //   margin:
                                            //       EdgeInsets.only(right: 10),
                                            //   padding: EdgeInsets.all(1.0),
                                            //   child: CircleAvatar(
                                            //     radius: 20.0,
                                            //     backgroundColor: Colors.white,
                                            //     backgroundImage: postList
                                            //                 .res[index]
                                            //                 .fuser
                                            //                 .profilePic ==
                                            //             null
                                            //         ? AssetImage(
                                            //             "assets/images/man2.jpg")
                                            //         : NetworkImage(
                                            //             "${postList.res[index].fuser.profilePic}"),
                                            //   ),
                                            //   decoration: new BoxDecoration(
                                            //     color: Colors
                                            //         .grey[300], // border color
                                            //     shape: BoxShape.circle,
                                            //   ),
                                            // ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 10, top: 0),
                                              height: 40,
                                              width: 40,
                                              //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                              padding: EdgeInsets.all(0.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${postList.res[index].fuser.profilePic}",
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget: (context, url,
                                                          error) =>
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
                                                    ////// <<<<< Name & Interest start >>>>> //////
                                                    Container(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                            child: Text(
                                                              "${postList.res[index].fuser.firstName} ${postList.res[index].fuser.lastName}",
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      'Oswald',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                          postList.res[index]
                                                                      .feedType ==
                                                                  "Share"
                                                              ? Expanded(
                                                                  child:
                                                                      Container(
                                                                    child: Text(
                                                                      " shared a post",
                                                                      maxLines:
                                                                          1,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color: Colors
                                                                              .grey,
                                                                          fontFamily:
                                                                              'Oswald',
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                  ),
                                                                )
                                                              : postList
                                                                          .res[
                                                                              index]
                                                                          .feedType ==
                                                                      "ComPost"
                                                                  ? Expanded(
                                                                      child:
                                                                          Container(
                                                                        child:
                                                                            Text(
                                                                          " has posted in ${postList.res[index].data.comName}",
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.grey,
                                                                              fontFamily: 'Oswald',
                                                                              fontWeight: FontWeight.w400),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : postList.res[index].feedType ==
                                                                          "Shop"
                                                                      ? Expanded(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Row(
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
                                                                      : postList.res[index].feedType ==
                                                                              "Product"
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
                                                          postList.res[index]
                                                                      .interests ==
                                                                  null
                                                              ? Container()
                                                              : Expanded(
                                                                  child:
                                                                      Container(
                                                                    child: Text(
                                                                      postList.res[index].interests ==
                                                                              null
                                                                          ? ""
                                                                          : " - ${postList.res[index].interests}",
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              header,
                                                                          fontFamily:
                                                                              'Oswald',
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
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .black54),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                "-  ${postList.res[index].fuser.jobTitle}",
                                                                maxLines: 1,
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
                                                                        FontWeight
                                                                            .w400),
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
                                      postList.res[index].feedType == "Share"
                                          ? sharedFirstText == "null"
                                              ? Container()
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      top: 10, right: 15),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (postList.res[index]
                                                                    .isRead ==
                                                                null ||
                                                            postList.res[index]
                                                                    .isRead ==
                                                                "0") {
                                                          postList.res[index]
                                                              .isRead = "1";
                                                        } else {
                                                          postList.res[index]
                                                              .isRead = "0";
                                                        }
                                                      });
                                                    },
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          child:
                                                              sharedLastText ==
                                                                      ""
                                                                  ? Container(
                                                                      width: MediaQuery.of(
                                                                              context)
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
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              20),
                                                                      child: new Text(
                                                                          postList.res[index].isRead == "0" || postList.res[index].isRead == null
                                                                              ? sharedFirstText +
                                                                                  "..."
                                                                              : sharedLastText +
                                                                                  sharedFirstText,
                                                                          textAlign: TextAlign
                                                                              .start,
                                                                          style: TextStyle(
                                                                              color: Colors.black.withOpacity(0.7),
                                                                              fontSize: 13,
                                                                              fontFamily: "Oswald",
                                                                              fontWeight: FontWeight.w300)),
                                                                    ),
                                                        ),
                                                        secondHalf == ""
                                                            ? Container()
                                                            : Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20,
                                                                        top: 5),
                                                                child: new Text(
                                                                    postList.res[index].isRead ==
                                                                                "0" ||
                                                                            postList.res[index].isRead ==
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
                                                )
                                          : postList.res[index].feedType !=
                                                  "Status"
                                              ? Container()
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      top: 10, right: 15),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (postList.res[index]
                                                                    .isRead ==
                                                                null ||
                                                            postList.res[index]
                                                                    .isRead ==
                                                                "0") {
                                                          postList.res[index]
                                                              .isRead = "1";
                                                        } else {
                                                          postList.res[index]
                                                              .isRead = "0";
                                                        }
                                                      });
                                                    },
                                                    child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          child: secondHalf ==
                                                                  ""
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    if (postList.res[index].data.linkMeta !=
                                                                            null ||
                                                                        postList.res[index].data.linkMeta ==
                                                                            "") {
                                                                      _launchURL(postList
                                                                          .res[
                                                                              index]
                                                                          .data
                                                                          .linkMeta['og:url']);
                                                                    }
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                20),
                                                                    child: new Text(
                                                                        firstHalf,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .justify,
                                                                        style:
                                                                            TextStyle(
                                                                          color: postList.res[index].data.linkMeta != null
                                                                              ? Colors.blueAccent
                                                                              : Colors.black.withOpacity(0.7),
                                                                          fontSize:
                                                                              13,
                                                                          fontFamily:
                                                                              "Oswald",
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                          decoration: postList.res[index].data.linkMeta != null
                                                                              ? TextDecoration.underline
                                                                              : TextDecoration.none,
                                                                        )),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20),
                                                                  child: new Text(
                                                                      postList.res[index].isRead == "0" ||
                                                                              postList.res[index].isRead ==
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
                                                                              FontWeight.w300)),
                                                                ),
                                                        ),
                                                        secondHalf == ""
                                                            ? Container()
                                                            : Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20,
                                                                        top: 5),
                                                                child: new Text(
                                                                    postList.res[index].isRead ==
                                                                                "0" ||
                                                                            postList.res[index].isRead ==
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
                                      Container(
                                          child: Column(
                                        children: <Widget>[
                                          postList.res[index].data.linkMeta !=
                                                      null ||
                                                  postList.res[index].data
                                                          .linkMeta ==
                                                      ""
                                              ? GestureDetector(
                                                  onTap: () {
                                                    _launchURL(postList
                                                        .res[index]
                                                        .data
                                                        .linkMeta['og:url']);
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
                                                          EdgeInsets.all(16.0),
                                                      child: Container(
                                                        color: Colors.grey[100],
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Image.network(
                                                                "${postList.res[index].data.linkMeta['og:image']}",
                                                                height: 120,
                                                                width: 130,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                              Flexible(
                                                                  child:
                                                                      Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      postList
                                                                          .res[
                                                                              index]
                                                                          .data
                                                                          .linkMeta['og:title'],
                                                                      maxLines:
                                                                          2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .normal,
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              "Oswald"),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Text(
                                                                        postList.res[index].data.linkMeta[
                                                                            'og:description'],
                                                                        maxLines:
                                                                            3,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .black45,
                                                                            fontSize:
                                                                                13,
                                                                            fontFamily:
                                                                                "Oswald",
                                                                            fontWeight:
                                                                                FontWeight.w400)),
                                                                    SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          // Image.network(
                                                                          //   feedList[index].data.linkMeta['favicon'],
                                                                          //   height: 12,
                                                                          //   width: 12,
                                                                          // ),
                                                                          // SizedBox(
                                                                          //   width: 4,
                                                                          // ),
                                                                          Expanded(
                                                                              child: Container(child: Text(postList.res[index].data.linkMeta['og:site_name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey, fontSize: 12))))
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
                                              : postList.res[index].data.images
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
                                                  : postList.res[index]
                                                              .feedType ==
                                                          "Share"
                                                      ? Container()
                                                      : Stack(
                                                          children: <Widget>[
                                                            Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                    height: 500,
                                                                    child:
                                                                        Container(
                                                                      margin: EdgeInsets.only(
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
                                                                          setState(
                                                                              () {
                                                                            _current =
                                                                                index;
                                                                          });
                                                                        },
                                                                        items: imagePost
                                                                            .map((imgUrl) {
                                                                          return Builder(
                                                                            builder:
                                                                                (BuildContext context) {
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
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    color: Colors
                                                                            .grey[
                                                                        500],
                                                                    child: Text(
                                                                      "${imagePost.length} images",
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
                                        ],
                                      )),
                                      postList.res[index].feedType == "Share"
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                border: Border.all(
                                                    width: 0.8,
                                                    color: Colors.grey[300]),
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
                                                  top: 25,
                                                  bottom: 15,
                                                  left: 20,
                                                  right: 20),
                                              child: SingleChildScrollView(
                                                child: Container(
                                                  //color: Colors.yellow,
                                                  margin: EdgeInsets.only(
                                                      left: 20,
                                                      right: 10,
                                                      bottom: 10),
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            ////// <<<<< pic start >>>>> //////

                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => postList.res[index].data.fuser.userName ==
                                                                                userData['userName']
                                                                            ? MyProfilePage(userData)
                                                                            : FriendsProfilePage(postList.res[index].data.fuser.userName, 2)));
                                                              },
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            10,
                                                                        top: 0),
                                                                height: 40,
                                                                width: 40,
                                                                //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0.0),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    imageUrl:
                                                                        "${postList.res[index].data.fuser.profilePic}",
                                                                    placeholder:
                                                                        (context,
                                                                                url) =>
                                                                            CircularProgressIndicator(),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image.asset(
                                                                            "assets/images/user.png",
                                                                            fit:
                                                                                BoxFit.cover),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                                decoration:
                                                                    new BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                ),
                                                              ),
                                                            ),
                                                            ////// <<<<< pic end >>>>> //////

                                                            Expanded(
                                                              child: Container(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    ////// <<<<< Name & Interest start >>>>> //////
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.push(context, MaterialPageRoute(builder: (context) => postList.res[index].data.fuser.userName == userData['userName'] ? MyProfilePage(userData) : FriendsProfilePage(postList.res[index].data.fuser.userName, 2)));
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              child: Text(
                                                                                "${postList.res[index].data.fuser.firstName} ${postList.res[index].data.fuser.lastName}",
                                                                                maxLines: 1,
                                                                                style: TextStyle(fontSize: 15, color: Colors.black, fontFamily: 'Oswald', fontWeight: FontWeight.w400),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Container(
                                                                              child: Text(
                                                                                postList.res[index].data.interest == null ? "" : " - ${postList.res[index].data.interest}",
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
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                              top: 3),
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              "${day[index]}",
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: TextStyle(fontFamily: 'Oswald', fontWeight: FontWeight.w400, fontSize: 11, color: Colors.black54),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Container(
                                                                              margin: EdgeInsets.only(left: 5),
                                                                              child: Text(
                                                                                "-  ${postList.res[index].data.fuser.jobTitle}",
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
                                                      postList.res[index].data
                                                                  .feedType !=
                                                              "Status"
                                                          ? Container()
                                                          : Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 20,
                                                                      right:
                                                                          15),
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    child: secondHalf ==
                                                                            ""
                                                                        ? Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            margin:
                                                                                EdgeInsets.only(left: 0),
                                                                            child: new Text(firstHalf,
                                                                                textAlign: TextAlign.justify,
                                                                                style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                          )
                                                                        : Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            margin:
                                                                                EdgeInsets.only(left: 0),
                                                                            child: new Text(postList.res[index].data.isRead == "0" || postList.res[index].data.isRead == null ? firstHalf + "..." : firstHalf + secondHalf,
                                                                                textAlign: TextAlign.start,
                                                                                style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                          ),
                                                                  ),
                                                                  Container()
                                                                ],
                                                              ),
                                                            ),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            left: 0,
                                                            right: 0,
                                                            top: 10,
                                                          ),
                                                          child: Column(
                                                            children: <Widget>[
                                                              postList
                                                                          .res[
                                                                              index]
                                                                          .data
                                                                          .images
                                                                          .length ==
                                                                      0
                                                                  ? Container()
                                                                  : Container(
                                                                      child:
                                                                          Stack(
                                                                        children: <
                                                                            Widget>[
                                                                          Column(
                                                                            children: <Widget>[
                                                                              Container(
                                                                                  height: 500,
                                                                                  child: Container(
                                                                                    margin: EdgeInsets.only(left: 0, right: 0, top: 10),
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
                                                                            margin:
                                                                                EdgeInsets.only(top: 15, right: 0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                                              children: <Widget>[
                                                                                Container(
                                                                                  padding: EdgeInsets.all(5),
                                                                                  color: Colors.grey[500],
                                                                                  child: Text(
                                                                                    "${imagePost.length} images",
                                                                                    style: TextStyle(color: Colors.white, fontFamily: "Oswald"),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                              // Container(
                                                              //     //color: Colors.red,
                                                              //     height: 200,
                                                              //     padding: const EdgeInsets.all(0.0),
                                                              //     margin: EdgeInsets.only(top: 10),
                                                              //     decoration: BoxDecoration(
                                                              //         borderRadius: BorderRadius.circular(15),
                                                              //         image: DecorationImage(
                                                              //             image: //AssetImage("assets/images/friend7.jpg"),
                                                              //                 NetworkImage("${feedList[index].data.images[0].file}"),
                                                              //             fit: BoxFit.cover)),
                                                              //     child: null),
                                                              postList
                                                                          .res[
                                                                              index]
                                                                          .data
                                                                          .feedType ==
                                                                      "Status"
                                                                  ? Container()
                                                                  : Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              0),
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Expanded(
                                                                            child:
                                                                                Container(
                                                                              margin: EdgeInsets.only(top: postList.res[index].data.images.length == 0 ? 0 : 10, right: 0, left: 0),
                                                                              padding: EdgeInsets.all(5),
                                                                              decoration: postList.res[index].data.images.length == 0
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
                                                                                    if (postList.res[index].isRead == null || postList.res[index].isRead == "0") {
                                                                                      postList.res[index].isRead = "1";
                                                                                    } else {
                                                                                      postList.res[index].isRead = "0";
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
                                                                                              margin: EdgeInsets.only(left: postList.res[index].data.images.length == 0 ? 0 : 20),
                                                                                              child: new Text(postList.res[index].isRead == "0" || postList.res[index].isRead == null ? firstHalf + "..." : firstHalf + secondHalf, textAlign: TextAlign.start, style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                                            ),
                                                                                    ),
                                                                                    secondHalf == ""
                                                                                        ? Container()
                                                                                        : Container(
                                                                                            width: MediaQuery.of(context).size.width,
                                                                                            margin: EdgeInsets.only(left: postList.res[index].data.images.length == 0 ? 0 : 0, top: 5),
                                                                                            child: new Text(postList.res[index].isRead == "0" || postList.res[index].isRead == null ? "Read more" : "", textAlign: TextAlign.start, style: TextStyle(color: header, fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w400)),
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
                                          : postList.res[index].feedType ==
                                                  "Status"
                                              ? Container()
                                              : Container(
                                                  margin:
                                                      EdgeInsets.only(left: 20),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              top: postList
                                                                          .res[
                                                                              index]
                                                                          .data
                                                                          .images
                                                                          .length ==
                                                                      0
                                                                  ? 0
                                                                  : 10,
                                                              right: 20,
                                                              left: 0),
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          decoration: postList
                                                                      .res[
                                                                          index]
                                                                      .data
                                                                      .images
                                                                      .length ==
                                                                  0
                                                              ? BoxDecoration()
                                                              : BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                              .grey[
                                                                          300],
                                                                      blurRadius:
                                                                          17,
                                                                    )
                                                                  ],
                                                                ),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                if (postList
                                                                            .res[
                                                                                index]
                                                                            .isRead ==
                                                                        null ||
                                                                    postList.res[index]
                                                                            .isRead ==
                                                                        "0") {
                                                                  postList
                                                                      .res[
                                                                          index]
                                                                      .isRead = "1";
                                                                } else {
                                                                  postList
                                                                      .res[
                                                                          index]
                                                                      .isRead = "0";
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
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          margin:
                                                                              EdgeInsets.only(left: 5),
                                                                          child: new Text(
                                                                              firstHalf,
                                                                              textAlign: TextAlign.justify,
                                                                              style: TextStyle(color: Colors.black.withOpacity(0.9), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                        )
                                                                      : Container(
                                                                          width: MediaQuery.of(context)
                                                                              .size
                                                                              .width,
                                                                          margin:
                                                                              EdgeInsets.only(left: postList.res[index].data.images.length == 0 ? 0 : 20),
                                                                          child: new Text(
                                                                              postList.res[index].isRead == "0" || postList.res[index].isRead == null ? firstHalf + "..." : firstHalf + secondHalf,
                                                                              textAlign: TextAlign.start,
                                                                              style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 13, fontFamily: "Oswald", fontWeight: FontWeight.w300)),
                                                                        ),
                                                                ),
                                                                secondHalf == ""
                                                                    ? Container()
                                                                    : Container(
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        margin: EdgeInsets.only(
                                                                            left: postList.res[index].data.images.length == 0
                                                                                ? 0
                                                                                : 20,
                                                                            top:
                                                                                5),
                                                                        child: new Text(
                                                                            postList.res[index].isRead == "0" || postList.res[index].isRead == null
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
                                        margin:
                                            EdgeInsets.only(left: 20, top: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.all(3.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (postList.res[index]
                                                              .like !=
                                                          null) {
                                                        setState(() {
                                                          postList.res[index]
                                                              .like = null;
                                                          // print(widget.feed[index].meta
                                                          //     .totalLikesCount);
                                                          // likeCount = widget
                                                          //     .feed[index].meta.totalLikesCount;
                                                          // //likeCount = likeCount - 1;
                                                          // print(widget.feed[index].meta
                                                          //     .totalLikesCount);
                                                          // print("bfg $likeCount");

                                                          postList
                                                                  .res[index]
                                                                  .meta
                                                                  .totalLikesCount =
                                                              postList
                                                                      .res[
                                                                          index]
                                                                      .meta
                                                                      .totalLikesCount -
                                                                  1;
                                                          //likes.insert(index, likeCount);
                                                        });
                                                        likeButtonPressed(
                                                            checkIndex, 0);
                                                        //print(likes);
                                                      } else {
                                                        setState(() {
                                                          postList.res[index]
                                                              .like = 1;
                                                          // print(widget.feed[index].meta
                                                          //     .totalLikesCount);
                                                          // likeCount = widget
                                                          //     .feed[index].meta.totalLikesCount;
                                                          // likeCount = likeCount + 1;
                                                          // print("bfg $likeCount");
                                                          postList
                                                                  .res[index]
                                                                  .meta
                                                                  .totalLikesCount =
                                                              postList
                                                                      .res[
                                                                          index]
                                                                      .meta
                                                                      .totalLikesCount +
                                                                  1;
                                                          // likeCount = widget
                                                          //     .feed[index].meta.totalLikesCount;
                                                          // likeCount = likeCount + 1;
                                                          //likes.insert(index, likeCount);
                                                        });
                                                        likeButtonPressed(
                                                            checkIndex, 1);
                                                        //print(likes);
                                                      }
                                                    },
                                                    child: Container(
                                                      child: Icon(
                                                        postList.res[index]
                                                                    .like !=
                                                                null
                                                            //likePressed == true
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        size: 20,
                                                        color: postList
                                                                    .res[index]
                                                                    .like !=
                                                                null
                                                            //likePressed == true
                                                            ? Colors.redAccent
                                                            : Colors.black54,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 3),
                                                  child: Text(
                                                      "${postList.res[index].meta.totalLikesCount}",
                                                      style: TextStyle(
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.black54,
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
                                                          ProfileCommentPage(
                                                              postList
                                                                  .res[index]
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
                                                          profileComCount[index]
                                                                      [
                                                                      'count'] ==
                                                                  null
                                                              ? ""
                                                              : "${profileComCount[index]['count']}",
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
                                            GestureDetector(
                                              onTap: () {
                                                _shareModalBottomSheet(
                                                    context,
                                                    index,
                                                    widget.userData,
                                                    postList.res[index]);
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
                                                        Icons.send,
                                                        size: 20,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 3),
                                                      child: Text(
                                                          postList
                                                                      .res[
                                                                          index]
                                                                      .meta
                                                                      .totalSharesCount ==
                                                                  null
                                                              ? ""
                                                              : "${postList.res[index].meta.totalSharesCount}",
                                                          style:
                                                              TextStyle(
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
                                    ],
                                  ),
                                );
                        }),
                      ),
                    )),
                  ],
                ),
              ));
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

    List imgList = [];

    for (int i = 0; i < feeds.data.images.length; i++) {
      if (feeds.data.images[i].file.contains("127.0.0.1")) {
        setState(() {
          feeds.data.images[i].file =
              feeds.data.images[i].file.replaceAll("127.0.0.1", "10.0.2.2");
        });
      }
      imgList.add(feeds.data.images[i].file);
    }

    print("feeds.created_at");
    print(feeds.created_at);

    DateTime date1 = DateTime.parse("${feeds.created_at}");

    print("date1");
    print(date1);

    String days = DateFormat.yMMMd().format(date1);

    print(days);

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
                          margin: EdgeInsets.only(right: 10, top: 0, left: 20),
                          height: 50,
                          width: 50,
                          //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                          padding: EdgeInsets.all(0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: "${userData['profilePic']}",
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
                                    margin: EdgeInsets.only(
                                        right: 10, top: 0, left: 0),
                                    height: 40,
                                    width: 40,
                                    //transform: Matrix4.translationValues(0.0, 0.0, 0.0),
                                    padding: EdgeInsets.all(0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl: "${feeds.fuser.profilePic}",
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
                                                    days,
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
                                        : Stack(
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Container(
                                                      height: 500,
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 10,
                                                            right: 10,
                                                            top: 10),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: CarouselSlider(
                                                          height: 500.0,
                                                          initialPage: 0,
                                                          enlargeCenterPage:
                                                              false,
                                                          autoPlay: false,
                                                          reverse: false,
                                                          viewportFraction: 1.0,
                                                          enableInfiniteScroll:
                                                              true,
                                                          autoPlayInterval:
                                                              Duration(
                                                                  seconds: 2),
                                                          autoPlayAnimationDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      2000),
                                                          pauseAutoPlayOnTouch:
                                                              Duration(
                                                                  seconds: 10),
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          onPageChanged:
                                                              (index) {
                                                            setState(() {
                                                              _current = index;
                                                            });
                                                          },
                                                          items: imgList
                                                              .map((imgUrl) {
                                                            return Builder(
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return CachedNetworkImage(
                                                                  imageUrl:
                                                                      imgUrl,
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      Center(
                                                                          child:
                                                                              Text("Please Wait...")),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Image
                                                                          .asset(
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
                                                margin: EdgeInsets.only(
                                                    top: 15, right: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      color: Colors.grey[500],
                                                      child: Text(
                                                        "${imgList.length} images",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                "Oswald"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
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
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyProfilePage(widget.userData)));
      setState(() {
        //isDelete.add("$id");
        //page1 = 0;
      });
    } else {
      Navigator.pop(context);
      _showMsg("Something went wrong!");
    }
  }

  List<Widget> _showFeedList() {
    int checkIndex = 0;
    print("postList 1");
    print(postList);
    // print("postList.feed.length");
    // print(postList.feed.length);
    for (var d in postList.res) {
      print("index");
      print(checkIndex);
      //print(d.data.status);
      des = "${d.data.status}";
      if (des.length > 150) {
        firstHalf = des.substring(0, 150);
        secondHalf = des.substring(150, des.length);
      } else {
        firstHalf = des;
        secondHalf = "";
      }

      setState(() {
        checkIndex++;
        if (checkIndex >= postList.res.length) {
          checkIndex = postList.res.length - 1;
          print("checkIndex 1");
          print(checkIndex);
        } else {
          int index = checkIndex;
          print(index);
          print(postList.res.length);
          print("checkIndex 2");
          print(checkIndex);
          if (checkIndex + 1 == postList.res.length) {
            //loadPosts1(d.id);
            print(checkIndex);
            print(postList.res.length);
          }
        }

        for (int i = 0; i < postList.res.length; i++) {
          profileComCount.add({'count': d.meta.totalCommentsCount});
        }
        print("profileComCount");
        print(profileComCount);
      });

      for (int i = 0; i < d.data.images.length; i++) {
        if (d.data.images[i].file.contains("localhost") ||
            d.data.images[i].file.contains("127.0.0.1")) {
          setState(() {
            d.data.images[i].file =
                d.data.images[i].file.replaceAll("localhost", "10.0.2.2");
          });
        }
        if (d.data.images[i].file.contains("127.0.0.1")) {
          setState(() {
            d.data.images[i].file =
                d.data.images[i].file.replaceAll("127.0.0.1", "10.0.2.2");
          });
        }
      }

      list.add(isDelete.contains("${d.id}")
          ? Container()
          : Container(
              padding: EdgeInsets.only(top: 5, bottom: 10),
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
              margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      id == d.fuser.id
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _statusModalBottomSheet(
                                      context, checkIndex, widget.userData, d);
                                  //print(widget.feed[index].id);
                                });
                              },
                              child: Container(
                                  margin: EdgeInsets.only(right: 15),
                                  // color: Colors.blue,
                                  child: Icon(
                                    Icons.more_horiz,
                                    color: Colors.black54,
                                  )),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 10),
                            ),
                    ],
                  ),
                  Container(
                    //color: Colors.yellow,
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    padding: EdgeInsets.only(right: 10),
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
                            backgroundImage: d.fuser.profilePic == null
                                ? AssetImage("assets/images/man2.jpg")
                                : NetworkImage("${d.fuser.profilePic}"),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ////// <<<<< Name & Interest start >>>>> //////
                                Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          "${d.fuser.firstName} ${d.fuser.lastName}",
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      // widget.feed[index].activityType ==
                                      //         "community"
                                      //     ? Container(
                                      //         child: Text(
                                      //           " has created a community",
                                      //           maxLines: 1,
                                      //           style: TextStyle(
                                      //               fontSize: 15,
                                      //               color: Colors.black54,
                                      //               fontFamily: 'Oswald',
                                      //               fontWeight:
                                      //                   FontWeight.w300),
                                      //         ),
                                      //       )
                                      //     : Container(),
                                      // widget.feed[index].shop != null &&
                                      //         widget.feed[index].product ==
                                      //             null
                                      //     ? Container(
                                      //         child: Text(
                                      //           " has created a shop",
                                      //           maxLines: 1,
                                      //           style: TextStyle(
                                      //               fontSize: 15,
                                      //               color: Colors.black54,
                                      //               fontFamily: 'Oswald',
                                      //               fontWeight:
                                      //                   FontWeight.w300),
                                      //         ),
                                      //       )
                                      //     : Container(),
                                      // widget.feed[index].shop != null &&
                                      //         widget.feed[index].product !=
                                      //             null
                                      //     ? Container(
                                      //         child: Text(
                                      //           " has uploaded a new product",
                                      //           maxLines: 1,
                                      //           style: TextStyle(
                                      //               fontSize: 15,
                                      //               color: Colors.black54,
                                      //               fontFamily: 'Oswald',
                                      //               fontWeight:
                                      //                   FontWeight.w300),
                                      //         ),
                                      //       )
                                      //     : Container(),
                                      // widget.feed[index].activityType ==
                                      //         "offer"
                                      //     ? Container(
                                      //         child: Text(
                                      //           " has created a offer",
                                      //           maxLines: 1,
                                      //           style: TextStyle(
                                      //               fontSize: 15,
                                      //               color: Colors.black54,
                                      //               fontFamily: 'Oswald',
                                      //               fontWeight:
                                      //                   FontWeight.w300),
                                      //         ),
                                      //       )
                                      //     : Container(),
                                      d.feedType == "ComPost"
                                          ? Expanded(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 2),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "Posted in",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey,
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Text(
                                                          d.data.comName == null
                                                              ? ""
                                                              : " ${d.data.comName}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: header,
                                                              fontFamily:
                                                                  'Oswald',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Expanded(
                                              child: Container(
                                                child: Text(
                                                  d.interests == null
                                                      ? ""
                                                      : " - ${d.interests}",
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
                                          "Aug 7 at 5:34 PM",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 11,
                                              color: Colors.black54),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Icon(
                                                  Icons.album,
                                                  size: 10,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    "  ${d.fuser.jobTitle}",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: header,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w400),
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
                  d.feedType != "Status"
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(top: 10, right: 15),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (d.isRead == null || d.isRead == "0") {
                                  d.isRead = "1";
                                } else {
                                  d.isRead = "0";
                                }
                              });
                            },
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: secondHalf == ""
                                      ? Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(left: 20),
                                          child: new Text(firstHalf,
                                              textAlign: TextAlign.justify,
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  fontSize: 13,
                                                  fontFamily: "Oswald",
                                                  fontWeight: FontWeight.w300)),
                                        )
                                      : Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.only(left: 20),
                                          child: new Text(
                                              d.isRead == "0" ||
                                                      d.isRead == null
                                                  ? firstHalf + "..."
                                                  : firstHalf + secondHalf,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.7),
                                                  fontSize: 13,
                                                  fontFamily: "Oswald",
                                                  fontWeight: FontWeight.w300)),
                                        ),
                                ),
                                secondHalf == ""
                                    ? Container()
                                    : Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin:
                                            EdgeInsets.only(left: 20, top: 5),
                                        child: new Text(
                                            d.isRead == "0" || d.isRead == null
                                                ? "Read more"
                                                : "",
                                            textAlign: TextAlign.start,
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
                      margin: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 10,
                      ),
                      child: Column(
                        children: <Widget>[
                          d.data.images.length == 0
                              ? Container()
                              : Container(
                                  //color: Colors.red,
                                  height: 200,
                                  padding: const EdgeInsets.all(0.0),
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image: //AssetImage("assets/images/friend7.jpg"),
                                              NetworkImage(
                                                  "${d.data.images[0].file}"),
                                          fit: BoxFit.cover)),
                                  child: null)
                          ////// <<<<< Status start >>>>> //////
                          // Container(
                          //   margin: EdgeInsets.only(bottom: 10),
                          //   alignment: Alignment.centerLeft,
                          //   child: Text(
                          //     widget.feed[index].activityType == "community"
                          //         ? "${widget.feed[index].group.name}"
                          //         : widget.feed[index].shop != null &&
                          //                 widget.feed[index].product == null
                          //             ? "${widget.feed[index].shop.shopName}"
                          //             : widget.feed[index].shop != null &&
                          //                     widget.feed[index].product !=
                          //                         null
                          //                 ? "${widget.feed[index].product.productName}"
                          //                 : widget.feed[index]
                          //                             .activityType ==
                          //                         "offer"
                          //                     ? "${widget.feed[index].offer.title}"
                          //                     : widget.feed[index].status ==
                          //                             null
                          //                         ? ""
                          //                         : "${widget.feed[index].status}",
                          //     textAlign: TextAlign.justify,
                          //     style: TextStyle(
                          //         color: Colors.black,
                          //         fontWeight: FontWeight.w400),
                          //   ),
                          // ),

                          ////// <<<<< Status end >>>>> //////

                          ////// <<<<< Picture Start >>>>> //////
                          // widget.feed[index].activityType == "community"
                          // ? Container(
                          //     //color: Colors.red,
                          //     height: 200,
                          //     padding: const EdgeInsets.all(0.0),
                          //     margin: EdgeInsets.only(top: 10),
                          //     decoration: BoxDecoration(
                          //         borderRadius:
                          //             BorderRadius.circular(15),
                          //         image: DecorationImage(
                          //             image: //AssetImage("assets/images/friend7.jpg"),
                          //                 NetworkImage(
                          //                     "${widget.feed[index].group.logo}"),
                          //             fit: BoxFit.cover)),
                          //     child: null)
                          //     : widget.feed[index].shop != null &&
                          //             widget.feed[index].product == null
                          //         ? GestureDetector(
                          //             onTap: () {
                          //               Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           ShopPage(
                          //                               widget.feed[index]
                          //                                   .shop.id,
                          //                               widget.userData[
                          //                                   'id'])));
                          //             },
                          //             child: Container(
                          //                 //color: Colors.red,
                          //                 height: 200,
                          //                 padding:
                          //                     const EdgeInsets.all(0.0),
                          //                 margin: EdgeInsets.only(top: 10),
                          //                 decoration: BoxDecoration(
                          //                     borderRadius:
                          //                         BorderRadius.circular(15),
                          //                     image: DecorationImage(
                          //                         image: //AssetImage("assets/images/friend7.jpg"),
                          //                             NetworkImage(
                          //                                 "${widget.feed[index].shop.logo}"),
                          //                         fit: BoxFit.cover)),
                          //                 child: null),
                          //           )
                          //         : widget.feed[index].shop != null &&
                          //                 widget.feed[index].product != null
                          //             ? GestureDetector(
                          //                 onTap: () {
                          //                   Navigator.push(
                          //                       context,
                          //                       MaterialPageRoute(
                          //                           builder: (context) =>
                          //                               ProductDetailsPage(
                          //                                   widget
                          //                                       .feed[index]
                          //                                       .product
                          //                                       .id)));
                          //                 },
                          //                 child: Container(
                          //                     //color: Colors.red,
                          //                     height: 200,
                          //                     padding:
                          //                         const EdgeInsets.all(0.0),
                          //                     margin:
                          //                         EdgeInsets.only(top: 10),
                          //                     decoration: BoxDecoration(
                          //                         borderRadius:
                          //                             BorderRadius.circular(
                          //                                 15),
                          //                         image: DecorationImage(
                          //                             image: //AssetImage("assets/images/friend7.jpg"),
                          //                                 NetworkImage(
                          //                                     "${widget.feed[index].product.singleImage.image}"),
                          //                             fit: BoxFit.cover)),
                          //                     child: null),
                          //               )
                          //             : widget.feed[index].images == null
                          //                 ? Container()
                          //                 : widget.feed[index].images
                          //                             .length ==
                          //                         0
                          //                     ? Container()
                          //                     : widget.feed[index].images
                          //                                 .length ==
                          //                             1
                          //                         ? Container(
                          //                             //color: Colors.red,
                          //                             height: 200,
                          //                             padding:
                          //                                 const EdgeInsets
                          //                                     .all(0.0),
                          //                             margin:
                          //                                 EdgeInsets.only(
                          //                                     top: 10),
                          //                             decoration:
                          //                                 BoxDecoration(
                          //                                     borderRadius:
                          //                                         BorderRadius
                          //                                             .circular(
                          //                                                 15),
                          //                                     image: DecorationImage(
                          //                                         image: //AssetImage("assets/images/friend7.jpg"),
                          //                                             NetworkImage("${widget.feed[index].images[0].thum}"),
                          //                                         fit: BoxFit.cover)),
                          //                             child: null)
                          //                         : Container(
                          //                             height: widget
                          //                                         .feed[
                          //                                             index]
                          //                                         .images
                          //                                         .length <=
                          //                                     3
                          //                                 ? 100
                          //                                 : 200,
                          //                             child:
                          //                                 GridView.builder(
                          //                               //semanticChildCount: 2,
                          //                               gridDelegate:
                          //                                   SliverGridDelegateWithMaxCrossAxisExtent(
                          //                                 maxCrossAxisExtent:
                          //                                     100.0,
                          //                                 mainAxisSpacing:
                          //                                     0.0,
                          //                                 crossAxisSpacing:
                          //                                     0.0,
                          //                                 childAspectRatio:
                          //                                     1.0,
                          //                               ),
                          //                               //crossAxisCount: 2,
                          //                               itemBuilder: (BuildContext
                          //                                           context,
                          //                                       int indexes) =>
                          //                                   new Padding(
                          //                                 padding:
                          //                                     const EdgeInsets
                          //                                         .all(5.0),
                          //                                 child: Container(
                          //                                   height: 100,
                          //                                   //width: 50,
                          //                                   padding:
                          //                                       const EdgeInsets
                          //                                               .all(
                          //                                           5.0),
                          //                                   decoration: BoxDecoration(
                          //                                       border: Border.all(
                          //                                           width:
                          //                                               0.1,
                          //                                           color: Colors
                          //                                               .grey),
                          //                                       image: DecorationImage(
                          //                                           image: NetworkImage(
                          //                                               "${widget.feed[index].images[indexes].thum}"))),
                          //                                 ),
                          //                               ),
                          //                               itemCount: widget
                          //                                   .feed[index]
                          //                                   .images
                          //                                   .length,
                          //                             ),
                          //                           ),
                        ],
                      )),
                  d.feedType == "Status"
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: d.data.images.length == 0 ? 0 : 10,
                                      right: 20,
                                      left: 0),
                                  padding: EdgeInsets.all(5),
                                  decoration: d.data.images.length == 0
                                      ? BoxDecoration()
                                      : BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
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
                                        if (d.isRead == null ||
                                            d.isRead == "0") {
                                          d.isRead = "1";
                                        } else {
                                          d.isRead = "0";
                                        }
                                      });
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: secondHalf == ""
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin:
                                                      EdgeInsets.only(left: 5),
                                                  child: new Text(firstHalf,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.9),
                                                          fontSize: 13,
                                                          fontFamily: "Oswald",
                                                          fontWeight:
                                                              FontWeight.w300)),
                                                )
                                              : Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin: EdgeInsets.only(
                                                      left: d.data.images
                                                                  .length ==
                                                              0
                                                          ? 0
                                                          : 20),
                                                  child: new Text(
                                                      d.isRead == "0" ||
                                                              d.isRead == null
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
                                        secondHalf == ""
                                            ? Container()
                                            : Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin: EdgeInsets.only(
                                                    left:
                                                        d.data.images.length ==
                                                                0
                                                            ? 0
                                                            : 20,
                                                    top: 5),
                                                child: new Text(
                                                    d.isRead == "0" ||
                                                            d.isRead == null
                                                        ? "Read more"
                                                        : "",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        color: header,
                                                        fontSize: 13,
                                                        fontFamily: "Oswald",
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
                  Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, bottom: 0, top: 10),
                      child: Divider(
                        color: Colors.grey[400],
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(3.0),
                              child: GestureDetector(
                                onTap: () {
                                  if (d.like != null) {
                                    setState(() {
                                      d.like = null;
                                      // print(widget.feed[index].meta
                                      //     .totalLikesCount);
                                      // likeCount = widget
                                      //     .feed[index].meta.totalLikesCount;
                                      // //likeCount = likeCount - 1;
                                      // print(widget.feed[index].meta
                                      //     .totalLikesCount);
                                      // print("bfg $likeCount");

                                      d.meta.totalLikesCount =
                                          d.meta.totalLikesCount - 1;
                                      //likes.insert(index, likeCount);
                                    });
                                    likeButtonPressed(checkIndex, 0);
                                    //print(likes);
                                  } else {
                                    setState(() {
                                      d.like = 1;
                                      // print(widget.feed[index].meta
                                      //     .totalLikesCount);
                                      // likeCount = widget
                                      //     .feed[index].meta.totalLikesCount;
                                      // likeCount = likeCount + 1;
                                      // print("bfg $likeCount");
                                      d.meta.totalLikesCount =
                                          d.meta.totalLikesCount + 1;
                                      // likeCount = widget
                                      //     .feed[index].meta.totalLikesCount;
                                      // likeCount = likeCount + 1;
                                      //likes.insert(index, likeCount);
                                    });
                                    likeButtonPressed(checkIndex, 1);
                                    //print(likes);
                                  }
                                },
                                child: Container(
                                  child: Icon(
                                    d.like != null
                                        //likePressed == true
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 20,
                                    color: d.like != null
                                        //likePressed == true
                                        ? Colors.redAccent
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Text("${d.meta.totalLikesCount}",
                                  style: TextStyle(
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black54,
                                      fontSize: 12)),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => CommentPage(d.id)),
                            // );
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
                                  child: Text(
                                      d.meta.totalCommentsCount == null
                                          ? ""
                                          : "${d.meta.totalCommentsCount}",
                                      style: TextStyle(
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black54,
                                          fontSize: 12)),
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              padding: EdgeInsets.all(3.0),
                              child: Icon(
                                Icons.send,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Text(
                                  d.meta.totalSharesCount == null
                                      ? ""
                                      : "${d.meta.totalSharesCount}",
                                  style: TextStyle(
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black54,
                                      fontSize: 12)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      // setState(() {
      //   checkIndex++;
      // });
    }

    return list;
  }

  void likeButtonPressed(index, type) async {
    var data = {
      'id': '${postList.res[index].id}',
      'type': type,
      'uid': '${postList.res[index].userId}'
    };

    print(data);

    var res = await CallApi().postData1(data, 'add/like');
    var body = json.decode(res.body);

    print(body);
  }

  Future<void> changingEmail() async {
    setState(() {
      _isEmailChanged = true;
    });

    var res = await CallApi().postData2('send-email-verification');
    print(res.body);
    print(res.statusCode);

    if (res.statusCode == 200) {
      print("res");
      print(res);
      setState(() {
        _isResetCodeSent = true;
      });
    } else {
      print("res 1");
      print(res);
    }

    setState(() {
      _isEmailChanged = false;
    });
  }

  Future<void> resetCode() async {
    setState(() {
      _isEmailChanged = true;
    });

    var data = {
      "emailToken": emailResetCodeController.text,
      "id": widget.userData['id']
    };

    var res = await CallApi().postData3(data, 'account/verfiyResetEmailCode');

    print(res.statusCode);
    print(res.body);

    if (res.statusCode == 200) {
      print("res");
      print(res);
      setState(() {
        _isChangedEmailSent = true;
      });
    } else {
      print("res 1");
      print(res);
    }

    setState(() {
      _isEmailChanged = false;
    });
  }

  Future<void> resetEmail() async {
    setState(() {
      _isEmailChanged = true;
    });

    var data = {
      "emailToken": emailResetCodeController.text,
      "email": emailResetController.text
    };

    print(data);

    var res = await CallApi().postData3(data, 'reset-email');

    print(res.statusCode);
    print(res.body);

    if (res.statusCode == 200) {
      print("res");
      print(res);
      setState(() {
        _isChangedEmailSent = false;
        _isResetCodeSent = false;
        _isEmailChanged = false;
      });

      _showChangedDialog();
    } else {
      print("res 1");
      print(res);
    }

    setState(() {
      _isEmailChanged = false;
      //_isResetCodeSent = false;
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

  Future<Null> _showChangedDialog() async {
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
                    Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          "Your email has been successfully changed.",
                          textAlign: TextAlign.center,
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
                                    left: 0, right: 0, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: header,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
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
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
