import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school/admin/adminhome.dart';
import 'package:school/users/home.dart';
import 'dart:async';
import 'Login.dart';
import 'main.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    _function().then(
            (status){
          _navigatetohome();
        }
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _function() async{
    await Future.delayed(Duration(milliseconds: 4000),(){});
    return true;
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _navigatetohome() async{
    final FirebaseUser user = await _auth.currentUser();
    if (user == null) {
      setState(() {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (BuildContext context)=>LoginPage()
            )
        );
      });
    } else {
      final databaseReference = Firestore.instance;
      await databaseReference
          .collection("userdetails")
          .where('uuid', isEqualTo: user.uid)
          .getDocuments()
          .then((value) {
        if (value.documents[0].exists) {
          if (value.documents[0].data['role'] == "admin") {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context)=>AdminHome()
                )
            );
          } else {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context)=>HomePage()
                )
            );
          }
        }
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Image.asset('assets/school.jpeg',width: 150,),
            SizedBox(height: 30,),
            SizedBox(
              width: 200.0,
              child: TypewriterAnimatedTextKit(
                onTap: () {
                },
                text: [
                  "KIDS R KIDS","E-Almanac",
                ],
                textStyle: TextStyle(
                    fontSize: 22.0,
                    color: Colors.black,
                    fontFamily: "Agne",
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.start,
                alignment: AlignmentDirectional.topStart ,
                speed: Duration(milliseconds: 100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
