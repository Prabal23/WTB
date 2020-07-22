import 'package:flutter/material.dart';

class CopyrightPage extends StatefulWidget {
  @override
  _CopyrightPageState createState() => _CopyrightPageState();
}

class _CopyrightPageState extends State<CopyrightPage> {
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
                        "Copyright Policy",
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
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "Complaints regarding content posted on the Tradister website",
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
              "Tradister respects the intellectual property rights of others and desires to offer a platform which contains no content that violates those rights. Our User Agreement requires that information posted by Members be accurate, lawful and not in violation of the rights of third parties. To promote these objectives, Tradister provides a process for submission of complaints concerning content posted by our Members. Our policy and procedures are described and/or referenced in the sections that follow.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "Please note that whether or not we disable access to or remove content, Tradister may make a good faith attempt to forward the written notification, including the complainant’s contact information, to the Member who posted the content and/or take other reasonable steps to notify the Member that Tradister has received notice of an alleged violation of intellectual property rights or other content violation. It is also our policy, in appropriate circumstances and in our discretion, to disable and/or terminate the accounts of Members, or groups as the case may be, who infringe or repeatedly infringe the rights of others or otherwise post unlawful content. Please note that any notice or counter-notice you submit must be truthful and must be submitted under penalty of perjury. A false notice or counter-notice may give rise to personal liability. You may therefore want to seek the advice of legal counsel before submitting a notice or a counter-notice.",
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
              "Claims regarding copyright infringement",
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
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "Notice of Copyright Infringement:",
              textAlign: TextAlign.start,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "Pursuant to the Digital Millennium Copyright Act (17 U.S.C. § 512), Tradister has implemented procedures for receiving written notification of claimed infringements. Tradister has also designated an agent to receive notices of claimed copyright infringement. If you believe in good faith that your copyright has been infringed, you may complete and submit a Notice of Copyright Infringement form, or otherwise provide a written communication which contains:",
              textAlign: TextAlign.justify,
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
                      "An electronic or physical signature of the person authorized to act on behalf of the owner of the copyright interest;",
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
                      "A description of the copyrighted work that you claim has been infringed;",
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
                      "A description specifying the location on our website of the material that you claim is infringing;",
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
                      "Your email address and your mailing address and/or telephone number;",
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
                      "A statement by you that you have a good faith belief that the disputed use is not authorized by the copyright owner, its agent, or the law; and",
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
                      "A statement by you, made under penalty of perjury, that the information in your notice is accurate and that you are the copyright owner or authorized to act on the copyright owner’s behalf.",
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
              "Please submit your notice to Tradister Corporation’s Copyright Agent as follows:",
              textAlign: TextAlign.start,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "Contact us by email in the about section",
              textAlign: TextAlign.start,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 0, left: 20, right: 20),
            child: Text(
              "Or contact us by mail at:",
              textAlign: TextAlign.start,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "KashnKurry",
              textAlign: TextAlign.start,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 0, left: 20, right: 20),
            child: Text(
              "ATTN: Regus\n1 Boulevard Victor\nParis, FR 75015",
              textAlign: TextAlign.start,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
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
              "Counter-Notice:",
              textAlign: TextAlign.start,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 0, left: 20, right: 20),
            child: Text(
              "If you believe that a notice of copyright infringement has been improperly submitted against you, you may submit a Counter-Notice, pursuant to Sections 512(g)(2) and (3) of the Digital Millennium Copyright Act. You may complete the Counter-Notice Regarding Claim of Copyright Infringement form, or otherwise provide a written communication which contains:",
              textAlign: TextAlign.justify,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
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
                      "Your physical or electronic signature;",
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
                      "Identification of the material removed or to which access has been disabled;",
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
                      "A statement under penalty of perjury that you have a good faith belief that removal or disablement of the material was a mistake or that the material was misidentified;",
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
                      "Your full name, your email address, your mailing address, and a statement that you consent to the jurisdiction of the Federal District court (i) in the judicial district where your address is located if the address is in the United States, or (ii) located in the Northern District of California (Santa Clara County), if your address is located outside the United States, and that you will accept service of process from the Complainant submitting the notice or his/her authorized agent.",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "Please submit your Counter-Notice to Tradister’s Copyright Agent via email in our about section or mail to the address specified above.",
              textAlign: TextAlign.start,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
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
              "Claims regarding content other than copyright infringement",
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
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "For issues other than copyright infringement please contact us by email in the about section.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Text(
              "Notice regarding Associated Press content on Tradister: Associated Press text, photo, graphic, audio and/or video material shall not be published, broadcast, rewritten for broadcast or publication or redistributed directly or indirectly in any medium. Neither these AP materials nor any portion thereof may be stored in a computer except for personal and non-commercial use. Users may not download or reproduce a substantial portion of the AP material found on this web site. AP will not be held liable for any delays, inaccuracies, errors or omissions therefrom or in the transmission or delivery of all or any part thereof or for any damages arising from any of the foregoing.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w300),
            ),
          ),
        ]),
      ),
    );
  }
}
