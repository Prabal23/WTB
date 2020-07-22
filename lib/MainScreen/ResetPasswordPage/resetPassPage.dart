import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatapp_new/Forms/ResetPassForm/resetPassForm.dart';
import 'package:chatapp_new/Forms/VerifyEmailForm/verifyEmailForm.dart';
import 'package:chatapp_new/Forms/VerifyPassForm/verifyPassForm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class ResetPassPage extends StatefulWidget {
  final token;
  ResetPassPage(this.token);
  @override
  State<StatefulWidget> createState() {
    return ResetPassPageState();
  }
}

class ResetPassPageState extends State<ResetPassPage> {
  int page = 0;
  int count = 0, tnc = 0;
  SharedPreferences sharedPreferences;
  String theme = "";

  @override
  void initState() {
    sharedPrefcheck();
    super.initState();
  }

  void sharedPrefcheck() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      theme = sharedPreferences.getString("theme");
    });
    //print(theme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 0),
                        child: Container(
                            margin: EdgeInsets.only(top: 10, left: 5),
                            child: BackButton(color: Colors.grey)),
                      ),
                      ResetPassForm(widget.token)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
