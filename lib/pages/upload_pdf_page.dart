import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoega/pages/checkConnection.dart';

import 'login.dart';

enum UploadPDFFor{
  participation, volunteer
}

// ignore: must_be_immutable
class UploadPDFPage extends StatefulWidget{
  String eventID;
  DocumentSnapshot snapshot;
  bool partipationPDFproc;
  bool volunteerPDFproc;
  UploadPDFPage({Key key, this.partipationPDFproc, this.volunteerPDFproc, this.snapshot, this.eventID}):super(key:key);

  @override
  _UploadPDFPageState createState()=> new _UploadPDFPageState();

}
class _UploadPDFPageState extends State<UploadPDFPage>{
  File fileP, fileV;
  String fileNameP = '', fileNameV = "";
  bool participationPDFUploaded = false, volunteerPDFUploaded = false;
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

  Future filePicker(BuildContext context,String eventID, UploadPDFFor uploadPDFFor) async {
    try {
      if(uploadPDFFor == UploadPDFFor.participation) {
        fileP = await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: "pdf");
      }else{
        fileV = await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: "pdf");

      }
        setState(() {
          //TODO
          if(uploadPDFFor == UploadPDFFor.participation) {
            fileNameP = "Events/" + eventID + "/ParticipationForm/"+eventID+p.basename(fileP.path);
          }
          if(uploadPDFFor == UploadPDFFor.volunteer) {
            fileNameV = "Events/" + eventID + "/VolunteerForm/"+eventID+p.basename(fileV.path);
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
  Widget showVolunteerUploadDoneToast(){
    Fluttertoast.showToast(
        msg: "Volunteer Form Uploaded",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
    return Container();
  }

  Widget showParticipationUploadDoneToast(){
    Fluttertoast.showToast(
        msg: "Participation Form Uploaded",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
    return Container();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return connected?Scaffold(
        appBar: AppBar(
        //Title should the users Name
        backgroundColor: Colors.teal,
        title: Text("Upload PDF", style: TextStyle(color: Colors.white),),
    leading: new IconButton(
    icon: new Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () {
      Navigator.pop(context);
    },
    ),
    ),
    body:Container(
      child:ListView(
      children: <Widget>[
        widget.partipationPDFproc==true?buildPDFUploadWidget(context, UploadPDFFor.participation):Container(),
        widget.volunteerPDFproc==true?buildPDFUploadWidget(context, UploadPDFFor.volunteer):Container(),
      //buildParticipatePDFUploadWidget(context),
        //buildVolunteerPDFUploadWidget(),
        participationPDFUploaded||widget.snapshot["participatePDF"]!=null?Container(
          width: 50,
          child: MaterialButton(
            child: Text("Next"),
            color: Colors.teal,
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeController()));
            },
          ),
        ):volunteerPDFUploaded||widget.snapshot["volunteerPDF"]!=null?Container(
          width: 50,
          child: MaterialButton(
            child: Text("Next"),
            color: Colors.teal,
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeController()));
            },
          ),
        ):Container(),

        participationPDFUploaded?Container(child:showParticipationUploadDoneToast()):Container(),
        volunteerPDFUploaded?Container(child:showVolunteerUploadDoneToast()):Container(),
      ],
    ),
    )
    ):NoInternetConnection();
  }
  Widget buildPDFUploadWidget(BuildContext context, UploadPDFFor uploadPDFFor){
    File file = uploadPDFFor == UploadPDFFor.participation?fileP:fileV;
    String fileName = uploadPDFFor == UploadPDFFor.participation?fileNameP:fileNameV;
      return Container(
        child:ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            uploadPDFFor == UploadPDFFor.participation?
            Text("Participation PDF"):
            uploadPDFFor == UploadPDFFor.volunteer?
            Text("Volunteer PDF"):Container(),
            file==null?Container(
              child: uploadPDFFor==UploadPDFFor.participation?
              (widget.snapshot['participationPDF']!=null?Row(
                          children: <Widget>[
                            Image(image:AssetImage("assets/pdf.png"), height: 70, width: 70,),
                            Container(width: MediaQuery.of(context).size.width/1.25, margin:  EdgeInsets.only(right: 10),child: AutoSizeText(widget.snapshot['participationPDF'].toString(), style: TextStyle(fontWeight: FontWeight.bold),))
                          ]):Container())
                  :(uploadPDFFor == UploadPDFFor.volunteer?(widget.snapshot['volunteerPDF']!=null?Row(
    children: <Widget>[
    Image(image:AssetImage("assets/pdf.png"), height: 70, width: 70,),
      Container(width: MediaQuery.of(context).size.width/1.25, margin: EdgeInsets.only(right: 10),child: AutoSizeText(widget.snapshot['volunteerPDF'].toString(), style: TextStyle(fontWeight: FontWeight.bold),))
    ]
              ):Container()):Container()),
            ):Container(
                child:Row(
                  children: <Widget>[
                    Image(image:AssetImage("assets/pdf.png"), height: 70, width: 70,),
                    Container(width: MediaQuery.of(context).size.width/1.25, margin: EdgeInsets.only(right: 10),child: AutoSizeText(fileName.split("/")[1], style: TextStyle(fontWeight: FontWeight.bold),)),
                  ],)
            ),
            file==null?Container(
              width: 50,
              child: MaterialButton(
                child: Text("Select"),
                color: Colors.teal,
                onPressed: (){
                  filePicker(context, widget.eventID,uploadPDFFor);
                },
              ),
            ):Container(
              width: 50,
              child: MaterialButton(
                child: Text("Upload"),
                color: Colors.teal,
                onPressed: (){
                  _uploadFile(file, fileName, uploadPDFFor);
                },
              ),
            ),
          ],
        ),
      );
  }

    Future<void> _uploadFile(File file, String filename, UploadPDFFor uploadPDFFor) async {
      print("File is "+ filename);
      StorageReference pathReference;
      FirebaseStorage storage = FirebaseStorage.instance;
      StorageReference storageRef = await storage.getReferenceFromUrl("gs://yoega-6dc83.appspot.com");
      pathReference = storageRef.child(filename);

      try {
        final StorageUploadTask uploadTask = pathReference.putFile(file);
        final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
        final String url = (await downloadUrl.ref.getDownloadURL());
        if(uploadPDFFor == UploadPDFFor.participation) {
          Firestore.instance.collection('Events').document(widget.eventID).collection(
              "info").getDocuments()
              .then((querySnapshot) {
            querySnapshot.documents.forEach((documentSnapshot) {
              documentSnapshot.reference.updateData({'participationPDF': fileNameP});
              setState(() {
                participationPDFUploaded = true;
              });
              Firestore.instance.collection('Events').document(widget.eventID)
                    .collection("info").document("info")
                    .updateData({'participateProc': "PDF"});
            });
          });
        }else{
          //////TO-DO
          Firestore.instance.collection('Events').document(widget.eventID).collection(
              "info").getDocuments()
              .then((querySnapshot) {
            querySnapshot.documents.forEach((documentSnapshot) {
              documentSnapshot.reference.updateData({'volunteerPDF': fileNameV});
              setState(() {
                volunteerPDFUploaded = true;
              });
            });
          });
          Firestore.instance.collection('Events').document(widget.eventID)
              .collection("info").document("info")
              .updateData({'volunteerProc': "PDF"});
        }
        print("URL is $url");
      }catch (e){
        print(e.message);
      }
    }

  }
