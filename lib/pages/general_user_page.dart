import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yoega/common/fire_storage_service.dart';
import 'package:yoega/common/provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:yoega/pages/checkConnection.dart';
import 'package:yoega/pages/upload_image_page.dart';
import 'package:yoega/pages/user_profile.dart';
import 'package:yoega/widgets/StretchedButton.dart';
//TODO
//Edit Volunteer and participate procedure.


class GeneralUserView extends StatefulWidget{
  @override
  _GeneralUserView createState()=>new _GeneralUserView();

}

class _GeneralUserView extends State<GeneralUserView>{
  Future<Widget> _getImage(BuildContext context, String image) async {
    Image m;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
            m = Image.network(
                 downloadUrl.toString(),
              height:140,
              width:140,
                 fit: BoxFit.cover,
                );
          });
    return m;
  }


  Stream<QuerySnapshot> getUserDataStreamSnapshots(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection('UserData').document(uid).collection('info').snapshots();
  }
  bool connected = true;
  checkConnection() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          connected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        connected = false;
      });    }
  }
  @override
  void initState(){
    super.initState();
    checkConnection();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return connected?Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("User Profile", style: TextStyle(color: Colors.white)),
      ),
      body:Container(
        child: StreamBuilder(
          stream: getUserDataStreamSnapshots(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Scaffold(body: Center(child: JumpingDotsProgressIndicator(
                fontSize: 40.0,
                ),));

            return buildUserPage(context, snapshot.data.documents[0]);
        }
      ),
    )
    ):NoInternetConnection();
  }
  Widget buildUserPage(BuildContext context, DocumentSnapshot snapshot){
    String image = snapshot['propic'];
    return Container(
      color: Colors.white,
      child: new ListView(
          children: <Widget>[
            Column(
                children: <Widget>[
                  new Container(
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
                                        builder: (context, snapshots) {
                                          if (snapshots.connectionState ==
                                              ConnectionState.done) {
                                            if (snapshots.hasData) {
                                                return Container(
                                                  margin: EdgeInsets.all(20),
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
                                                      child: snapshots.data,
                                                    )
                                                  ),
                                                );
                                            }
                                          }
                                          return Container(
                                            height:140,
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
                                        child: IconButton(
                                          icon: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        ),
                                          onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadImagePage(uploadState: ImageUploadState.userPic)));
                                          }),
                                      )
                                    ],
                                  )),
                            ]),
                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(snapshot['username'], style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),),
                                  Text(snapshot['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.black54),),
                                  Padding(padding: EdgeInsets.only(top:10),child: Text(snapshot['bio'],style: TextStyle(fontSize: 15,color: Colors.black87)),)
                                ]
                            ),
                          )
                        ]),
                  ),
                ]),
            StretchedButton(label:"Edit Profile", minWidth: 100, textColor: Colors.white,color: Colors.teal, onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>UserPage()));}),
            Text("Events Participated In"),
            Text("Events Volunteered In"),
            Text("Events Organized"),
          ]),
    );
  }
}