import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yoega/common/AuthService.dart';
import 'package:yoega/common/menu_item.dart';
import 'package:yoega/common/provider.dart';
import 'package:yoega/pages/about_us.dart';
import 'package:yoega/pages/checkConnection.dart';
import 'package:yoega/pages/general_user_page.dart';
import 'package:yoega/pages/home.dart';
import 'package:yoega/pages/login.dart';
import 'package:yoega/pages/notification_settings.dart';
import 'package:yoega/pages/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'event_dashboard.dart';

//import 'package:yoega/bloc/navigation_bloc/navigation_bloc.dart';
class MenuPage extends StatefulWidget{
  final String uid;
  final TabController tabController;
  MenuPage({Key key, this.tabController, this.uid}):super(key:key);
  @override
  _MenuPageState createState() => new _MenuPageState();
}


class _MenuPageState extends State<MenuPage> {
  Stream<QuerySnapshot> getUsersInfoStreamSnapshots(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection('UserData').document(uid).collection('info').snapshots();
  }
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

    return connected?Container(
      child: StreamBuilder(
          stream: getUsersInfoStreamSnapshots(context),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return Center(child:  JumpingDotsProgressIndicator(
              fontSize: 40.0,
            ),);
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) =>
                    buildMenu(context, snapshot.data.documents[index]));
          }
      ),
    ):NoInternetConnection();
  }
  Widget buildMenu(BuildContext context, DocumentSnapshot info) {
    return Center(
        child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.white70,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        title: Text(
                          info['username'],
                          style: TextStyle(color: Colors.black54, fontSize: 22, fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          info['name'],
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.perm_identity, //Get image of the user
                            color: Colors.black54,
                          ),
                          radius: 40,
                          //make this tapable
                        ),
                      ),
                      Divider(
                        height: 30,
                        thickness: 0.5,
                        color: Colors.black54.withOpacity(0.3),
                        indent: 32,
                        endIndent: 32,
                      ),

                      MenuItem(
                        icon: Icons.person,
                        title: "User Profile",
                        fontSize: 18,
                        boxSize: 20,
                        iconSize: 25,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => GeneralUserView()));
                        },
                      ),

                      // Make this available only if user is hosting an event
                      MenuItem(
                        icon: Icons.dashboard,
                        title: "Dashboard",
                        fontSize: 18,
                        boxSize: 20,
                        iconSize: 25,
                        onTap: () {
                          widget.tabController.animateTo(2);
                        },
                      ),
                      MenuItem(
                        icon: Icons.add_box,
                        title: "Register an Event",
                        fontSize: 18,
                        boxSize: 20,
                        iconSize: 25,
                        onTap: () {
                          widget.tabController.animateTo(1);
                        },
                      ),
                      Divider(
                        height: 30,
                        thickness: 0.5,
                        color: Colors.black54.withOpacity(0.3),
                        indent: 32,
                        endIndent: 32,
                      ),
                      MenuItem(
                        icon: Icons.important_devices,
                        title: "About Us",
                        fontSize: 18,
                        boxSize: 20,
                        iconSize: 25,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AboutUsPage()));
                        },
                      ),
                      MenuItem(
                        icon: Icons.settings,
                        title: "Notification Settings",
                        fontSize: 18,
                        boxSize: 20,
                        iconSize: 25,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationSettingsPage()));
                        },
                      ),
                      MenuItem(
                        icon: Icons.exit_to_app,
                        title: "Logout",
                        fontSize: 18,
                        boxSize: 20,
                        iconSize: 25,
                        onTap: () async {
                          try{
                            AuthService auth = Provider.of(context).auth;
                            await auth.signOut();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                          }catch(e){
                            print(e);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            ]
        )
    );
  }
}
