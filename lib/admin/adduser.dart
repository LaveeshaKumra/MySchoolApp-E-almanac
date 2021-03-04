import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school/admin/manageuser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../Login.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  var _branch,_class;
  bool _success,_progress=false;
  var _image,profile;
  //var branch;
  final List<String> _allclasses = [
    "Toddler","Pre Level","Jr. Level","Sr. Level","Level P1",
    "admin"
  ];
  final List<String> _branches=[
    "Vrinda",
    "OHBC"
  ];
  _AddUserState(){
    _passwordController.text="almanac";
  }

  var _c=["1","2","3"];
  @override

  addnewUser(context) async {
    setState(() {
      _progress=true;
    });
    var url="";
    if(_image!=null){
       url=await uploadFile(_image);
    }
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text).then((value) async {
      final databaseReference = Firestore.instance;
      var noti;
      if(_class=="admin"){
        noti='admin';
      }
      else{
        noti='${_class}-${_branch}';
      }
      await databaseReference.collection("userdetails")
          .add({
        'uuid': value.user.uid,
        'email': _emailController.text,
        'role': _class,
        'name':_nameController.text,
        'branch':_branch,
        'profile':url,
        'topic':noti,
      }).then((value) async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var e=prefs.getString('email');
        var p=prefs.getString('password');
        FirebaseAuth.instance.signInWithEmailAndPassword(email: e,
            password: p);
        Toast.show("New User is added",context,duration: Toast.LENGTH_SHORT, gravity:  Toast.TOP);

        setState(() {
          _progress=false;
          _nameController.text="";
          _passwordController.text="almanac";
          _image=null;
          _branch=null;
          _class=null;
          _emailController.text="";
        });

//        Navigator.pushReplacement(
//          context,
//          MaterialPageRoute(builder: (context) => ManageUsers()),
//        );
      });
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
      returnURL =  fileURL;
    });
    return returnURL;
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
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
      profile = "";

    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
      profile = "";

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New User"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xffFDCF09),
                child: _image != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.file(
                    _image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight,
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(50)),
                  width: 100,
                  height: 100,
                  child: Icon(
                    Icons.camera_alt,
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
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                      hintText: "Email id",
                      prefixIcon: Material(
                        elevation: 0,
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
                child: TextFormField(
                  controller: _passwordController,
                  validator: (var value) {
                    if (value.isEmpty) {
                      return "Password can't be null";
                    }
                    return null;
                  },
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.lock,
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
                        value: _class,
                        items: _allclasses
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _class = value;
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
                        value: _branch,
                        items: _branches
                            .map((e) =>
                            DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _branch = value;
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
                  text: "Add User",
                  state: _progress,
                  press: () {

                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _progress=true;
                      });
                      addnewUser(context);
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
//                      "Add User",
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.w700,
//                          fontSize: 18),
//                    ),
//                    onPressed: () async {
//                      if (_formKey.currentState.validate()) {
//                        addnewUser(context);
//                      }
//                    },
//                  ),
//                )),
            Container(
              alignment: Alignment.center,
              child: Text(_success == null
                  ? ''
                  : (_success
                      ? 'Successfully registered ' + _emailController.text
                      : 'Registration failed')),
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
