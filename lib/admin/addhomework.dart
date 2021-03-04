import 'package:flutter/material.dart';
import 'package:school/admin/addwork.dart';
import 'package:school/admin/showhomwwork.dart';

class AddHomeWork extends StatefulWidget {
  var branch;
  AddHomeWork(b){this.branch=b;}
  @override
  _AddHomeWorkState createState() => _AddHomeWorkState(this.branch);
}

class _AddHomeWorkState extends State<AddHomeWork> {
  var branch;
  final List<String> classes1= ["Toddler","Pre Level","Jr. Level","Sr. Level","Level P1"];
  final List<String> classes2= ["Toddler","Pre Level"];
  var  classes;
  _AddHomeWorkState(b) {
    this.branch = b;
    if (branch == "Vrinda") {classes=classes1;}
    else {classes=classes2;}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$branch"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWork()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              child: Card(
                elevation: 5,
                child: ListTile(
                  leading: Icon(Icons.school,color: Colors.red,),
                  title: Text(classes[index]),
                  trailing: Icon(Icons.navigate_next),
                ),
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShowHomeWork(classes[index],branch)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
