import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school/admin/manageuser.dart';
import 'package:toast/toast.dart';

import '../Login.dart';

class EditUser extends StatefulWidget {
  var email;
  EditUser(e){
    this.email=e;
  }
  @override
  _EditUserState createState() => _EditUserState(this.email);
}

class _EditUserState extends State<EditUser> {
  var email,clas,branch,name;
  var profile;
  var id, _image;
  _EditUserState(e){this.email=e;_getuser();}
  final databaseReference = Firestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _progress=false;

  final List<String> _allclasses = [
    "Toddler","Pre Level","Jr. Level","Sr. Level","Level P1",
    "admin"
  ];
  final List<String> _branches=[
    "Vrinda",
    "OHBC"
  ];


  _getuser() async{
    print(email);
    final databaseReference = Firestore.instance;
    await databaseReference.collection("userdetails").where('email',isEqualTo: email).getDocuments().then((value) {
      setState(() {
        clas=value.documents[0]['role'];
        branch=value.documents[0]['branch'];
        name=value.documents[0]['name'];
        _emailController.text=email;
        _nameController.text=name;
        profile=value.documents[0]['profile'];
      });
    }).then((value){
    });

  }

  _updateuser(context) async{
    _progress=true;
    final databaseReference = Firestore.instance;
    var id;
    var url;
    if(_image!=null){
       url = await uploadFile(_image);

    }
    await databaseReference.collection("userdetails").where('email',isEqualTo: email).getDocuments().then((value) async {
      id=value.documents[0].documentID;
      print(id);
      await databaseReference
          .collection("userdetails").document(id).updateData(
          {
            'role': clas,
            'name':_nameController.text,
            'branch':branch,
            'profile':url==null?'':url,
            'topic':'$clas-$branch'
          }
      );

      Toast.show("Updated ! ",context,duration: Toast.LENGTH_SHORT, gravity:  Toast.TOP);
setState(() {
  _progress=false;
});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ManageUsers()),
      );
    });


  }
  _deleteuser() async {
    final databaseReference = Firestore.instance;
    var id;
    await databaseReference.collection("userdetails").where('email',isEqualTo: email).getDocuments().then((value) async {
        id=value.documents[0].documentID;
        print(id);
        await databaseReference
            .collection("userdetails").document(id).delete();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ManageUsers()),
        );
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
        .where('email', isEqualTo: email)
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

    });
  }

//  updateImage() async {
//    var id;
//    var url = await uploadFile(_image);
//    await databaseReference
//        .collection("userdetails")
//        .where('email', isEqualTo: email)
//        .getDocuments()
//        .then((value) async {
//      id = value.documents[0].documentID;
//      print(id);
//      await databaseReference
//          .collection("userdetails")
//          .document(id)
//          .updateData({'profile': url}).then((value) {
//        Toast.show("Profile Uploaded", context,
//            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
//      });
//
////      Navigator.pushReplacement(
////        context,
////        MaterialPageRoute(builder: (context) => ShowHomeWork(clas, branch)),
////      );
//    });
//  }

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

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit User Details"),
        actions: [
          InkWell(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.delete),
          ),onTap: (){
            _deleteuser();
          },)
        ],
      ),
      body: Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[

          SizedBox(
            height: 30,
          ),
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
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextFormField(
                controller: _nameController,
                validator: (var value) {
                  if (value.isEmpty) {
                    return "Name can't be null";
                  }
                  return null;
                },
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "Name",
                    prefixIcon: Material(
                      elevation: 0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.perm_identity,
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
              color: Colors.grey[200],
              elevation: 2.0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: TextFormField(
                controller: _emailController,
                validator: (var value) {
                  if (value.isEmpty) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                enabled: false,
                cursorColor: Colors.deepOrange,
                decoration: InputDecoration(
                    hintText: "Email id",
                    prefixIcon: Material(
                      elevation: 0,
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: Icon(
                        Icons.email,
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
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Material(
                    elevation: 0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Icon(
                      Icons.lock,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.67,
                    child: DropdownButton(
                      isExpanded: true,
                      hint: Text('User Role'),
                      value: clas,
                      items: _allclasses
                          .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          clas = value;
                        });
                      },
                    ),
                  ),
                ],
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
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Material(
                    elevation: 0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Icon(
                      Icons.school,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.67,
                    child: DropdownButton(
                      isExpanded: true,
                      hint: Text('Branch'),
                      value: branch,
                      items: _branches
                          .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          branch = value;
                        });
                      },
                    ),
                  ),
                ],
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
                text: "Update Profile",
                state: _progress,
                press: () {

                  if (_formKey.currentState.validate()) {
                    setState(() {
                      _progress=true;
                    });
                    _updateuser(context);
                  }
                },
              ),
            ),
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

