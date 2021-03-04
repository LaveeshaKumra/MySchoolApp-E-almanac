import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:school/admin/showhomwwork.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


import '../Login.dart';
class EditWork extends StatefulWidget {
  var clas,branch;
  var id;
  EditWork(c,b,i){
    this.clas=c;this.branch=b;this.id=i;
  }
  @override
  _EditWorkState createState() => _EditWorkState(this.clas,this.branch,this.id);
}

class _EditWorkState extends State<EditWork> {
  final databaseReference = Firestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _homework = TextEditingController();
  final TextEditingController _link = TextEditingController();
  bool _success;
  var clas,branch,id;
  bool _progress=false;

  var profile,_image;
  _EditWorkState(c,b,i){
    this.clas=c;this.branch=b;this.id=i;
    _getwork();
  }
  _getwork() async{
    final databaseReference = Firestore.instance;
    print(id);
    var document=await databaseReference.collection("homework").document(id)  ;
    document.get().then((doc) {
    setState(() {
        _homework.text=doc.data['work'];
        _link.text=doc.data['link'];
        profile=doc.data['image'];
      });
    });
//      setState(() {
//        _homework.text=value.documents[0]['work'];
//        _link.text=value.documents[0]['link'];
//        profile=value.documents[0]['image'];
//      });
//      print(value.documents[0]);


  }
  _edithomework() async {
    _progress=true;
    var url ;
    if(_image!=null){
      url = await uploadFile(_image);

    }

      await databaseReference
          .collection("homework").document(id).updateData(
          {
            'work':_homework.text,
            'image':url==null?'':url,
            'link':_link.text

          }
      );
      Toast.show("Updated ! ",context,duration: Toast.LENGTH_SHORT, gravity:  Toast.TOP);
      setState(() {
        _progress=false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ShowHomeWork(clas, branch)),
      );


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
        });
  }

  _removeProfile(context) async {
    Toast.show("Removing...", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
var id;
    await databaseReference.collection("homework").where('class',isEqualTo: clas).where("branch",isEqualTo: branch).getDocuments().then((value) async {
      id=value.documents[0].documentID;
      print(id);

      await databaseReference
          .collection("homework").document(id).updateData(
          {
            'work':_homework.text,
            'image':'',
            'link':_link.text

          }
      );
        Toast.show("Profile Changed", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        setState(() {
          _image = null;
          profile = null;
        });
      });
  }

  void _profile(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.edit),
                      title: new Text('Change Profile'),
                      onTap: () {
                        _showPicker(context);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.delete),
                    title: new Text('Remove Profile'),
                    onTap: () {
                      _removeProfile(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
      profile = "";

    });
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
      returnURL = fileURL;
    });
    return returnURL;
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      profile = "";

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit HomeWork"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Center(
              child: profile != null && profile != ""
                  ? GestureDetector(
                onTap: () {
                  _profile(context);
                },
                child: ClipRRect(
                  child: Image.network(
                    profile,
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              )
                  : _image != null
                  ? ClipRRect(

                child: Image.file(
                  _image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.fitHeight,
                ),
              )
                  : GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      ),
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.image,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
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
              height: 25,
            ),

            Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: Color(0xffff3a5a)),
                  child: FlatButton(
                    child: Text(
                      "Update Homework",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _edithomework();
                      }
                    },
                  ),
                )),
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