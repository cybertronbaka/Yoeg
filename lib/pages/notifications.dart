import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yoega/pages/checkConnection.dart';
import 'package:yoega/utilities/CircularImage.dart';

//import 'package:yoega/bloc/navigation_bloc/navigation_bloc.dart';

class NotificationsPage extends StatefulWidget{
  @override
  _NotificationsPageState createState()=> new _NotificationsPageState();
}
class _NotificationsPageState extends State<NotificationsPage> {
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
    return  connected?ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index)=>Notification(),
    ):NoInternetConnection();
  }
}

class Notification extends StatelessWidget {
  const Notification({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(

        child:ListTile(
          contentPadding: EdgeInsets.fromLTRB(30,10,30,10),
          leading: CircularImage(AssetImage('assets/logo.png'), width: 40, margin_top: 10,),
          title: Text("Notification Title", style: TextStyle(color: Colors.black54),),
          subtitle: Text("Notification Details"),
          onTap: (){
            //mark as read
            //reduce notifications count
            //go to the events page and read
          },
          onLongPress: (){
            // can be deleted
            // can be marked as unread
          },
        )
    );
  }
}