import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//import 'package:yoega/bloc/navigation_bloc/navigation_bloc.dart';

class NotificationSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //Title should the users Name
        backgroundColor: Colors.teal,
        title: Text("Notification Settings", style: TextStyle(color: Colors.white),),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:Container(
            child: ListView(children: <Widget>[
              SwitchWidget("Allow Notifications",activeText: "Notifications allowed",inactiveText: "Notifications not allowed",),
              SwitchWidget("Allow Reminders",activeText: "Reminders allowed",inactiveText: "Reminders not allowed",)

            ],)

            ),
    );
  }
}

// ignore: must_be_immutable
class SwitchWidget extends StatefulWidget {
  String activeText, inactiveText,text;
  SwitchWidget(this.text,{this.activeText, this.inactiveText});
  @override
  _SwitchWidgetState createState() => new _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget>{
  bool switchControl = false;
  var textHolder = '';
  void toggleSwitch(bool value) {

    if(switchControl == false)
    {
      setState(() {
        switchControl = true;
        textHolder = widget.activeText;
      });
      // Put your code here which you want to execute on Switch ON event.

    }
    else
    {
      setState(() {
        switchControl = false;
        textHolder = widget.inactiveText;
      });
      // Put your code here which you want to execute on Switch OFF event.

    }
    Fluttertoast.showToast(
        msg: textHolder,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child:Row(children: <Widget>[
        Column(children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(30, 20, 10, 0),
            child: FlatButton(
              child:Text(widget.text, style: TextStyle(fontSize: 17),),
              onPressed:(){
                toggleSwitch(true);
              },
            ),
          ),
          SizedBox(height: 20,),
        ],),

        Spacer(),
        Column(
          children:[ Transform.scale(
          scale: 1.3,
          child: Switch(
            onChanged: toggleSwitch,
            value: switchControl,
            activeColor: Colors.teal,
            activeTrackColor: Colors.tealAccent,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey,
            )
          ),
        ]),
      ],),
    );
  }


}