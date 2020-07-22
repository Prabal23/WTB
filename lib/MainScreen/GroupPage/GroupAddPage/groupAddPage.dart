import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/GroupFriendAddCard/groupFriendAddCard.dart';
import 'package:chatapp_new/Loader/FriendsLoader/friendLoader.dart';
import 'package:chatapp_new/MainScreen/GroupPage/groupPage.dart';
import 'package:chatapp_new/MainScreen/HomePage/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';

import '../../../main.dart';

class GroupAddPage extends StatefulWidget {
  @override
  _GroupAddPageState createState() => new _GroupAddPageState();
}

class _GroupAddPageState extends State<GroupAddPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _current = 0;
  int _isBack = 0;
  String result = '';
  bool _isChecked = false;
  bool isSubmit = false;
  var friendname = List<String>();
  SharedPreferences sharedPreferences;
  String theme = "", interest = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;
  TextEditingController nameController = new TextEditingController();
  TextEditingController aboutController = new TextEditingController();
  List<DropdownMenuItem<String>> _dropDownInterest;
  List interestcategory = [
    "General International Trade",
    "Buyers",
    "Sellers",
    "General Business",
  ];

  @override
  void initState() {
    print(user.length);
    _dropDownInterest = getDropDownInterest();
    interest = _dropDownInterest[0].value;
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
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  List<DropdownMenuItem<String>> getDropDownInterest() {
    List<DropdownMenuItem<String>> items = new List();
    for (String interestList in interestcategory) {
      items.add(new DropdownMenuItem(
          value: interestList,
          child: new Text(
            interestList,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
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
                          "Create Group",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.normal),
                        )),
                  ),
                ),
                // Container(
                //     margin: EdgeInsets.only(right: 10),
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "Next",
                //       style: TextStyle(
                //           color: header,
                //           fontSize: 15,
                //           fontFamily: 'Oswald',
                //           fontWeight: FontWeight.normal),
                //     )),
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
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          "Community Name",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.normal),
                        )),
                    Container(
                      child: Row(
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
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(5),
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 0),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Icon(Icons.people_outline,
                                          color: Colors.black45, size: 20)),
                                  Flexible(
                                    child: TextField(
                                      onChanged: (value) {},
                                      controller: nameController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Oswald',
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Type Community Name",
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
                    Container(
                        width: 50,
                        margin: EdgeInsets.only(
                            top: 5, left: 25, right: 25, bottom: 5),
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
                            border: Border.all(width: 0.5, color: header))),
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          "About Community",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.normal),
                        )),
                    Container(
                      child: Row(
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
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(5),
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 0),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      margin: EdgeInsets.only(left: 5, top: 5),
                                      child: Icon(Icons.info_outline,
                                          color: Colors.black45, size: 20)),
                                  Flexible(
                                    child: TextField(
                                      //maxLength: 300,
                                      maxLines: 4,
                                      onChanged: (value) {},
                                      controller: aboutController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Oswald',
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Type Summary",
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
                    Container(
                        width: 50,
                        margin: EdgeInsets.only(
                            top: 5, left: 25, right: 25, bottom: 5),
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
                            border: Border.all(width: 0.5, color: header))),
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          "Community interest category",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.normal),
                        )),
                    Container(
                      child: Row(
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
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.list,
                                              color: Colors.black45, size: 20)),
                                      DropdownButtonHideUnderline(
                                        child: Expanded(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: DropdownButton(
                                              hint: Text("Select"),
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black54,
                                                  fontFamily: 'Oswald',
                                                  fontWeight: FontWeight.w100),
                                              value: interest,
                                              items: _dropDownInterest,
                                              onChanged: (String value) {
                                                setState(() {
                                                  interest = value;
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
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20, top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: GestureDetector(
                                onTap: isSubmit ? null : createGroup,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(15),
                                    margin: EdgeInsets.only(left: 20, right: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        border: Border.all(width: 0.2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 17,
                                        fontFamily: 'BebasNeue',
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: GestureDetector(
                                onTap: () {
                                  if (!isSubmit) {
                                    createGroup();
                                  }
                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(15),
                                    margin: EdgeInsets.only(left: 5, right: 20),
                                    decoration: BoxDecoration(
                                        color: isSubmit ? Colors.grey : header,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Text(
                                      isSubmit ? "Please wait..." : "Create",
                                      style: TextStyle(
                                        color: isSubmit
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 17,
                                        fontFamily: 'BebasNeue',
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
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
        ));
  }

  void createGroup() async {
    //await Future.delayed(Duration(seconds: 3));
    if (nameController.text.isEmpty) {
      return _showMsg("Community name is empty");
    } else if (aboutController.text.isEmpty) {
      return _showMsg("About is empty");
    } else {
      var data = {
        'name': nameController.text,
        'about': aboutController.text,
        'category': interest,
      };

      print(data);

      setState(() {
        isSubmit = true;
      });

      var postresponse = await CallApi().postData1(data, 'create/community');
      print(postresponse);
      var postcontent = postresponse.body;
      print("postcontent");
      print(postcontent);

      if (postresponse.statusCode == 200) {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GroupPage()));
      }
    }

    setState(() {
      isSubmit = false;
    });
  }
}
