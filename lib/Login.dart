import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school/forgetpswd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'users/home.dart';
import 'admin/adminhome.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
bool _success,_progress=false;
final FirebaseAuth _auth = FirebaseAuth.instance;
void _signInWithEmailAndPassword() async {
  print(_emailController.text);
  print(_passwordController.text);
  FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text,
      password: _passwordController.text).then((value) async {
        print(value);
    final databaseReference = Firestore.instance;
    await databaseReference.collection("userdetails").where('uuid',isEqualTo: value.user.uid).getDocuments().then((value) async {
      if(value.documents[0].exists){
        if(value.documents[0].data['role']=="admin"){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email',_emailController.text);
          prefs.setString('password',_passwordController.text);
          Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminHome()),
      );
        }
        else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
            setState(() {
      _success = true;
    });
      }
      else{
            setState(() {
      _success = false;
    });
      }
      setState(() {
        _progress=true;
      });

    });
  }).catchError((e){
    setState(() {
      _progress=false;
    });

    Toast.show("Something went wrong", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

  });

}

_forgetpswd(){
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => Forgotpaswd()),
  );
}

@override
void dispose() {
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
//      floatingActionButton: FloatingActionButton(
//        child: InkWell(child: Icon(Icons.phone),
//          onTap: (){
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => Contact()),
//            );
//          },
//        ),
//      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: WaveClipper2(),
                  child: Container(
                    child: Column(),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0x44ff3a5a), Color(0x22fe494d)])),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper3(),
                  child: Container(
                    child: Column(),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0x44ff3a5a), Color(0x44fe494d)])),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper1(),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 80,
                        ),
                        Text(
                          "Kids R Kids",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 34),
                        ),
                      ],
                    ),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.deepOrange, Color(0xfffe494d)])),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: _emailController,
                  validator: (var value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                      hintText: "Email id",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.perm_identity,
                          color: Colors.red,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: _passwordController,
                  validator: (var value) {
                    if (value.isEmpty) {
                      return 'Password can not be null';
                    }
                    return null;
                  },
                  cursorColor: Colors.red,
                  obscureText: true,
                  decoration: InputDecoration(

                      hintText: "Password",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.lock,
                          color: Colors.red,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
//            Padding(
//                padding: EdgeInsets.symmetric(horizontal: 32),
//                child: Container(
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.all(Radius.circular(100)),
//                      color: Color(0xffff3a5a)),
//                  child: FlatButton(
//                    child: Text(
//                      "Login",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.w700,
//                          fontSize: 18),
//                    ),
//                    onPressed: () async {
//                      if (_formKey.currentState.validate()) {
//                        _signInWithEmailAndPassword();
//                      }
//                    },
//                  ),
//
//                )),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: RoundedButton(
                  text: "Login",
                  state: _progress,
                  press: () {

    if (_formKey.currentState.validate()) {
      setState(() {
        _progress=true;
      });
                            _signInWithEmailAndPassword();
                          }
                  },
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              alignment: Alignment.center,
              child: Text(_success == null
                  ? ''
                  : (_success
                  ? 'Successfully Login ' + _emailController.text
                  : 'Registration failed')),
            ),
            SizedBox(height: 10,),
            InkWell(
                child: Container(alignment: Alignment.center,child: Text("Forget Password?",style: TextStyle(color: Colors.blue),)),
              onTap: (){
                  _forgetpswd();
              },
            ),
            SizedBox(height: 20,),

            SizedBox(height: 20,),

            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(child: Text("f",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28,color: Colors.red),),onTap: (){launch("https://www.facebook.com/APlayschoolpanipat/");},),
                    GestureDetector(child: Icon(Icons.play_circle_filled_outlined,color: Colors.red,size: 35,),onTap: (){launch("https://www.youtube.com/channel/UCcqKRph6l4ax6pr57vwJ-Ig?sub_confirmation=1");},),
                    GestureDetector(child: Icon(Icons.message_rounded,color: Colors.red,size: 35,),onTap: (){launch("https://wa.link/hz16ej");},)
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),


          ],
        ),
      ),
    );
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 15 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 40);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * .7, size.height - 40);
    var firstControlPoint = Offset(size.width * .25, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 45);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;

  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  final bool state;
  const RoundedButton({
    Key key,
    this.text,
    this.state,
    this.press,
    this.color = Colors.deepOrange,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color: color,
          onPressed: press,
          child: state?
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ):Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}


