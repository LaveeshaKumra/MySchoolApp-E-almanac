import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'adduser.dart';
import 'edituser.dart';

class ManageUsers extends StatefulWidget {
  @override
  _ManageUsersState createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  final databaseReference = Firestore.instance;
  _getalluser() async {
    var val;
    await databaseReference
        .collection("userdetails")
        .getDocuments()
        .then((value) => {val = value.documents});
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddUser()),
          );
        },
        child: Icon(Icons.add),

      ),
      appBar: AppBar(
        title: Text("Manage Users"),
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, projectSnap) {
            if (projectSnap.hasData) {
              var d = projectSnap.data;

            return ListView.builder(
              itemCount: d.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      child: ListTile(
                      leading: d[index].data['profile']==""|| d[index].data['profile']==null?Icon(Icons.account_circle):ClipRRect(borderRadius: BorderRadius.circular(30)
                          ,child: Image.network(d[index].data['profile'],width: 30,height: 30,)),
                        title: d[index].data['name']==null?Text(''):Text(d[index].data['name']),
                        subtitle: Text(d[index].data['email']),
                        //trailing: Text(d[index].data['role']),
                      ),
                      onTap: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => EditUser(d[index].data['email'])),
                        );
                      },
                    ),Divider(height: 5,)
                  ],
                );
              },
            );
            } else {
              return Column(
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
              );
            }
          },
          future: _getalluser(),
        ),
      ),
    );
  }
}
