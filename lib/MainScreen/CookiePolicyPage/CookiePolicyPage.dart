import 'package:chatapp_new/main.dart';
import 'package:flutter/material.dart';

class CookiePolicyPage extends StatefulWidget {
  @override
  _CookiePolicyPageState createState() => _CookiePolicyPageState();
}

class _CookiePolicyPageState extends State<CookiePolicyPage> {
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
                        "Cookie Policy",
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
          child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Text(
              "At Tradister, we believe in being clear and open about how we collect and use data related to you. In the spirit of transparency, this policy provides detailed information about how and when we use cookies. This cookie policy applies to any Tradister product or service that links to this policy or incorporates it by reference.",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "Does Tradister use cookies?",
              textAlign: TextAlign.justify,
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Yes. As described in ",
                    style: TextStyle(
                        //decoration: TextDecoration.underline,
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w300),
                  ),
                  TextSpan(
                    text: "Section 1.4 of our Privacy Policy",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                        color: header,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w300),
                  ),
                  TextSpan(
                    text:
                        ", we use cookies and other technologies to ensure everyone who uses Tradister has the best possible experience. Cookies also help us keep your account safe. By continuing to visit or use our services, you are agreeing to the use of cookies and similar technologies for the purposes we describe in this policy.",
                    style: TextStyle(
                        //decoration: TextDecoration.underline,
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "What is a cookie?",
              textAlign: TextAlign.justify,
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Text(
              "A cookie is a small file placed onto your device that enables Tradister features and functionality. For example, cookies enable us to identify your device, secure your access to Tradister and our sites generally, and even help us know if someone attempts to access your account from a different device. Cookies also enable you to easily share content on Tradister and help us serve relevant ads to you.",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "When does Tradister place cookies?",
              textAlign: TextAlign.justify,
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Text(
              "We use cookies on our sites (such as tradister.com) and mobile applications. Any browser visiting these sites will receive cookies from us. We also place cookies in your browser when you visit non-Tradister sites that host our plugins (for example, Tradister’s “Share” button) or tags.",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "What types of cookies does Tradister use?",
              textAlign: TextAlign.justify,
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Text(
              "We use two types: persistent cookies and session cookies. A persistent cookie helps us recognize you as an existing user, so it’s easier to return to Tradister or interact with our services without signing in again. After you sign in, a persistent cookie stays in your browser and will be read by Tradister when you return to one of our sites or a partner site that uses our services (for example, our sharing or job application buttons). Session cookies only last for as long as the session (usually the current visit to a website or a browser session).",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "What are cookies used for?",
              textAlign: TextAlign.justify,
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Text(
              "Cookies can be used to recognize you when you visit Tradister, remember your preferences, and give you a personalized experience that’s in line with your settings. Cookies also make your interactions with Tradister faster and more secure. Additionally, cookies allow us to bring you advertising both on and off the Tradister sites, and bring customized features to you through Tradister plugins such as our “Share” button.",
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
            margin: EdgeInsets.only(top: 0, left: 17, right: 20),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //children: _buildRows(6),
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          //width: 120.0,
                          //height: 60.0,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.5, color: Colors.black45)),
                          margin: EdgeInsets.all(3.0),
                          child: Text(
                            "Categories of Use",
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 300.0,
                          //height: 60.0,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.5, color: Colors.black45)),
                          margin: EdgeInsets.all(3.0),
                          child: Text(
                            "Description",
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: 130.0,
                          height: 87.0,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.5, color: Colors.black45)),
                          margin: EdgeInsets.all(3.0),
                          child: Text(
                            "Authentication",
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 300.0,
                          //height: 60.0,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.5, color: Colors.black45)),
                          margin: EdgeInsets.all(3.0),
                          child: Text(
                            "If you’re signed in to Tradister, cookies help us show you the right information and personalize your experience.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: 130.0,
                          height: 87.0,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.5, color: Colors.black45)),
                          margin: EdgeInsets.all(3.0),
                          child: Text(
                            "Security",
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 300.0,
                          //height: 60.0,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.5, color: Colors.black45)),
                          margin: EdgeInsets.all(3.0),
                          child: Text(
                            "We use cookies to enable and support our security features, and to help us detect malicious activity and violations of our User Agreement.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: 130.0,
                          height: 152.0,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.5, color: Colors.black45)),
                          margin: EdgeInsets.all(3.0),
                          child: Text(
                            "Preferences, features and services",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 300.0,
                          //height: 60.0,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.5, color: Colors.black45)),
                          margin: EdgeInsets.all(3.0),
                          child: Text(
                            "Cookies can tell us which language you prefer and what your communications preferences are. They can help you fill out forms on Tradister more easily. They also provide you with features, insights, and customized content in conjunction with our plugins. You can learn more about plugins in our Privacy Policy.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: 130.0,
                          height: 262.0,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.5, color: Colors.black45)),
                          margin: EdgeInsets.all(3.0),
                          child: Text(
                            "Advertising",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 300.0,
                          //height: 60.0,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.5, color: Colors.black45)),
                          margin: EdgeInsets.all(3.0),
                          child: Text(
                            "We may use cookies to show you relevant advertising both on and off the Tradister site. We may also use a cookie to learn whether someone who saw an ad later visited and took an action (e.g. downloaded a white paper or made a purchase) on the advertiser’s site. Similarly, our partners may use a cookie to determine whether we’ve shown an ad and how it performed, or provide us with information about how you interact with ads. We may also work with a partner to show you an ad on or off Tradister, such as after you’ve visited a partner’s site or application.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: 130.0,
                          height: 152.0,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.5, color: Colors.black45)),
                          margin: EdgeInsets.all(3.0),
                          child: Text(
                            "Performance, Analytics and Research",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 300.0,
                          //height: 60.0,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 0.5, color: Colors.black45)),
                          margin: EdgeInsets.all(3.0),
                          child: Text(
                            "Cookies help us learn how well our site and plugins perform in different locations. We also use cookies to understand, improve, and research products, features, and services, including when you access Tradister from other websites, applications, or devices such as your work computer or your mobile device.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "What is Do Not Track (DNT)?",
              textAlign: TextAlign.justify,
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Text(
              "DNT is a concept that has been promoted by regulatory agencies such as the U.S. Federal Trade Commission (FTC), for the Internet industry to develop and implement a mechanism for allowing Internet users to control the tracking of their online activities across websites by using browser settings. The World Wide Web Consortium (W3C) has been working with industry groups, Internet browsers, technology companies, and regulators to develop a DNT technology standard. While some progress has been made, it has been slow. No standard has been adopted to this date. As such, Tradister does not generally respond to “do not track” signals.",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "How are cookies used for advertising purposes?",
              textAlign: TextAlign.justify,
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Text(
              "We are not using cookies for advertising at this time.",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "What third-party cookies does Tradister use?",
              textAlign: TextAlign.justify,
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Our ",
                    style: TextStyle(
                        //decoration: TextDecoration.underline,
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w300),
                  ),
                  TextSpan(
                    text: "cookie table",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                        color: header,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text:
                        " lists some of the third party cookies on our sites. Please note that the names of cookies, pixels and other technologies may change over time. Please also note that companies and other organizations that sponsor pages on Tradister may use cookies, pixels or other technologies on their Tradister pages to learn about your interest in them.",
                    style: TextStyle(
                        //decoration: TextDecoration.underline,
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "Controlling cookies",
              textAlign: TextAlign.justify,
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Text(
              "Most browsers allow you to control cookies through their settings preferences. However, if you limit the ability of websites to set cookies, you may worsen your overall user experience, since it will no longer be personalized to you. It may also stop you from saving customized settings like login information.",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "What to do if you don’t want cookies to be set or want them to be removed?",
              textAlign: TextAlign.justify,
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Text(
              "If you are a Visitor, you can opt-out of our advertising cookies contact us in the about section",
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
            margin: EdgeInsets.only(top: 0, left: 20, right: 20),
            child: Text(
              "Other helpful resources:",
              textAlign: TextAlign.justify,
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
            child: Text(
              "To learn more about advertisers’ use of cookies the following links may be helpful:",
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
                      "European Interactive Digital Advertising Alliance (EU)",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          color: header,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
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
                      "Internet Advertising Bureau (US)",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          color: header,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
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
                      "Internet Advertising Bureau (EU)",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          color: header,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
            child: Text(
              "Browser manufacturers provide help pages relating to cookie management in their products. Please see below for more information.",
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
                      "Google Chrome",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          color: header,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
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
                      "Internet Explorer",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          color: header,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
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
                      "Mozilla Firefox",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          color: header,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
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
                      "Safari (Desktop)",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          color: header,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
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
                      "Safari (Mobile)",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          color: header,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
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
                      "Android Browser",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          color: header,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
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
                      "Opera",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          color: header,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
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
                      "Opera Mobile",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          color: header,
                          fontFamily: 'Oswald',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Text(
              "Opera Mobile For other browsers, please consult the documentation that your browser manufacturer provides.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                  //decoration: TextDecoration.underline,
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w300),
            ),
          ),
        ],
      )),
    );
  }

  List<Widget> _buildCells(int count) {
    return List.generate(
      count,
      (index) => Container(
        alignment: Alignment.center,
        //width: 120.0,
        //height: 60.0,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 0.5, color: Colors.black45)),
        margin: EdgeInsets.all(4.0),
        child: Text("${index + 1}", style: Theme.of(context).textTheme.title),
      ),
    );
  }

  List<Widget> _buildRows(int count) {
    return List.generate(
      count,
      (index) => Row(
        children: _buildCells(2),
      ),
    );
  }
}
