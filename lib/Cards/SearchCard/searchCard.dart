import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_new/MainScreen/ProductDetails/productDetails.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/FriendsProfilePage/friendsProfilePage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/MyProfilePage/myProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:meet_network_image/meet_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class SearchCard extends StatefulWidget {
  final searchResult;
  final sp;
  SearchCard(this.searchResult, this.sp);
  @override
  SearchCardState createState() => SearchCardState();
}

class SearchCardState extends State<SearchCard> {
  int _current = 0;
  int _isBack = 0;
  String result = '', img = "";
  bool _isChecked = false;
  SharedPreferences sharedPreferences;
  String theme = "";
  Timer _timer;
  int _start = 3;
  bool loading = true;
  TextEditingController src = new TextEditingController();

  @override
  void initState() {
    //friendname.addAll(name);
    // img = "${widget.searchResult.singleImage.image}";
    // if (img.contains("localhost")) {
    //   img = img.replaceAll("localhost", "http://10.0.2.2");
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.sp == "2"
            ? Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyProfilePage(widget.searchResult['user'])),
              )
            : widget.searchResult['type'] == "user"
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FriendsProfilePage(
                            widget.searchResult['user']['userName'], 2)),
                  )
                : null;
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          //border: Border.all(width: 0.8, color: Colors.grey[300]),
          boxShadow: [
            BoxShadow(
              blurRadius: 1.0,
              color: Colors.black38,
              //offset: Offset(6.0, 7.0),
            ),
          ],
        ),
        margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                //color: Colors.red,
                margin: EdgeInsets.only(left: 15, right: 20, top: 0),
                padding: EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          width: 70,
                          height: 70,
                          padding: EdgeInsets.all(1.0),
                          child: widget.searchResult['type'] == "group"
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                      imageUrl:
                                          "${widget.searchResult['logo']}",
                                      placeholder: (context, url) => Center(
                                              child: Text(
                                            "Please Wait...",
                                            textAlign: TextAlign.center,
                                          )),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                            "assets/images/placeholder_cover.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                      fit: BoxFit.cover),
                                )
                              : widget.sp == "2"
                                  ? widget.searchResult['profilePic']
                                              .contains("Female.jpeg") ||
                                          widget.searchResult['profilePic']
                                              .contains("Male.jpeg")
                                      ? Image.asset("assets/images/user.png")
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "${widget.searchResult['profilePic']}",
                                            placeholder: (context, url) =>
                                                Center(
                                                    child: Text(
                                              "Please Wait...",
                                              textAlign: TextAlign.center,
                                            )),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              "assets/images/user.png",
                                              fit: BoxFit.cover,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                          imageUrl: widget
                                                      .searchResult['type'] ==
                                                  "user"
                                              ? "${widget.searchResult['user']['profilePic']}"
                                              : "${widget.searchResult['logo']}",
                                          placeholder: (context, url) =>
                                              Container(
                                                  child: Center(
                                                      child: Text(
                                                "Please Wait...",
                                                textAlign: TextAlign.center,
                                              ))),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  "assets/images/user.png"),
                                          fit: BoxFit.cover),
                                    ),
                          decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.sp == "2"
                                ? "${widget.searchResult['firstName']} ${widget.searchResult['lastName']}"
                                : "${widget.searchResult['name']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w400),
                          ),
                          widget.sp == "2"
                              ? Text(
                                  "${widget.searchResult['dayJob']}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: header,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w400),
                                )
                              : widget.searchResult['type'] == "user"
                                  ? Text(
                                      "${widget.searchResult['user']['dayJob']}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: header,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w400),
                                    )
                                  : Container(),
                          widget.sp == "2"
                              ? Text(
                                  "${widget.searchResult['jobTitle']}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w400),
                                )
                              : widget.searchResult['type'] == "user"
                                  ? Text(
                                      "${widget.searchResult['user']['jobTitle']}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w400),
                                    )
                                  : Container(),
                          widget.sp == "2"
                              ? Container()
                              : widget.searchResult['type'] == "user"
                                  ? widget.searchResult['user']
                                              ['isUserVerified'] ==
                                          "Yes"
                                      ? Container(
                                          width: 65,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                              color: header,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Verified",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Icon(Icons.done,
                                                  color: Colors.white, size: 14)
                                            ],
                                          ),
                                        )
                                      : Container()
                                  : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // setState(() {
                //   friendname.removeAt(widget.index);
                // });
              },
              child: Container(
                child: Icon(Icons.chevron_right,
                    color: Colors.black.withOpacity(0.5), size: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
