import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yoega/common/provider.dart';
import 'package:yoega/utilities/CircularImage.dart';
import 'package:yoega/widgets/DateTimeFieldCustom.dart';
import 'package:yoega/widgets/StretchedButton.dart';
import 'package:yoega/widgets/StretchedLabel.dart';
import 'package:yoega/widgets/TextFieldWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yoega/models/event.dart';
//import 'package:yoega/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'checkConnection.dart';



/// please add Image upload ///


class RegisterEventPage extends StatefulWidget{
  final TabController tabController;
  RegisterEventPage({Key key, @required this.tabController}):super(key:key);
  @override
  _RegisterEventPageState createState()=> new _RegisterEventPageState();
}
// ignore: must_be_immutable
class _RegisterEventPageState extends State<RegisterEventPage> {
  //controllers
  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController venueController = new TextEditingController();
  TextEditingController maxVolunteerController = new TextEditingController();
  TextEditingController maxParticipantController = new TextEditingController();
  TextEditingController startDateController = new TextEditingController();
  TextEditingController endDateController = new TextEditingController();


  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  final timeFormat = DateFormat("h:mm a");
  DateTime date;
  TimeOfDay time;
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
    return connected?Scaffold(
      body:Center(
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xfdfdfdff),
            ),
            child: Padding(
              padding: EdgeInsets.all(23),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      color: Color(0xfdfdfdff),
                      child: Text("Register an Event", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      color: Color(0xfdfdfdff),
                      child: TextFieldWidget("Event Title",TextInputType.text, Icon(null), controller: titleController,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      color: Color(0xfdfdfdff),
                      child: TextFieldWidget("Event Description",TextInputType.text, Icon(null), controller: descriptionController,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      color: Color(0xfdfdfdff),
                      child: TextFieldWidget("Venue",TextInputType.text, Icon(null), controller: venueController,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      color: Color(0xfdfdfdff),
                      child: TextFieldWidget("Max Volunteer",TextInputType.number, Icon(null), controller: maxVolunteerController,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      color: Color(0xfdfdfdff),
                      child: TextFieldWidget("Max Participant",TextInputType.number, Icon(null),controller: maxParticipantController,),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      color: Color(0xfdfdfdff),
                      child:  Column(children: <Widget>[Text("Start Date & Time"),BasicDateTimeField(controller: startDateController,),],),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Container(
                      color: Color(0xfdfdfdff),
                      child:  Column(children: <Widget>[Text("End Date & Time"),BasicDateTimeField(controller: endDateController,),],),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: StretchedButton(label:"Register Event",color: Colors.teal,onPressed: (){
                        registerEvent(context);
                      },)
                  ),
                ],
              ),
            ),
          ),
      ),
    ):NoInternetConnection();
  }

  Future registerEvent(BuildContext context) async{
    var uid = await Provider.of(context).auth.getCurrentUID();
    Event event = Event(titleController.text, descriptionController.text,venueController.text, maxVolunteerController.text, maxParticipantController.text, startDateController.text, endDateController.text,uid,DateTime.now().toString());
    var ref = Firestore.instance.collection('Events').document();
    ref.setData({"Here": "true"});
    ref.collection("info").document("info").setData(event.toJson());
    ref.collection("likes").document("count").setData({"count":0});
    ref.collection("participants").document("count").setData({"count":0});
    ref.collection("volunteers").document("count").setData({"count":0});
    ref.collection("participantsRequest").document("count").setData({"count":0});
    ref.collection("volunteerRequest").document("count").setData({"count":0});
    ref.collection("comments").document("count").setData({"count":0});
    ref.collection("participantsRequest").document("count").setData({"count":0});
    widget.tabController.animateTo(2);
  }
}
