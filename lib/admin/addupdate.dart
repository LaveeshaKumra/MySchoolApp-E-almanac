import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:toast/toast.dart';
import '../Login.dart';

class AddUpdate extends StatefulWidget {
  @override
  _AddUpdateState createState() => _AddUpdateState();
}

class _AddUpdateState extends State<AddUpdate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _success;
  var _progress=false,checkedValue=false;
  final String serverToken = 'AAAAkgw6AJk:APA91bGRPBagwJydmgRcvUNkr0KHx6jo6GMaJ67NWguNw3fOrMBz--9TC4btXxO1q1_RIxqUXz8VWUm-LRgTaR_WHr-02iCS1Aibtiatk4bxlSRiBg9PL-tDT3udvDnbxyxRA2IhEEr7';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<bool> sendAndRetrieveMessage() async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
        "key=$serverToken",
      };
      var request = {
        "notification": {
          "title": _titleController.text,
          "text": _descController.text,
          "sound": "default",
          "tag":"New Updates from Kids R Kids"
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "screen": "OPEN_UPDATE_PAGE",
        },
        "priority": "high",
        "to": '/topics/all',
      };

      var client = new Client();
      var response =
      await client.post(url, headers: header, body: json.encode(request));
      print(response.body);
      print(response.statusCode);
      return true;
    } catch (e, s) {
      print(e);
      return false;
    }
  }
  addnewUpdate(context) async {
    setState(() {
      _progress=true;
    });
      final databaseReference = Firestore.instance;
      await databaseReference.collection("updates")
          .add({
        'id':DateTime.now(),
        'message': _titleController.text,
        'description': _descController.text,
        'date': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} - ${DateTime.now().hour}:${DateTime.now().minute}"
      }).then((value) async {
        await sendAndRetrieveMessage();
        Toast.show("New Update is added",context,duration: Toast.LENGTH_SHORT, gravity:  Toast.TOP);
        setState(() {
          _progress=false;
          _titleController.text="";
          _descController.text="";
        });
//        Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(builder: (context) => OtherUpdates()),
//        );
      });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Update"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: _titleController,
                  validator: (var value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  cursorColor: Colors.deepOrange,
                  maxLines: 10,
                  minLines: 2,
                  decoration: InputDecoration(
                      hintText: "Title",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.info,
                          color: Colors.red,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: _descController,
                  validator: (var value) {
                    if (value.isEmpty) {
                      return 'Password can not be null';
                    }
                    return null;
                  },
                  cursorColor: Colors.deepOrange,
                  maxLines: 10,
                  minLines: 2,
                  decoration: InputDecoration(
                      hintText: "Description",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.edit,
                          color: Colors.red,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                ),
              ),
            ),

            SizedBox(
              height: 25,
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: RoundedButton(
                  text: "Add Update",
                  state: _progress,
                  press: () {

                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _progress=true;
                      });
                      addnewUpdate(context);
                    }
                  },
                ),
              ),
            ),
//            Padding(
//                padding: EdgeInsets.symmetric(horizontal: 32),
//                child: Container(
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.all(Radius.circular(100)),
//                      color: Color(0xffff3a5a)),
//                  child: FlatButton(
//                    child: Text(
//                      "Add Update",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.w700,
//                          fontSize: 18),
//                    ),
//                    onPressed: () async {
//                      if (_formKey.currentState.validate()) {
//                        addnewUpdate();
//                      }
//                    },
//                  ),
//                )),
            Container(
              alignment: Alignment.center,
              child: Text(_success == null
                  ? ''
                  : (_success
                  ? 'Successfully published '
                  : ' failed')),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}