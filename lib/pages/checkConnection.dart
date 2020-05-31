import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Connection{
  bool connected = false;
  bool isConnected(BuildContext context){
    setConnectionStatus(context);
    return connected;
  }
   Future<void> setConnectionStatus(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connected = true;
      }
    } on SocketException catch (_) {

    }
  }
  void checkConnection(BuildContext context){
    if(!isConnected(context)){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NoInternetConnection()));
    }
  }

}
class NoInternetConnection extends StatefulWidget{
  @override
  _NoInternetConnectionState createState()=> new _NoInternetConnectionState();
}
class _NoInternetConnectionState extends State<NoInternetConnection>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Container(
        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Center(child:AutoSizeText("No internet Connection. Please Make sure you are connected and restart the application.", style:TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 23),)),
      ),
    );
  }

}