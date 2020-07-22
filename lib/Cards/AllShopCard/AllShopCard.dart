import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/MainScreen/ProductDetails/productDetails.dart';
import 'package:chatapp_new/MainScreen/ShopPage/shopPage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class AllShopCard extends StatefulWidget {
  var shopList;
  AllShopCard(this.shopList);
  @override
  _AllShopCardState createState() => _AllShopCardState();
}

class _AllShopCardState extends State<AllShopCard> {
  String img = "";
  List imgList = [];
  int _current = 0;
  var userData;

  @override
  void initState() {
    // img = "${widget.productList.singleImage.image}";
    // if (img.contains("localhost")) {
    //   img = img.replaceAll("localhost", "http://10.0.2.2");
    // }

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
                      ShopPage(widget.shopList.id, userData['id'])),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 0, top: 5, left: 2.5, right: 2.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 16.0,
                  color: Colors.grey[300],
                  //offset: Offset(3.0, 4.0),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.only(bottom: 0),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(children: <Widget>[
                      ////// <<<<< Product Image >>>>> //////
                      Stack(
                        children: <Widget>[
                          Container(
                              height: 170,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      left: 10, right: 10, top: 10),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 0.2, color: Colors.grey)),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.shopList.banner,
                                    placeholder: (context, url) =>
                                        Center(child: Text("Please Wait...")),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      "assets/images/shop_banner.jpg",
                                      height: 40,
                                      //fit: BoxFit.cover,
                                    ),
                                    //fit: BoxFit.cover,
                                    // NetworkImage(
                                    //     widget.friend[index].profilePic
                                  ))),
                        ],
                      ),
                      Center(
                        child: Container(
                          height: 60,
                          width: 60,
                          margin: EdgeInsets.only(top: 135),
                          padding: EdgeInsets.all(1.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: widget.shopList.logo,
                              placeholder: (context, url) =>
                                  Center(child: Text("")),
                              errorWidget: (context, url, error) => Image.asset(
                                  "assets/images/shop_logo.jpg",
                                  fit: BoxFit.cover),
                              fit: BoxFit.cover,
                            ),
                          ),
                          decoration: new BoxDecoration(
                              color: Colors.grey[300],
                              //shape: BoxShape.circle,
                              // image: DecorationImage(
                              //     image: AssetImage("assets/images/no_image.png"),
                              //     fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(100)),
                        ),
                      ),
                    ]),
                  ),

                  ////// <<<<< Divider 1 >>>>> //////
                  Divider(
                    color: Colors.grey[300],
                  ),

                  ////// <<<<< Product Name >>>>> //////
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                              widget.shopList.shopName != null
                                  ? "${widget.shopList.shopName}"
                                  : "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: "Oswald",
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
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
                          margin: EdgeInsets.only(top: 0, left: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                widget.shopList.meta.productsCount != null
                                    ? "Products Uploaded: ${widget.shopList.meta.productsCount}"
                                    : "",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontFamily: "Oswald",
                                    color: Colors.black54,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  ////// <<<<< Seller start >>>>> //////
                  Container(
                    margin: EdgeInsets.only(top: 7),
                    padding: EdgeInsets.only(right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 0, left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          "Seller: ",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: "Oswald",
                                              color: Colors.black54,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        Expanded(
                                          child: Container(
                                            margin: EdgeInsets.only(right: 5),
                                            child: Text(
                                              "${widget.shopList.seller.firstName} ${widget.shopList.seller.lastName}",
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
                                        ),
                                      ],
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
                  ////// <<<<< Seller end >>>>> //////

                  ////// <<<<< Product Rating >>>>> //////
                  Container(
                    margin: EdgeInsets.only(top: 8, left: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin:
                                EdgeInsets.only(right: 8, top: 0, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                          fontWeight: FontWeight.bold)),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 3),
                                    child: Text("(0)",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            fontFamily: "Oswald",
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ////// <<<<< Country start >>>>> //////
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "${widget.shopList.location}",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Oswald",
                                    color: Colors.black38,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: header,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.verified_user,
                                size: 13,
                                color: Colors.white,
                              ),
                              Text("Verified",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Oswald",
                                      fontSize: 10)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  ////// <<<<< Country end >>>>> //////
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
