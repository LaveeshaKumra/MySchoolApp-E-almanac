
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school/admin/addupdate.dart';

class OtherUpdates extends StatefulWidget {
  @override
  _OtherUpdatesState createState() => _OtherUpdatesState();
}

class _OtherUpdatesState extends State<OtherUpdates> {
  final databaseReference = Firestore.instance;
  _getalluser() async {
    var val;
    await databaseReference
        .collection("updates").orderBy('id')
        .getDocuments()
        .then((value) => {val = value.documents});
    var x= val.reversed.toList();
    return x;
  }

  _deleteupdate(id) async {
    await databaseReference
        .collection("updates").document(id).delete();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OtherUpdates()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddUpdate()),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Other Updates"),
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
                        trailing: InkWell(child: Icon(Icons.delete,color: Colors.red,),onTap: (){
                          _deleteupdate(projectSnap.data[index].documentID);
                        },),
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
