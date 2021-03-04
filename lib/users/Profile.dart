import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

import '../Login.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var user, profile;
  var id, _image;
  var clas, name, branch;
  bool _switch = true;
  _ProfilePageState() {
    _getUser();
  }
  final databaseReference = Firestore.instance;

  _getUser() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    setState(() {
      id = _user.uid;
    });
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection("userdetails")
        .where('uuid', isEqualTo: id)
        .getDocuments()
        .then((value) {
      setState(() {
        clas = value.documents[0]['role'];
        user = value.documents[0]['email'];
        branch = value.documents[0]['branch'];
        name = value.documents[0]['name'];
        profile = value.documents[0]['profile'];
        print(profile);
      });
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
        });
  }

  _removeProfile(context) async {
    Toast.show("Removing...", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

    await databaseReference
        .collection("userdetails")
        .where('email', isEqualTo: user)
        .getDocuments()
        .then((value) async {
      id = value.documents[0].documentID;
      print(id);
      await databaseReference
          .collection("userdetails")
          .document(id)
          .updateData({'profile': ''}).then((value) {
        Toast.show("Profile Changed", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        setState(() {
          _image = null;
          profile = null;
        });
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
      Toast.show("Uploading....", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      updateImage();
    });
  }

  updateImage() async {
    var id;
    var url = await uploadFile(_image);
    await databaseReference
        .collection("userdetails")
        .where('email', isEqualTo: user)
        .getDocuments()
        .then((value) async {
      id = value.documents[0].documentID;
      print(id);
      await databaseReference
          .collection("userdetails")
          .document(id)
          .updateData({'profile': url}).then((value) {
        Toast.show("Profile Uploaded", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      });

//      Navigator.pushReplacement(
//        context,
//        MaterialPageRoute(builder: (context) => ShowHomeWork(clas, branch)),
//      );
    });
  }

  Future<String> uploadFile(File _image) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile/${_image.path.split('/').last}');
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
      Toast.show("Uploading....", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

      updateImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.deepOrange,
      appBar: AppBar(
        title: Text("View Profile"),
        backgroundColor: Color(0xfffe494d),
        elevation: 0,
      ),
      body: clas == null || user == null
          ? Center(
              child: Column(
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
              ),
            )
          : ListView(
              children: <Widget>[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.5, 0.9],
                          colors: [Color(0xffff3a5a), Color(0xfffe494d)])),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Center(
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Color(0xffFDCF09),
                              child: profile != null && profile != ""
                                  ? GestureDetector(
                                      onTap: () {
                                        _profile(context);
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
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
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            width: 100,
                                            height: 100,
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        user,
                        style: TextStyle(fontSize: 22.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                ListTile(
                  title: Text(
                    "Name",
                    style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
                  ),
                  subtitle: Text(
                    name,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    "Class",
                    style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
                  ),
                  subtitle: Text(
                    clas,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    "Branch",
                    style: TextStyle(color: Colors.deepOrange, fontSize: 12.0),
                  ),
                  subtitle: Text(
                    branch,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
//                Divider(),
//                ListTile(
//                    title: Text(
//                      "Notifications",
//                      style:
//                          TextStyle(color: Colors.deepOrange, fontSize: 12.0),
//                    ),
//                    trailing: Switch(
//                      value: _switch,
//                      onChanged: (bool val) {
//                        setState(() {
//                          _switch = val;
//                        });
//                      },
//                    )),
//          SizedBox(
//            height: 30,
//          ),
//          Padding(
//            padding: EdgeInsets.symmetric(horizontal: 32),
//            child: Material(
//              elevation: 2.0,
//              borderRadius: BorderRadius.all(Radius.circular(30)),
//              child: TextFormField(
//                controller: _password,
//                validator: (var value) {
//                  if (value.isEmpty) {
//                    return "Name can't be null";
//                  }
//                  return null;
//                },
//                cursorColor: Colors.deepOrange,
//                decoration: InputDecoration(
//                    hintText: "password",
//                    prefixIcon: Material(
//                      elevation: 0,
//                      borderRadius: BorderRadius.all(Radius.circular(30)),
//                      child: Icon(
//                        Icons.perm_identity,
//                        color: Colors.red,
//                      ),
//                    ),
//                    border: InputBorder.none,
//                    contentPadding:
//                    EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
//              ),
//            ),
//          ),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.red)),
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                        onPressed: () async {
                          final FirebaseAuth _auth = FirebaseAuth.instance;
                          _auth
                              .sendPasswordResetEmail(email: user)
                              .then((value) {
                            Toast.show(
                                "Password Reset Mail has been sent to $user}",
                                context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          });
                        },
                      ),
                    )),
              ],
            ),
    );
  }
}
