import 'dart:convert';
import 'package:chatapp_new/API/api.dart';
import 'package:chatapp_new/MainScreen/ForgotPassPage/forgotPassPage.dart';
import 'package:chatapp_new/MainScreen/HomePage/homePage.dart';
import 'package:chatapp_new/MainScreen/RegisterPage/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class LoginForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  int count = 0;
  bool _isLoading = false;
  String appID = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var userData;

  void initState() {
    super.initState();
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

  // @override
  // void dispose() {
  //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      child: Container(
          //backgroundColor: back_new,
          child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 170, left: 0, right: 0, bottom: 0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        "Connecting Businesses Globally",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.normal),
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
                        "Sign in to Tradister",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w300),
                      )),

                  ////// <<<<< Email Field start >>>>> ///////
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
                              controller: emailController,
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
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 2.5, 20.0, 2.5),
                                border: InputBorder.none,
                              ),
                            )),
                      ],
                    ),
                  ),

                  ////// <<<<< Email Field end >>>>> ///////

                  ////// <<<<< Password Field start >>>>> ///////
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
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: TextField(
                                    controller: passwordController,
                                    keyboardType: TextInputType.text,
                                    obscureText: count % 2 != 0 ? false : true,
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

                  ////// <<<<< Password Field end >>>>> ///////
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassPage()));
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(top: 5, right: 20),
                        child: Text(
                          "Forget Pasword?",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 13,
                              fontFamily: 'Oswald',
                              fontWeight: FontWeight.w300),
                        )),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: _isLoading ? null : _login,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                  color: _isLoading ? Colors.grey : header,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Text(
                                _isLoading ? "Please wait..." : "Sign in",
                                style: TextStyle(
                                  color:
                                      _isLoading ? Colors.black : Colors.white,
                                  fontSize: 17,
                                  fontFamily: 'BebasNeue',
                                ),
                                textAlign: TextAlign.center,
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 0, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Text(
                          "Don't have an account?",
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
                                  builder: (context) => RegisterPage()),
                            );
                          },
                          child: Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                "Sign up",
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
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  void _login() async {
    if (emailController.text.isEmpty) {
      return _showMsg("Email is empty");
    } else if (passwordController.text.isEmpty) {
      return _showMsg("Password is empty");
    }

    setState(() {
      _isLoading = true;
    });
    // print(productBuyer);
    // print(productSeller);

    var data = {
      'email': emailController.text,
      'password': passwordController.text,
      'deviceToken': deviceToken,
    };

    //print(data);

    var res = await CallApi().postData(data, 'user-login');
    var body = json.decode(res.body);
    print("body");
    print(body);

    if (body['success'] == true) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage(0)));
    } else {
      _showMsg("Invalid email or password. Please try again!");
    }

    setState(() {
      _isLoading = false;
    });
  }
}
