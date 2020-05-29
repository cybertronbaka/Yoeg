import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yoega/common/fire_storage_service.dart';
import 'package:yoega/common/provider.dart';
import 'package:file_picker/file_picker.dart';


enum VolunteerParticipate{
  volunteer, participate
}


class VolunteerParticipatePage extends StatefulWidget{
  String eventID;
  DocumentSnapshot snapshot;
  VolunteerParticipate volunteerParticipate;

  VolunteerParticipatePage({Key key, this.eventID, this.snapshot, this.volunteerParticipate}):super(key:key);
  @override
  _VolunteerParticipatePage createState()=> new _VolunteerParticipatePage();
}

class _VolunteerParticipatePage extends State<VolunteerParticipatePage>{
  bool submitted = false, uploading = false;
  File file;
  String alreadyUploadedForm = "";
  String filename;
  bool downloading=false;
  String progress = "";
  bool downloadComplete = false;

  String uploadProgress = "";
  void downloadFile(String filename) async{
    var dio = Dio();
    var dir = await ExtStorage.getExternalStorageDirectory();
      if (await Permission.storage
          .request()
          .isGranted) {
        FirebaseStorage storage = FirebaseStorage.instance;
        StorageReference storageRef = storage.ref();
        var islandRef = storageRef.child(filename);
        var knockDir =
        await new Directory('${dir}/Yeoga').create(recursive: true);
        knockDir.create();
        final String url = await islandRef.getDownloadURL();
        await dio.download(url, '${knockDir.path}/'+filename,
            options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),  // disable gzip
            onReceiveProgress: (received, total) {
              if(total != -1) {
                setState(() {
                  downloading = true;
                  progress ="Downloaded " + ((received / total * 100).toStringAsFixed(0) + "%");
                  downloadComplete = false;
                });
              }
            });
        setState(() {
          downloading = false;
          downloadComplete = true;
          progress = "";
        });
        print("Download completed");
        print("File Path: " + knockDir.path);
        Fluttertoast.showToast(
            msg: "Downloaded in " + knockDir.path,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        print(url);
      }
  }
  void init()async{
    if(widget.volunteerParticipate == VolunteerParticipate.participate) {
      Firestore.instance.collection("Events").document(widget.eventID)
          .collection("participantsRequest").where(
          "userID", isEqualTo: await Provider
          .of(context)
          .auth
          .getCurrentUID()).getDocuments()
          .then((query) {
        query.documents.forEach((f) {
          setState(() {
            submitted = true;
            alreadyUploadedForm = f['pdfURL'];
          });
        });
      });
    }else{
      Firestore.instance.collection("Events").document(widget.eventID)
          .collection("volunteerRequest").where(
          "userID", isEqualTo: await Provider
          .of(context)
          .auth
          .getCurrentUID()).getDocuments()
          .then((query) {
        query.documents.forEach((f) {
          setState(() {
            alreadyUploadedForm = f['pdfURL'];
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          //Title should theimport 'package:path_provider/path_provider.dart'; users Name
          backgroundColor: Colors.teal,
          title: Text(widget.volunteerParticipate == VolunteerParticipate.participate?"Participate":"Volunteer", style: TextStyle(color: Colors.white),),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:Container(
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image(image:AssetImage("assets/pdf.png"), height: 70, width: 70,),
                  Container(width: MediaQuery.of(context).size.width/1.25, margin: EdgeInsets.only(right: 10),child: AutoSizeText(widget.volunteerParticipate == VolunteerParticipate.volunteer?widget.snapshot['volunteerPDF'].toString():widget.snapshot['participationPDF'].toString(), style: TextStyle(fontWeight: FontWeight.bold),))
                ],
              ),
              downloading?Text(progress, style: TextStyle(color: Colors.tealAccent),):Container(),
              Container(width: MediaQuery.of(context).size.width/1.3, child: MaterialButton(child:Text("Download Form",  style: TextStyle(color: Colors.white),),color: !downloadComplete?Colors.teal:Colors.black12, onPressed: (){
                if(!downloadComplete) {
                  if (widget.volunteerParticipate == VolunteerParticipate.participate) {
                    downloadFile(widget.snapshot['participationPDF']);
                  } else {
                    downloadFile(widget.snapshot['volunteerPDF']);
                  }
                }
              }),),
              widget.volunteerParticipate == VolunteerParticipate.participate?
              Text("Upload Participation Form", style: TextStyle(fontWeight: FontWeight.bold),):
              widget.volunteerParticipate == VolunteerParticipate.volunteer?
              Text("Upload Volunteer Form", style: TextStyle(fontWeight: FontWeight.bold),):Container(),
              file==null?Container(
                child: widget.volunteerParticipate==VolunteerParticipate.participate?
                (alreadyUploadedForm.length!=0?Row(
                    children: <Widget>[
                      Image(image:AssetImage("assets/pdf.png"), height: 70, width: 70,),
                      Container(width: MediaQuery.of(context).size.width/1.25, margin:  EdgeInsets.only(right: 10),child: AutoSizeText(alreadyUploadedForm, style: TextStyle(fontWeight: FontWeight.bold),))
                    ]):Container())
                    :(widget.volunteerParticipate == VolunteerParticipate.volunteer?(alreadyUploadedForm!=null?Row(
                    children: <Widget>[
                      Image(image:AssetImage("assets/pdf.png"), height: 70, width: 70,),
                      Container(width: MediaQuery.of(context).size.width/1.25, margin: EdgeInsets.only(right: 10),child: AutoSizeText(alreadyUploadedForm, style: TextStyle(fontWeight: FontWeight.bold),))
                    ]
                ):Container()):Container()),
              ):Container(
                  child:Row(
                    children: <Widget>[
                      Image(image:AssetImage("assets/pdf.png"), height: 70, width: 70,),
                      Container(width: MediaQuery.of(context).size.width/1.25, margin: EdgeInsets.only(right: 10),child: AutoSizeText(filename.split("/")[3], style: TextStyle(fontWeight: FontWeight.bold),)),
                    ],)
              ),
              uploading?Text(uploadProgress, style: TextStyle(color: Colors.tealAccent),):Container(),
              file==null?Container(
                width: 50,
                child: MaterialButton(
                  child: Text("Select",style: TextStyle(color:Colors.white)),
                  color: Colors.teal,
                  onPressed: (){
                    filePicker(context, widget.eventID,widget.volunteerParticipate);
                  },
                ),
              ):Container(
                width: 50,
                child: MaterialButton(
                  child: Text("Upload",style: TextStyle(color:Colors.white)),
                  color: (submitted == null || !submitted)&&!uploading?Colors.teal:Colors.black12,
                  onPressed: (){
                    if((submitted == null || !submitted)&&!uploading) {
                      setState(() {
                        uploading = true;
                      });
                      _uploadFile(file, filename);
                    }
                  },
                ),
              ),
              submitted != null && submitted || alreadyUploadedForm.length!= 0?Container(
                width: 50,
                child: MaterialButton(
                  child: Container(child:Row(children: <Widget>[ Icon(Icons.delete, color: Colors.white,),Text("Cancel request", style: TextStyle(color:Colors.white),), ],)),
                  color: Colors.redAccent,
                  onPressed: (){
                    cancelRequest();
                  },
                ),
              ):Container(),
            ],
          ),
        ),
    );
  }

  void cancelRequest()async{
    String uid = await Provider.of(context).auth.getCurrentUID();
    if(widget.volunteerParticipate == VolunteerParticipate.participate) {
      Firestore.instance.collection('Events').document(widget.eventID).collection(
          "participantsRequest").where("userID", isEqualTo: uid).getDocuments().then((q){
            q.documents.forEach((f){
              Firestore.instance.collection("Events").document(widget.eventID).collection("participantsRequest").document(f.documentID).delete();
            });
      });
    }else{
      //////TO-DO
      Firestore.instance.collection('Events').document(widget.eventID).collection(
          "volunteerRequest").where("userID", isEqualTo: uid).getDocuments().then((q){
        q.documents.forEach((f){
          Firestore.instance.collection("Events").document(widget.eventID).collection("volunteerRequest").document(f.documentID).delete();
        });
      });
    }
  }
  Future<void> _uploadFile(File file, String filename) async {
    print("File is "+ filename);
    StorageReference pathReference;
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference storageRef = await storage.getReferenceFromUrl("gs://yoega-6dc83.appspot.com");
    pathReference = storageRef.child(filename);
    String uid = await Provider.of(context).auth.getCurrentUID();

    try {
      final StorageUploadTask uploadTask = pathReference.putFile(file);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);

      final String url = (await downloadUrl.ref.getDownloadURL());
      if(widget.volunteerParticipate == VolunteerParticipate.participate) {
        if(alreadyUploadedForm.length != 0) {
          Firestore.instance.collection("Events").document(widget.eventID)
              .collection("participantsRequest").where("userID", isEqualTo: uid)
              .getDocuments().then((q){
             q.documents.forEach((f){
               Firestore.instance.collection("Events").document(widget.eventID).collection("participantsRequest").document(f.documentID).setData({'userID': uid, 'method': "PDF", "requestDate": DateTime.now().toString(), "AcceptedRejected" :"none", "pdfURL": filename});
             });
          });
        }else{
          Firestore.instance.collection('Events').document(widget.eventID).collection(
              "participantsRequest").add({'userID': uid, 'method': "PDF", "requestDate": DateTime.now().toString(), "AcceptedRejected" :"none", "pdfURL": filename});
        }
      }else{
        if(alreadyUploadedForm.length != 0) {
          Firestore.instance.collection("Events").document(widget.eventID)
              .collection("volunteerRequest").where("userID", isEqualTo: uid)
              .getDocuments().then((q){
            q.documents.forEach((f){
              Firestore.instance.collection("Events").document(widget.eventID).collection("volunteerRequest").document(f.documentID).setData({'userID': uid, 'method': "PDF", "requestDate": DateTime.now().toString(), "AcceptedRejected" :"none", "pdfURL": filename});
            });
          });
        }else{
          Firestore.instance.collection('Events').document(widget.eventID).collection(
              "volunteerRequest").add({'userID': uid, 'method': "PDF", "requestDate": DateTime.now().toString(), "AcceptedRejected" :"none", "pdfURL": filename});
        }
      }
      Fluttertoast.showToast(
          msg: "Form Submitted. Request Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
         submitted = true;
         uploading = false;
      });
    }catch (e){
      print(e);
    }
  }


  Future filePicker(BuildContext context,String eventID, VolunteerParticipate volunteerParticipate) async {
    String uid = await Provider.of(context).auth.getCurrentUID();
    try {
        file = await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: "pdf");
      setState(() {
        //TODO
        if(widget.volunteerParticipate == VolunteerParticipate.participate) {
          filename = "Events/" + eventID + "/ParticipatationRequest/"+uid+eventID+p.basename(file.path);
        }
        if(widget.volunteerParticipate == VolunteerParticipate.volunteer) {
          filename = "Events/" + eventID + "/VolunteerRequest/"+uid+eventID+p.basename(file.path);
        }
      });
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
}