import 'package:flutter/material.dart';

import 'addhomework.dart';
import 'addwork.dart';

class BranchPage extends StatefulWidget {
  @override
  _BranchPageState createState() => _BranchPageState();
}

class _BranchPageState extends State<BranchPage> {
  final List<String> branch=[
    "Vrinda",
    "OHBC"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeWork"),
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
        itemCount: branch.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              child: Card(
                elevation: 5,
                child: ListTile(
                  leading: Icon(Icons.location_city,color: Colors.red,),
                  title: Text(branch[index]),
                  trailing: Icon(Icons.navigate_next),
                ),
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddHomeWork(branch[index])),
                );
              },
            ),
          );
        },
      ),
    );
  }
}