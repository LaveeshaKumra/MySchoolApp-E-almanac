import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:school/Login.dart';

import 'branchpage.dart';
import 'manageuser.dart';
import 'otherupdates.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  void initState() {
    _fcm.subscribeToTopic("all");
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
              MaterialPageRoute(builder: (context) => BranchPage()),
            );
            break;
          case "OPEN_UPDATE_PAGE":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OtherUpdates()),
            );
            break;
          default:
            break;
        }
      },
    );
  }
  _logout() async {
    final FirebaseUser user = await _auth.currentUser();
    if (user == null) {

      Scaffold.of(context).showSnackBar(const SnackBar(
        content: Text('No one has signed in.'),
      ));
      return;
    }
    await _auth.signOut().then((value) => {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      )
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
      body: ListView(
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
                    fit: BoxFit.fill,
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
                      MaterialPageRoute(builder: (context) => BranchPage()),
                    );
                  },
                  child: _buildWikiCategory(Icons.assignment, "HomeWork",
                      Color(0xffff3a5a).withOpacity(0.7)),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OtherUpdates()),
                    );
                  },
                  child: _buildWikiCategory(Icons.info, "Other Updates",
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
                      MaterialPageRoute(builder: (context) => ManageUsers()),
                    );
                  },
                  child: _buildWikiCategory(
                      Icons.supervised_user_circle, "Manage Users", Colors.greenAccent),
                ),
              ),
             // const SizedBox(width: 16.0),
//              Expanded(
//                child: GestureDetector(
//                  onTap: () {
////                    Navigator.push(
////                      context,
////                      MaterialPageRoute(builder: (context) => ContactPage()),
////                    );
//                  },
//                  child: _buildWikiCategory(Icons.phone, "Contact Us",
//                      Colors.blue.withOpacity(0.6)),
//                ),
//              ),
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
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(height: 16.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
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
