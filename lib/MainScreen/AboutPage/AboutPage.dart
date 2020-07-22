import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        "About Us",
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Text(
                "Tradister is a B2B Global Business Networking tool and Marketplace connecting importers, exporters, shipping agents, trade finance specialists, and Digital Freelancers with latest and updated technology and blockchain.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                "Tradister Lets users:",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 5.0,
                    width: 5.0,
                    decoration: new BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Business Feed for Latest business updates",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 5.0,
                    width: 5.0,
                    decoration: new BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Create business network and share updates",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 5.0,
                    width: 5.0,
                    decoration: new BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Search for relevant business contacts (buyer, sellers, freelancer, banker, shipper etc) and do business",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 5.0,
                    width: 5.0,
                    decoration: new BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Search for relevant product/service offers and finalize the order",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 0, left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 5.0,
                    width: 5.0,
                    decoration: new BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Join relevant communities and find business events, meetups and news",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontFamily: 'Oswald',
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                "Vision",
                textAlign: TextAlign.start,
                style: TextStyle(
                    //decoration: TextDecoration.underline,
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Text(
                "Tradister is goto place for business sourcing, networking and industry updates",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                "Mission",
                textAlign: TextAlign.start,
                style: TextStyle(
                    //decoration: TextDecoration.underline,
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Text(
                "Tradister is goto place for business sourcing, networking and industry updates",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
              child: Row(
                children: <Widget>[
                  Text(
                    "Mail at: ",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "admin@tradister.com ",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "to contact admin",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
