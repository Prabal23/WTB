import 'package:chatapp_new/main.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
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
                        "Privacy Policy",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "Tradister’s mission is to connect the world’s business professionals to allow them to be more productive and successful. Central to this mission is our commitment to be transparent about the data we collect about you, how it is used and with whom it is shared.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "This Privacy Policy applies when you use our Services (described below). We offer our users choices about the data we collect, use and share as described in this Privacy Policy,  Cookie Policy , Settings and our Help Center . View our Privacy Policy video.",
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
              "Introduction",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We are a social network and online platform for business professionals. People use our Services to find and be found for business opportunities and to connect with others and information. Our Privacy Policy applies to any Member or Visitor to our Services.Our registered users (“Members”) share their professional identities, engage with their network, exchange knowledge and professional insights, post and view relevant content, learn and find business opportunities. Content and data on some of our Services is viewable to non-members (“Visitors”).",
              textAlign: TextAlign.justify,
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Oswald',
                  fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We use the term “Designated Countries” to refer to countries in the European Union (EU), European Economic Area (EEA), and Switzerland.",
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
              "Services",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "This Privacy Policy, including our Cookie Policy applies to your use of our Services. This Privacy Policy applies to tradister.com, Tradister-branded apps, and other Tradister-related sites, apps, communications and services ( “Services), but excluding services that state that they are offered under a different privacy policy",
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
              "Data Controllers and Contracting Parties",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "KashnKurry France Company (“KashnKurry”) will be the controller of your personal data provided to, or collected by or for, or processed in connection with our Services; you are entering into the  User Agreement with KashnKurry France.",
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
              "Change",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "Changes to the Privacy Policy apply to your use of our Services after the “effective date.” Tradister (“we” or “us”) can modify this Privacy Policy, and if we make material changes to it, we will provide notice through our Services, or by other means, to provide you the opportunity to review the changes before they become effective. If you object to any changes, you may close your account by contacting admin. You acknowledge that your continued use of our Services after we publish or send a notice about our changes to this Privacy Policy means that the collection, use and sharing of your personal data is subject to the updated Privacy Policy.",
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
              "1. Data We Collect",
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
              "1.1 Data You Provide To Us",
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
              "You provide data to create an account with us.",
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
              "Registration",
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
              "To create an account you need to provide data including your name, email address and/or mobile number, and a password.",
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
              "You create your Tradister profile (a complete profile helps you get the most from our Services",
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
              "Profile",
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
              "You have choices about the information on your profile, such as your education, work experience, skills, photo, city or area and portfolio. You don’t have to provide additional information on your profile; however, profile information helps you to get more from our Services, including verified badge and business opportunities. It’s your choice whether to include sensitive information on your profile and to make that sensitive information public. Please do not post or add personal data to your profile that you would not want to be publicly available.",
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
              "You give other data to us, such as by syncing your address book or calendar.",
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
              "Posting and Uploading",
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
              "We collect personal data from you when you provide, post or upload it to our Services, such as when you fill out a form, (e.g., with demographic data or business information). If you opt to import your address book, we receive your contacts (including contact information your service provider(s) or app automatically added to your address book when you communicated with addresses or numbers not already in your list). If you sync your contacts or calendars with our Services, we will collect your address book and calendar meeting information to keep growing your network by suggesting connections for you and others, and by providing information about them, e.g. times, places, attendees and contacts. You don’t have to post or upload personal data; though if you don’t, it may limit your ability to grow and engage with your network over our Services.",
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
              "1.2 Data From Others",
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
              "Others may post or write about you.",
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
              "Content and News",
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
              "You and others may post content that includes information about you (as part of articles, posts, comments, videos) on our Services. we collect public information about you, such as professional-related news and accomplishments (e.g., patents granted, professional recognition, conference speakers, products, etc.) and make it available as part of our Services (e.g. suggestions for your profile, or notifications of mentions in the news ). Others may sync their contacts or calendar with our Services.",
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
              "Contact and Calendar Information",
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
              "We receive personal data (including contact information) about you when others import or sync their contacts or calendar with our Services, associate their contacts with Member profiles, or send messages using our Services (including invites or connection requests). If you or others opt-in to sync email accounts with our Services, we will also collect “email header” information that we can associate with Member profiles.",
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
              "Customers and partners may provide data to us.",
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
              "Partners",
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
              "We receive personal data about you when you use the services of our customers and partners, such as shops and orders.",
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
              "1.3 Service Use",
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
              "We log your visits and use of our Services, including mobile apps. We log usage data when you visit or otherwise use our Services, including our sites, app and platform technology (e.g., our off-site plugins), such as when you view or click on content (e.g., learning video) or ads (on or off our sites and apps), perform a search, install or update one of our mobile apps, share articles or apply for jobs. We use log-ins, cookies, device information and internet protocol (“IP”) addresses to identify you and log your use.",
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
              "1.4 Cookies, Web Beacons and Other Similar Technologies",
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
              "We collect data through cookies and similar technologies. As further described in our Cookie Policy , we use cookies and similar technologies (e.g., web beacons, pixels, ad tags and device identifiers) to recognize you and/or your device(s) on, off and across different Services and devices. We also allow some others to use cookies as described in our Cookie Policy. We do not use cookies data for adveritising and tracking your behavior. We are building module to give you cookie control soon.",
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
              "1.5 Your Device and Location",
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
              "We receive data from your devices and networks, including location data. When you visit or leave our Services (including our plugins or cookies or similar technology on the sites of others), we receive the URL of both the site you came from and the one you go to next. We also get information about your IP address, proxy server, operating system, web browser and add-ons, device identifier and features, and/or ISP or your mobile carrier. If you use our Services from a mobile device, that device will send us data about your location based on your phone settings. We will ask you to opt-in before we use GPS or other tools to identify your precise location.",
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
              "1.6 Messages",
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
              "If you communicate through our Services, we learn about that. We collect information about you when you send, receive, or engage with messages in connection with our Services. For example, if you get a Tradister connection request, we track whether you have acted on it and will send you reminders. We also use automatic scanning technology on messages.",
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
              "1.7 Sites and Services of Others",
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
              "We get data when you visit sites that include our plugins, ads or cookies or log-in to others’ services with your Tradister account. We receive information about your visits and interaction with services provided by others when you log-in with Tradister or visit others’ services that include our plugins (such as “Share on Tradister” or “Apply with Tradister”), ads, cookies or similar technologies.",
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
              "1.8 Other",
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
              "We are improving our Services, which means we get new data and create new ways to use data. Our Services are dynamic, and we often introduce new features, which may require the collection of new information. If we collect materially different personal data or materially change how we use your data, we will notify you and may also modify this Privacy Policy.",
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
              "2. How We Use Your Data",
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
              "We use your data to provide, support, personalize and develop our Services. How we use your personal data will depend on which Services you use, how you use those Services and the choices you make in your settings. We use the data that we have about you to provide and personalize, including with the help of automated systems and inferences we make, our Services so that they can be more relevant and useful to you and others.",
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
              "Our Services help you connect with others, find and be found for work and business opportunities, stay informed, and be more productive. We use your data to authorize access to our Services.",
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
              "Stay Connected",
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
              "Our Services allow you to stay in touch and up to date with colleagues, partners, clients, and other professional contacts. To do so, you will “connect” with the professionals who you choose, and who also wish to “connect” with you. Subject to your settings, when you connect with other Members, you will be able to search each others’ connections in order to exchange professional opportunities.",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We will use data about you (such as your profile, profiles you have viewed or data provided through address book uploads or partner integrations) to help others find your profile, suggest connections for you and others (e.g. Members who share your contacts or job experiences) and enable you to invite others to become a Member and connect with you. You can also opt-in to allow us to use your precise location or proximity to others for certain tasks (e.g. to suggest other nearby Members for you to connect with, calculate the commute to a new job, or notify your connections that you are at a professional event).",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "It is your choice whether to invite someone to our Services, send a connection request, or allow another Member to become your connection. When you invite someone to connect with you, your invitation will include your name, photo, network and contact information. We will send invitation reminders to the person you invited. You can choose whether or not to share your own list of connections with your connections. Visitors have choices about how we use their data.",
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
              "Stay Informed",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "Our Services allow you to stay informed about news, events and ideas regarding professional topics you care about, and from professionals you respect. Our Services also allow you to improve your professional skills, or learn new ones. We use the data we have about you (e.g., data you provide, data we collect from your engagement with our Services and inferences we make from the data we have about you), to recommend relevant content and conversations on our Services. We use your content, activity and other data, including your name and picture, to provide notices to your network and others. For example, subject to your settings, we may notify others that you have updated your profile, posted a blog, took a social action, made new connections or were mentioned in the news.",
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
              "Business",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "Our Services allow you to explore business opportunities. Your profile can be found by those looking to source product or service or be hired by you. We will use your data to recommend business to you and you to other users. We may use automated systems to profile and provide recommendations to help make our Services more relevant to our Members, Visitors and customers. Keeping your profile accurate and up-to-date may help you better connect to others and to opportunities through our Services.",
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
              "Productivity",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "Our Services allow you to collaborate with colleagues, search for potential clients, customers, partners and others to do business with. Our Services allow you to communicate with other Members and schedule and prepare meetings with them. If your settings allow, we scan messages to provide “bots” or similar tools that facilitate tasks such as scheduling meetings, drafting responses, summarizing messages or recommending next steps. Learn more.",
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
              "2.2 Communications",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We contact you and enable communications between Members. We offer settings to control what messages you receive and how often you receive some types of messages. We will contact you through email, mobile phone, notices posted on our websites or apps, messages to your Tradister inbox, and other ways through our Services, including text messages and push notifications. We will send you messages about the availability of our Services, security, or other service-related issues. We also send messages about how to use the Services, network updates, reminders, work suggestions and promotional messages from us and our partners. You may change your communication preferences at any time soon. Please be aware that you cannot opt-out of receiving service messages from us, including security and legal notices. We also enable communications between you and others through our Services, including for example invitations, communities and messages between connections.",
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
              "2.3 Advertising",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We do not do ads at this time. When we serve ads. We will notify you with updtes in our policy.",
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
              "2.4 Marketing",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We promote our Services to you and others. We use data and content about Members for invitations and communications promoting membership and network growth, engagement and our Services",
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
              "2.5 Developing Services and Research",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We develop our Services and conduct research",
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
              "Service Development",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We use data, including public feedback, to conduct research and development for the further development of our Services in order to provide you and others with a better, more intuitive and personalized experience, drive membership growth and engagement on our Services, and help connect professionals to each other and to economic opportunity.",
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
              "Other Research",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We seek to create economic opportunity for Members of the global workforce and to help them be more productive and successful. We use the personal data available to us to research social, economic and workplace trends such as sourcing products and policies that help bridge the gap in various industries and geographic areas. In some cases, we work with trusted third parties to perform this research, under controls that are designed to protect your privacy. We publish or allow others to publish economic insights, presented as aggregated data rather than personal data.",
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
              "Surveys",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "Polls and surveys are conducted by us and others through our Services. You are not obligated to respond to polls or surveys, and you have choices about the information you provide.",
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
              "2.7 Customer Support",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We use data to help you and fix problems. We use the data (which can include your communications) to investigate, respond to and resolve complaints and Service issues (e.g., bugs).",
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
              "2.8 Aggregate Insights",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We use data to generate aggregate insights. We use your data to produce and share aggregated insights that do not identify you. For example we may use your data to generate statistics about our members, their profession or industry, to calculate ad impressions served or clicked on, or to publish visitor demographics for a Service or demographic workforce insights.",
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
              "2.9 Security and Investigations",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We use data for security, fraud prevention and investigations. We use your data (including your communications) if we think it’s necessary for security purposes or to investigate possible fraud or other violations of our  User Agreement or this Privacy Policy and/or attempts to harm our Members or Visitors.",
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
              "3. How We Share Information",
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
              "3.1 Our Services",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "Any data that you include on your profile and any content you post or social action (e.g. likes, follows, comments, shares) you take on our Services will be seen by others.",
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
              "Profile",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "Your profile is fully visible to all Members and customers of our Services. It can also be visible to others on or off of our Services (e.g., Visitors to our Services or users of third- party search engines). As detailed in our Help Center , your settings, degree of connection with the viewing Member, the subscriptions they may have, their usage of our Services , access channels and search types (e.g., by name or by keyword) impact the availability of your profile and whether they can view certain fields in your profile. Posts, Likes, Follows, Comments, Messages Our Services allow viewing and sharing information including through posts, likes, follows and comments.",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "Our Services allow viewing and sharing information including through posts, likes, follows and comments.",
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
                      "When you share an article or a post (e.g., an update, image, video or article) publicly it can be viewed by everyone and re-shared anywhere (subject to your settings we are working on). Members, Visitors and others will be able to find and see your publicly-shared content, including your name (and photo if you have provided one).",
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
                      "In a group, posts are visible to others in the group. Your membership in groups is public and part of your profile, but you can change visibility in your settings soon we are building this feature.",
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
                      "Any information you share through companies’ or other organizations’ pages on our Services will be viewable by it and others who visit those pages.",
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
                      "When you follow a person or organization, you are visible to others and that “page owner” as a follower.",
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
                      "We let senders know when you act on their message, where applicable.",
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
                      "When you like or re-share or comment on another’s content (including ads), others will be able to view these “social actions” and associate it with you (e.g., your name, profile and photo if you provided it).",
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
              "3.2 Communication Archival",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "Regulated Members may need to store communications outside of our Service. Some Members (or their employers) need, for legal or professional compliance, to archive their communications and social media activity, and will use services of others to provide these archival services. We enable archiving of messages by those Members outside of our Services. For example, a financial advisor needs to archive communications with her clients through our Services in order to maintain her professional financial advisor license.",
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
              "3.3 Others’ Services",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "You may link your account with others’ services so that they can look up your contacts’ profiles, post your shares on such platforms, or start conversations with your connections on such platforms. Excerpts from your profile will also appear on the services of others. Other services may look-up your profile. When you opt to link your account with other services, personal data will become available to them. The sharing and use of that personal data will be described in, or linked to, a consent screen when you opt to link the accounts. For example, you may link your Twitter or WeChat account to share content from our Services into these other services, or your email provider may give you the option to upload your Tradister contacts into its own service.",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "Excerpts from your profile will appear on the services of others (e.g., search engine results, mail and calendar applications that show a user a “mini” Tradister profile of the person they are meeting or messaging, social media aggregators, talent and lead managers). “Old” profile information remains on these services until they update their data cache with changes you made to your profile.",
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
              "3.4 Related Services",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We share your data across our different Services and Tradister-affiliated entities. We will share your personal data with our affiliates to provide and develop our Services. We may combine information internally across the different Services covered by this Privacy Policy to help our Services be more relevant and useful to you and others. For example, SlideShare will recommend better content to you based on your Tradister profile or the articles you read on the Tradister Services, and we can personalize your feed or job recommendations based on your learning video history, because we are able to identify you across different Services using cookies or similar technologies.",
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
              "3.5 Service Providers",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We may use others to help us with our Services. We use others to help us provide our Services (e.g., maintenance, analysis, audit, payments, fraud detection, marketing and development). They will have access to your information as reasonably necessary to perform these tasks on our behalf and are obligated not to disclose or use it for other purposes.",
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
              "3.6 Legal Disclosures",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 0),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text:
                        "We may need to share your data when we believe it’s required by law or to help protect the rights and safety of you, us or others. It is possible that we will need to disclose information about you when required by law, subpoena, or other legal process or if we have a good faith belief that disclosure is reasonably necessary to (1) investigate, prevent, or take action regarding suspected or actual illegal activities or to assist government enforcement agencies; (2) enforce our agreements with you, (3) investigate and defend ourselves against any third-party claims or allegations, (4) protect the security or integrity of our Service (such as by sharing with companies facing similar threats); or (5) exercise or protect the rights and safety of Tradister, our Members, personnel, or others. We attempt to notify Members about legal demands for their personal data when appropriate in our judgment, unless prohibited by law or court order or when the request is an emergency. We may dispute such demands when we believe, in our discretion, that the requests are overbroad, vague or lack proper authority, but we do not promise to challenge every demand. To learn more see our ",
                    style: TextStyle(
                        //decoration: TextDecoration.underline,
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w300),
                  ),
                  TextSpan(
                    text: "Data Request Guidelines ",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                        color: header,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: "and ",
                    style: TextStyle(
                        //decoration: TextDecoration.underline,
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w300),
                  ),
                  TextSpan(
                    text: "Transparency Report.",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                        color: header,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              "3.7 Change in Control or Sale",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We may share your data when our business is sold to others, but it must continue to be used in accordance with this Privacy Policy. We can also share your personal data as part of a sale, merger or change in control, or in preparation for any of these events. Any other entity which buys us or part of our business will have the right to continue to use your data, but only in the manner set out in this Privacy Policy unless you agree otherwise.",
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
              "4. Your Choices & Obligations",
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
              "4.1 Data Retention",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We keep most of your personal data for as long as your account is open. We retain your personal data while your account is in existence or as needed to provide you Services. This includes data you or others provided to us and data generated or inferred from your use of our Services. Even if you only use our Services when looking for a new job every few years, we will retain your information and keep your profile open until you decide to close your account. In some cases we choose to retain certain information (e.g., visits to sites carrying our “share with Tradister”) in a depersonalized or aggregated form.",
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
              "4.2 Rights to Access and Control Your Personal Data",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "You can access or delete your personal data. You have many choices about how your data is collected, used and shared. You can email admin if you want to delete your profile. \nFor personal data that we have about you:",
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
            margin: EdgeInsets.only(top: 0, left: 20, right: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 5.0,
                  width: 5.0,
                  decoration: new BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        top: 10, left: 20, right: 20, bottom: 20),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Delete Data: ",
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text:
                                "You can ask us to erase or delete all or some of your personal data (e.g., if it is no longer necessary to provide Services to you).",
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
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        top: 0, left: 20, right: 20, bottom: 20),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Change or Correct Data: ",
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text:
                                "You can edit some of your personal data through your account. You can also ask us to change, update or fix your data in certain cases, particularly if it’s inaccurate.",
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
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        top: 0, left: 20, right: 20, bottom: 20),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                "Object to, or Limit or Restrict, Use of Data: ",
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text:
                                "You can ask us to stop using all or some of your personal data (e.g., if we have no legal right to keep using it) or to limit our use of it (e.g., if your personal data is inaccurate or unlawfully held).",
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
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        top: 0, left: 20, right: 20, bottom: 20),
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Right to Access and/or Take Your Data: ",
                            style: TextStyle(
                                //decoration: TextDecoration.underline,
                                fontSize: 15,
                                color: Colors.black,
                                fontFamily: 'Oswald',
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text:
                                "You can ask us for a copy of your personal data and can ask for a copy of personal data you provided in machine readable form.",
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
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Text(
              "4.3 Account Closure",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We delete all your data after account closue.",
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
              "5. Other Important Information",
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
              "5.1. Security",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We monitor for and try to prevent security breaches. Please use the security features available through our Services. We implement security safeguards designed to protect your data, such as HTTPS. We regularly monitor our systems for possible vulnerabilities and attacks. However, we cannot warrant the security of any information that you send us. There is no guarantee that data may not be accessed, disclosed, altered, or destroyed by breach of any of our physical, technical, or managerial safeguards.",
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
              "5.2. Cross-Border Data Transfers",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We store and use your data outside your country. We process data both inside and outside of the United States and rely on legally-provided mechanisms to lawfully transfer data across borders. Countries where we process data may have laws which are different, and potentially not as protective, as the laws of your own country.",
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
              "5.3 Lawful Bases for Processing",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "We have lawful bases to collect, use and share data about you. You have choices about our use of your data. At any time, you can withdraw consent you have provided by going to settings. We will only collect and process personal data about you where we have lawful bases. Lawful bases include consent (where you have given consent), contract (where processing is necessary for the performance of a contract with you (e.g. to deliver the Tradister Services you have requested)) and “legitimate interests”. Where we rely on your consent to process personal data, you have the right to withdraw or decline your consent at any time and where we rely on legitimate interests, you have the right to object. If you have any questions about the lawful bases upon which we collect and use your personal data, please contact admin.",
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
              "5.4. Direct Marketing and Do Not Track Signals",
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
            margin: EdgeInsets.only(top: 5, left: 20, right: 20),
            child: Text(
              "Our statements regarding direct marketing and “do not track” signals. We currently do not share personal data with third parties for their direct marketing purposes without your permission. ",
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
              "5.5. Contact Information",
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
            margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text:
                        "You can contact us or use other options to resolve any complaints. If you have questions or complaints regarding this Policy, please first ",
                    style: TextStyle(
                        //decoration: TextDecoration.underline,
                        fontSize: 15,
                        color: Colors.black,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w300),
                  ),
                  TextSpan(
                    text: "contact Tradister ",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                        color: header,
                        fontFamily: 'Oswald',
                        fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: "by email in the about section.",
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
        ],
      )),
    );
  }
}
