import 'package:flutter/material.dart';
import 'package:yoega/utilities/CircularImage.dart';

//import 'package:yoega/bloc/navigation_bloc/navigation_bloc.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index)=>Notification(),
    );
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