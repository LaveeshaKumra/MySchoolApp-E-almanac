import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:school/Login.dart';
import 'package:school/users/AssignmentPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cal.dart';
import 'contact.dart';
import 'profile.dart';
import 'updates.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var clas,branch;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  void initState() {

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> msg) async {
        switch (msg['data']['screen']) {
          case "OPEN_HOMEWORK_PAGE":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalPage(clas, branch)),
            );
            break;
          case "OPEN_UPDATE_PAGE":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Updates()),
            );
            break;
          default:
            break;
        }
      },
    );
  }
  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseMessaging _fcm = FirebaseMessaging();

    final FirebaseUser user = await _auth.currentUser();
    if (user == null) {

      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text('No one has signed in.'),
      ));
      return;
    }
    _fcm.unsubscribeFromTopic(prefs.getString('topic'));

    await _auth.signOut().then((value) => {
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    )
    });

  }
  _HomePageState(){
    _getclass();
  }
  _getclass() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseUser _user= await FirebaseAuth.instance.currentUser();
    final databaseReference = Firestore.instance;
    await databaseReference.collection("userdetails").where('uuid',isEqualTo: _user.uid).getDocuments().then((value) {
      setState(() {
        clas=value.documents[0]['role'];
        branch=value.documents[0]['branch'];
      });
      var topic=value.documents[0]['topic'];
      var t2=topic.replaceAll('.', "");
      var t3=t2.replaceAll(new RegExp(r"\s+"), "");
      _fcm.subscribeToTopic(t3);
      prefs.setString("topic", t3);

      _fcm.subscribeToTopic("all");

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Text("E-Almanac"),
          backgroundColor: Color(0xffff3a5a),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(child: Icon(Icons.logout),onTap: (){ _logout();},),
            )
          ],
        ),
      ),

      body: clas == null?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor)),
              width: 30,
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text("Loading.."),
            )
          ],
        ),
      ):ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.asset(
                    'assets/pic.jpg',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 8,
                  margin: EdgeInsets.all(20),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  child: _buildWikiCategory(Icons.perm_identity, "Profile",
                      Color(0xffff3a5a).withOpacity(0.7)),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalPage(clas,branch)),
                    );
                  },
                  child: _buildWikiCategory(Icons.assignment, "HomeWork",
                      Colors.indigo.withOpacity(0.7)),
                ),
              ),

            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: <Widget>[


              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Updates()),
                    );
                  },
                  child: _buildWikiCategory(
                      Icons.chat, "Notice Board", Colors.greenAccent),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Contact()),
                    );
                  },
                  child: _buildWikiCategory(Icons.phone, "Contact Us",
                      Colors.blue.withOpacity(0.6)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Stack _buildWikiCategory(IconData icon, String label, Color color) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(26.0),
          alignment: Alignment.centerRight,
          child: Opacity(
              opacity: 0.3,
              child: Icon(
                icon,
                size: 40,
                color: Colors.white,
              )),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10.0),
                  label=="HomeWork"?Text(clas,style: TextStyle(color: Colors.white),):Container(),
                ],
              ),

              const SizedBox(height: 16.0),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
