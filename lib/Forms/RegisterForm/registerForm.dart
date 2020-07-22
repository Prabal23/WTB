import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/CategoryModel/categoryModel.dart';
import 'package:chatapp_new/JSON_Model/check.dart';
import 'package:chatapp_new/MainScreen/LoginPage/loginPage.dart';
import 'package:chatapp_new/MainScreen/VerifyEmailPage/verifyEmailPage.dart';
import 'package:chatapp_new/Preview/PreviewClass.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutube/flutube.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../main.dart';

class RegisterForm extends StatefulWidget {
  @override
  RegisterFormState createState() => new RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();

  ScaffoldState scaffoldState;
  bool internet = true;
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

  int count = 0,
      gen = 1,
      gen1 = 0,
      selectType = 0,
      userType = 0,
      userType1 = 0,
      signChk = 0;
  SharedPreferences sharedPreferences;
  String theme = "", gender = "female", user = "";
  String typeService = "",
      productBuyer = "",
      productSeller = "",
      productCategory = "",
      typeCategory = "",
      uType = "",
      supplier = "",
      countryName = "",
      check1 = "",
      check2 = "";

  List<String> selectedCategory = [];
  var selectedCat;

  List type = ["Seller", "Buyer"];
  List sellerOpt = [
    "Product Seller",
    "Inspection & Logistics Provider",
    "Warehouse & Fulfillment Provider",
    "Business Financier & Investor",
    "Business Agent & Virtual Assistant",
    "Web/Mobile Developer & Designer",
    "Marketing Consultant",
    "Photo & Video Grapher",
    "Business Legal Consultant",
    "Business Accountant",
    "Other Business Seller"
  ];
  List buyerOpt = ["Business Buyer"];

  List supplierOpt = [
    "Manufacturer",
    "Wholesaler, Distributer & Trader",
    "Broker Agent",
    "Employee",
    "DropShip Supplier",
  ];

  //List categories;
  var catList;
  bool isLoading = true;
  bool isSubmit = false;
  bool isOpen = false;
  bool _isPlayerReady = false;
  String _sound = "";
  String videoId;
  var data;
  YoutubePlayerController _controller;

  List<DropdownMenuItem<String>> _dropDowntypeService,
      _dropDownBuyerItems,
      _dropDownSellerItems,
      _dropDownCategoryItems,
      _dropDownSupplierItems,
      _dropDownCountryItems;

  List<DropdownMenuItem<String>> getDropDowntypeService() {
    List<DropdownMenuItem<String>> items = new List();
    for (String typeServe in type) {
      items.add(new DropdownMenuItem(
          value: typeServe,
          child: new Text(
            typeServe,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownColorItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String sellersOpt in sellerOpt) {
      items.add(new DropdownMenuItem(
          value: sellersOpt,
          child: new Text(
            sellersOpt,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownSizeItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String buyersOpt in buyerOpt) {
      items.add(new DropdownMenuItem(
          value: buyersOpt,
          child: new Text(
            buyersOpt,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownCategoryItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String cat in catList) {
      items.add(new DropdownMenuItem(
          value: cat,
          child: new Text(
            cat,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownSupplierItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String supplierList in supplierOpt) {
      items.add(new DropdownMenuItem(
          value: supplierList,
          child: new Text(
            supplierList,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownCountryItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String countryList in contList) {
      items.add(new DropdownMenuItem(
          value: countryList,
          child: new Text(
            countryList,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List contList = [];

  @override
  void initState() {
    videoId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/embed/QlTR7mI-oSc");
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      ),
    );
    //internetCheck();
    sharedPrefcheck();
    _dropDowntypeService = getDropDowntypeService();
    typeService = _dropDowntypeService[0].value;

    _dropDownBuyerItems = getDropDownColorItems();
    productBuyer = _dropDownBuyerItems[0].value;

    _dropDownSellerItems = getDropDownSizeItems();
    productSeller = _dropDownSellerItems[0].value;

    _dropDownSupplierItems = getDropDownSupplierItems();
    supplier = _dropDownSupplierItems[0].value;

    for (int i = 0; i < country.length; i++) {
      contList.add("${country[i]['name']}");
    }
    //print(contList);
    _dropDownCountryItems = getDropDownCountryItems();
    countryName = _dropDownCountryItems[0].value;
    loadCategories();
    // print("selectedCategory.length");
    // print(selectedCategory.length);
    super.initState();
  }

  void sharedPrefcheck() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      theme = sharedPreferences.getString("theme");
    });
    //print(theme);
  }

  Future loadCategories() async {
    //await Future.delayed(Duration(seconds: 3));
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("Connected to Mobile Network");
      setState(() {
        internet = true;
      });
      var response = await CallApi().getData3('allInterests');
      var content = response.body;
      final collection = json.decode(content);
      var data = Catagory.fromJson(collection);

      setState(() {
        catList = data;
        isLoading = false;
        // print("Listing");
        // print(catList);
      });
      // print("catList.interests.length");
      // print(catList.interests.length);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //print("Connected to WiFi");
      setState(() {
        internet = true;
      });
      var response = await CallApi().getData3('allInterests');
      var content = response.body;
      final collection = json.decode(content);
      var data = Catagory.fromJson(collection);

      setState(() {
        catList = data;
        isLoading = false;
        // print("Listing");
        // print(catList);
      });
      // print("catList.interests.length");
      // print(catList.interests.length);
    } else {
      setState(() {
        internet = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return internet == false
        ? Center(
            child: Text("No internet connection"),
          )
        : isLoading
            ? Center(child: CircularProgressIndicator())
            : catList == null
                ? Center(
                    child: Text(
                    "No Report has been done yet. Go to 'Start Reporting' page to report a problem",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18),
                  ))
                : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 10, left: 20),
                            child: Text(
                              "Create Network, Find Trusted",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.normal),
                            )),
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 0, left: 20),
                            child: Text(
                              "Buyers, Sellers, Communities, & Industry Updates",
                              style: TextStyle(
                                  color: header,
                                  fontSize: 14,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.bold),
                            )),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              margin: EdgeInsets.only(top: 10, left: 20),
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
                            margin: EdgeInsets.only(top: 12, left: 20),
                            child: Text(
                              "Connecting Businesses Globally",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w300),
                            )),

                        ////// <<<<< First Name Field start >>>>> //////
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: TextField(
                                    controller: firstNameController,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Oswald',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "First name *",
                                      hintStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 15,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      //labelStyle: TextStyle(color: Colors.white70),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 2.5, 20.0, 2.5),
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        ////// <<<<< First Name Field end >>>>> //////

                        ////// <<<<< Last Name Field >>>>> //////
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: TextField(
                                    controller: lastNameController,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Oswald',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Last name *",
                                      hintStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 15,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      //labelStyle: TextStyle(color: Colors.white70),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 2.5, 20.0, 2.5),
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        ////// <<<<< Last Name Field end >>>>> //////

                        ////// <<<<< User Name Field >>>>> //////
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: TextField(
                                    controller: userNameController,
                                    onChanged: (value) {
                                      if (value.contains(" ")) {
                                        setState(() {
                                          check1 = "1";
                                        });
                                      } else {
                                        setState(() {
                                          check1 = "";
                                        });
                                      }
                                    },
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Oswald',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Username *",
                                      hintStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 15,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      //labelStyle: TextStyle(color: Colors.white70),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 2.5, 20.0, 2.5),
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        ////// <<<<< User Name Field end >>>>> //////

                        check1 == ""
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(bottom: 10, top: 0),
                                child: Text(
                                  check1 == "1"
                                      ? "Username shouldn't contain any spaces"
                                      : "",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.normal),
                                ),
                              ),

                        ////// <<<<< Country name >>>>> //////
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                          padding: EdgeInsets.only(left: 20, right: 10),
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
                                          DropdownButtonHideUnderline(
                                            child: Expanded(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: DropdownButton(
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black87,
                                                      fontFamily: 'Oswald',
                                                      fontWeight:
                                                          FontWeight.w100),
                                                  value: countryName,
                                                  items: _dropDownCountryItems,
                                                  onChanged: (String value) {
                                                    setState(() {
                                                      countryName = value;
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

                        ////// <<<<< Email Field >>>>> //////
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: TextField(
                                    controller: emailController,
                                    onChanged: (value) {
                                      bool emailValid = RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value);
                                      if (value.contains(" ")) {
                                        setState(() {
                                          check2 = "1";
                                        });
                                      } else {
                                        if (emailController.text == "") {
                                          setState(() {
                                            check2 = "";
                                          });
                                        } else {
                                          if (emailValid == false) {
                                            setState(() {
                                              check2 = "2";
                                            });
                                          } else {
                                            setState(() {
                                              check2 = "";
                                            });
                                          }
                                        }
                                      }
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Oswald',
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Email *",
                                      hintStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 15,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      //labelStyle: TextStyle(color: Colors.white70),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 2.5, 20.0, 2.5),
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        ////// <<<<< Email Field end >>>>> //////

                        check2 == ""
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(bottom: 10, top: 0),
                                child: Text(
                                  check2 == "1"
                                      ? "Email shouldn't contain any spaces"
                                      : check2 == "2"
                                          ? "Invalid email format"
                                          : "",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                        ////// <<<<< Password Field >>>>> //////
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: TextField(
                                          controller: passwordController,
                                          obscureText:
                                              count % 2 != 0 ? false : true,
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontFamily: 'Oswald',
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Password *",
                                            hintStyle: TextStyle(
                                                color: Colors.black38,
                                                fontSize: 15,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w300),
                                            //labelStyle: TextStyle(color: Colors.white70),
                                            contentPadding: EdgeInsets.fromLTRB(
                                                10.0, 0.0, 20.0, 0.0),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            count++;
                                          });
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(4),
                                            child: Icon(
                                              count % 2 != 0
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              size: 22,
                                              color: count % 2 != 0
                                                  ? header
                                                  : Colors.black38,
                                            )),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        ////// <<<<< Password Field end >>>>> //////

                        ////// <<<<< Gender Selection >>>>> //////
                        Container(
                          margin: EdgeInsets.only(left: 25, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Gender * : ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w300),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    gen = 1;
                                    gen1 = 0;
                                    gender = "Female";
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 0),
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                            color: gen == 1
                                                ? header
                                                : Colors.white,
                                            border: Border.all(
                                                color: gen == 1
                                                    ? header
                                                    : Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Icon(
                                          Icons.done,
                                          size: 12,
                                          color: gen == 1
                                              ? Colors.white
                                              : Colors.black38,
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              right: 20, left: 5, top: 0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "Female",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    gen = 0;
                                    gen1 = 1;
                                    gender = "Male";
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 0),
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                            color: gen1 == 1
                                                ? header
                                                : Colors.white,
                                            border: Border.all(
                                                color: gen1 == 1
                                                    ? header
                                                    : Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Icon(
                                          Icons.done,
                                          size: 12,
                                          color: gen1 == 1
                                              ? Colors.white
                                              : Colors.black38,
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              right: 20, left: 5, top: 0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "Male",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ////// <<<<< Buyer/Seller Selection >>>>> //////
                        Container(
                          margin: EdgeInsets.only(left: 25, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Sign up as * : ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w300),
                              ),

                              ////// <<<<< Seller Section >>>>> //////
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    userType = 1;
                                    userType1 = 0;
                                    selectType = 1;
                                    user = "Seller";
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 0),
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                            color: userType == 1
                                                ? header
                                                : Colors.white,
                                            border: Border.all(
                                                color: userType == 1
                                                    ? header
                                                    : Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Icon(
                                          Icons.done,
                                          size: 12,
                                          color: userType == 1
                                              ? Colors.white
                                              : Colors.black38,
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              right: 20, left: 5, top: 0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "Seller",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),

                              ////// <<<<< Buyer Section >>>>> //////
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    userType = 0;
                                    userType1 = 1;
                                    selectType = 2;
                                    user = "Buyer";
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(top: 0),
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                            color: userType1 == 1
                                                ? header
                                                : Colors.white,
                                            border: Border.all(
                                                color: userType1 == 1
                                                    ? header
                                                    : Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Icon(
                                          Icons.done,
                                          size: 12,
                                          color: userType1 == 1
                                              ? Colors.white
                                              : Colors.black38,
                                        ),
                                      ),
                                      Container(
                                          margin: EdgeInsets.only(
                                              right: 20, left: 5, top: 0),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "Buyer",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 15,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        ////// <<<<< Buyer Dropdown >>>>> //////
                        selectType == 1
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 15),
                                padding: EdgeInsets.only(left: 20, right: 10),
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
                                                DropdownButtonHideUnderline(
                                                  child: Expanded(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: DropdownButton(
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black87,
                                                            fontFamily:
                                                                'Oswald',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w100),
                                                        value: productBuyer,
                                                        items:
                                                            _dropDownBuyerItems,
                                                        onChanged:
                                                            (String value) {
                                                          setState(() {
                                                            productBuyer =
                                                                value;
                                                            uType =
                                                                productBuyer;
                                                            //productSeller = "";
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
                              )

                            ////// <<<<< Seller Dropdown >>>>> //////
                            : selectType == 2
                                ? Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.only(
                                              left: 20, right: 10),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          margin: EdgeInsets.only(
                                              top: 15, right: 20, left: 20),
                                          child: Row(
                                            children: <Widget>[
                                              DropdownButtonHideUnderline(
                                                child: Expanded(
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: DropdownButton(
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black87,
                                                          fontFamily: 'Oswald',
                                                          fontWeight:
                                                              FontWeight.w100),
                                                      value: productSeller,
                                                      items:
                                                          _dropDownSellerItems,
                                                      onChanged:
                                                          (String value) {
                                                        setState(() {
                                                          productSeller = value;
                                                          uType = productSeller;
                                                          //productBuyer = "";
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
                                  )
                                : Container(),

                        ////// <<<<< Supplier Dropdown >>>>> //////
                        uType == "Product Seller"
                            ? Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.only(
                                            left: 20, right: 10),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        margin: EdgeInsets.only(
                                            top: 15, right: 20, left: 20),
                                        child: Row(
                                          children: <Widget>[
                                            DropdownButtonHideUnderline(
                                              child: Expanded(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: DropdownButton(
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black87,
                                                        fontFamily: 'Oswald',
                                                        fontWeight:
                                                            FontWeight.w100),
                                                    value: supplier,
                                                    items:
                                                        _dropDownSupplierItems,
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        supplier = value;
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
                              )
                            : Container(),

                        ////// <<<<< Profile Headline Field >>>>> //////
                        Container(
                          margin: EdgeInsets.only(bottom: 0, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: TextField(
                                    controller: jobTitleController,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Oswald',
                                    ),
                                    decoration: InputDecoration(
                                      hintText:
                                          "Profile Headline e. g. App Developer*",
                                      hintStyle: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 15,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      //labelStyle: TextStyle(color: Colors.white70),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          10.0, 2.5, 20.0, 2.5),
                                      border: InputBorder.none,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        ////// <<<<< Profile Headline Field end >>>>> //////

                        ////// <<<<< Category dropdown >>>>> //////

                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 0),
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 10),
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isOpen == false) {
                                      isOpen = true;
                                    } else {
                                      isOpen = false;
                                    }
                                  });
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Select Business Interests upto 3",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15,
                                            fontFamily: 'Oswald',
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black54,
                                          ))
                                    ],
                                  ),
                                ),
                              ),

                              ////// <<<<< Hidden Section start >>>>> //////
                              isOpen == true
                                  ? Container(
                                      child: Column(
                                        children: <Widget>[
                                          ///// <<<<< Selected Interest end >>>>> //////
                                          selectedCategory.length != 0
                                              ? Container(
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.black,
                                                            width: 0.5),
                                                        top: BorderSide(
                                                            color: Colors.black,
                                                            width: 0.5),
                                                      )),
                                                  margin: EdgeInsets.only(
                                                      top: 10, bottom: 15),
                                                  child: ListView.builder(
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        selectedCategory.length,
                                                    //separatorBuilder: (context, index) => Divider(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey[50],
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 5,
                                                                    right: 5,
                                                                    top: 8,
                                                                    bottom: 8),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    right: 10),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "${selectedCat[index]}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      selectedCategory
                                                                          .removeAt(
                                                                              index);
                                                                      selectedCat =
                                                                          selectedCategory;
                                                                      // print(
                                                                      //     "selectedCat");
                                                                      // print(
                                                                      //     selectedCat);
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    margin: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                5),
                                                                    child: Icon(
                                                                        Icons
                                                                            .clear),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container(),

                                          ////// <<<<< Selected Interest end >>>>> //////

                                          ///// <<<<<  Interest start >>>>> //////
                                          Container(
                                            height: 180,
                                            margin: EdgeInsets.only(top: 10),
                                            child: ListView.builder(
                                              itemCount:
                                                  catList.interests.length,
                                              //separatorBuilder: (context, index) => Divider(),
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Container(
                                                  child: GestureDetector(
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: selectedCategory
                                                                    .contains(catList
                                                                        .interests[
                                                                            index]
                                                                        .name)
                                                                ? back
                                                                : Colors
                                                                    .grey[50],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        margin: EdgeInsets.only(
                                                            bottom: 5, top: 3),
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 6,
                                                                top: 6,
                                                                left: 10,
                                                                right: 10),
                                                        child: Text(
                                                          "${catList.interests[index].name}",
                                                          style: TextStyle(
                                                              fontSize: 15),
                                                        )),
                                                    onTap: () {
                                                      setState(() {
                                                        // print(
                                                        //     "selectedCategory.length");
                                                        // print(selectedCategory
                                                        //     .length);
                                                        if (selectedCategory
                                                                .length <=
                                                            2) {
                                                          if (selectedCategory
                                                                  .length ==
                                                              0) {
                                                            selectedCategory.add(
                                                                "${catList.interests[index].name}");
                                                            selectedCat =
                                                                selectedCategory
                                                                    .toList();
                                                          } else {
                                                            if (selectedCat
                                                                .contains(catList
                                                                    .interests[
                                                                        index]
                                                                    .name)) {
                                                              selectedCategory
                                                                  .remove(catList
                                                                      .interests[
                                                                          index]
                                                                      .name);
                                                              selectedCat =
                                                                  selectedCategory;
                                                            } else {
                                                              selectedCategory.add(
                                                                  "${catList.interests[index].name}");
                                                              selectedCat =
                                                                  selectedCategory
                                                                      .toList();
                                                            }
                                                          }
                                                        } else {
                                                          _showMsg(
                                                              "You have selected 3 interests");
                                                        }
                                                      });
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          )

                                          ///// <<<<<  Interest end >>>>> //////
                                        ],
                                      ),
                                    )
                                  : Container()

                              ////// <<<<< Hidden Section end >>>>> //////
                            ],
                          ),
                        ),

                        ////// <<<<< Category dropdown end >>>>> //////

                        ////// <<<<< check box start >>>>> //////

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (signChk == 0) {
                                signChk = 1;
                              } else {
                                signChk = 0;
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 0),
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                      color:
                                          signChk == 1 ? header : Colors.white,
                                      border: Border.all(
                                          color: signChk == 1
                                              ? header
                                              : Colors.grey),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Icon(
                                    Icons.done,
                                    size: 12,
                                    color: signChk == 1
                                        ? Colors.white
                                        : Colors.black38,
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "By clicking sign up button you agree to the terms & conditions",
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 12,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                    )),
                              ],
                            ),
                          ),
                        ),

                        ////// <<<<< check box end >>>>> //////

                        ////// <<<<< Sign up button >>>>> //////
                        Container(
                          margin: EdgeInsets.only(bottom: 20, top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: isSubmit || signChk == 0
                                    ? null
                                    : signUpButton,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(15),
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(
                                        color: isSubmit || signChk == 0
                                            ? Colors.grey
                                            : header,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      isSubmit ? "Please wait..." : "Sign Up",
                                      style: TextStyle(
                                        color: isSubmit || signChk == 0
                                            ? Colors.black54
                                            : Colors.white,
                                        fontSize: 17,
                                        fontFamily: 'BebasNeue',
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                            ],
                          ),
                        ),

                        ////// <<<<< Sign in option >>>>> //////
                        Container(
                          margin: EdgeInsets.only(top: 0, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  child: Text(
                                "Already have an account?",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w300),
                              )),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      "Sign in",
                                      style: TextStyle(
                                          color: header,
                                          fontSize: 14,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w400),
                                    )),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.all(20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: false,
                              //progressIndicatorColor: Colors.blueAccent,
                              topActions: <Widget>[
                                SizedBox(width: 8.0),
                              ],
                              onReady: () {
                                // print("dfsifugsdf");
                                if (_sound == "") {
                                  setState(() {
                                    _isPlayerReady = true;
                                  });
                                } else if (_sound == "no") {
                                  setState(() {
                                    _isPlayerReady = false;
                                    print("no sound for paly");
                                  });
                                }

                                // print(_isPlayerReady);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
  }

  void signUpButton() async {
    if (firstNameController.text.isEmpty) {
      return _showMsg("First name is empty");
    } else if (lastNameController.text.isEmpty) {
      return _showMsg("Last name is empty");
    } else if (userNameController.text.isEmpty) {
      return _showMsg("Username is empty");
    } else if (emailController.text.isEmpty) {
      return _showMsg("Email is empty");
    } else if (check1 == "1") {
      return _showMsg("Invalid username");
    } else if (check1 == "2") {
      return _showMsg("Invalid email address");
    } else if (passwordController.text.isEmpty) {
      return _showMsg("Password is empty");
    } else if (jobTitleController.text.isEmpty) {
      return _showMsg("Profile Headline is empty");
    } else if (selectedCategory.length == 0) {
      return _showMsg("No interest selected");
    } else if (user == "") {
      return _showMsg("Please select an user type");
    } else if (uType == "") {
      return _showMsg("Please select an user category");
    }

    setState(() {
      isSubmit = true;
    });
    // print(productBuyer);
    // print(productSeller);

    var data = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'userName': userNameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'jobTitle': jobTitleController.text,
      'gender': gender,
      'interests': selectedCategory,
      'userType': user,
      'dayJob': uType,
      'supplier_type': supplier,
      'country': countryName,
    };

    //print(data);

    var res = await CallApi().postData(data, 'user-signup');
    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));

      _showCompleteDialog();
    } else if (body['success'] == false) {
      print(body['errorMessage']);
      for (var i = 0; i < body['errorMessage'].length; i++) {
        print('addfadfadf');
        _showMsg(body['errorMessage'][i]['message']);
      }
    }

    setState(() {
      isSubmit = false;
    });
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
                        decoration: BoxDecoration(
                            border: Border.all(color: header, width: 1.5),
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white),
                        child: Icon(
                          Icons.done,
                          color: header,
                          size: 50,
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 12),
                        child: Text(
                          "An email with verification code has been sent to your email address. Enter that code to verify your account",
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VerifyEmailPage()));
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
