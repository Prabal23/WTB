import 'package:chatapp_new/Loader/NotificationLoader/notifyLoader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class NotificationCard extends StatefulWidget {
  final notifyList;
  final loading;
  NotificationCard(this.notifyList, this.loading);
  @override
  NotificationCardState createState() => NotificationCardState();
}

class NotificationCardState extends State<NotificationCard> {
  SharedPreferences sharedPreferences;
  String theme = "", daysAgo = "";
  Timer _timer;
  int _start = 3;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          List day = [];
          for (int i = 0; i < widget.notifyList.length; i++) {
            DateTime date1 =
                DateTime.parse("${widget.notifyList[i].created_at}");

            daysAgo = DateFormat.yMMMd().format(date1);
            day.add(daysAgo);
          }
          return widget.loading == false
              ? Container(
                  padding: EdgeInsets.only(top: 0, bottom: 0),
                  decoration: BoxDecoration(
                    color: widget.notifyList[index].seen == "No"
                        ? Colors.grey.withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 1.0,
                        color: widget.notifyList[index].seen == "No"
                            ? Colors.grey.withOpacity(0.1)
                            : Colors.black38.withOpacity(0.3),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(
                      top: 2.5, bottom: 2.5, left: 10, right: 10),
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: Row(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            ////// <<<<< Picture >>>>> //////
                            // Container(
                            //   margin: EdgeInsets.only(right: 0, top: 0),
                            //   padding: EdgeInsets.all(1.0),
                            //   child: CircleAvatar(
                            //     radius: 25.0,
                            //     backgroundColor: Colors.transparent,
                            //     backgroundImage: index % 2 == 0
                            //         ? AssetImage('assets/images/man.png')
                            //         : AssetImage('assets/images/man2.jpg'),
                            //   ),
                            //   decoration: new BoxDecoration(
                            //     color: Colors.grey[300],
                            //     shape: BoxShape.circle,
                            //   ),
                            // ),

                            ////// <<<<< React Icon along with picture >>>>> //////
                            Container(
                              margin: EdgeInsets.only(left: 0, top: 0),
                              padding: EdgeInsets.all(4.0),
                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(width: 0.4, color: header)),
                              child: Icon(
                                Icons.notifications,
                                size: 15,
                                color: header,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    children: <TextSpan>[
                                      ////// <<<<< Who reacted >>>>> //////
                                      TextSpan(
                                          text:
                                              "${widget.notifyList[index].name}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w400,
                                          )),

                                      ////// <<<<< Reacted for what >>>>> //////
                                      TextSpan(
                                          text:
                                              " ${widget.notifyList[index].notiTxt}",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w300,
                                          )),
                                    ],
                                  ),
                                ),

                                ////// <<<<< Time >>>>> //////
                                Container(
                                  margin: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "${day[index]}",
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        ////// <<<<< More Icon >>>>> //////
                        Container(
                            margin: EdgeInsets.only(left: 12, right: 0),
                            child: Icon(
                              Icons.more_horiz,
                              color: Colors.black45,
                            ))
                      ],
                    ),
                  ),
                )

              ////// <<<<< Loader >>>>> //////
              : NotifyLoaderCard();
        }, childCount: widget.notifyList.length),
      ),
    );
  }
}
