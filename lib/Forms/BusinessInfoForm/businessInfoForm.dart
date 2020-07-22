import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/JSON_Model/BusinessModel/BusinessModel.dart';
import 'package:chatapp_new/JSON_Model/User_Model/user_Model.dart';
import 'package:chatapp_new/MainScreen/HomePage/homePage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_multiple_image_picker/flutter_multiple_image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class BusinessInfoForm extends StatefulWidget {
  final userData;

  BusinessInfoForm(this.userData);
  @override
  _BusinessInfoFormState createState() => _BusinessInfoFormState();
}

class _BusinessInfoFormState extends State<BusinessInfoForm> {
  TextEditingController businessNameCont = new TextEditingController();
  TextEditingController offWebCont = new TextEditingController();
  TextEditingController offAddCont = new TextEditingController();
  TextEditingController opeAddCont = new TextEditingController();
  TextEditingController taxNumCont = new TextEditingController();
  TextEditingController yearEstdCont = new TextEditingController();
  TextEditingController numEmployeeCont = new TextEditingController();
  TextEditingController businessOffersCont = new TextEditingController();
  TextEditingController directorNameCont = new TextEditingController();
  TextEditingController contactNameCont = new TextEditingController();
  TextEditingController contactNumCont = new TextEditingController();
  TextEditingController businessCertifyCont = new TextEditingController();
  List allImages = [];
  List images = [];
  List imagesBase64 = [];
  var img;
  var businessInfo;
  var userToken;
  int maxImageNo = 10;
  bool selectSingleImage = false;
  bool isSubmit = false;
  bool isLoading = false;
  bool isEdit = false;
  File fileName;
  CancelToken token = CancelToken();
  var dio = new Dio();
  List type = ["Image", "PDF"];
  String typeFile = "";
  List<DropdownMenuItem<String>> _dropDowntypeFile;

  @override
  void initState() {
    _dropDowntypeFile = getDropDowntypeService();
    typeFile = _dropDowntypeFile[0].value;
    _getUserInfo();
    getBusinessInfo();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    userToken = localStorage.getString('token');
  }

  Future getBusinessInfo() async {
    //await Future.delayed(Duration(seconds: 3));

    var response = await CallApi()
        .getData('profile/${widget.userData['userName']}?tab=about');
    var content = response.body;

    if (content != null) {
      print(content);
      final collection = json.decode(content);
      var data = BusinessModel.fromJson(collection);

      setState(() {
        businessInfo = data;
        if (businessInfo.res != null) {
          businessNameCont.text = "${businessInfo.res.name}";
          if (businessNameCont.text == "null") {
            businessNameCont.text = "";
          }
          offWebCont.text = "${businessInfo.res.website}";
          if (offWebCont.text == "null") {
            offWebCont.text = "";
          }
          offAddCont.text = "${businessInfo.res.address}";
          if (offAddCont.text == "null") {
            offAddCont.text = "";
          }
          opeAddCont.text = "${businessInfo.res.operatingAddress}";
          if (opeAddCont.text == "null") {
            opeAddCont.text = "";
          }
          taxNumCont.text = "${businessInfo.res.taxNumber}";
          if (taxNumCont.text == "null") {
            taxNumCont.text = "";
          }
          yearEstdCont.text = "${businessInfo.res.yearEstablished}";
          if (yearEstdCont.text == "null") {
            yearEstdCont.text = "";
          }
          numEmployeeCont.text = "${businessInfo.res.totalEmployies}";
          if (numEmployeeCont.text == "null") {
            numEmployeeCont.text = "";
          }
          businessOffersCont.text = "${businessInfo.res.businessOfferings}";
          if (businessOffersCont.text == "null") {
            businessOffersCont.text = "";
          }
          businessCertifyCont.text =
              "${businessInfo.res.businessCertifications}";
          if (businessCertifyCont.text == "null") {
            businessCertifyCont.text = "";
          }
          directorNameCont.text = "${businessInfo.res.directorName}";
          if (directorNameCont.text == "null") {
            directorNameCont.text = "";
          }
          contactNameCont.text = "${businessInfo.res.contactPerson}";
          if (contactNameCont.text == "null") {
            contactNameCont.text = "";
          }
          contactNumCont.text = "${businessInfo.res.contactNumber}";
          if (contactNumCont.text == "null") {
            contactNumCont.text = "";
          }

          for (int i = 0; i < businessInfo.res.files.length; i++) {
            allImages.add("${businessInfo.res.files[i].id}");
            images.add({"portfolio": "${businessInfo.res.files[i].portfolio}"});
          }

          //images = allImages;
          img = images.toList();
        }
        isLoading = false;
      });
    }

    //print(contList);
  }

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

  Future initMultiPickUp() async {
    // var file =
    //     await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: 'jpg');
    var file = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    print(file);
    if (file == null) {
    } else {
      _uploadImg(file);

      setState(() {
        fileName = file;
      });

      print(file);
    }
  }

  void _uploadImg(filePath) async {
    String fileName = Path.basename(filePath.path);
    print("File base name: $fileName");

    try {
      FormData formData = new FormData.from({
        "file": new UploadFileInfo(filePath, fileName,
            contentType: ContentType('image', 'jpg'))
      });

      var response = await Dio()
          .post(CallApi().url + 'upload/bussinessInfo?token=$userToken',
              // options: Options(
              //     followRedirects: false,
              //     validateStatus: (status) {
              //       return status < 500;
              //     }),
              data: formData,
              cancelToken: token,
              onSendProgress: (int sent, int total) {});

      print("response");
      print(response);
      setState(() {
        var res = response.toString();
        final data = json.decode(res);

        images.add({"portfolio": "${data['file']}"});

        img = images.toList();

        print(img);
      });
      //isLoading = false;
    } catch (e) {}
  }

  Future initMultiFilePickUp() async {
    var file =
        await FilePicker.getFile(type: FileType.custom, fileExtension: 'pdf');
    // var file = await ImagePicker.pickImage(
    //     source: ImageSource.gallery, imageQuality: 80);
    print(file);
    if (file == null) {
    } else {
      _uploadFile(file);

      setState(() {
        fileName = file;
      });

      //print(file);
    }
  }

  void _uploadFile(filePath) async {
    String fileName = Path.basename(filePath.path);
    print("File base name: $fileName");

    try {
      FormData formData = new FormData.from({
        "file": new UploadFileInfo(filePath, fileName,
            contentType: ContentType('application', 'pdf'))
      });

      var response = await Dio().post(
          CallApi().url + 'upload/bussinessInfo?token=$userToken',
          // options: Options(
          //     followRedirects: false,
          //     validateStatus: (status) {
          //       return status < 500;
          //     }),
          data: formData,
          cancelToken: token,
          options: new Options(
            contentType: ContentType.parse("application/x-www-form-urlencoded"),
          ),
          onSendProgress: (int sent, int total) {});

      print("response");
      print(response);
      setState(() {
        var res = response.toString();
        final data = json.decode(res);

        images.add({"portfolio": "${data['file']}"});

        img = images.toList();

        print(img);
      });
    } catch (e) {}
  }

  // initMultiPickUp() async {
  //   setState(() {
  //     //images = null;
  //     maxImageNo -= images.length;
  //   });
  //   List resultList;
  //   try {
  //     resultList = await FlutterMultipleImagePicker.pickMultiImages(
  //         maxImageNo, selectSingleImage);
  //     //resultList = await FilePicker.getMultiFile();
  //   } on PlatformException catch (e) {
  //     print(e.message);
  //   }

  //   if (!mounted) return;

  //   // for (int i = 0; i < resultList.length; i++) {
  //   //   uploadImages(resultList[i]);
  //   // }

  //   uploadImages(resultList);
  // }

  // Future uploadImages(List resultList) async {
  //   for (int i = 0; i < resultList.length; i++) {
  //     File file = new File(resultList[i].toString());
  //     List<int> imageBytes = file.readAsBytesSync();
  //     String image = base64.encode(imageBytes);
  //     image = 'data:image/png;base64,' + image;
  //     setState(() {
  //       //images.add(resultList[i]);
  //       imagesBase64.add(image);
  //       //print(imagesBase64);
  //     });
  //   }
  //   var data3 = {'file': imagesBase64};
  //   print(imagesBase64.length);
  //   var res1 = await CallApi().postData1(data3, 'upload/bussinessInfo');
  //   var body1 = json.decode(res1.body);
  //   print("image success check");
  //   print(body1);

  //   if (body1['success'] == true) {
  //     //localStorage.setString('user', json.encode(body['user']));
  //     // SharedPreferences localStorage = await SharedPreferences.getInstance();
  //     // localStorage.setString('user', json.encode(body1['user']));
  //     for (var i = 0; i < body1['uploadImages'].length; i++) {
  //       allImages.add(body1['uploadImages'][i]['id']);
  //       //images.add(body1['uploadImages'][i]['file']);
  //       if (body1['uploadImages'][i]['file'].contains("localhost")) {
  //         body1['uploadImages'][i]['file'] = body1['uploadImages'][i]['file']
  //             .replaceAll("localhost", "http://10.0.2.2");
  //         images.add(body1['uploadImages'][i]['file']);
  //       }
  //     }
  //     //print(allImages);

  //     setState(() {
  //       //images = resultList;
  //       img = images.toList();
  //       //isUploaded = true;
  //       //print(images);
  //     });
  //     //print(body1['uploadImages']);
  //     //_showCompleteDialog();
  //   } else if (body1['success'] == false) {
  //     //print(body['message']);
  //     _showMsg(body1['message']);
  //   }
  //   // print("images");
  //   // print(images);
  //   // print(images.length);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    isEdit == false
                        ? "Manage Business Information"
                        : "Edit Business Information",
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
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3.0,
                        color: Colors.black,
                        //offset: Offset(6.0, 7.0),
                      ),
                    ],
                    border: Border.all(width: 0.5, color: Colors.black)),
              ),
            ],
          ),
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 12, left: 20),
              child: Text(
                isEdit == false
                    ? "View your business information"
                    : "Update your business information",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.w300),
              )),

          ////// <<<<< Business Name Field start >>>>> //////
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      controller: businessNameCont,
                      enabled: isEdit ? true : false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Oswald',
                      ),
                      decoration: InputDecoration(
                        hintText: "Business Name *",
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
          ////// <<<<< Business Name Field end >>>>> //////

          ////// <<<<< Official Web Field start >>>>> //////
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      controller: offWebCont,
                      enabled: isEdit ? true : false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Oswald',
                      ),
                      decoration: InputDecoration(
                        hintText: "Official Website *",
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
          ////// <<<<< Official Web Field end >>>>> //////

          ////// <<<<< Official Address Field start >>>>> //////
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      controller: offAddCont,
                      enabled: isEdit ? true : false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Oswald',
                      ),
                      decoration: InputDecoration(
                        hintText: "Official Address *",
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
          ////// <<<<< Official Address Field end >>>>> //////

          ////// <<<<< Operating Address Field start >>>>> //////
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      controller: opeAddCont,
                      enabled: isEdit ? true : false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Oswald',
                      ),
                      decoration: InputDecoration(
                        hintText: "Operating Address *",
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
          ////// <<<<< Operating Address Field end >>>>> //////

          ////// <<<<< Tax Number Field start >>>>> //////
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      controller: taxNumCont,
                      enabled: isEdit ? true : false,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Oswald',
                      ),
                      decoration: InputDecoration(
                        hintText: "Tax Number *",
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
          ////// <<<<< Tax Number Field end >>>>> //////

          ////// <<<<< Year Established Field start >>>>> //////
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      controller: yearEstdCont,
                      enabled: isEdit ? true : false,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Oswald',
                      ),
                      decoration: InputDecoration(
                        hintText: "Year Established *",
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
          ////// <<<<< Year Established Field end >>>>> //////

          ////// <<<<< No of Employees Field start >>>>> //////
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      controller: numEmployeeCont,
                      enabled: isEdit ? true : false,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Oswald',
                      ),
                      decoration: InputDecoration(
                        hintText: "No of Employees *",
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
          ////// <<<<< No of Employees Field end >>>>> //////

          ////// <<<<< About Business and Main Offerings Field start >>>>> //////
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      controller: businessOffersCont,
                      enabled: isEdit ? true : false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Oswald',
                      ),
                      decoration: InputDecoration(
                        hintText: "About Business and Main Offerings *",
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
          ////// <<<<< About Business and Main Offerings Field end >>>>> //////

          ////// <<<<< Business Certifications Field start >>>>> //////
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      controller: businessCertifyCont,
                      enabled: isEdit ? true : false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Oswald',
                      ),
                      decoration: InputDecoration(
                        hintText: "Business Certifications *",
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
          ////// <<<<< Business Certifications Field end >>>>> //////

          ////// <<<<< Director Name Field start >>>>> //////
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      controller: directorNameCont,
                      enabled: isEdit ? true : false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Oswald',
                      ),
                      decoration: InputDecoration(
                        hintText: "Director Name *",
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
          ////// <<<<< Director Name Field end >>>>> //////

          ////// <<<<< Contact Person Name Field start >>>>> //////
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      controller: contactNameCont,
                      enabled: isEdit ? true : false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Oswald',
                      ),
                      decoration: InputDecoration(
                        hintText: "Contact Person Name *",
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
          ////// <<<<< Contact Person Name Field end >>>>> //////

          ////// <<<<< Contact Person Contact Number Field start >>>>> //////
          Container(
            margin: EdgeInsets.only(bottom: 5, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 5),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextField(
                      controller: contactNumCont,
                      enabled: isEdit ? true : false,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Oswald',
                      ),
                      decoration: InputDecoration(
                        hintText:
                            "Contact Person Contact Number (Phone, Skype, WhatsApp) *",
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
          ////// <<<<< Contact Person Contact Number Field end >>>>> //////

          ////// <<<<< Upload Images Field Start >>>>> //////
          Container(
            margin: EdgeInsets.only(left: 0, right: 0, top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    isEdit == false
                        ? Container()
                        : Container(
                            width: 100,
                            padding: EdgeInsets.only(
                                left: 20, right: 10, top: 1, bottom: 2),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                border:
                                    Border.all(color: Colors.grey, width: 0.5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            margin:
                                EdgeInsets.only(top: 0, right: 10, left: 20),
                            child: DropdownButtonHideUnderline(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: DropdownButton(
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                      fontFamily: 'Oswald',
                                      fontWeight: FontWeight.w100),
                                  value: typeFile,
                                  items: _dropDowntypeFile,
                                  onChanged: (String value) {
                                    setState(() {
                                      typeFile = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                    typeFile == "Image"
                        ? Expanded(
                            child: Container(
                              child: GestureDetector(
                                onTap: isEdit
                                    ? images.length >= 5
                                        ? _showMessage(
                                            "Cannnot select above 5 files!")
                                        : initMultiPickUp
                                    : null,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: 2,
                                      top: 5,
                                      right: 20,
                                      left: isEdit ? 0 : 20),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                (images == null ||
                                                        images.length == 0)
                                                    ? "Business Portfolio (Max. 5)"
                                                    : "${images.length}/5 file selected",
                                                style: TextStyle(
                                                    color: (images == null ||
                                                            images.length == 0)
                                                        ? Colors.black38
                                                        : header,
                                                    fontSize: 15,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Icon(Icons.photo_camera,
                                                color: header, size: 22),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Container(
                              child: GestureDetector(
                                onTap: images.length >= 5
                                    ? _showMessage(
                                        "Cannnot select above 5 files!")
                                    : initMultiFilePickUp,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: 2, top: 5, right: 20),
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.7),
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: Text(
                                                (images == null ||
                                                        images.length == 0)
                                                    ? "Business Portfolio (Max. 5)"
                                                    : "${images.length}/5 file selected",
                                                style: TextStyle(
                                                    color: (images == null ||
                                                            images.length == 0)
                                                        ? Colors.black38
                                                        : header,
                                                    fontSize: 15,
                                                    fontFamily: 'Oswald',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Icon(Icons.picture_as_pdf,
                                                color: header, size: 22),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
          ////// <<<<< Upload Images Field end >>>>> //////

          ////// <<<<< Image List Start >>>>> //////

          (images == null || images.length == 0)
              ? Container()
              : Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(
                      top: isEdit ? 10 : 0, bottom: 0, left: 15),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    //separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 60,
                        //width: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey, width: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(
                            left: 5, right: 5, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "${img[index]['portfolio']}",
                              style: TextStyle(fontSize: 12),
                            ),
                            isEdit
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        img.removeAt(index);
                                        images = img;
                                        print(images.length);
                                      });
                                    },
                                    child: Container(
                                        margin: EdgeInsets.all(5),
                                        child: Icon(Icons.close, size: 16)),
                                  )
                                : Container()
                          ],
                        ),
                        // padding:
                        //     EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                        // child: Image.file(
                        //   new File(images[index].toString()),
                        //   // height: 20,
                        //   // width: 20,
                        // )),
                      );
                    },
                  ),
                ),

          ////// <<<<< Image List End >>>>> //////

          ////// <<<<< Create Shop button >>>>> //////
          isEdit == false
              ? Container()
              : Container(
                  margin: EdgeInsets.only(bottom: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: isSubmit ? null : sendBusinesInfo,
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: isSubmit ? Colors.grey : header,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Text(
                              isSubmit
                                  ? "Please wait..."
                                  : "Update Business Information",
                              style: TextStyle(
                                color: isSubmit ? Colors.black : Colors.white,
                                fontSize: 17,
                                fontFamily: 'BebasNeue',
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  _showMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        textColor: Colors.white,
        fontSize: 13.0);
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

  void sendBusinesInfo() async {
    if (businessNameCont.text.isEmpty) {
      return _showMsg("Business name is empty");
    } else if (contactNameCont.text.isEmpty) {
      return _showMsg("Contact Name is empty");
    } else if (contactNumCont.text.isEmpty) {
      return _showMsg("Contact Number is empty");
    }
    // else if (offWebCont.text.isEmpty) {
    //   return _showMsg("Official Website is empty");
    // } else if (offAddCont.text.isEmpty) {
    //   return _showMsg("Official Address is empty");
    // } else if (opeAddCont.text.isEmpty) {
    //   return _showMsg("Operating Address is empty");
    // } else if (taxNumCont.text.isEmpty) {
    //   return _showMsg("Tax Number is empty");
    // } else if (yearEstdCont.text.isEmpty) {
    //   return _showMsg("Year of established is empty");
    // } else if (numEmployeeCont.text.isEmpty) {
    //   return _showMsg("Number of employees is empty");
    // } else if (businessOffersCont.text.isEmpty) {
    //   return _showMsg("Business Offers is empty");
    // } else if (directorNameCont.text.isEmpty) {
    //   return _showMsg("Director Name is empty");
    // } else if (contactNameCont.text.isEmpty) {
    //   return _showMsg("Contact Name is empty");
    // } else if (contactNumCont.text.isEmpty) {
    //   return _showMsg("Contact Number is empty");
    // } else if (businessCertifyCont.text.isEmpty) {
    //   return _showMsg("Business Certification is empty");
    // }

    setState(() {
      isSubmit = true;
    });
    // print(productBuyer);
    // print(productSeller);

    var data = {
      'address': offAddCont.text,
      'businessCertifications': businessCertifyCont.text,
      'businessOfferings': businessOffersCont.text,
      'contactNumber': contactNumCont.text,
      'contactPerson': contactNameCont.text,
      'created_at': "",
      'directorName': directorNameCont.text,
      'name': businessNameCont.text,
      'operatingAddress': opeAddCont.text,
      'taxNumber': taxNumCont.text,
      'totalEmployies': numEmployeeCont.text,
      'updated_at': "",
      'user_id': widget.userData['id'],
      'website': offWebCont.text,
      'yearEstablished': yearEstdCont.text,
      'businessPortfolio': images,
      'files': businessInfo.res == null ? [] : images,
    };

    print(data);

    var res = await CallApi().postData1(data, 'profile/bussinessInfo');
    var body = json.decode(res.body);
    // var body2 = json.decode(res);
    print(body.toString());
    print('sdfsd');
    print(res.statusCode);

    if (res.statusCode == 200) {
      showUser();
    } else {
      _showMessage("Something went wrong!");
    }
  }

  Future showUser() async {
    //await Future.delayed(Duration(seconds: 3));
    var postresponse = await CallApi().getData1('initData');
    var postcontent = postresponse.body;
    var body = json.decode(postcontent);

    print(body);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('user', json.encode(body['user']));
    setState(() {
      isSubmit = false;
      _showCompleteDialog();
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
                          "Business Information has been edited successfully.",
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
