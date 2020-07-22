import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/CategoryModel/categoryModel.dart';
import 'package:chatapp_new/JSON_Model/User_Model/user_Model.dart';
import 'package:chatapp_new/JSON_Model/check.dart';
import 'package:chatapp_new/MainScreen/HomePage/homePage.dart';
import 'package:chatapp_new/MainScreen/LoginPage/loginPage.dart';
import 'package:chatapp_new/MainScreen/ProfilePages/MyProfilePage/myProfilePage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class BasicEditForm extends StatefulWidget {
  final userData;

  BasicEditForm(this.userData);
  @override
  State<StatefulWidget> createState() {
    return BasicEditFormState();
  }
}

class BasicEditFormState extends State<BasicEditForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  ScaffoldState scaffoldState;
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

  int count = 0, gen = 1, gen1 = 0, selectType = 0, userType = 0, userType1 = 0;
  SharedPreferences sharedPreferences;
  String theme = "", gender = "female", user = "";
  String typeService = "",
      productBuyer = "",
      productSeller = "",
      productCategory = "",
      typeCategory = "",
      uType = "",
      user_id = "",
      countryName = "";

  List<String> selectedCategory = [];
  var selectedCat;
  List contList = [];
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
  //List categories;
  var catList, conList;
  bool isLoading = true;
  bool isSubmit = false;
  bool isOpen = false;
  bool isEdit = false;

  List<DropdownMenuItem<String>> _dropDowntypeService,
      _dropDownBuyerItems,
      _dropDownSellerItems,
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

  @override
  void initState() {
    _dropDowntypeService = getDropDowntypeService();
    typeService = _dropDowntypeService[0].value;

    _dropDownBuyerItems = getDropDownSizeItems();
    productBuyer = _dropDownBuyerItems[0].value;

    loadConnection();

    firstNameController.text = "${widget.userData['firstName']}";
    lastNameController.text = "${widget.userData['lastName']}";
    jobTitleController.text = "${widget.userData['jobTitle']}";
    if (jobTitleController.text == "null") {
      setState(() {
        jobTitleController.text = "";
      });
    }
    aboutController.text = "${widget.userData['about']}";
    if (aboutController.text == "null") {
      setState(() {
        aboutController.text = "";
      });
    }
    gender = "${widget.userData['gender']}";
    user = "${widget.userData['userType']}";
    user_id = "${widget.userData['id']}";
    String userDropdown = "${widget.userData['dayJob']}";

    if (user == "Seller") {
      print(userDropdown);
      for (int i = 0; i < sellerOpt.length; i++) {
        print(sellerOpt[i]);
        if (sellerOpt[i] == userDropdown) {
          setState(() {
            //productSeller = sellerOpt[i];

            _dropDownSellerItems = getDropDownColorItems();
            productSeller = _dropDownSellerItems[i].value;
            uType = productSeller;
          });
        }
      }
    }

    print(widget.userData['country']);
    for (int i = 0; i < country.length; i++) {
      contList.add("${country[i]['name']}");
      if (widget.userData['country'] == country[i]['name']) {
        _dropDownCountryItems = getDropDownCountryItems();
        countryName = _dropDownCountryItems[i].value;
      }
    }

    super.initState();
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
      countryController.text = "${conList.user.country}";
      isLoading = false;
    });

    //print(contList);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
      child: isLoading
          ? Container(
              height: MediaQuery.of(context).size.height - 90,
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 0, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            isEdit == false
                                ? "Manage Basic Information"
                                : "Edit Basic Information",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.normal),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isEdit) {
                                  isEdit = false;
                                } else {
                                  isEdit = true;
                                }
                              });
                            },
                            child: Container(
                              child: Text(
                                isEdit ? "Cancel" : "Edit",
                                style: TextStyle(
                                    color: header,
                                    fontSize: 15,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
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
                            border:
                                Border.all(width: 0.5, color: Colors.black)),
                      ),
                    ],
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 12, left: 20),
                      child: Text(
                        isEdit == false
                            ? "View your basic profile information"
                            : "Update your basic profile information",
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
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 5),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: TextField(
                              controller: firstNameController,
                              enabled: isEdit ? true : false,
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
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 2.5, 20.0, 2.5),
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
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 5),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: TextField(
                              controller: lastNameController,
                              enabled: isEdit ? true : false,
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
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 2.5, 20.0, 2.5),
                                border: InputBorder.none,
                              ),
                            )),
                      ],
                    ),
                  ),
                  ////// <<<<< Last Name Field end >>>>> //////

                  ////// <<<<< Country name >>>>> //////
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
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
                                    isEdit
                                        ? DropdownButtonHideUnderline(
                                            child: Expanded(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: DropdownButton(
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontFamily: 'Oswald',
                                                  ),
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
                                          )
                                        : Container(
                                            padding: EdgeInsets.only(
                                                top: 13, bottom: 13),
                                            child: Text(
                                              "$countryName",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontFamily: 'Oswald',
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
                  ////// <<<<< Country end >>>>> //////

                  ////// <<<<< Profile Headline Field >>>>> //////
                  Container(
                    margin: EdgeInsets.only(bottom: 10, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(10),
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 5),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: TextField(
                              controller: jobTitleController,
                              enabled: isEdit ? true : false,
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
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 2.5, 20.0, 2.5),
                                border: InputBorder.none,
                              ),
                            )),
                      ],
                    ),
                  ),
                  ////// <<<<< Profile Headline Field end >>>>> //////

                  ////// <<<<< Buyer/Seller Selection >>>>> //////
                  Container(
                    margin: EdgeInsets.only(left: 25, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "User Type * : ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w300),
                        ),

                        ////// <<<<< Seller Section >>>>> //////
                        user == "Buyer"
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    user = "Seller";
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: <Widget>[
                                      isEdit
                                          ? Container(
                                              margin: EdgeInsets.only(top: 0),
                                              padding: EdgeInsets.all(1),
                                              decoration: BoxDecoration(
                                                  color: user == "Seller"
                                                      ? header
                                                      : Colors.white,
                                                  border: Border.all(
                                                      color: user == "Seller"
                                                          ? header
                                                          : Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Icon(
                                                Icons.done,
                                                size: 12,
                                                color: user == "Seller"
                                                    ? Colors.white
                                                    : Colors.black38,
                                              ),
                                            )
                                          : Container(),
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
                        user == "Seller"
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    user = "Buyer";
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: <Widget>[
                                      isEdit
                                          ? Container(
                                              margin: EdgeInsets.only(top: 0),
                                              padding: EdgeInsets.all(1),
                                              decoration: BoxDecoration(
                                                  color: user == "Buyer"
                                                      ? header
                                                      : Colors.white,
                                                  border: Border.all(
                                                      color: user == "Buyer"
                                                          ? header
                                                          : Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: Icon(
                                                Icons.done,
                                                size: 12,
                                                color: user == "Buyer"
                                                    ? Colors.white
                                                    : Colors.black38,
                                              ),
                                            )
                                          : Container(),
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
                  user == "Buyer"
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          padding: EdgeInsets.all(5),
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
                                          isEdit
                                              ? DropdownButtonHideUnderline(
                                                  child: Expanded(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: DropdownButton(
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontFamily: 'Oswald',
                                                        ),
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
                                                )
                                              : Container(
                                                  padding: EdgeInsets.only(
                                                      top: 13, bottom: 13),
                                                  child: Text(
                                                    "$productBuyer",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontFamily: 'Oswald',
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
                      : user == "Seller"
                          ? Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding:
                                          EdgeInsets.only(left: 20, right: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      margin: EdgeInsets.only(
                                          top: 10, right: 20, left: 20),
                                      child: Row(
                                        children: <Widget>[
                                          isEdit
                                              ? DropdownButtonHideUnderline(
                                                  child: Expanded(
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: DropdownButton(
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Oswald'),
                                                        value: productSeller,
                                                        items:
                                                            _dropDownSellerItems,
                                                        onChanged:
                                                            (String value) {
                                                          setState(() {
                                                            productSeller =
                                                                value;
                                                            uType =
                                                                productSeller;
                                                            //productBuyer = "";
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  padding: EdgeInsets.only(
                                                      top: 13, bottom: 13),
                                                  child: Text(
                                                    "$productSeller",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontFamily: 'Oswald',
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

                  ////// <<<<< Gender Selection >>>>> //////
                  isEdit == false
                      ? Container(
                          margin: EdgeInsets.only(right: 20, left: 5, top: 0),
                          child: Container(
                            margin: EdgeInsets.only(left: 20, top: 20),
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
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Text(
                                    "$gender",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      : Container(
                          margin: EdgeInsets.only(left: 25, top: 20),
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
                                            color: gender == "Female" ||
                                                    gender == "female"
                                                ? header
                                                : Colors.white,
                                            border: Border.all(
                                                color: gender == "Female" ||
                                                        gender == "female"
                                                    ? header
                                                    : Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Icon(
                                          Icons.done,
                                          size: 12,
                                          color: gender == "Female" ||
                                                  gender == "female"
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
                                            color: gender == "Male" ||
                                                    gender == "male"
                                                ? header
                                                : Colors.white,
                                            border: Border.all(
                                                color: gender == "Male" ||
                                                        gender == "male"
                                                    ? header
                                                    : Colors.grey),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Icon(
                                          Icons.done,
                                          size: 12,
                                          color: gender == "Male" ||
                                                  gender == "male"
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

                  Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxHeight: 200.0, minHeight: 100.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: TextField(
                                  maxLines: null,
                                  controller: aboutController,
                                  enabled: isEdit ? true : false,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Oswald',
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "About You",
                                    hintStyle: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 15,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w300),
                                    //labelStyle: TextStyle(color: Colors.white70),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        10.0, 0.0, 10.0, 0.0),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),

                  ////// <<<<< Sign up button >>>>> //////
                  isEdit
                      ? Container(
                          margin: EdgeInsets.only(bottom: 20, top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: isSubmit ? null : signUpButton,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.all(15),
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(
                                        color: isSubmit ? Colors.grey : header,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: Text(
                                      isSubmit
                                          ? "Please wait..."
                                          : "Update Basic Information",
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
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
    );
  }

  void signUpButton() async {
    if (firstNameController.text.isEmpty) {
      return _showMsg("First name is empty");
    } else if (lastNameController.text.isEmpty) {
      return _showMsg("Last name is empty");
    } else if (jobTitleController.text.isEmpty) {
      return _showMsg("Profile Headline is empty");
    } else if (countryName == "") {
      return _showMsg("Please select a country");
    } else if (aboutController.text.isEmpty) {
      return _showMsg("About You is empty");
    } else if (uType == "") {
      return _showMsg("Please select an user category");
    }

    setState(() {
      isSubmit = true;
    });
    // print(productBuyer);
    // print(productSeller);

    var data = {
      'id': user_id,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'jobTitle': jobTitleController.text,
      'gender': gender,
      'country': countryName,
      'dayJob': uType,
      'about': aboutController.text
    };

    print(data);

    var res = await CallApi().postData1(data, 'update-user-basicinfo');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', json.encode(body['user']));

      _showCompleteDialog();
    } else if (body['success'] == false) {
      _showMsg(body['message']);
    }

    setState(() {
      isSubmit = false;
    });
  }

  Future<Null> _showCompleteDialog() async {
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
                          "Basic Information has been edited successfully.",
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage(4)));
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
