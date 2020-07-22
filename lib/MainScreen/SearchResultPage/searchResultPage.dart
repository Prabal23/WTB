import 'dart:convert';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/SearchCard/searchCard.dart';
import 'package:chatapp_new/JSON_Model/ProductsrchModel/productsrchModel.dart';
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
  SharedPreferences sharedPreferences;
  String theme = "", productCategory = "";
  bool loading = false;
  var searchList;
  TextEditingController src = new TextEditingController();
  List category = ["People", "SUV", "Mercedes", "Audi"];
  List<DropdownMenuItem<String>> _dropDownCategoryService;

  @override
  void initState() {
    //print(user.length);
    //friendname.addAll(name);
    //searchData("");
    searchResult("");
    _dropDownCategoryService = getDropDownCategoryItems();
    productCategory = _dropDownCategoryService[0].value;
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
      'str': value,
    };

    print(data);

    var res = await CallApi().postData1(data, 'search');
    var body = json.decode(res.body);

    setState(() {
      searchList = body;
      loading = false;
    });
    print(searchList);
    print(searchList['sortedRes'].length);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
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
                          "Shop Information",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.normal),
                        )),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[],
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 10, left: 20),
                      child: Text(
                        "Search result",
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
                        margin: EdgeInsets.only(top: 10, left: 20, bottom: 10),
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
                ],
              ),
              Container(
                //constraints: BoxConstraints(maxHeight: 150.0),
                child: new Material(
                  //color: header,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3.0,
                            color: Colors.black.withOpacity(.2),
                            //offset: Offset(6.0, 7.0),
                          ),
                        ],
                        //border: Border.all(color: sub_white, width: 0.3),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: new TabBar(
                      labelStyle: TextStyle(
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                      tabs: [
                        new Tab(
                          text: "People",
                        ),
                        new Tab(
                          text: "Community",
                        ),
                      ],
                      indicatorColor: Colors.transparent,
                      unselectedLabelColor: Colors.black45,
                      unselectedLabelStyle: TextStyle(
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                      labelColor: header,
                      //labelStyle: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    CustomScrollView(
                      slivers: <Widget>[
                        result == ""
                            ? SliverToBoxAdapter(
                                child: Container(),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return SearchCard(
                                      searchList.sortedRes[index], 2);
                                }, childCount: searchList.sortedRes.length),
                              ),
                      ],
                    ),
                    CustomScrollView(
                      slivers: <Widget>[
                        result == ""
                            ? SliverToBoxAdapter(
                                child: Container(),
                              )
                            : SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return SearchCard(
                                      searchList.sortedRes[index], 2);
                                }, childCount: searchList.sortedRes.length),
                              ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
