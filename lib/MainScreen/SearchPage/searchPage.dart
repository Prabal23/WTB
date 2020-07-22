import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/SearchCard/searchCard.dart';
import 'package:chatapp_new/JSON_Model/CategoryModel/categoryModel.dart';
import 'package:chatapp_new/JSON_Model/ProductsrchModel/productsrchModel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../main.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  int _current = 0;
  int _isBack = 0;
  int activePage = 1;
  String result = '';
  bool _isChecked = false;
  bool isOpen = false;
  List<String> selectedCategory = [];
  var selectedCat;
  SharedPreferences sharedPreferences;
  String theme = "", productCategory = "", seller = "", sp = "";
  bool loading = false, isLoading = true;
  var searchList;
  TextEditingController src = new TextEditingController();
  TextEditingController controller = new TextEditingController();
  List category = ["People", "SUV", "Mercedes", "Audi"];
  List sellerOpt = [
    "Select Type",
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
  List<DropdownMenuItem<String>> _dropDownCategoryService;
  String supLoc = "";
  List contList = [];
  List<DropdownMenuItem<String>> _dropDownCountryItems, _dropDownBuyerItems;

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

  var catList;

  @override
  void initState() {
    //print(user.length);
    //friendname.addAll(name);
    //searchData("");
    loadCategories();
    searchResult("All");
    _dropDownCategoryService = getDropDownCategoryItems();
    productCategory = _dropDownCategoryService[0].value;

    contList.add("Select Country");

    for (int i = 0; i < country.length; i++) {
      contList.add("${country[i]['name']}");
    }
    _dropDownCountryItems = getDropDownCountryItems();
    supLoc = _dropDownCountryItems[0].value;

    _dropDownBuyerItems = getDropDownColorItems();
    seller = _dropDownBuyerItems[0].value;

    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownCategoryItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String cat in category) {
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

  Future searchData(String result) async {
    setState(() {
      loading = true;
    });
    //await Future.delayed(Duration(seconds: 3));
    var searchtresponse = await CallApi()
        .getData('filter/title?keyword=$result&page=$activePage');
    var searchcontent = searchtresponse.body;
    final searchs = json.decode(searchcontent);
    var searchdata = ProductSearchModel.fromJson(searchs);

    setState(() {
      searchList = searchdata;
    });
    setState(() {
      loading = false;
    });
    // print("searchList.searchResult.length");
    // print(searchList.searchResult.length);
  }

  Future searchResult(String value) async {
    setState(() {
      loading = true;
      result = value;
    });
    print(value);
    var data = {
      'str': value == "" ? "All" : value,
    };

    print(data);

    await Future.delayed(Duration(seconds: 1));

    var res = await CallApi().postData1(data, 'search');
    var body = json.decode(res.body);

    setState(() {
      searchList = body;
      loading = false;
      sp = "1";
    });
    print(searchList);
    //print(searchList['searchResult'].length);
  }

  Future searchFilter() async {
    setState(() {
      loading = true;
    });
    var data = {
      'country': supLoc == "Select Country" ? "" : supLoc,
      'dayJob': seller == "Select Type" ? "" : seller,
      'searchedStr': controller.text,
      'searchingFor': "People",
      'tags': selectedCategory,
      'userType': ""
    };

    print(data);

    var res = await CallApi().postData1(data, 'advance-people-filter');
    var body = json.decode(res.body);

    setState(() {
      searchList = body;
      loading = false;
      sp = "2";
    });
    print(searchList);
    //print(searchList['searchResult'].length);
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

  Future loadCategories() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          title: Container(
            margin: EdgeInsets.only(top: 0),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 5), child: BackButton()),

                Expanded(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      //padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(
                          left: 0, right: 10, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey, width: 0.2),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchResult(value);
                                });
                              },
                              controller: src,
                              autofocus: true,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: 'Oswald',
                              ),
                              decoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w300),
                                //labelStyle: TextStyle(color: Colors.white70),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 0, 20.0, 0),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                ////// <<<<< Search button >>>>> //////
                // GestureDetector(
                //   onTap: () {
                //     //searchData(result);
                //   },
                //   child: Container(
                //     decoration: BoxDecoration(
                //         color: back,
                //         border: Border.all(color: Colors.grey[100], width: 0.5),
                //         borderRadius: BorderRadius.circular(25)),
                //     margin: EdgeInsets.only(right: 10),
                //     padding: EdgeInsets.all(10),
                //     child: Icon(
                //       Icons.search,
                //       color: header,
                //       size: 16,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          actions: <Widget>[],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : catList == null
                ? Center(
                    child: Text(
                    "Problem in loading data. try again later!",
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 18, fontFamily: "Oswald"),
                  ))
                : Container(
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                            child: Column(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 10, left: 20),
                                child: Text(
                                  "Search",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.normal),
                                )),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 30,
                                  margin: EdgeInsets.only(
                                      top: 10, left: 20, bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
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
                          ],
                        )),
                        SliverPadding(
                          padding:
                              EdgeInsets.only(bottom: 15, top: 5, left: 20),
                          sliver: loading == true
                              ? SliverToBoxAdapter(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Please wait...",
                                        style: TextStyle(
                                            fontFamily: "Oswald",
                                            color: Colors.grey[600]),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _showFilterDialog();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: back,
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 5.0,
                                                  color: Colors.grey[300],
                                                  //offset: Offset(3.0, 4.0),
                                                ),
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(25)),
                                          margin: EdgeInsets.only(
                                              left: 10, right: 20),
                                          padding: EdgeInsets.all(10),
                                          child: Icon(
                                            Icons.filter_list,
                                            color: header,
                                            size: 18,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : searchList == null
                                  ? SliverToBoxAdapter()
                                  : searchList['searchResult'].length == 0
                                      ? SliverPadding(
                                          padding: EdgeInsets.only(left: 0),
                                          sliver: SliverToBoxAdapter(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "No result found!",
                                                  style: TextStyle(
                                                      fontFamily: "Oswald",
                                                      color: Colors.grey[600]),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _showFilterDialog();
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: back,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 5.0,
                                                            color: Colors
                                                                .grey[300],
                                                            //offset: Offset(3.0, 4.0),
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    margin: EdgeInsets.only(
                                                        left: 10, right: 20),
                                                    padding: EdgeInsets.all(10),
                                                    child: Icon(
                                                      Icons.filter_list,
                                                      color: header,
                                                      size: 18,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : SliverPadding(
                                          padding: EdgeInsets.only(left: 0),
                                          sliver: SliverToBoxAdapter(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  searchList['searchResult']
                                                              .length ==
                                                          1
                                                      ? "${searchList['searchResult'].length} result found"
                                                      : "${searchList['searchResult'].length} results found",
                                                  style: TextStyle(
                                                      fontFamily: "Oswald",
                                                      color: Colors.grey[600]),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _showFilterDialog();
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: back,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            blurRadius: 5.0,
                                                            color: Colors
                                                                .grey[300],
                                                            //offset: Offset(3.0, 4.0),
                                                          ),
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25)),
                                                    margin: EdgeInsets.only(
                                                        left: 10, right: 20),
                                                    padding: EdgeInsets.all(10),
                                                    child: Icon(
                                                      Icons.filter_list,
                                                      color: header,
                                                      size: 18,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                        ),
                        searchList == null
                            ? SliverToBoxAdapter()
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return SearchCard(
                                      searchList['searchResult'][index], sp);
                                },
                                    childCount:
                                        searchList['searchResult'].length),
                              )
                      ],
                    ),
                  ));
  }

  Future<Null> _showFilterDialog() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    //color: Colors.red,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            //color: Colors.yellow,
                            //width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 0, left: 0),
                            child: Text(
                              "Name: ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w200),
                            )),
                        Flexible(
                          child: Container(
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                //////// <<<<< From Textfield start >>>>> //////
                                Flexible(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(left: 10),
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: TextField(
                                        controller: controller,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontFamily: 'Oswald',
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "",
                                          hintStyle: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 15,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w300),
                                          //labelStyle: TextStyle(color: Colors.white70),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              2.5, 2.5, 2.5, 2.5),
                                          border: InputBorder.none,
                                        ),
                                      )),
                                ),

                                //////// <<<<< From Textfield end >>>>> //////
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    //color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            //color: Colors.yellow,
                            //width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 10, left: 0),
                            child: Text(
                              "Country: ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w200),
                            )),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      value: supLoc,
                                      items: _dropDownCountryItems,
                                      onChanged: (String value) {
                                        setState(() {
                                          supLoc = value;
                                        });
                                        Navigator.of(context).pop();
                                        _showFilterDialog();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            //color: Colors.yellow,
                            //width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 10, left: 0),
                            child: Text(
                              "Interests: ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w200),
                            )),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isOpen == false) {
                                isOpen = true;
                              } else {
                                isOpen = false;
                              }
                            });
                            Navigator.pop(context);
                            _showFilterDialog();
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Select Interests",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
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
                      ],
                    ),
                  ),

                  Container(
                    //color: Colors.red,
                    margin: EdgeInsets.only(top: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            //color: Colors.yellow,
                            //width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 10, left: 0),
                            child: Text(
                              "Seller Type: ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w200),
                            )),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontFamily: 'Oswald',
                                          fontWeight: FontWeight.w300),
                                      value: seller,
                                      items: _dropDownBuyerItems,
                                      onChanged: (String value) {
                                        setState(() {
                                          seller = value;
                                        });
                                        Navigator.of(context).pop();
                                        _showFilterDialog();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  ////// <<<<< Hidden Section start >>>>> //////
                  isOpen == true
                      ? Container(
                          width: double.maxFinite,
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
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 15),
                                      child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: selectedCategory.length,
                                        //separatorBuilder: (context, index) => Divider(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[50],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              margin: EdgeInsets.only(
                                                  left: 5,
                                                  right: 5,
                                                  top: 8,
                                                  bottom: 8),
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    "${selectedCat[index]}",
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedCategory
                                                            .removeAt(index);
                                                        selectedCat =
                                                            selectedCategory;
                                                        // print(
                                                        //     "selectedCat");
                                                        // print(
                                                        //     selectedCat);
                                                      });
                                                      Navigator.pop(context);
                                                      _showFilterDialog();
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 5),
                                                      child: Icon(Icons.clear),
                                                    ),
                                                  )
                                                ],
                                              ));
                                        },
                                      ),
                                    )
                                  : Container(),

                              ////// <<<<< Selected Interest end >>>>> //////

                              ///// <<<<<  Interest start >>>>> //////
                              Container(
                                height: 120,
                                width: double.maxFinite,
                                margin: EdgeInsets.only(top: 10),
                                child: ListView.builder(
                                  itemCount: catList.interests.length,
                                  //separatorBuilder: (context, index) => Divider(),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      child: GestureDetector(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: selectedCategory
                                                        .contains(catList
                                                            .interests[index]
                                                            .name)
                                                    ? back
                                                    : Colors.grey[50],
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            margin: EdgeInsets.only(
                                                bottom: 5, top: 3),
                                            padding: EdgeInsets.only(
                                                bottom: 6,
                                                top: 6,
                                                left: 10,
                                                right: 10),
                                            child: Text(
                                              "${catList.interests[index].name}",
                                              style: TextStyle(fontSize: 15),
                                            )),
                                        onTap: () {
                                          setState(() {
                                            // print(
                                            //     "selectedCategory.length");
                                            // print(selectedCategory
                                            //     .length);
                                            if (selectedCategory.length == 0) {
                                              selectedCategory.add(
                                                  "${catList.interests[index].name}");
                                              selectedCat =
                                                  selectedCategory.toList();
                                            } else {
                                              if (selectedCat.contains(catList
                                                  .interests[index].name)) {
                                                selectedCategory.remove(catList
                                                    .interests[index].name);
                                                selectedCat = selectedCategory;
                                              } else {
                                                selectedCategory.add(
                                                    "${catList.interests[index].name}");
                                                selectedCat =
                                                    selectedCategory.toList();
                                              }
                                            }
                                          });
                                          Navigator.pop(context);
                                          _showFilterDialog();
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
                      : Container(),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //////// <<<<< Cancel Button start >>>>> //////
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 0, right: 10, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 17,
                                    fontFamily: 'BebasNeue',
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),

                        //////// <<<<< Cancel Button end >>>>> //////

                        //////// <<<<< Apply Button start >>>>> //////
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                Navigator.of(context).pop();
                                searchFilter();
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(
                                    left: 10, right: 0, top: 20, bottom: 0),
                                decoration: BoxDecoration(
                                    color: header,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100))),
                                child: Text(
                                  "GO",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontFamily: 'BebasNeue',
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ),
                        //////// <<<<< Apply Button end >>>>> //////
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
