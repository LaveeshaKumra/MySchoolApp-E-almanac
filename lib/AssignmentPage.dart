import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';


 class AssignmentPage extends StatefulWidget {
   var subject;
   AssignmentPage(data){
     this.subject=data;
   }
   @override
   _AssignmentPageState createState() => _AssignmentPageState(this.subject);
 }

 class _AssignmentPageState extends State<AssignmentPage> {
   var subject;
   _AssignmentPageState(data){
     this.subject=data;
   }

   _assignments() async{
     var D=DateTime.now();
     if(subject=="Maths") {
       var Maths = [
         {"title": "Mathas Assignment 1", "date": D.toString()},
       ];
       return Maths;

     }
     else{
       var bb=[];
       return bb;
     }

 }
   var downloading=false;
   var urlPath="https://images.unsplash.com/photo-1494548162494-384bba4ab999?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80";
   _downloadfile() async{
     Dio dio= new Dio();
     try{
       var dir=await getApplicationDocumentsDirectory();
       await dio.download(urlPath, "${dir.path}/newimage.jpg",onReceiveProgress: (rec,total){
         print("rec :$rec and total: $total");
       });
     }catch(e){
       print(e);
     }
 }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title: Text("$subject"),),
       body: FutureBuilder(
         builder: (BuildContext context, AsyncSnapshot snapshot) {
           print(snapshot.data);
           if (snapshot.data.length > 0) {
             return ListView.builder(
               itemCount: snapshot.data.length,
               itemBuilder: (BuildContext context, int index) {
                 return Card(
                   child: ListTile(
                     leading: Icon(Icons.insert_drive_file),
                     title: Text(snapshot.data[index]["title"]),
                     trailing: GestureDetector(child: Icon(Icons.file_download),onTap: (){print("download");},),
                     subtitle: Text(
                         "Posted on\n${DateFormat.yMMMMd('en_US').format(DateTime.parse(snapshot.data[index]['date']).toLocal())}",
                     style: TextStyle(fontSize: 16),
                     ),
                   ),
                 );
               },
             );
           } else {
             print("yee");
             return Center(
                 child: Text(
                   "No Assignment of this subject !",
                   style: TextStyle(fontSize: 22),
                 ));
           }
         },
         future: _assignments(),
       ),
     );
   }
 }
