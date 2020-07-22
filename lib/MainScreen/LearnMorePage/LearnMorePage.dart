import 'package:chatapp_new/MainScreen/PrivacyPolicyPage/PrivacyPolicyPage.dart';
import 'package:chatapp_new/MainScreen/UserAgreementPage/UserAgreementPage.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:chatapp_new/MainScreen/AboutPage/AboutPage.dart';
import 'package:chatapp_new/MainScreen/CopyrightPage/CopyrightPage.dart';
import 'package:chatapp_new/MainScreen/CookiePolicyPage/CookiePolicyPage.dart';

class LearnMorePage extends StatefulWidget {
  @override
  _LearnMorePageState createState() => _LearnMorePageState();
}

class _LearnMorePageState extends State<LearnMorePage> {
  String videoId;
  YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  String _sound = "";

  @override
  initState() {
    videoId = YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/embed/QlTR7mI-oSc");
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      ),
    );
    super.initState();
  }

  Container optContainer(Icon icon, String text) {
    return Container(
      padding: EdgeInsets.only(top: 13, bottom: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        //border: Border.all(width: 0.8, color: Colors.grey[300]),
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Colors.grey[300],
            //offset: Offset(3.0, 4.0),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 2.5, bottom: 2.5, left: 0, right: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            //color: Colors.red,
            margin: EdgeInsets.only(left: 20, right: 20, top: 0),
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(margin: EdgeInsets.only(right: 10), child: icon),
                Container(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
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
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.chevron_right,
                color: Colors.black45,
                size: 22,
              )),
        ],
      ),
    );
  }

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
                        "Learn More",
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
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutPage()));
              },
              child: optContainer(
                  Icon(
                    Icons.info_outline,
                    color: Colors.black45,
                    size: 20,
                  ),
                  "About Us"),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage()));
              },
              child: optContainer(
                  Icon(
                    Icons.lock_outline,
                    color: Colors.black45,
                    size: 20,
                  ),
                  "Privacy Policy"),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserAgreementPage()));
              },
              child: optContainer(
                  Icon(
                    Icons.content_paste,
                    color: Colors.black45,
                    size: 20,
                  ),
                  "User Agreement"),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CopyrightPage()));
              },
              child: optContainer(
                  Icon(
                    Icons.copyright,
                    color: Colors.black45,
                    size: 20,
                  ),
                  "Copyright"),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CookiePolicyPage()));
              },
              child: optContainer(
                  Icon(
                    Icons.lock_open,
                    color: Colors.black45,
                    size: 20,
                  ),
                  "Cookies Policy"),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 30),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  //progressIndicatorColor: Colors.blueAccent,
                  topActions: <Widget>[
                    SizedBox(width: 5.0),
                  ],
                  onReady: () {
                    // print("dfsifugsdf");
                    if (_sound == "") {
                      setState(() {
                        _isPlayerReady = true;
                      });
                    } else if (_sound == "no") {
                      setState(() {
                        _isPlayerReady = false;
                        print("no sound for play");
                      });
                    }

                    // print(_isPlayerReady);
                  },
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
