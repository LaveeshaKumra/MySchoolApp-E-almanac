import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        title: Text("View Profile"),
        backgroundColor: Colors.red,
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [0.5, 0.9],
                    colors: [
                      Colors.deepOrange.shade300,
                      Colors.deepOrange.shade200
                    ]
                )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[

                    Center(
                      child: CircleAvatar(
                        minRadius: 60,
                        backgroundColor: Colors.deepOrange.shade400,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage("assets/user.png"),
                          minRadius: 50,

                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 10,),
                Text("Name", style: TextStyle(fontSize: 22.0, color: Colors.white),),
              ],
            ),
          ),

          ListTile(
            title: Text("Class", style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
            subtitle: Text("Xth A3", style: TextStyle(fontSize: 18.0),),
          ),
          Divider(),
          ListTile(
            title: Text("Rollno", style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
            subtitle: Text("15", style: TextStyle(fontSize: 18.0),),
          ),
          Divider(),
          ListTile(
            title: Text("Admission No.", style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
            subtitle: Text("58957123", style: TextStyle(fontSize: 18.0),),
          ),
          Divider(),
          ListTile(
            title: Text("Bith Date", style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
            subtitle: Text("01/01/2016", style: TextStyle(fontSize: 18.0),),
          ),
          Divider(),
          ListTile(
            title: Text("Phone No.", style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
            subtitle: Text("1233654790", style: TextStyle(fontSize: 18.0),),
          ),
          Divider(),
          ListTile(
            title: Text("Address", style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
            subtitle: Text("Vikas nagar", style: TextStyle(fontSize: 18.0),),
          ),
          Divider(),
          ListTile(
            title: Text("Email id", style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),),
            subtitle: Text("c@gmail.com", style: TextStyle(fontSize: 18.0),),
          ),
          Divider(),
        ],
      ),
    );
  }
}
