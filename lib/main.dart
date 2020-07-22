import 'dart:convert';

import 'package:chatapp_new/MainScreen/HomePage/homePage.dart';
import 'package:chatapp_new/MainScreen/NotifyChatPage/NotifyChatPage.dart';
import 'package:chatapp_new/MainScreen/NotifyPage/notifyPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'API/api.dart';
import 'JSON_Model/ChatListModel/chatListModel.dart';
import 'MainScreen/ChatPage/ChattingPage/chattingPage.dart';
import 'MainScreen/ChatPage/chatPage.dart';
import 'MainScreen/LoginPage/loginPage.dart';
import 'MainScreen/StatusDetailsPage/StatusDetailsPage.dart';

int stId = 0;

void main() => runApp(MyApp());

Color header = Color(0xFF26B7AD);
Color header1 = Color(0xFF20968E);
Color priceTag = Color(0xFF7B9FA0);
Color back = Color(0xFFEEFCFC);
Color back_new = Color(0xFF272727);
Color subheader = Color(0xFF272727);
//Color fb = Color(0xFF3B5999);
Color fb = Color(0xFF1877F2);
Color sub_white = Color(0xFFf4f4f4);
Color golden = Color(0xFFCFB53B);
Color chat_back = Color(0xFFEAE7E2);
Color my_chat = Color(0xFF01AFF4);
Color person_chat = Color(0xFFE9EBED);
Color chat_page_back = Color(0xFFFFFFFF);
List<String> user = [];
List lastMsg = [];
List lastSeen = [];
var users;
var postList;
var reqList;
var productList;
var shopList;
var deviceToken;
var body;
var chatLists;
var chats;
var chatID;
var sender;
var receiver;
bool _isVerified = false;
bool isEdit1 = false;
//SocketIOManager manager = new SocketIOManager();

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
String pagess = "";
String pageDirect = "";
String picture = "";
String fn = "";
String ln = "";
int selectedPage = 0;
int frndNum = 0;
int chatUnseenNum = 0;
int notifyNum = 0;
int page1 = 0, page2 = 0, page3 = 0, page4 = 0, activePage = 1, lastID = 1;
int onlineChk = 0;
int conType = 0;

List statusPostComCount = [];
List statusPostRepCount = [];

List country = [
  {"name": "Afghanistan", "code": "AF"},
  {"name": "Åland Islands", "code": "AX"},
  {"name": "Albania", "code": "AL"},
  {"name": "Algeria", "code": "DZ"},
  {"name": "American Samoa", "code": "AS"},
  {"name": "Andorra", "code": "AD"},
  {"name": "Angola", "code": "AO"},
  {"name": "Anguilla", "code": "AI"},
  {"name": "Antarctica", "code": "AQ"},
  {"name": "Antigua and Barbuda", "code": "AG"},
  {"name": "Argentina", "code": "AR"},
  {"name": "Armenia", "code": "AM"},
  {"name": "Aruba", "code": "AW"},
  {"name": "Australia", "code": "AU"},
  {"name": "Austria", "code": "AT"},
  {"name": "Azerbaijan", "code": "AZ"},
  {"name": "Bahamas", "code": "BS"},
  {"name": "Bahrain", "code": "BH"},
  {"name": "Bangladesh", "code": "BD"},
  {"name": "Barbados", "code": "BB"},
  {"name": "Belarus", "code": "BY"},
  {"name": "Belgium", "code": "BE"},
  {"name": "Belize", "code": "BZ"},
  {"name": "Benin", "code": "BJ"},
  {"name": "Bermuda", "code": "BM"},
  {"name": "Bhutan", "code": "BT"},
  {"name": "Bolivia", "code": "BO"},
  {"name": "Bosnia and Herzegovina", "code": "BA"},
  {"name": "Botswana", "code": "BW"},
  {"name": "Bouvet Island", "code": "BV"},
  {"name": "Brazil", "code": "BR"},
  {"name": "British Indian Ocean Territory", "code": "IO"},
  {"name": "Brunei Darussalam", "code": "BN"},
  {"name": "Bulgaria", "code": "BG"},
  {"name": "Burkina Faso", "code": "BF"},
  {"name": "Burundi", "code": "BI"},
  {"name": "Cambodia", "code": "KH"},
  {"name": "Cameroon", "code": "CM"},
  {"name": "Canada", "code": "CA"},
  {"name": "Cape Verde", "code": "CV"},
  {"name": "Cayman Islands", "code": "KY"},
  {"name": "Central African Republic", "code": "CF"},
  {"name": "Chad", "code": "TD"},
  {"name": "Chile", "code": "CL"},
  {"name": "China", "code": "CN"},
  {"name": "Christmas Island", "code": "CX"},
  {"name": "Cocos (Keeling) Islands", "code": "CC"},
  {"name": "Colombia", "code": "CO"},
  {"name": "Comoros", "code": "KM"},
  {"name": "Congo", "code": "CG"},
  {"name": "Congo, The Democratic Republic of the", "code": "CD"},
  {"name": "Cook Islands", "code": "CK"},
  {"name": "Costa Rica", "code": "CR"},
  {"name": "Cote D'Ivoire", "code": "CI"},
  {"name": "Croatia", "code": "HR"},
  {"name": "Cuba", "code": "CU"},
  {"name": "Cyprus", "code": "CY"},
  {"name": "Czech Republic", "code": "CZ"},
  {"name": "Denmark", "code": "DK"},
  {"name": "Djibouti", "code": "DJ"},
  {"name": "Dominica", "code": "DM"},
  {"name": "Dominican Republic", "code": "DO"},
  {"name": "Ecuador", "code": "EC"},
  {"name": "Egypt", "code": "EG"},
  {"name": "El Salvador", "code": "SV"},
  {"name": "Equatorial Guinea", "code": "GQ"},
  {"name": "Eritrea", "code": "ER"},
  {"name": "Estonia", "code": "EE"},
  {"name": "Ethiopia", "code": "ET"},
  {"name": "Falkland Islands (Malvinas)", "code": "FK"},
  {"name": "Faroe Islands", "code": "FO"},
  {"name": "Fiji", "code": "FJ"},
  {"name": "Finland", "code": "FI"},
  {"name": "France", "code": "FR"},
  {"name": "French Guiana", "code": "GF"},
  {"name": "French Polynesia", "code": "PF"},
  {"name": "French Southern Territories", "code": "TF"},
  {"name": "Gabon", "code": "GA"},
  {"name": "Gambia", "code": "GM"},
  {"name": "Georgia", "code": "GE"},
  {"name": "Germany", "code": "DE"},
  {"name": "Ghana", "code": "GH"},
  {"name": "Gibraltar", "code": "GI"},
  {"name": "Greece", "code": "GR"},
  {"name": "Greenland", "code": "GL"},
  {"name": "Grenada", "code": "GD"},
  {"name": "Guadeloupe", "code": "GP"},
  {"name": "Guam", "code": "GU"},
  {"name": "Guatemala", "code": "GT"},
  {"name": "Guernsey", "code": "GG"},
  {"name": "Guinea", "code": "GN"},
  {"name": "Guinea-Bissau", "code": "GW"},
  {"name": "Guyana", "code": "GY"},
  {"name": "Haiti", "code": "HT"},
  {"name": "Heard Island and Mcdonald Islands", "code": "HM"},
  {"name": "Holy See (Vatican City State)", "code": "VA"},
  {"name": "Honduras", "code": "HN"},
  {"name": "Hong Kong", "code": "HK"},
  {"name": "Hungary", "code": "HU"},
  {"name": "Iceland", "code": "IS"},
  {"name": "India", "code": "IN"},
  {"name": "Indonesia", "code": "ID"},
  {"name": "Iran, Islamic Republic Of", "code": "IR"},
  {"name": "Iraq", "code": "IQ"},
  {"name": "Ireland", "code": "IE"},
  {"name": "Isle of Man", "code": "IM"},
  {"name": "Israel", "code": "IL"},
  {"name": "Italy", "code": "IT"},
  {"name": "Jamaica", "code": "JM"},
  {"name": "Japan", "code": "JP"},
  {"name": "Jersey", "code": "JE"},
  {"name": "Jordan", "code": "JO"},
  {"name": "Kazakhstan", "code": "KZ"},
  {"name": "Kenya", "code": "KE"},
  {"name": "Kiribati", "code": "KI"},
  {"name": "Democratic People's Republic of Korea", "code": "KP"},
  {"name": "Korea, Republic of", "code": "KR"},
  {"name": "Kosovo", "code": "XK"},
  {"name": "Kuwait", "code": "KW"},
  {"name": "Kyrgyzstan", "code": "KG"},
  {"name": "Lao People's Democratic Republic", "code": "LA"},
  {"name": "Latvia", "code": "LV"},
  {"name": "Lebanon", "code": "LB"},
  {"name": "Lesotho", "code": "LS"},
  {"name": "Liberia", "code": "LR"},
  {"name": "Libyan Arab Jamahiriya", "code": "LY"},
  {"name": "Liechtenstein", "code": "LI"},
  {"name": "Lithuania", "code": "LT"},
  {"name": "Luxembourg", "code": "LU"},
  {"name": "Macao", "code": "MO"},
  {"name": "Macedonia, The Former Yugoslav Republic of", "code": "MK"},
  {"name": "Madagascar", "code": "MG"},
  {"name": "Malawi", "code": "MW"},
  {"name": "Malaysia", "code": "MY"},
  {"name": "Maldives", "code": "MV"},
  {"name": "Mali", "code": "ML"},
  {"name": "Malta", "code": "MT"},
  {"name": "Marshall Islands", "code": "MH"},
  {"name": "Martinique", "code": "MQ"},
  {"name": "Mauritania", "code": "MR"},
  {"name": "Mauritius", "code": "MU"},
  {"name": "Mayotte", "code": "YT"},
  {"name": "Mexico", "code": "MX"},
  {"name": "Micronesia, Federated States of", "code": "FM"},
  {"name": "Moldova, Republic of", "code": "MD"},
  {"name": "Monaco", "code": "MC"},
  {"name": "Mongolia", "code": "MN"},
  {"name": "Montenegro", "code": "ME"},
  {"name": "Montserrat", "code": "MS"},
  {"name": "Morocco", "code": "MA"},
  {"name": "Mozambique", "code": "MZ"},
  {"name": "Myanmar", "code": "MM"},
  {"name": "Namibia", "code": "NA"},
  {"name": "Nauru", "code": "NR"},
  {"name": "Nepal", "code": "NP"},
  {"name": "Netherlands", "code": "NL"},
  {"name": "Netherlands Antilles", "code": "AN"},
  {"name": "New Caledonia", "code": "NC"},
  {"name": "New Zealand", "code": "NZ"},
  {"name": "Nicaragua", "code": "NI"},
  {"name": "Niger", "code": "NE"},
  {"name": "Nigeria", "code": "NG"},
  {"name": "Niue", "code": "NU"},
  {"name": "Norfolk Island", "code": "NF"},
  {"name": "Northern Mariana Islands", "code": "MP"},
  {"name": "Norway", "code": "NO"},
  {"name": "Oman", "code": "OM"},
  {"name": "Pakistan", "code": "PK"},
  {"name": "Palau", "code": "PW"},
  {"name": "Palestinian Territory, Occupied", "code": "PS"},
  {"name": "Panama", "code": "PA"},
  {"name": "Papua New Guinea", "code": "PG"},
  {"name": "Paraguay", "code": "PY"},
  {"name": "Peru", "code": "PE"},
  {"name": "Philippines", "code": "PH"},
  {"name": "Pitcairn", "code": "PN"},
  {"name": "Poland", "code": "PL"},
  {"name": "Portugal", "code": "PT"},
  {"name": "Puerto Rico", "code": "PR"},
  {"name": "Qatar", "code": "QA"},
  {"name": "Reunion", "code": "RE"},
  {"name": "Romania", "code": "RO"},
  {"name": "Russian Federation", "code": "RU"},
  {"name": "Rwanda", "code": "RW"},
  {"name": "Saint Helena", "code": "SH"},
  {"name": "Saint Kitts and Nevis", "code": "KN"},
  {"name": "Saint Lucia", "code": "LC"},
  {"name": "Saint Pierre and Miquelon", "code": "PM"},
  {"name": "Saint Vincent and the Grenadines", "code": "VC"},
  {"name": "Samoa", "code": "WS"},
  {"name": "San Marino", "code": "SM"},
  {"name": "Sao Tome and Principe", "code": "ST"},
  {"name": "Saudi Arabia", "code": "SA"},
  {"name": "Senegal", "code": "SN"},
  {"name": "Serbia", "code": "RS"},
  {"name": "Seychelles", "code": "SC"},
  {"name": "Sierra Leone", "code": "SL"},
  {"name": "Singapore", "code": "SG"},
  {"name": "Slovakia", "code": "SK"},
  {"name": "Slovenia", "code": "SI"},
  {"name": "Solomon Islands", "code": "SB"},
  {"name": "Somalia", "code": "SO"},
  {"name": "South Africa", "code": "ZA"},
  {"name": "South Georgia and the South Sandwich Islands", "code": "GS"},
  {"name": "Spain", "code": "ES"},
  {"name": "Sri Lanka", "code": "LK"},
  {"name": "Sudan", "code": "SD"},
  {"name": "Suri", "code": "SR"},
  {"name": "Svalbard and Jan Mayen", "code": "SJ"},
  {"name": "Swaziland", "code": "SZ"},
  {"name": "Sweden", "code": "SE"},
  {"name": "Switzerland", "code": "CH"},
  {"name": "Syrian Arab Republic", "code": "SY"},
  {"name": "Taiwan", "code": "TW"},
  {"name": "Tajikistan", "code": "TJ"},
  {"name": "Tanzania, United Republic of", "code": "TZ"},
  {"name": "Thailand", "code": "TH"},
  {"name": "Timor-Leste", "code": "TL"},
  {"name": "Togo", "code": "TG"},
  {"name": "Tokelau", "code": "TK"},
  {"name": "Tonga", "code": "TO"},
  {"name": "Trinidad and Tobago", "code": "TT"},
  {"name": "Tunisia", "code": "TN"},
  {"name": "Turkey", "code": "TR"},
  {"name": "Turkmenistan", "code": "TM"},
  {"name": "Turks and Caicos Islands", "code": "TC"},
  {"name": "Tuvalu", "code": "TV"},
  {"name": "Uganda", "code": "UG"},
  {"name": "Ukraine", "code": "UA"},
  {"name": "United Arab Emirates", "code": "AE"},
  {"name": "United Kingdom", "code": "GB"},
  {"name": "United States", "code": "US"},
  {"name": "United States Minor Outlying Islands", "code": "UM"},
  {"name": "Uruguay", "code": "UY"},
  {"name": "Uzbekistan", "code": "UZ"},
  {"name": "Vanuatu", "code": "VU"},
  {"name": "Venezuela", "code": "VE"},
  {"name": "Viet Nam", "code": "VN"},
  {"name": "Virgin Islands, British", "code": "VG"},
  {"name": "Virgin Islands, U.S.", "code": "VI"},
  {"name": "Wallis and Futuna", "code": "WF"},
  {"name": "Western Sahara", "code": "EH"},
  {"name": "Yemen", "code": "YE"},
  {"name": "Zambia", "code": "ZM"},
  {"name": "Zimbabwe", "code": "ZW"}
];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  //SocketIOManager manager;
  var userData;
  int id = 0;
  int req = 0, chat = 0, notice = 0, comm = 0, repp = 0, stID;

  void initState() {
    firebaseCheck();
    _getUserInfo();
    _firebaseMessaging.getToken().then((token) async {
      print("Notification token");
      print(token);

      setState(() {
        deviceToken = token;
      });
    });

    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    var userJson = localStorage.getString('user');

    if (token != null) {
      setState(() {
        _isLoggedIn = true;
      });
    }

    if (userJson != null) {
      var user = json.decode(userJson);
      setState(() {
        userData = user;
        id = userData['id'];
        //isLoading = false;
      });
    }
  }

  void firebaseCheck() {
    _firebaseMessaging.getToken().then((token) {
      print("Notification token");
      print(token);
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        setState(() {
          if (message['data']['type'] == "request" ||
              message['data']['type'] == "friend-request-accept") {
            frndNum += 1;
            notifyNum += 1;
          } else if (message['data']['type'] == "feed-like" ||
              message['data']['type'] == "feed-comment" ||
              message['data']['type'] == "feed-reply" ||
              message['data']['type'] == "feed-comment-like" ||
              message['data']['type'] == "feed-reply-like" ||
              message['data']['type'] == "feed-share") {
            notifyNum += 1;
          } else if (message['data']['msg'] != "" ||
              message['data']['msg'] != null) {
            chatUnseenNum += 1;
          }
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //pageRoute(message);
        setState(() async {
          if (message['data']['type'] == "request" ||
              message['data']['type'] == "friend-request-accept") {
            req = 1;
          } else if (message['data']['type'] == "feed-like" ||
              message['data']['type'] == "feed-comment" ||
              message['data']['type'] == "feed-reply" ||
              message['data']['type'] == "feed-comment-like" ||
              message['data']['type'] == "feed-reply-like" ||
              message['data']['type'] == "feed-share") {
            notice = 1;
            SharedPreferences localStorage =
                await SharedPreferences.getInstance();
            localStorage.setString('stid', message['data']['id']);
            stId = message['data']['id'];
          } else if (message['data']['msg'] != "" ||
              message['data']['msg'] != null) {
            loadChatList(message['data']['con_id']);
          }
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        setState(() {
          if (message['data']['type'] == "request" ||
              message['data']['type'] == "friend-request-accept") {
            frndNum += 1;
            notifyNum += 1;
          } else if (message['data']['type'] == "feed-like" ||
              message['data']['type'] == "feed-comment" ||
              message['data']['type'] == "feed-reply" ||
              message['data']['type'] == "feed-comment-like" ||
              message['data']['type'] == "feed-reply-like" ||
              message['data']['type'] == "feed-share") {
            notifyNum += 1;
          } else if (message['data']['msg'] != "" ||
              message['data']['msg'] != null) {
            chatUnseenNum += 1;
          }
        });
        //pageRoute(message);
      },
    );
  }

  Future loadChatList(conId) async {
    var response = await CallApi().getData2('get-chat-listing');
    body = json.decode(response.body);

    if (response.statusCode == 200) {
      var chats = ChatListModel.fromJson(body);
      if (!mounted) return;
      setState(() {
        chatLists = chats.lists;

        for (int i = 0; i < chatLists.length; i++) {
          if (conId == chatLists[i].id.toString()) {
            chatID = chatLists[i].id;
            picture = chatLists[i].profilePic;
            fn = chatLists[i].firstName;
            ln = chatLists[i].lastName;
            sender = chatLists[i].sender;
            receiver = chatLists[i].reciever;
            onlineChk = chatLists[i].isOnline;
            conType = chatLists[i].conType;
          }
        }
        chat = 1;
      });
    }
  }

  void pageRoute(Map<String, dynamic> msg) {
    if (msg['data']['type'] == "request") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyHomePage(1)));
    } else if (msg['data']['type'] == "feed-like") {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => StatusDetailsPage()));
    } else if (msg['data']['msg'] != "" || msg['data']['msg'] != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotifyChatPage(chatID, picture, fn, ln,
                  sender, receiver, userData, onlineChk, conType)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tradister',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: header),
      home: _isLoggedIn
          ? req == 1
              ? MyHomePage(1)
              : chat == 1
                  ? NotifyChatPage(chatID, picture, fn, ln, sender, receiver,
                      userData, onlineChk, conType)
                  : notice == 1 ? StatusDetailsPage() : MyHomePage(selectedPage)
          : LoginPage(),
    );
  }
}
