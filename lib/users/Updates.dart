import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Updates extends StatefulWidget {
  @override
  _UpdatesState createState() => _UpdatesState();
}
var D=DateTime.now();





class _UpdatesState extends State<Updates> {
  final databaseReference = Firestore.instance;
  _getalluser() async {
    var val;
    await databaseReference
        .collection("updates").orderBy('id')
        .getDocuments()
        .then((value) => {val = value.documents});
    return val.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("New Updates"),
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, projectSnap) {
            if (projectSnap.hasData) {
              if (projectSnap.data.length > 0) {
                return ListView.builder(
                  itemCount: projectSnap.data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.new_releases),
                        title: Text(projectSnap.data[index]["message"]),
                        subtitle: Text(
                            "\n${projectSnap.data[index]["description"]}\n\n${projectSnap.data[index]["date"]}"),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                    child: Text(
                      "No notice from school !",
                      style: TextStyle(fontSize: 22),
                    ));
              }
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
