import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/routes/profile/profilepage.dart';
import 'package:socialapp310/routes/walkthrough.dart';
import 'dart:async';
import 'package:socialapp310/utils/color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialapp310/routes/welcome.dart';

import 'homefeed/HomeFeed.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key, this.analytics, this.observer}): super (key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  bool signedin = false;
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool _seen = (prefs.getBool('_seen') ?? false);
    //User cool = await auth.currentUser;
    //print(_seen);
    await auth.signOut();//TODO: Remove this auto sign out. Keep to test log in and sign up for now.
    if (_seen && !signedin) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Welcome()));
    }
    else if(_seen && signedin)
    {
    Navigator.of(context).pushReplacement(
    new MaterialPageRoute(builder: (context) => new HomeFeed()));

    }
    else {
      await prefs.setBool('_seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new WalkThrough()));
    }
  }
  FirebaseAuth auth = FirebaseAuth.instance;
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User user) {
      if(user == null) {
        print('User is signed out');
        signedin = false;
      }
      else {
        print('User is signed in');

      }
    });
    Timer(Duration(seconds: 4), () => checkFirstSeen()); //TODO:ADD CONTEXT TO ONBOARDING SCREENS

  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: AppColors.darkpurple),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/images/logo_woof.png'),
                        radius: 90,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Text( "Woof",
                        style: TextStyle(
                          //fontFamily: 'OpenSansCondensed-LightItalic',
                          fontSize: 40.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFffffff),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightgrey),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),

                    Column(
                      children: [
                        Text( "All your pals under one roof!",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkgreyblack,
                          ),
                        ),
                        Text( "Stay Connected",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                            color: AppColors.peachpink,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}