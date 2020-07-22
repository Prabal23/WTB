import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/MainScreen/ProductDetails/productDetails.dart';
import 'package:chatapp_new/MainScreen/ShopPage/shopPage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class MarketplaceLandCard extends StatefulWidget {
  var productList;
  MarketplaceLandCard(this.productList);
  @override
  _MarketplaceLandCardState createState() => _MarketplaceLandCardState();
}

class _MarketplaceLandCardState extends State<MarketplaceLandCard> {
  String img = "", day = "";
  List imgList = [];
  int _current = 0;
  var userData;

  @override
  void initState() {
    print("widget.productList.created_at");
    print(widget.productList.created_at);
    DateTime date1 = DateTime.parse("${widget.productList.created_at}");

    print("date1");
    print(date1);

    day = DateFormat.yMMMd().format(date1);

    for (int i = 0; i < widget.productList.images.length; i++) {
      imgList.add(widget.productList.images[i].image);
    }

    getUser();

    super.initState();
  }

  Future getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);

    setState(() {
      userData = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailsPage(widget.productList.id)),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 0, top: 5, left: 2.5, right: 2.5),
            padding: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              //border: Border.all(width: 0.5, color: Colors.grey),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10.0,
                  color: Colors.grey[300],
                  //offset: Offset(3.0, 4.0),
                ),
              ],
            ),
            child: Container(
              //width: 100,
              padding: EdgeInsets.only(bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      //height: 150,
                      child: Container(
                    child: Stack(children: <Widget>[
                      ////// <<<<< Product Image >>>>> //////
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 300,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  color: Colors.white,
                                ),
                                child: CarouselSlider(
                                  //height: 400.0,
                                  initialPage: 0,
                                  enlargeCenterPage: true,
                                  autoPlay: false,
                                  reverse: false,
                                  enableInfiniteScroll: true,
                                  autoPlayInterval: Duration(seconds: 2),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 2000),
                                  pauseAutoPlayOnTouch: Duration(seconds: 10),
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _current = index;
                                    });
                                  },
                                  items: imgList.map((imgUrl) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailsPage(
                                                            widget.productList
                                                                .id)),
                                              );
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: imgUrl,
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child: Text(
                                                          "Please Wait...")),
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
                                        );
                                      },
                                    );
                                  }).toList(),
                                ),
                              )),
                          Container(
                            height: 300,
                            width: 130,
                            alignment: Alignment.topRight,
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(5),
                                  color: Colors.grey[500],
                                  child: Text(
                                    "${_current + 1}/${imgList.length}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Oswald"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      ////// <<<<< Product Tag >>>>> //////
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              color: header,
                              child: Icon(
                                Icons.verified_user,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                  )),

                  ////// <<<<< Divider 1 >>>>> //////
                  VerticalDivider(
                    color: Colors.grey[300],
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ////// <<<<< Product Name >>>>> //////
                            Container(
                              margin: EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                        widget.productList.productName != null
                                            ? "${widget.productList.productName}"
                                            : "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: "Oswald",
                                            fontSize: 15,
                                            color: Colors.black87)),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),

                            ////// <<<<< Product Price >>>>> //////
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 0, left: 6),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.attach_money,
                                          color: Colors.black87,
                                          size: 18,
                                        ),
                                        Text(
                                          widget.productList.lowerPrice !=
                                                      null &&
                                                  widget.productList
                                                          .upperPrice !=
                                                      null
                                              ? "${widget.productList.lowerPrice}" +
                                                  "-" +
                                                  "${widget.productList.upperPrice}"
                                              : "",
                                          style: TextStyle(
                                              fontFamily: "Oswald",
                                              fontSize: 16,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ////// <<<<< Qnt start >>>>> //////
                            widget.productList.minimumOrderQuantity == null &&
                                    (widget.productList.unit == "" ||
                                        widget.productList.unit == null)
                                ? Container()
                                : Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin:
                                              EdgeInsets.only(top: 5, left: 10),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "${widget.productList.minimumOrderQuantity} ${widget.productList.unit}",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: "Oswald",
                                                    color: Colors.black54,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              Text(
                                                " (MOQ)",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: "Oswald",
                                                    color: Colors.black38,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ////// <<<<< Qnt end >>>>> //////

                            ////// <<<<< Comp start >>>>> //////
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5, left: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "Completion time : ",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontFamily: "Oswald",
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${widget.productList.estimatedDeliveryDays} days",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily: "Oswald",
                                                  color: Colors.black38,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ////// <<<<< Comp end >>>>> //////

                            ////// <<<<< Seller start >>>>> //////
                            Container(
                              margin: EdgeInsets.only(top: 7),
                              padding: EdgeInsets.only(right: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 0, left: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "Seller : ",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontFamily: "Oswald",
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      child: Text(
                                                        "${widget.productList.shop.shopName}",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontFamily:
                                                                "Oswald",
                                                            color:
                                                                Colors.black38,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ShopPage(
                                                    widget.productList.shopId,
                                                    userData['id'])));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                            color: header,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text("View Shop",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: "Oswald",
                                                fontSize: 10)),
                                      ))
                                ],
                              ),
                            ),
                            ////// <<<<< Seller end >>>>> //////

                            ////// <<<<< Country start >>>>> //////
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 5, left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "${widget.productList.country}",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: "Oswald",
                                              color: Colors.black38,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ////// <<<<< Country end >>>>> //////

                            ////// <<<<< Product Rating >>>>> //////
                            Container(
                              margin: EdgeInsets.only(top: 7, left: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: 8, top: 0, bottom: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.star,
                                            size: 13,
                                            color: header,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 3),
                                            child: Text("0.0",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                    fontFamily: "Oswald",
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 3),
                                              child: Text("(0)",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.grey,
                                                      fontFamily: "Oswald",
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ////// <<<<< Product Arrival Time >>>>> //////
                                  Container(
                                    //color: Colors.red,
                                    margin: EdgeInsets.only(
                                        right: 8, top: 0, bottom: 0, left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.timer,
                                          size: 13,
                                          color: header,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 3),
                                          child: Text("$day",
                                              style: TextStyle(
                                                  fontFamily: "Oswald",
                                                  color: Colors.grey,
                                                  fontSize: 12)),
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
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
