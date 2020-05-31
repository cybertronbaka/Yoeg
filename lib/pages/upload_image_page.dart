import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoega/common/AuthService.dart';
import 'package:yoega/common/fire_storage_service.dart';
import 'package:yoega/common/provider.dart';
import 'package:yoega/pages/checkConnection.dart';
import 'package:yoega/pages/database_ops.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:yoega/pages/edit_event.dart';
import 'package:yoega/pages/general_user_page.dart';

enum ImageUploadState{
  userPic, eventPic
}

class UploadImagePage extends StatefulWidget{
  String eventID;
  DocumentSnapshot eventSnapshot;
  ImageUploadState uploadState;
  UploadImagePage({Key key, @required this.uploadState, this.eventID, this.eventSnapshot}):super(key:key);
  @override
  _UploadImagePageState createState()=> new _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage>{
  String fileType = '';
  File file;
  String fileName = '';
  String operationText = '';
  bool isUploaded = true;
  String result = '';

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
  Future filePicker(BuildContext context,String username) async {
    try {
      if (fileType == 'image') {
        file = await FilePicker.getFile(type: FileType.IMAGE);
        setState(() {
          if(widget.uploadState == ImageUploadState.userPic) {
            fileName = "Users/" + username + p.basename(file.path);
          }else{
            fileName = "Events/" + username + p.basename(file.path);
          }
        });
        print(fileName);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sorry...'),
              content: Text('Unsupported exception: $e'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
      );
    }
  }


  Future<void> _uploadFile(File file, String filename) async {
    print("File is "+ filename);
    StorageReference pathReference;
    var uid = await Provider.of(context).auth.getCurrentUID();
    StorageReference storageReference;
    if (fileType == 'image') {
      FirebaseStorage storage = FirebaseStorage.instance;
      StorageReference storageRef = await storage.getReferenceFromUrl("gs://yoega-6dc83.appspot.com");
      pathReference = storageRef.child(filename);
    }
    try {
      final StorageUploadTask uploadTask = pathReference.putFile(file);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      final String url = (await downloadUrl.ref.getDownloadURL());
      if(widget.uploadState == ImageUploadState.userPic) {
       Firestore.instance.collection('UserData').document(uid).collection(
            "info").getDocuments()
           .then((querySnapshot) {
         querySnapshot.documents.forEach((documentSnapshot) {
           documentSnapshot.reference.updateData({'propic': fileName});
         });
       });
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GeneralUserView()));
      }else{
        //////TO-DO
        Firestore.instance.collection('Events').document(widget.eventID).collection(
            "info").getDocuments()
            .then((querySnapshot) {
          querySnapshot.documents.forEach((documentSnapshot) {
            documentSnapshot.reference.updateData({'eventPic': fileName});
          });
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditEventPage(eventID: widget.eventID,snapshot: widget.eventSnapshot)));

      }
      print("URL is $url");
    }catch (e){
      print(e.message);
    }

  }

  Future<Widget> _getImage(BuildContext context, String image) async {
    Image m;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });

    return m;
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
      return connected?Scaffold(
        appBar: AppBar(
          //Title should the users Name
          backgroundColor: Colors.teal,
          title: Text(widget.uploadState == ImageUploadState.eventPic?"Upload Event Pic":"Upload profile picture", style: TextStyle(color: Colors.white),),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: widget.uploadState == ImageUploadState.userPic?Container(
          child: StreamBuilder(
              stream: DbOps().getUserDataStreamSnapshots(context),
              builder: (context, snapshot) {
                if(!snapshot.hasData) return Center(child:  JumpingDotsProgressIndicator(
                  fontSize: 40.0,
                ),);
                return buildDisplay(context, snapshot.data.documents[0]);
              }
          ),
        ):Container(child:buildDisplay(context, widget.eventSnapshot)),
      ):NoInternetConnection();
  }

  Future getUid(BuildContext context) async{
    return await Provider.of(context).auth.getCurrentUID();
  }
  String getUidString(BuildContext context){
    return getUid(context).toString();
  }

  Widget buildDisplay(BuildContext context, DocumentSnapshot snapshots,){
    String image;
    if(widget.uploadState == ImageUploadState.userPic) {
      image = snapshots['propic'];
    }else{
      image = snapshots['eventPic'];
    }
    return Container(
          padding: EdgeInsets.only(top:10),
          child:ClipRRect(
            child: FutureBuilder(
              future: _getImage(context, image),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.done)
                  if(snapshot.hasData) {
                    return Container(
                      height:
                      MediaQuery
                          .of(context)
                          .size
                          .height,
                      width:
                      MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: ListView(children: <Widget>[
                        (file!=null)?Image.file(
                          file,
                          fit: BoxFit.fill,
                        ):snapshot.data,
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(top: 30),
                            child: MaterialButton(
                              minWidth: 300,
                              height: 50,
                              color: Colors.teal,
                              child: Text("Upload", style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                              onPressed: () {
                                setState(() {
                                  fileType = 'image';
                                });
                                if(widget.uploadState == ImageUploadState.userPic){
                                  filePicker(context,snapshots['username']);
                                }else{
                                  //Todo
                                  filePicker(context, widget.eventID);
                                }
                              },
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(top: 30),
                            child: MaterialButton(
                              minWidth: 300,
                              height: 50,
                              color: Colors.teal,
                              child: Text("Submit", style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                              onPressed: () {
                                _uploadFile(file, fileName);
                              },
                            ),
                          ),
                        ),
                      ],),
                    );
                  }else{
                    return Container(
                      height:
                      MediaQuery
                          .of(context)
                          .size
                          .height,
                      width:
                      MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: ListView(children: <Widget>[
                        (file!=null)?Image.file(
                          file,
                          fit: BoxFit.fill,
                        ):Text("Image not found"),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(top: 30),
                            child: MaterialButton(
                              minWidth: 300,
                              height: 50,
                              color: Colors.teal,
                              child: Text("Upload", style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                              onPressed: () {
                                setState(() {
                                  fileType = 'image';
                                });
                                if(widget.uploadState == ImageUploadState.userPic){
                                  filePicker(context,snapshots['username']);
                                }else{
                                  filePicker(context, widget.eventID);
                                }
                              },
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(top: 30),
                            child: MaterialButton(
                              minWidth: 300,
                              height: 50,
                              color: Colors.teal,
                              child: Text("Submit", style: TextStyle(
                                  color: Colors.white, fontSize: 16)),
                              onPressed: () {
                                _uploadFile(file, fileName);
                              },
                            ),
                          ),
                        ),
                      ],),
                    );
                  }
                if (snapshot.connectionState ==
                    ConnectionState.waiting)
                  return Center(
                    child: Container(
                      height:20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
                  );

                return Container(
                  child: ListView(children: <Widget>[
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top:30),
                      child: MaterialButton(
                        minWidth: 300,
                        height: 50,
                        color: Colors.teal,
                        child: Text("Upload", style:TextStyle(color: Colors.white, fontSize: 16)),
                        onPressed: (){
                          setState(() {
                            fileType = 'image';
                          });
                          if(widget.uploadState == ImageUploadState.userPic){
                            filePicker(context,snapshots['username']);
                          }else{
                            filePicker(context,widget.eventID);
                          }
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(top:30),
                      child: MaterialButton(
                        minWidth: 300,
                        height: 50,
                        color: Colors.teal,
                        child: Text("Submit", style:TextStyle(color: Colors.white, fontSize: 16)),
                        onPressed: (){
                          _uploadFile(file, fileName);
                        },
                      ),
                    ),
                  ),
                ],),
                );
              },
            ),
          ),
    );
  }
}
