import 'package:flutter/material.dart';
import 'package:school/AssignmentPage.dart';
import 'package:school/AttendencePage.dart';
import 'package:school/Login.dart';
import 'package:school/Profile.dart';
import 'package:school/Subjects.dart';
import 'package:school/Updates.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', null);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Text("My School Info"),
          backgroundColor: Colors.deepOrange,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/pic.jpg"),fit: BoxFit.fill),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              leading: Icon(
                Icons.person,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );

              },
            ),
            ListTile(
              leading: Icon(
                Icons.notifications,
              ),
              title: Text('School Updates'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Updates()),
                );
              },
            ),
            ListTile(
              title: Text("Assignments"),
              leading: Icon(
                Icons.assignment,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Subjects()),
                );
              },
            ),
            ListTile(
              title: Text('Attendence'),
              leading: Icon(
                Icons.insert_chart,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Attendence()),
                );
              },
            ),
            ListTile(
              title: Text('Contact us'),
              leading: Icon(
                Icons.contact_phone,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('LogOut'),
              leading: Icon(
                Icons.exit_to_app,
              ),
              onTap: () {
                _logout();
                Navigator.pop(context);
              },
            ),
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
                  margin: EdgeInsets.all(10),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.0),
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
                      Colors.deepOrange.withOpacity(0.7)),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Attendence()),
                    );
                  },
                  child: _buildWikiCategory(Icons.insert_chart, "Attendence",
                      Colors.blue.withOpacity(0.6)),
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
                      MaterialPageRoute(builder: (context) => Subjects()),
                    );
                  },
                  child: _buildWikiCategory(Icons.assignment, "Assignments",
                      Colors.indigo.withOpacity(0.7)),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Updates()),
                    );
                  },
                  child: _buildWikiCategory(
                      Icons.chat, "New Updates", Colors.greenAccent),
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
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(height: 16.0),
              Text(
                label,
                style: TextStyle(
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
