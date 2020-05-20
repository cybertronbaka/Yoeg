import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ManageEventPage extends StatefulWidget{
  @override
  _ManageEventPageState createState()=> new _ManageEventPageState();
}

class _ManageEventPageState extends State<ManageEventPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
        //Title should the users Name
        backgroundColor: Colors.teal,
        title: Text("Manage (Place Event Title Here)", style: TextStyle(color: Colors.white),),
        leading:  IconButton(
          icon:  Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Text("Graphs", style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
          ),
          Center(
            child: Text("Comments", style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
          ),
          Center(
            child: Text("Likes", style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
          ),
          Center(
            child: Text("Participants", style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
          ),
          Center(
            child: Text("Volunteers", style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
          ),
          Center(
            child: Text("Lists", style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }
}