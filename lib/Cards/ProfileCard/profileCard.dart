import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/BusinessModel/BusinessModel.dart';
import 'package:chatapp_new/JSON_Model/User_Model/user_Model.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/MyProfilePage/myProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../main.dart';

class ProfileCard extends StatefulWidget {
  final userData;
  ProfileCard(this.userData);
  @override
  ProfileCardState createState() => ProfileCardState();
}

class ProfileCardState extends State<ProfileCard> {
  SharedPreferences sharedPreferences;
  String theme = "",
      image = "",
      fName = "",
      lName = "",
      verified = "",
      businessInfoProvided = "";
  Timer _timer;
  int _start = 3, shopProvided = 0;
  bool loading = true;
  bool _isVerified = false;
  bool _isPending = false;
  bool _isBusiness = false;
  bool _isVerification = true;

  @override
  void initState() {
    // sharedPrefcheck();
    // timerCheck();
    print(widget.userData);
    //showUser();

    loadConnection();

    setState(() {
      image = "${widget.userData['profilePic']}";
      fName = "${widget.userData['firstName']}";
      lName = "${widget.userData['lastName']}";
      shopProvided = widget.userData['isShopCreated'];
      verified = "${widget.userData['isUserVerified']}";
      businessInfoProvided = "${widget.userData['isBusinessInfoProvided']}";
    });

    // if (verified == "Yes" && businessInfoProvided == "Yes") {
    //   setState(() {
    //     _isVerified = true;
    //   });
    // }
    super.initState();
  }

  Future loadConnection() async {
    //await Future.delayed(Duration(seconds: 3));
    var conList;
    var response = await CallApi()
        .getData('profile/${widget.userData['userName']}?tab=connection');
    var content = response.body;
    final collection = json.decode(content);
    var data = Connection.fromJson(collection);

    setState(() {
      _isVerification = false;
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
  }

  Future showUser() async {
    setState(() {
      loading = true;
    });
    //await Future.delayed(Duration(seconds: 3));
    var postresponse = await CallApi().getData1('initData');
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
    fName = user['firstName'];
    lName = user['lastName'];
    verified = user['isUserVerified'];
    businessInfoProvided = user['isBusinessInfoProvided'];
    loading = false;

    if (shopProvided == 1 && verified == "No" ||
        businessInfoProvided == "Yes") {
      setState(() {
        _isPending = true;
        _isVerified = false;
      });
    }
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

    // setState(() {
    //   showUser();
    //   //loading = false;
    // });
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

  // void sharedPrefcheck() async {
  //   sharedPreferences = await SharedPreferences.getInstance();

  //   setState(() {
  //     theme = sharedPreferences.getString("theme");
  //   });
  //   //print(theme);
  // }

  // void timerCheck() {
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = new Timer.periodic(
  //     oneSec,
  //     (Timer timer) => setState(
  //       () {
  //         if (_start < 1) {
  //           timer.cancel();
  //           setState(() {
  //             loading = false;
  //           });
  //         } else {
  //           _start = _start - 1;
  //         }
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyProfilePage(widget.userData)));
          //_showMsg("Coming Soon");
        },

        ////// <<<<< Main Data >>>>> //////
        child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                blurRadius: 5.0,
                color: Colors.grey[300],
                //offset: Offset(3.0, 4.0),
              ),
            ],
            //border: Border.all(width: 1.0, color: Colors.grey[300]),
          ),
          margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 0, right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                  padding: EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ////// <<<<< Profile picture >>>>> //////
                      Stack(
                        children: <Widget>[
                          ////// <<<<< Picture >>>>> //////
                          Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(1.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                imageUrl: image,
                                placeholder: (context, url) =>
                                    Center(child: Text("wait...")),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "assets/images/user.png",
                                  //height: 40,
                                ),
                                fit: BoxFit.cover,

                                // NetworkImage(
                                //     widget.friend[index].profilePic
                              ),
                            ),
                            decoration: new BoxDecoration(
                              //color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),

                          ////// <<<<< Online Green Dot >>>>> //////
                          Container(
                            margin: EdgeInsets.only(left: 40, top: 5),
                            padding: EdgeInsets.all(1.0),
                            child: CircleAvatar(
                              radius: 5.0,
                              backgroundColor: Colors.greenAccent,
                            ),
                            decoration: new BoxDecoration(
                              color: Colors.greenAccent, // border color
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),

                      ////// <<<<< User Name >>>>> //////
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              fName != "" && lName != ""
                                  ? '$fName ' + '$lName'
                                  : '',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.black,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w400),
                            ),

                            ////// <<<<< View Profile Option >>>>> //////
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              child: Text(
                                "View and edit profile",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ////// <<<<< Verify Button >>>>> //////
            _isVerification?Container(margin: EdgeInsets.only(right: 15),
              child: CircularProgressIndicator()):  widget.userData['userType'] == "Seller"
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_isBusiness == false) {
                            _showCompleteDialog();
                          } else {
                            if (_isPending == false && _isVerified == false) {
                              verifyUser();
                              _isPending = true;
                              _isVerified = false;
                            }
                          }
                          // else if (verified != "Yes" &&
                          //     businessInfoProvided == "Yes") {
                          //   if (_isPending == false) {
                          //     verifyUser();
                          //   }
                          // } else {
                          //   if (_isVerified == false) {
                          //     _isVerified = true;
                          //   }
                          // }
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.only(right: 15),
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                              color: _isVerified == true && _isPending == false
                                  ? header
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 3),
                                child: Text(
                                    _isPending == true && _isVerified == false
                                        ? "Verification Pending"
                                        : _isPending == false &&
                                                _isVerified == false
                                            ? "Verify"
                                            : "Verified",
                                    style: TextStyle(
                                        color: _isVerified == true &&
                                                _isPending == false
                                            ? Colors.white
                                            : Colors.black54,
                                        fontSize: 12,
                                        fontFamily: "Oswald")),
                              ),
                              Icon(
                                  _isPending == false && _isVerified == true
                                      ? Icons.verified_user
                                      : Icons.info,
                                  color:
                                      _isPending == false && _isVerified == true
                                          ? Colors.white
                                          : Colors.black54,
                                  size: 13)
                            ],
                          )),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
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
}
