import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school/admin/addhomework.dart';
import 'package:school/admin/addwork.dart';
import 'package:school/admin/editwork.dart';
import 'package:school/showimage.dart';


class ShowHomeWork extends StatefulWidget {
  var clas,branch;

  ShowHomeWork(w,b){
    this.clas=w;
    this.branch=b;
  }
  @override
  _ShowHomeWorkState createState() => _ShowHomeWorkState(clas,branch);
}

class _ShowHomeWorkState extends State<ShowHomeWork> {
  var clas,branch;

  _ShowHomeWorkState(w,b){
    this.clas=w;
    this.branch=b;
  }
  final databaseReference = Firestore.instance;
  _getallwork() async {
    var val;
    await databaseReference
        .collection("homework").where("class",isEqualTo: clas).where("branch",isEqualTo: branch).orderBy('id')
        .getDocuments()
        .then((value) => {val = value.documents});
    return val.reversed.toList();
  }

  _deleteupdate(id) async {
    await databaseReference
        .collection("homework").document(id).delete();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ShowHomeWork(clas,branch)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("$branch : $clas"),
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
                      child: InkWell(
                        child: ListTile(
                          leading: projectSnap.data[index]["image"]==null || projectSnap.data[index]["image"]==""?Icon(Icons.assignment):InkWell(child: Image.network(projectSnap.data[index]["image"],width: 50,),onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ShowImage(projectSnap.data[index]["image"])),
                            );
                          },),
                          title: Text(projectSnap.data[index]["work"],style: TextStyle(fontSize: 18 )),
                          subtitle: Text(
                              "\n${projectSnap.data[index]["date"].toDate().day}/${projectSnap.data[index]["date"].toDate().month}/${projectSnap.data[index]["date"].toDate().year} - ${projectSnap.data[index]["date"].toDate().hour}:${projectSnap.data[index]["date"].toDate().minute}"),
                          trailing:
                              InkWell(child: Icon(Icons.delete,color: Colors.red,),onTap: (){
                                _deleteupdate(projectSnap.data[index].documentID);
                              },),
                        ),
                        onTap: (){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => EditWork(clas,branch,projectSnap.data[index].documentID)),
                            );
                        },
                      ),
                    );
                  },
                );
              } else {
                return Center(
                    child: Text(
                      "No homework, enjoy your day !",
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
          future: _getallwork(),
        ),
      ),
    );
  }
}
