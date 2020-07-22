import 'package:flutter/material.dart';

class UserAgreementPage extends StatefulWidget {
  @override
  _UserAgreementPageState createState() => _UserAgreementPageState();
}

class _UserAgreementPageState extends State<UserAgreementPage> {
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
                        "User Agreement",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "1. Introduction",
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
              "1.1 Contract",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "When you use our Services you agree to all of these terms. Your use of our Services is also subject to our Cookie Policy and our Privacy Policy, which covers how we collect, use, share, and store your personal information. You agree that by clicking “Join Now”, “Join Tradister”, “Sign Up” or similar, registering, accessing or using our services (described below), you are agreeing to enter into a legally binding contract with Tradister (even if you are using our Services on behalf of a company). If you do not agree to this contract (“Contract” or “User Agreement”), do not click “Sign up” (or similar) and do not access or otherwise use any of our Services. If you wish to terminate this contract, at any time you can do so by closing your account and no longer accessing or using our Services.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "Services",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "This Contract applies to tradister.com, Tradister-branded apps, and other Tradister-related sites, apps, communications and other services that state that they are offered under this Contract (“Services”), including the offsite collection of data for those Services. Registered users of our Services are “Members” and unregistered users are “Visitors”. This Contract applies to both Members and Visitors.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "Tradister",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "You are entering into this Contract with Tradister (also referred to as “we” and “us”). We use the term “Designated Countries” to refer to countries in the European Union (EU), European Economic Area (EEA), and Switzerland. You are entering into this Contract with KashnKurry France Limited Company (“KashnKurry”) and KashnKurry will be the controller of your personal data provided to, or collected by or for, or processed in connection with our Services. This Contract applies to Members and Visitors. As a Visitor or Member of our Services, the collection, use and sharing of your personal data is subject to this Privacy Policy (which includes our Cookie Policy and other documents referenced in this Privacy Policy) and updates.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "1.2 Members and Visitors",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "When you register and join the Tradister Service or become a registered user on SlideShare, you become a Member. If you have chosen not to register for our Services, you may access certain features as a “Visitor.”",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "1.3 Change",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "We may make changes to the Contract. We may modify this Contract, our Privacy Policy and our Cookies Policies from time to time. If we make material changes to it, we will provide you notice through our Services, or by other means, to provide you the opportunity to review the changes before they become effective. We agree that changes cannot be retroactive. If you object to any changes, you may close your account. Your continued use of our Services after we publish or send a notice about our changes to these terms means that you are consenting to the updated terms.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "2. Obligations",
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
              "2.1 Service Eligibility",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "Here are some promises that you make to us in this Contract: You’re eligible to enter into this Contract and you are at least our “Minimum Age.” The Services are not for use by anyone under the age of 16. To use the Services, you agree that: (1) you must be the “Minimum Age” (described below) or older; (2) you will only have one Tradister account (and/or one SlideShare account, if applicable), which must be in your real name; and (3) you are not already restricted by Tradister from using the Services. Creating an account with false information is a violation of our terms, including accounts registered on behalf of others or persons under the age of 16. “Minimum Age” means 16 years old. However, if law requires that you must be older in order for Tradister to lawfully provide the Services to you without parental consent (including using of your personal data) then the Minimum Age is such older age.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "2.2 Your Account",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "You will keep your password a secret. You will not share an account with anyone else and will follow our rules and the law. Members are account holders. You agree to: (1) try to choose a strong and secure password; (2) keep your password secure and confidential; (3) not transfer any part of your account (e.g., connections) and (4) follow the law and our list of Dos and Don’ts and Professional Community Policies. You are responsible for anything that happens through your account unless you close it or report misuse. As between you and others (including your employer), your account belongs to you. However, if the Services were purchased by another party for you to use (e.g. Recruiter seat bought by your employer), the party paying for such Service has the right to control access to and get reports on your use of such paid Service; however, they do not have rights to your personal account.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "2.3 Payment",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "You’ll honor your payment obligations and you are okay with us storing your payment information. You understand that there may be fees and taxes that are added to our prices. We don't guarantee refunds. If you buy any of our paid Services (“Premium Services”), you agree to pay us the applicable fees and taxes and to additional terms specific to the paid Services. Failure to pay these fees will result in the termination of your paid Services. Also, you agree that:",
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
                      "Your purchase may be subject to foreign exchange fees or differences in prices based on location (e.g. exchange rates).",
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
                      "We may store and continue billing your payment method (e.g. credit card) even after it has expired, to avoid interruptions in your Services and to use to pay other Services you may buy.",
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
                      "If you purchase a subscription, your payment method automatically will be charged at the start of each subscription period for the fees and taxes applicable to that period. To avoid future charges, cancel before the renewal date. Learn how to cancel or suspend your Premium Services.",
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
                      "All of your purchases of Services are subject to Tradister’s refund policy.",
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
                      "We may calculate taxes payable by you based on the billing information that you provide us at the time of purchase.",
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
              "You can get a copy of your invoice through your Tradister account settings under “Purchase History”.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "2.4 Notices and Messages",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "You’re okay with us providing notices and messages to you through our websites, apps, and contact information. If your contact information is out of date, you may miss out on important notices. You agree that we will provide notices and messages to you in the following ways: (1) within the Service, or (2) sent to the contact information you provided us (e.g., email, mobile number, physical address). You agree to keep your contact information up to date. Please review your settings to control and limit messages you receive from us.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "2.5 Sharing",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "When you share information on our Services, others can see, copy and use that information. Our Services allow messaging and sharing of information in many ways, such as your profile, links to news articles, offer postings, messages and blogs. Information and content that you share or post may be seen by other Members, Visitors or others (including off of the Services). Where we have made settings available, we will honor the choices you make about who can see content or information (e.g., message content to your addressees, sharing content only to Tradister connections, restricting your profile visibility from search engines, or opting not to notify others of your Tradister profile update). For job searching activities, we default to not notifying your connections network or the public. So if you apply for a job through our Service or opt to signal that you are interested in a job, our default is to share it only with the job poster. We are not obligated to publish any information or content on our Service and can remove it in our sole discretion, with or without notice.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "3. Rights and Limits",
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
              "3.1. Your License to Tradister",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "You own all of the content, feedback, and personal information you provide to us, but you also grant us a non-exclusive license to it. We’ll honor the choices you make about who gets to see your information and content, including how it can be used for ads. As between you and Tradister, you own the content and information that you submit or post to the Services, and you are only granting Tradister and our affiliates the following non-exclusive license: A worldwide, transferable and sublicensable right to use, copy, modify, distribute, publish, and process, information and content that you provide through our Services and the services of others, without any further consent, notice and/or compensation to you or others. These rights are limited in the following ways:",
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
                      "You can end this license for specific content by deleting such content from the Services, or generally by closing your account, except (a) to the extent you shared it with others as part of the Service and they copied, re-shared it or stored it and (b) for the reasonable time it takes to remove from backup and other systems.",
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
                      "We will not include your content in advertisements for the products and services of third parties to others without your separate consent (including sponsored content). However, we have the right, without payment to you or others, to serve ads near your content and information, and your social actions may be visible and included with ads, as noted in the Privacy Policy.",
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
                      "We will get your consent if we want to give others the right to publish your content beyond the Services. However, if you choose to share your post as \"public\", we will enable a feature that allows other Members to embed that public post onto third-party services, and we enable search engines to make that public content findable though their services.",
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
                      "While we may edit and make format changes to your content (such as translating it, modifying the size, layout or file type or removing metadata), we will not modify the meaning of your expression.",
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
                      "Because you own your content and information and we only have non-exclusive rights to it, you may choose to make it available to others, including under the terms of a Creative Commons license.",
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
              "You and Tradister agree that if content includes personal data, it is subject to our Privacy Policy. You and Tradister agree that we may access, store, process and use any information and personal data that you provide in accordance with the terms of the Privacy Policy and your choices (including settings). By submitting suggestions or other feedback regarding our Services to Tradister, you agree that Tradister can use and share (but does not have to) such feedback for any purpose without compensation to you. You promise to only provide information and content that you have the right to share, and that your Tradister profile will be truthful. You agree to only provide content or information that does not violate the law nor anyone’s rights (including intellectual property rights). You also agree that your profile information will be truthful. Tradister may be required by law to remove certain information or content in certain countries.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "3.2 Service Availability",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "We may change, suspend or end any Service, or change and modify prices prospectively in our discretion. To the extent allowed under law, these changes may be effective upon notice provided to you. We may change or discontinue any of our Services. We don’t promise to store or keep showing any information and content that you’ve posted. Tradister is not a storage service. You agree that we have no obligation to store, maintain or provide you a copy of any content or information that you or others provide, except to the extent required by applicable law and as noted in our Privacy Policy.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "3.3 Other Content, Sites and Apps",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "Your use of others’ content and information posted on our Services, is at your own risk. Others may offer their own products and services through our Services, and we aren’t responsible for those third-party activities. By using the Services, you may encounter content or information that might be inaccurate, incomplete, delayed, misleading, illegal, offensive or otherwise harmful. Tradister generally does not review content provided by our Members or others. You agree that we are not responsible for others’ (including other Members’) content or information. We cannot always prevent this misuse of our Services, and you agree that we are not responsible for any such misuse. You also acknowledge the risk that you or your organization may be mistakenly associated with content about others when we let connections and followers know you or your organization were mentioned in the news. You are responsible for deciding if you want to access or use third-party apps or sites that link from our Services. If you allow a third-party app or site to authenticate you or connect with your Tradister account, that app or site can access information on Tradister related to you and your connections. Third-party apps and sites have their own legal terms and privacy policies, and you may be giving others permission to use your information in ways we would not. Except to the limited extent it may be required by applicable law, Tradister is not responsible for these other sites and apps – use these at your own risk. Please see our Privacy Policy.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "3.4 Limits",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "We have the right to limit how you connect and interact on our Services. Tradister reserves the right to limit your use of the Services, including the number of your connections and your ability to contact other Members. Tradister reserves the right to restrict, suspend, or terminate your account if Tradister believes that you may be in breach of this Contract or law or are misusing the Services (e.g., violating any of the Dos and Don’ts or Professional Community Policies).",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "3.5 Intellectual Property Rights",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "We’re providing you notice about our intellectual property rights. Tradister reserves all of its intellectual property rights in the Services. Using the Services does not give you any ownership in our Services or the content or information made available through our Services. Trademarks and logos used in connection with the Services are the trademarks of their respective owners. Tradister, SlideShare, and “in” logos and other Tradister trademarks, service marks, graphics, and logos used for our Services are trademarks or registered trademarks of Tradister.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "3.6 Automated Processing",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "We use data and information about you to make relevant suggestions to you and others. We will use the information and data that you provide and that we have about Members to make recommendations for connections, content and features that may be useful to you. For example, we use data and information about you to recommend jobs to you and you to recruiters. Keeping your profile accurate and up-to-date helps us to make these recommendations more accurate and relevant.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "4. Disclaimer and Limit of Liability",
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
              "4.1 No Warranty",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "This is our disclaimer of legal liability for the quality, safety, or reliability of our Services. TO THE EXTENT ALLOWED UNDER LAW, Tradister AND ITS AFFILIATES (AND THOSE THAT Tradister WORKS WITH TO PROVIDE THE SERVICES) (A) DISCLAIM ALL IMPLIED WARRANTIES AND REPRESENTATIONS (E.G. WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, ACCURACY OF DATA, AND NONINFRINGEMENT); (B) DO NOT GUARANTEE THAT THE SERVICES WILL FUNCTION WITHOUT INTERRUPTION OR ERRORS, AND (C) PROVIDE THE SERVICE (INCLUDING CONTENT AND INFORMATION) ON AN “AS IS” AND “AS AVAILABLE” BASIS. SOME LAWS DO NOT ALLOW CERTAIN DISCLAIMERS, SO SOME OR ALL OF THESE DISCLAIMERS MAY NOT APPLY TO YOU.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "4.2 Exclusion of Liability",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "These are the limits of legal liability we may have to you. TO THE EXTENT PERMITTED UNDER LAW (AND UNLESS Tradister HAS ENTERED INTO A SEPARATE WRITTEN AGREEMENT THAT OVERRIDES THIS CONTRACT), Tradister AND ITS AFFILIATES (AND THOSE THAT Tradister WORKS WITH TO PROVIDE THE SERVICES) SHALL NOT BE LIABLE TO YOU OR OTHERS FOR ANY INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL OR PUNITIVE DAMAGES, OR ANY LOSS OF DATA, OPPORTUNITIES, REPUTATION, PROFITS OR REVENUES, RELATED TO THE SERVICES (E.G. OFFENSIVE OR DEFAMATORY STATEMENTS, DOWN TIME OR LOSS, USE OF, OR CHANGES TO, YOUR INFORMATION OR CONTENT). IN NO EVENT SHALL THE LIABILITY OF Tradister AND ITS AFFILIATES (AND THOSE THAT Tradister WORKS WITH TO PROVIDE THE SERVICES) EXCEED, IN THE AGGREGATE FOR ALL CLAIMS, AN AMOUNT THAT IS THE LESSER OF (A) FIVE TIMES THE MOST RECENT MONTHLY OR YEARLY FEE THAT YOU PAID FOR A PREMIUM SERVICE, IF ANY, OR (B) US \$1000. THIS LIMITATION OF LIABILITY IS PART OF THE BASIS OF THE BARGAIN BETWEEN YOU AND Tradister AND SHALL APPLY TO ALL CLAIMS OF LIABILITY (E.G. WARRANTY, TORT, NEGLIGENCE, CONTRACT, LAW) AND EVEN IF Tradister OR ITS AFFILIATES HAS BEEN TOLD OF THE POSSIBILITY OF ANY SUCH DAMAGE, AND EVEN IF THESE REMEDIES FAIL THEIR ESSENTIAL PURPOSE. SOME LAWS DO NOT ALLOW THE LIMITATION OR EXCLUSION OF LIABILITY, SO THESE LIMITS MAY NOT APPLY TO YOU.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "5. Termination",
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
              "We can each end this Contract anytime we want. Both you and Tradister may terminate this Contract at any time with notice to the other. On termination, you lose the right to access or use the Services. The following shall survive termination",
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
                      "Our rights to use and disclose your feedback;",
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
                      "Members and/or Visitors’ rights to further re-share content and information you shared through the Service to the extent copied or re-shared prior to termination;",
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
                      "Sections 4, 6, 7, and 8.2 of this Contract;",
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
                      "Any amounts owed by either party prior to termination remain owed after termination.",
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
              "You can visit our About section to close your account by contacting admin.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "6. Governing Law and Dispute Resolution",
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
              "In the unlikely event we end up in a legal dispute, Tradister and you agree to resolve it in California courts using California law, or Dublin, Ireland courts using Irish law. If you live in the Designated Countries: You and Tradister Ireland agree that the laws of Ireland, excluding conflict of laws rules, shall exclusively govern any dispute relating to this Contract and/or the Services. You and Tradister Ireland agree that claims and disputes can be litigated only in Dublin, Ireland, and we each agree to personal jurisdiction of the courts located in Dublin, Ireland. For others outside of Designated Countries, including those who live outside of the United States: You and Tradister agree that the laws of the State of California, U.S.A., excluding its conflict of laws rules, shall exclusively govern any dispute relating to this Contract and/or the Services. You and Tradister both agree that all claims and disputes can be litigated only in the federal or state courts in Santa Clara County, California, USA, and you and Tradister each agree to personal jurisdiction in those courts.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "7. General Terms",
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
              "Here are some important details about the Contract. If a court with authority over this Contract finds any part of it unenforceable, you and we agree that the court should modify the terms to make that part enforceable while still achieving its intent. If the court cannot do that, you and we agree to ask the court to remove that unenforceable part and still enforce the rest of this Contract. To the extent allowed by law, the English language version of this Contract is binding and other translations are for convenience only. This Contract (including additional terms that may be provided by us when you engage with a feature of the Services) is the only agreement between us regarding the Services and supersedes all prior agreements for the Services. If we don't act to enforce a breach of this Contract, that does not mean that Tradister has waived its right to enforce this Contract. You may not assign or transfer this Contract (or your membership or use of Services) to anyone without our consent. However, you agree that Tradister may assign this Contract to its affiliates or a party that buys it without your consent. There are no third-party beneficiaries to this Contract. You agree that the only way to provide us legal notice is at the addresses provided in Section 10.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "8. Tradister “Dos and Don’ts”",
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
              "8.1. Dos",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "Tradister is a community of professionals. This list of “Dos and Don’ts” along with Professional Community Policies limit what you can and cannot do on our Services. You agree that you will:",
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
                      "Comply with all applicable laws, including, without limitation, privacy laws, intellectual property laws, anti-spam laws, export control laws, tax laws, and regulatory requirements;",
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
                      "Provide accurate information to us and keep it updated;",
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
                      "Use your real name on your profile; and",
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
                      "Use the Services in a professional manner.",
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
              "8.2. Don’ts",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "You agree that you will not:",
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
                      "Create a false identity on Tradister, misrepresent your identity, create a Member profile for anyone other than yourself (a real person), or use or attempt to use another’s account;",
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
                      "Develop, support or use software, devices, scripts, robots, or any other means or processes (including crawlers, browser plugins and add-ons, or any other technology) to scrape the Services or otherwise copy profiles and other data from the Services;",
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
                      "Override any security feature or bypass or circumvent any access controls or use limits of the Service (such as caps on keyword searches or profile views);",
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
                      "Copy, use, disclose or distribute any information obtained from the Services, whether directly or through third parties (such as search engines), without the consent of Tradister;",
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
                      "Disclose information that you do not have the consent to disclose (such as confidential information of others (including your employer));",
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
                      "Violate the intellectual property rights of others, including copyrights, patents, trademarks, trade secrets, or other proprietary rights. For example, do not copy or distribute (except through the available sharing functionality) the posts or other content of others without their permission, which they may give by posting under a Creative Commons license;",
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
                      "Violate the intellectual property or other rights of Tradister, including, without limitation, (i) copying or distributing our learning videos or other materials or (ii) copying or distributing our technology, unless it is released under open source licenses; (iii) using the word Ttradister” or our logos in any business name, email, or URL except as provided in the Brand Guidelines;",
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
                      "Post anything that contains software viruses, worms, or any other harmful code;",
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
                      "Reverse engineer, decompile, disassemble, decipher or otherwise attempt to derive the source code for the Services or any related technology that is not open source;",
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
                      "Imply or state that you are affiliated with or endorsed by Tradister without our express consent (e.g., representing yourself as an accredited Tradister trainer);",
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
                      "Rent, lease, loan, trade, sell/re-sell or otherwise monetize the Services or related data or access to the same, without Tradister’s consent;",
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
                      "Deep-link to our Services for any purpose other than to promote your profile or a Group on our Services, without Tradister’s consent;",
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
                      "Use bots or other automated methods to access the Services, add or download contacts, send or redirect messages;",
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
                      "Monitor the Services’ availability, performance or functionality for any competitive purpose;",
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
                      "Engage in “framing,” “mirroring,” or otherwise simulating the appearance or function of the Services;",
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
                      "Overlay or otherwise modify the Services or their appearance (such as by inserting elements into the Services or removing, covering, or obscuring an advertisement included on the Services);",
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
                      "Interfere with the operation of, or place an unreasonable load on, the Services (e.g., spam, denial of service attack, viruses, gaming algorithms); and/or",
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
                      "Violate the Professional Community Policies or any additional terms concerning a specific Service that are provided when you sign up for or start using such Service.",
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
              "9. Complaints Regarding Content",
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
              "Contact information for complaint about content provided by our Members. We respect the intellectual property rights of others. We require that information posted by Members be accurate and not in violation of the intellectual property rights or other rights of third parties. We provide a policy and process for complaints concerning content posted by our Members.",
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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "10. How To Contact Us",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: Text(
              "Our Contact information. Our About section provides information about our Services. If you want to send us notices or service of process, please contact us by email in the about section.",
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
}
