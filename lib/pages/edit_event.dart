import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoega/common/fire_storage_service.dart';
import 'package:yoega/pages/upload_image_page.dart';
import 'package:yoega/widgets/DateTimeFieldCustom.dart';
import 'package:yoega/widgets/TextFieldWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEventPage extends StatefulWidget{
  DocumentSnapshot snapshot;
  String eventID;
  EditEventPage({Key key, @required this.eventID, this.snapshot}):super(key:key);
  @override
  _EditEventPageState createState() => new _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {

  TextEditingController eventTitleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController venueController = new TextEditingController();
  TextEditingController maxVolunteerController = new TextEditingController();
  TextEditingController maxParticipantController = new TextEditingController();
  TextEditingController startDateController = new TextEditingController();
  TextEditingController endDateController = new TextEditingController();

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

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    String image = widget.snapshot['eventPic'];
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          //Title should the users Name
          backgroundColor: Colors.teal,
          title: Text("Edit "+ widget.snapshot['title'], style: TextStyle(color: Colors.white),),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
            Navigator.pop(context);
            },
          ),
        ),
    body: new Container(
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
                              child:FutureBuilder(
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
                                              child: ClipOval(
                                                child: snapshot.data,
                                              )
                                          ),
                                        );
                                      }
                                    }
                                    return Container(
                                      width: 140.0,
                                      height: 140.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image:  new DecorationImage(
                                            fit: BoxFit.fill,
                                            image:AssetImage('default_pro_pic.png'),
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
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadImagePage(uploadState: ImageUploadState.eventPic,eventID: widget.eventID,eventSnapshot: widget.snapshot,)));
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
                                    'Event Information',
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
                      TextFieldLabel("Title"),
                      TextFieldForm("Event Title", _status, myFocusNode,controller: eventTitleController,),
                      TextFieldLabel("Description"),
                      TextFieldForm("Write something about the event", _status, myFocusNode,maxLines: 10,controller: descriptionController,),
                      TextFieldLabel("Venue"),
                      TextFieldForm("Enter Venue", _status, myFocusNode,controller: venueController,),
                      TextFieldLabel("Max Volunteer"),
                      TextFieldForm("", _status, myFocusNode,keyboardType: TextInputType.number,controller: maxVolunteerController,),
                      TextFieldLabel("Max Participants"),
                      TextFieldForm("", _status, myFocusNode,keyboardType: TextInputType.number, controller: maxParticipantController,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Container(
                          color: Color(0xfdfdfdff),
                          child:  Column(children: <Widget>[Text("Start Date & Time", style: TextStyle(fontWeight: FontWeight.bold)),BasicDateTimeField(controller: startDateController,),],),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Container(
                          color: Color(0xfdfdfdff),
                          child:  Column(children: <Widget>[Text("End Date & Time", style: TextStyle(fontWeight: FontWeight.bold)),BasicDateTimeField(controller: endDateController,),],),
                        ),
                      ),
                      !_status ? _getActionButtons() : new Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    )

    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
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
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
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
                        FocusScope.of(context).requestFocus(new FocusNode());
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


