import 'dart:async';
import 'dart:convert';

import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/Cards/AllShopCard/AllShopCard.dart';
import 'package:chatapp_new/Cards/MarketplaceCard/marketplaceCard.dart';
import 'package:chatapp_new/Cards/MarketplaceCard/marketplacelandscapeCard.dart';
import 'package:chatapp_new/JSON_Model/AllShopModel/AllShopModel.dart';
import 'package:chatapp_new/JSON_Model/Color_Model/color_Model.dart';
import 'package:chatapp_new/JSON_Model/MarketPlace_Model/marketPlace_model.dart';
import 'package:chatapp_new/JSON_Model/ProductFilterModel/productFilterModel.dart';
import 'package:chatapp_new/Loader/GroupLoader/groupLoader.dart';
import 'package:chatapp_new/Loader/MarketplaceLoader/marketplaceLoader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../../main.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

int total = 0, lastPage = 0;
List colors = [];
bool colorClicked = false;

class AllShopPage extends StatefulWidget {
  @override
  _AllShopPageState createState() => _AllShopPageState();
}

class _AllShopPageState extends State<AllShopPage> {
  //var productList;
  SharedPreferences sharedPreferences;
  String theme = "",
      typeService = "",
      productColor = "",
      productSize = "",
      productCategory = "",
      sample = "",
      supLoc = "",
      supplier = "",
      search = "";
  int selectType = 1,
      currentPage = 1,
      totalPage = 3,
      pageCheck = 0,
      initLoad = 0;
  int xs = 0, s = 0, m = 0, l = 0, xl = 0, xxl = 0;
  var colorDetails;
  bool loading = false;
  bool isSizeOpen = false;
  bool isSearch = false;
  final RefreshController _refreshController = RefreshController();
  TextEditingController minPriceController = new TextEditingController();
  TextEditingController maxPriceController = new TextEditingController();
  TextEditingController orderController = new TextEditingController();
  TextEditingController searchController = new TextEditingController();

  List type = ["Product", "Service"];
  List color = ["Red", "Green", "Blue", "Orange", "Pink", "Violet", "Yellow"];
  List size = ["XS", "S", "M", "L", "XL", "XXL"];
  List category = [
    "Management",
    "App Development",
    "Web Development",
    "UI/UX",
    "SEO"
  ];

  List supplierOpt = [
    "Manufacturer",
    "Wholesaler, Distributer & Trader",
    "Broker Agent",
    "Employee",
    "DropShip Supplier",
  ];
  List selectedColorList = [];
  List sizeList = [];
  List contList = [];

  List<DropdownMenuItem<String>> _dropDowntypeService,
      _dropDownColorItems,
      _dropDownSizeItems,
      _dropDownCategoryItems,
      _dropDownCountryItems,
      _dropDownSupplierItems;

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
    for (String colors in color) {
      items.add(new DropdownMenuItem(
          value: colors,
          child: new Text(
            colors,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getDropDownSizeItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String sizes in size) {
      items.add(new DropdownMenuItem(
          value: sizes,
          child: new Text(
            sizes,
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 15, color: Colors.black),
          )));
    }
    return items;
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

  @override
  void initState() {
    //sharedPrefcheck();
    //timerCheck();
    loadData(1);
    _dropDowntypeService = getDropDowntypeService();
    typeService = _dropDowntypeService[0].value;

    _dropDownColorItems = getDropDownColorItems();
    productColor = _dropDownColorItems[0].value;

    _dropDownSizeItems = getDropDownSizeItems();
    productSize = _dropDownSizeItems[0].value;

    _dropDownCategoryItems = getDropDownCategoryItems();
    productCategory = _dropDownCategoryItems[0].value;

    for (int i = 0; i < country.length; i++) {
      contList.add("${country[i]['name']}");
    }
    _dropDownCountryItems = getDropDownCountryItems();
    supLoc = _dropDownCountryItems[0].value;

    _dropDownSupplierItems = getDropDownSupplierItems();
    supplier = _dropDownSupplierItems[0].value;
    super.initState();
  }

  Future loadData(int page) async {
    setState(() {
      loading = true;
    });
    //await Future.delayed(Duration(seconds: 3));
    if (page4 == 0) {
      var postresponse = await CallApi().getData2('get/shops');
      var postcontent = postresponse.body;
      final posts = json.decode(postcontent);
      var shopdata = AllShopModel.fromJson(posts);

      setState(() {
        shopList = shopdata;
        print("shopList");
        print(shopList);
        page4 = 1;
        lastPage = shopList.shops.lastPage;
        total = total + shopList.shops.data.length;
      });
    }

    setState(() {
      loading = false;
    });
    // print("productList.data.length");
    // print(productList.data.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        //header: WaterDropMaterialHeader(),
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          setState(() {
            page4 = 0;
          });
          loadData(activePage);
          _refreshController.refreshCompleted();
        },
        child: loading == true
            ? MarketplaceLoaderCard()
            : CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        ////// <<<<< Title >>>>> //////
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 15, left: 20),
                            child: Text(
                              "Shop List",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.normal),
                            )),

                        ////// <<<<< Divider 1 >>>>> //////
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
                                    ),
                                  ],
                                  border: Border.all(
                                      width: 0.5, color: Colors.black)),
                            ),
                          ],
                        ),

                        ////// <<<<< Number of products >>>>> //////
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                      top: 12, left: 20, bottom: 10),
                                  child: Text(
                                    shopList.shops.data.length == 0
                                        ? "No shops"
                                        : "${shopList.shops.total} shops",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w400),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(left: 10, right: 10),

                    ////// <<<<< Gridview>>>>> //////
                    sliver: SliverGrid(
                      // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      //   maxCrossAxisExtent: 300.0,
                      //   mainAxisSpacing: 0.0,
                      //   crossAxisSpacing: 0.0,
                      //   childAspectRatio: 1.0,
                      // ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio:
                            (MediaQuery.of(context).size.width / 2) /
                                (MediaQuery.of(context).size.height / 1.75),
                      ),
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        ////// <<<<< Portrait Card >>>>> //////
                        return OrientationBuilder(
                            builder: (context, orientation) {
                          return AllShopCard(shopList.shops.data[index]);
                        });

                        // ////// <<<<< Loader >>>>> //////
                        // : GroupLoaderCard();
                      }, childCount: shopList.shops.data.length),
                    ),
                  ),
                  shopList.shops.data.length == 0
                      ? SliverToBoxAdapter()
                      : SliverToBoxAdapter(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      activePage--;
                                      //page3 = 0;
                                      if (activePage <= 1) {
                                        activePage = 1;
                                      }
                                      if (activePage % totalPage == 0) {
                                        currentPage = activePage - 2;
                                      }
                                      if (activePage == shopList.shops.page) {
                                        setState(() {
                                          page4 = 1;
                                        });
                                      } else {
                                        setState(() {
                                          page4 = 0;
                                        });
                                      }
                                    });
                                    // print(productList.lastPage);
                                    // print(productList.page);
                                    initLoad == 0
                                        ? loadData(activePage)
                                        : filterProduct();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 5, bottom: 5),
                                      margin:
                                          EdgeInsets.only(right: 0, left: 20),
                                      decoration: BoxDecoration(
                                          color: activePage == 1
                                              ? Colors.grey[100]
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 2.0,
                                              color: Colors.grey,
                                            )
                                          ]),
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 3, left: 0),
                                        child: Icon(Icons.chevron_left,
                                            color: activePage == 1
                                                ? Colors.grey[400]
                                                : header,
                                            size: 18),
                                      )),
                                ),
                                currentPage > lastPage
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            activePage = currentPage;
                                            pageCheck++;
                                            page4 = 0;
                                          });
                                          initLoad == 0
                                              ? loadData(activePage)
                                              : filterProduct();
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 5,
                                                bottom: 5),
                                            margin: EdgeInsets.only(
                                                right: 5, left: 10),
                                            decoration: BoxDecoration(
                                                color: activePage == currentPage
                                                    ? header
                                                    : Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2.0,
                                                    color: Colors.grey,
                                                  )
                                                ]),
                                            child: Container(
                                              child: Text(
                                                "$currentPage",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: activePage ==
                                                            currentPage
                                                        ? Colors.white
                                                        : Colors.grey[400],
                                                    fontSize: 14,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )),
                                      ),
                                currentPage + 1 > lastPage
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            activePage = currentPage + 1;
                                            pageCheck++;
                                            page4 = 0;
                                          });
                                          initLoad == 0
                                              ? loadData(activePage)
                                              : filterProduct();
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 5,
                                                bottom: 5),
                                            margin: EdgeInsets.only(
                                                right:
                                                    currentPage + 1 > lastPage
                                                        ? 5
                                                        : 10,
                                                left: 5),
                                            decoration: BoxDecoration(
                                                color: activePage ==
                                                        currentPage + 1
                                                    ? header
                                                    : Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2.0,
                                                    color: Colors.grey,
                                                  )
                                                ]),
                                            child: Container(
                                              child: Text(
                                                "${currentPage + 1}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: activePage ==
                                                            currentPage + 1
                                                        ? Colors.white
                                                        : Colors.grey[400],
                                                    fontSize: 14,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )),
                                      ),
                                currentPage + 2 > lastPage
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            activePage = currentPage + 2;
                                            pageCheck++;
                                            page4 = 0;
                                          });
                                          initLoad == 0
                                              ? loadData(activePage)
                                              : filterProduct();
                                        },
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 5,
                                                bottom: 5),
                                            margin: EdgeInsets.only(
                                                right: 10, left: 5),
                                            decoration: BoxDecoration(
                                                color: activePage ==
                                                        currentPage + 2
                                                    ? header
                                                    : Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 2.0,
                                                    color: Colors.grey,
                                                  )
                                                ]),
                                            child: Container(
                                              child: Text(
                                                "${currentPage + 2}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: activePage ==
                                                            currentPage + 2
                                                        ? Colors.white
                                                        : Colors.grey[400],
                                                    fontSize: 14,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            )),
                                      ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      activePage++;
                                      //page3 = 0;
                                      if (activePage >= lastPage) {
                                        activePage = lastPage;
                                        page4 = 1;
                                      }
                                      if (activePage > currentPage + 2) {
                                        currentPage = activePage;
                                      }
                                      if (productList.lastPage ==
                                          productList.page) {
                                        setState(() {
                                          page4 = 1;
                                        });
                                      } else {
                                        setState(() {
                                          page4 = 0;
                                        });
                                      }
                                    });
                                    // print(productList.lastPage);
                                    // print(productList.page);
                                    initLoad == 0
                                        ? loadData(activePage)
                                        : filterProduct();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 8, right: 8, top: 5, bottom: 5),
                                      margin:
                                          EdgeInsets.only(right: 20, left: 0),
                                      decoration: BoxDecoration(
                                          color: activePage == lastPage
                                              ? Colors.grey[100]
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 2.0,
                                              color: Colors.grey,
                                            )
                                          ]),
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 3, left: 0),
                                        child: Icon(Icons.chevron_right,
                                            color: activePage == lastPage
                                                ? Colors.grey[400]
                                                : header,
                                            size: 18),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        )
                ],
              ),
      ),
    );
  }

  Future<Null> _showFilterDialog() async {
    if (typeService == "Product") {
      selectType = 1;
    } else {
      selectType = 2;
    }
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            //width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 0, left: 0),
                            child: Text(
                              "Type: ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w200),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            DropdownButtonHideUnderline(
                              child: DropdownButton(
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontFamily: 'Oswald',
                                    fontWeight: FontWeight.w300),
                                value: typeService,
                                items: _dropDowntypeService,
                                onChanged: (String value) {
                                  setState(() {
                                    typeService = value;
                                    print(typeService);
                                  });
                                  Navigator.of(context).pop();
                                  _showFilterDialog();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  typeService == "Service"
                      ? Container()
                      : Container(
                          //color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                  //color: Colors.yellow,
                                  //width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 0, left: 0),
                                  child: Text(
                                    "Order Quantity: ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w200),
                                  )),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      //////// <<<<< From Textfield start >>>>> //////
                                      Container(
                                          width: 147,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: TextField(
                                            controller: orderController,
                                            keyboardType: TextInputType.number,
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
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      2.5, 2.5, 2.5, 2.5),
                                              border: InputBorder.none,
                                            ),
                                          )),

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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            //color: Colors.yellow,
                            //width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 0, left: 0),
                            child: Text(
                              "Offer Sample: ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w200),
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(
                              left: 0, right: 15, top: 10, bottom: 10),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      sample = 'Yes';
                                    });
                                    Navigator.pop(context);
                                    _showFilterDialog();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                color: sample == 'Yes'
                                                    ? header.withOpacity(0.7)
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: sample == 'Yes'
                                                        ? header
                                                            .withOpacity(0.7)
                                                        : Colors.grey,
                                                    width: 0.3),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Icon(
                                              Icons.radio_button_unchecked,
                                              color: sample == 'Yes'
                                                  ? Colors.white
                                                  : Colors.grey,
                                              size: 14,
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(left: 5),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Yes",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 14,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      sample = 'No';
                                    });
                                    Navigator.pop(context);
                                    _showFilterDialog();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                                color: sample == 'No'
                                                    ? header.withOpacity(0.7)
                                                    : Colors.white,
                                                border: Border.all(
                                                    color: sample == 'No'
                                                        ? header
                                                            .withOpacity(0.7)
                                                        : Colors.grey,
                                                    width: 0.3),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Icon(
                                              Icons.radio_button_unchecked,
                                              color: sample == 'No'
                                                  ? Colors.white
                                                  : Colors.grey,
                                              size: 14,
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(left: 5),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "No",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontSize: 14,
                                                fontFamily: 'Oswald',
                                                fontWeight: FontWeight.w300),
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
                  Container(
                    //color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            //color: Colors.yellow,
                            //width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 0, left: 0),
                            child: Text(
                              typeService == "Service"
                                  ? "Seller Location"
                                  : "Supplier Location: ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w200),
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          padding: EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  typeService == "Service"
                      ? Container()
                      : Container(
                          //color: Colors.red,
                          margin: EdgeInsets.only(top: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  //color: Colors.yellow,
                                  //width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 0, left: 0),
                                  child: Text(
                                    "Supplier Type: ",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.w200),
                                  )),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                padding: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                            value: supplier,
                                            items: _dropDownSupplierItems,
                                            onChanged: (String value) {
                                              setState(() {
                                                supplier = value;
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
                    //color: Colors.red,
                    margin: EdgeInsets.only(top: 10, left: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            //color: Colors.yellow,
                            //width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 0, left: 0),
                            child: Text(
                              typeService == "Service"
                                  ? "Maximum Budget:"
                                  : "Price: ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 15,
                                  fontFamily: 'Oswald',
                                  fontWeight: FontWeight.w200),
                            )),
                        Expanded(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                //////// <<<<< From Textfield start >>>>> //////
                                Container(
                                    width: 60,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.7),
                                        border: Border.all(
                                            color: Colors.grey, width: 0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: TextField(
                                      controller: minPriceController,
                                      keyboardType: TextInputType.number,
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

                                //////// <<<<< From Textfield end >>>>> //////

                                typeService == "Service"
                                    ? Container()
                                    : Container(
                                        margin:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: Text(
                                          "To",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontFamily: 'Oswald',
                                              fontWeight: FontWeight.w200),
                                        )),

                                //////// <<<<< To Textfield start >>>>> //////
                                typeService == "Service"
                                    ? Container()
                                    : Container(
                                        width: 60,
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: TextField(
                                          controller: maxPriceController,
                                          keyboardType: TextInputType.number,
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

                                //////// <<<<< To Textfield end >>>>> //////
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                                page3 = 0;
                                filterProduct();
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

  Future filterProduct() async {
    setState(() {
      loading = true;
    });
    var data = {
      'maxPrice': minPriceController.text,
      'minPrice': maxPriceController.text,
      'sizes': sizeList,
      'country': supLoc,
      'colors': colors,
      'offerSample': sample,
      'searchTitle': search,
      'suplierType': supplier,
      'page': null,
      'moq': typeService == "Product" ? orderController.text : null,
      'type': typeService == "Product" ? "product" : "service",
    };

    print(data);

    var res = await CallApi().postData(data, 'filter/allData');
    var body = json.decode(res.body);
    var marketdata = MarketPlaceModel.fromJson(body);

    setState(() {
      productList = marketdata;
      page3 = 1;
      lastPage = productList.lastPage;
      total = total + productList.data.length;
      print(lastPage);
      print(total);
    });

    print(body);

    setState(() {
      loading = false;
      initLoad = 1;
    });
  }
}
