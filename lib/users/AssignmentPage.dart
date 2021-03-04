import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';



 class AssignmentPage extends StatefulWidget {
   var clas;

   AssignmentPage(w){
     this.clas=w;
   }
   @override
   _AssignmentPageState createState() => _AssignmentPageState(this.clas);
 }

 class _AssignmentPageState extends State<AssignmentPage> {
   var clas;

   _AssignmentPageState(w){
     this.clas=w;
   }
   final databaseReference = Firestore.instance;
   _getallwork() async {
     var val;
     await databaseReference
         .collection("homework").where("class",isEqualTo: clas)
         .getDocuments()
         .then((value) => {val = value.documents});
     return val.reversed.toList();
   }


   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("HomeWork"),
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
                         leading: Icon(Icons.assignment),
                         title: Text(projectSnap.data[index]["work"]),
                         subtitle: Text(
                             "\n${projectSnap.data[index]["date"].toDate().day}/${projectSnap.data[index]["date"].toDate().month}/${projectSnap.data[index]["date"].toDate().year}"),
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
