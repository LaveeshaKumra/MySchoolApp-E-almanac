import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Updates extends StatefulWidget {
  @override
  _UpdatesState createState() => _UpdatesState();
}
var D=DateTime.now();


_updatedetail() async{
  var _updatedata=[
    {"update":"New submission date","date":D.toString(),"updatedescpription":"You can submit physics assignment upto 18 march"},
    {"update":"New assignment uploaded","date":D.toString(),"updatedescpription":"You have to submit the assignment of physics upto 16 april"},

  ];
  print(_updatedata.length); return _updatedata;}


class _UpdatesState extends State<Updates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Updates"),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
        print(snapshot.data);
        if (snapshot.data.length > 0) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.new_releases),
                  title: Text(snapshot.data[index]["update"]),
                  subtitle: Text(snapshot.data[index]["updatedescpription"]),
                  trailing: Text(
                      "${DateFormat.yMMMMd('en_US').format(DateTime.parse(snapshot.data[index]['date']).toLocal())}"),
                ),
              );
            },
          );
        } else {
          print("yee");
          return Center(
              child: Text(
                "No notice from school !",
                style: TextStyle(fontSize: 22),
              ));
        }

        },
        future: _updatedetail(),
      ),
    );
  }
}
