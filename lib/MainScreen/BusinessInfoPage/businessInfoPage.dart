import 'package:chatapp_new/Forms/BusinessInfoForm/businessInfoForm.dart';
import 'package:flutter/material.dart';

class BusinessInfoPage extends StatefulWidget {
  final userData;

  BusinessInfoPage(this.userData);
  @override
  _BusinessInfoPageState createState() => _BusinessInfoPageState();
}

class _BusinessInfoPageState extends State<BusinessInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  //color: header,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 10, left: 5),
                          child: BackButton(color: Colors.grey)),
                      // Container(
                      //   margin: EdgeInsets.only(
                      //       bottom: 10, left: 10, top: 20, right: 20),
                      //   width: 180,
                      //   height: 180,
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(15),
                      //     image: DecorationImage(
                      //       image: AssetImage("assets/images/login2.png"),
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ),
                      //   child: null,
                      // ),
                    ],
                  ),
                ),
                BusinessInfoForm(widget.userData)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
