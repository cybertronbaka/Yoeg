import 'dart:io';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:yoega/common/fire_storage_service.dart';
import 'package:yoega/models/user_info.dart';
import 'package:yoega/pages/upload_image_page.dart';
import 'package:yoega/widgets/TextFieldWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yoega/common/provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:yoega/bloc/navigation_bloc/navigation_bloc.dart';

class UserPage extends StatefulWidget{
  @override
  _UserPageState createState() => new _UserPageState();
}

class _UserPageState extends State<UserPage> {

  Future<Widget> _getImage(BuildContext context, String image) async {
    Image m;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        height:140,
        width: 140,
        fit: BoxFit.fill,
      );
    });

    return m;
  }
  File _image;

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  TextEditingController nameController = new TextEditingController();
  TextEditingController bioController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();

  Stream<QuerySnapshot> getUserDataStreamSnapshots(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection('UserData').document(uid).collection('info').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        //Title should the users Name
        backgroundColor: Colors.teal,
        title: Text("Edit user profile", style: TextStyle(color: Colors.white),),
    leading: new IconButton(
    icon: new Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () {
    Navigator.pop(context);
    },
    ),
    ),
    body:Container(child:StreamBuilder(
          stream: getUserDataStreamSnapshots(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Scaffold(body: Center(child: JumpingDotsProgressIndicator(
                fontSize: 40.0,
              ),));
            return buildPage(context, snapshot.data.documents[0]);
          }
    )));
  }

  Widget buildPage(BuildContext context, DocumentSnapshot snapshot){
    bioController.text = snapshot['bio'];
    emailController.text = snapshot['email'];
    phoneController.text = snapshot['phone'];
    String image = snapshot['propic'];
    return Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  height: 250.0,
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: new Stack(fit: StackFit.loose, children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                  child: FutureBuilder(
                            future: _getImage(context, image),
            builder: (context, snapshot) {
              if (snapshot.connectionState ==
                  ConnectionState.done) {
                if (snapshot.hasData) {
                  return Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: Colors.teal,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                        radius:70,
                        child: ClipOval(
                          child: snapshot.data,
                        )
                    ),
                  );
                }
              }
              return Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.0,
                      color: Colors.teal,
                    ),
                    shape: BoxShape.circle,
                    image:  new DecorationImage(
                      fit: BoxFit.fill,
                      image:AssetImage('assets/default_pro_pic.png'),
                    )
                ),
              );
            }
        )
                                  ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new CircleAvatar(
                                    backgroundColor: Colors.teal,
                                    radius: 25.0,
                                    child: new IconButton(
                                      icon: Icon(Icons.camera_alt),
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadImagePage(uploadState: ImageUploadState.userPic,)));
                                      },
                                    ),
                                  )
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
                new Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Parsonal Information',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : new Container(),
                                  ],
                                )
                              ],
                            )),
                        TextFieldLabel("Bio"),
                        TextFieldForm("Write something about yourself", _status, myFocusNode, controller: bioController,),
                        TextFieldLabel("Email"),
                        TextFieldForm("Enter Email ID", _status, myFocusNode, controller: emailController,),
                        TextFieldLabel("Mobile"),
                        TextFieldForm("Enter Mobile No.", _status, myFocusNode,controller: phoneController,),

                        !_status ? _getActionButtons(context) : new Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
    );
  }
  Future updateData(BuildContext context) async{
    var uid = await Provider.of(context).auth.getCurrentUID();
    Firestore.instance.collection('UserData').document(uid).collection("info").document("info").updateData({'bio':bioController.text});
    Firestore.instance.collection('UserData').document(uid).collection("info").document("info").updateData({'email':emailController.text});
    Firestore.instance.collection('UserData').document(uid).collection("info").document("info").updateData({'phone':phoneController.text});

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserPage()));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Colors.teal,
                    onPressed: () {
                      setState(() {
                        _status = true;
                      });
                      updateData(context);

                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.teal,
                    onPressed: () {
                      setState(() {
                        _status = true;
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.teal,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
