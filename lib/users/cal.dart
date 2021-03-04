import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../showimage.dart';

class CalPage extends StatefulWidget {
  var clas,branch;

  CalPage(w,b){
    this.clas=w;
    this.branch=branch;
  }
  @override
  _CalPageState createState() => _CalPageState(this.clas,this.branch);
}

class _CalPageState extends State<CalPage> {
  final CalendarWeekController _controller = CalendarWeekController();
  var homework;
  final databaseReference = Firestore.instance;
  var clas,branch;
  DateTime _now = DateTime.now();

  _CalPageState(w,b){
    this.clas=w;
    this.branch=b;
    _gethomework();
  }


  _gethomework() async{

    DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
    DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);
    var val;
//    await databaseReference
//        .collection("homework").where("class",isEqualTo: clas).where('date', isGreaterThanOrEqualTo: _start)
//        .where('date', isLessThanOrEqualTo: _end).orderBy('date').snapshots()
//        .then((value) => {val = value.documents});
//    print(val);

    CollectionReference col = databaseReference.collection("homework");
    Query query = col.where("class",isEqualTo: clas);
    query = query.where('branch', isEqualTo: branch);
    query = query.where('date', isGreaterThanOrEqualTo: _start);
      query = query.where('date', isLessThanOrEqualTo: _end);
    var vale= await query.getDocuments();
    var t= vale.documents;
    return t.reversed.toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeWork"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: "Chat with us",
        elevation: 5,
        icon: Icon(Icons.message_rounded),
        label: Text("Chat with us"),
        onPressed: (){launch("https://wa.link/hz16ej");},
      ),
      body: Column(children: [
        Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1)
            ]),
            child: CalendarWeek(
              dayOfWeek: [
                DateFormat('EEE').format(DateTime.now().subtract(Duration(days:6))),
                DateFormat('EEE').format(DateTime.now().subtract(Duration(days:5))),
                DateFormat('EEE').format(DateTime.now().subtract(Duration(days:4))),
                DateFormat('EEE').format(DateTime.now().subtract(Duration(days:3))),
                DateFormat('EEE').format(DateTime.now().subtract(Duration(days:2))),
                DateFormat('EEE').format(DateTime.now().subtract(Duration(days:1))),
                DateFormat('EEE').format(DateTime.now()),

              ],
monthStyle:const TextStyle(color: Colors.blue,fontStyle: FontStyle.italic,fontSize: 18),
weekendsStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              dayOfWeekStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              dateStyle: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              todayDateStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              controller: _controller,
              height: 120,
              showMonth: true,
              minDate: DateTime.now().add(
                Duration(days: -6),
              ),
              maxDate: DateTime.now().add(
                Duration(days: 0),
              ),
              onDatePressed: (DateTime datetime) {
                setState(() {
                  _now=datetime;
                });
              },
              onDateLongPressed: (DateTime datetime) {
                // Do something
              },
              onWeekChanged: () {
                // Do something
              },
              decorations: [
                DecorationItem(
                    decorationAlignment: FractionalOffset.bottomRight,
                    date: DateTime.now(),
                    decoration: Icon(
                      Icons.today,
                      color: Colors.blue,
                    )),
              ],
            )),
        Expanded(
          child: Center(
            child: FutureBuilder(
              builder: (context, projectSnap) {
                if (projectSnap.hasData) {
                  if (projectSnap.data.length > 0) {
                    return ListView.builder(
                      itemCount: projectSnap.data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(Icons.assignment),
                                title: Text(projectSnap.data[index]["work"],style: TextStyle(fontSize: 18 ),),
                                subtitle: Text(
                                    "\n${projectSnap.data[index]["date"].toDate().hour}:${projectSnap.data[index]["date"].toDate().minute}"),
                              ),
                              projectSnap.data[index]["image"]==null ||projectSnap.data[index]["image"]==""?Container():InkWell(child: Container(child: Image.network(projectSnap.data[index]["image"]),width: 100,height: 100,),

                              onTap: (){Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ShowImage(projectSnap.data[index]["image"])),
                              );},
                              ),
                              SizedBox(height: 20,),
                              projectSnap.data[index]["link"]==null?Container():InkWell(child: Text(projectSnap.data[index]["link"],style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline,fontSize: 16),),onTap: (){launch(projectSnap.data[index]["link"]);},),
                              projectSnap.data[index]["link"]==null?Container():SizedBox(height: 20,),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: Text(
                          "No homework till now, enjoy your day !",
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
              future: _gethomework(),
            ),
          ),
        )
      ]),
    );
  }}