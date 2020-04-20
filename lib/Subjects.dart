import 'package:flutter/material.dart';
import 'package:school/AssignmentPage.dart';


class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}

var data=["English","Maths","Hindi","Social Science","Physical Education","Maths"];
class _SubjectsState extends State<Subjects> {


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Subjects"),
        backgroundColor: Colors.deepOrange,
      ),

    body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20.0),
        crossAxisSpacing: 10.0,
        crossAxisCount: 2,
        children: List<Widget>.generate(
          data.length,
              (index) {
            return GridTile(
              child: GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AssignmentPage(data[index])),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    child: Center(
                      child:Text(data[index],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    ),
                    elevation: 5.0,
                    color:
                    Colors.deepOrange[100],
                  ),
                ),
              ),
            );
          },
        )),
    );
  }
}
