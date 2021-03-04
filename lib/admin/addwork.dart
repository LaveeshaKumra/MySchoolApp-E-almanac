import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../Login.dart';


class AddWork extends StatefulWidget {

  @override
  _AddWorkState createState() => _AddWorkState();
}

class _AddWorkState extends State<AddWork> {
  var clas,_progress=false;
  File _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _homework = TextEditingController();
  final TextEditingController _link = TextEditingController();

  bool _success;
  final List<String> classes1= ["Toddler","Pre Level","Jr. Level","Sr. Level","Level P1"];
  final List<String> classes2= ["Toddler","Pre Level"];
var checked;
  List<String> list1,list2;

  final String serverToken = 'AAAAkgw6AJk:APA91bGRPBagwJydmgRcvUNkr0KHx6jo6GMaJ67NWguNw3fOrMBz--9TC4btXxO1q1_RIxqUXz8VWUm-LRgTaR_WHr-02iCS1Aibtiatk4bxlSRiBg9PL-tDT3udvDnbxyxRA2IhEEr7';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future<bool> sendAndRetrieveMessage(topic) async {
    var t2=topic.replaceAll('.', "");
    var t3=t2.replaceAll(new RegExp(r"\s+"), "");

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
          "title": "Homework uploaded",
          "text": _homework.text,
          "sound": "default",
          "tag":"New Updates from kids R Kids"
        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "screen": "OPEN_HOMEWORK_PAGE",
        },
        "priority": "high",
        "to": '/topics/$t3',
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

  addwork(context) async {
    setState(() {
      _progress=true;
    });
    var url;
    if(_image!=null){
       url=await uploadFile(_image);
    }
    else{
      url="";
    }
      final databaseReference = Firestore.instance;
      if(list1!=null){for(int i=0;i<list1.length;i++){
        await databaseReference.collection("homework")
            .add({
          'id':DateTime.now(),
          'work': _homework.text,
          'link':_link.text,
          'class':list1[i],
          'date':FieldValue.serverTimestamp(),
          'branch':"Vrinda",
          "image":url
        }).then((value) async {
          await sendAndRetrieveMessage('${list1[i]}-Vrinda');

        });
      }}

    if(list2!=null){for(int i=0;i<list2.length;i++){
      await databaseReference.collection("homework")
          .add({
        'id':DateTime.now(),
        'work': _homework.text,
        'class':list2[i],
        'link':_link.text,
        'date':FieldValue.serverTimestamp(),
        'branch':"OHBC",
        "image":url
      }).then((value) async {

        await sendAndRetrieveMessage('${list2[i]}-OHBC');

      });
    }}
    Toast.show("HomeWork is uploaded",context,duration: Toast.LENGTH_SHORT, gravity:  Toast.TOP);



    setState(() {
      _progress=false;
      _homework.text="";
      _link.text="";
      list1=[];list2=[];
      _image=null;
    });


  }




  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Future<String> uploadFile(File _image) async {

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('homework/${_image.path.split('/').last}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL =  fileURL;
    });
    return returnURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add HomeWork"),
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
                  controller: _homework,
                  validator: (var value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  cursorColor: Colors.deepOrange,
                  maxLines: 20,
                  minLines: 5,
                  decoration: InputDecoration(
                      hintText: "Home work",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.assignment,
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
                  controller: _link,
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                      hintText: "Home work (link)",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.link,
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Text("Vrinda Branch",style: TextStyle(fontWeight: FontWeight.bold)),
                  CheckboxGroup(
                      checked: list1,
                      labels: classes1,
                      onSelected: (List<String> checked) {setState(() {
                        list1=checked;
                      });})
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Text("OHBC Branch",style: TextStyle(fontWeight: FontWeight.bold),),
                  CheckboxGroup(
                    checked: list2,
                      labels: classes2,
                      onSelected: (List<String> checked) {setState(() {
                        list2=checked;
                      });})

                ],
              ),
            ),
          ],
        ),
            SizedBox(
              height: 20,
            ),
            _image==null?Container():Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Container(child: Image.file(_image),width: 200,
                height: 200,),
            ),
            SizedBox(
              height: 20,
            ),
            _image==null?Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffff3a5a) ),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                  child: FlatButton(
                    child: Text(
                      "Add Image",
                      style: TextStyle(
                          color: Color(0xffff3a5a),
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    onPressed: () async {
                      _showPicker(context);
                    },
                  ),
                )):Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffff3a5a) ),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                  child: FlatButton(
                    child: Text(
                      "Remove Image",
                      style: TextStyle(
                          color: Color(0xffff3a5a),
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    onPressed: () async {
                      setState(() {
                        _image=null;
                      });
                    },
                  ),
                ))
            ,SizedBox(
              height: 25,
            ),

            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: RoundedButton(
                  text: "Add HomeWork",
                  state: _progress,
                  press: () {

                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _progress=true;
                      });
                      addwork(context);
                    }
                  },
                ),
              ),
            ),
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
