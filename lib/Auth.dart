import 'package:flutter/material.dart';
import 'package:school/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  _AuthPageState(){
    check();
  }

  @override
  void initState() {
    super.initState();
  }

  Future check() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value=await prefs.getString('user');
    if(value==null || value ==""){
      setState(() {
        _default=LoginPage();
      });
    }

  }

  Widget _default=new HomePage();
  @override
  Widget build(BuildContext context) {
    return _default;
  }
}
