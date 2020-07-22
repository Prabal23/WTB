import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class StatusLoader extends StatefulWidget {
  @override
  _StatusLoaderState createState() => _StatusLoaderState();
}

class _StatusLoaderState extends State<StatusLoader> {
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
    return Scaffold(
      body: PostLoader(),
    );
  }
}

class PostLoader extends StatefulWidget {
  @override
  _PostLoaderState createState() => _PostLoaderState();
}

class _PostLoaderState extends State<PostLoader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 10),
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
      margin: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 0),
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ////// <<<<< Picture >>>>> //////
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(1.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[200],
                        child: CircleAvatar(
                          radius: 20.0,
                          //backgroundColor: Colors.white,
                        ),
                      ),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ////// <<<<< User Name >>>>> //////
                        Shimmer.fromColors(
                          baseColor: Colors.grey[100],
                          highlightColor: Colors.grey[200],
                          child: Container(
                            width: 100,
                            height: 22,
                            child: Container(
                              color: Colors.black,
                            ),
                          ),
                        ),

                        ////// <<<<< Time >>>>> //////
                        Container(
                          margin: EdgeInsets.only(top: 3),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[100],
                            highlightColor: Colors.grey[200],
                            child: Container(
                              width: 50,
                              height: 12,
                              child: Container(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          ////// <<<<< Status >>>>> //////
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ////// <<<<< Line 1 >>>>> //////
              Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[200],
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 10,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                  )),

              ////// <<<<< Line 2 >>>>> //////
              Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 5),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[100],
                    highlightColor: Colors.grey[200],
                    child: Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 10,
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
