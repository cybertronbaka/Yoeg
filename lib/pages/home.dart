
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yoega/common/fire_storage_service.dart';
import 'package:yoega/common/provider.dart';
import 'package:yoega/pages/event_dashboard.dart';
import 'package:yoega/pages/event_register.dart';
import 'package:yoega/pages/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:yoega/models/event.dart';
import 'menu.dart';
//import 'package:yoega/bloc/navigation_bloc/navigation_bloc.dart';

class HomePage extends StatefulWidget{
  String uid;
  HomePage({Key key, this.uid}):super(key:key);
  @override
  _HomePageState createState() => new _HomePageState();
}
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  TabController controller;
  @override
  void initState(){
    super.initState();
    controller = new TabController(length: 5, vsync: this);
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.grey,
      child: DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: Text("Yoega", style: TextStyle(color: Colors.white)),
              bottom: TabBar(
                controller: controller,
                tabs: <Widget>[
                  Tab(child: Icon(Icons.fiber_new, color: Colors.white)),
                  Tab(icon:Icon(Icons.add_box, color: Colors.white)),
                  Tab(icon:Icon(Icons.dashboard, color: Colors.white)),
                  Tab(icon:Icon(Icons.notifications, color: Colors.white)),
                  Tab(icon:Icon(Icons.menu, color: Colors.white)),
                ],
              ),
            ),
            body: new TabBarView(
              controller: controller,
              children: <Widget>[
                HomePageBuild(),
                RegisterEventPage(tabController: controller,),
                EventDashboardPage(),
                NotificationsPage(),
                MenuPage(tabController: controller, uid:widget.uid),
              ]
            )
         )
      )
    )
    );
  }


}

class HomePageBuild extends StatefulWidget {
  @override
  _HomePageBuildState createState()=> new _HomePageBuildState();
}
class _HomePageBuildState extends State<HomePageBuild>{
  Stream<QuerySnapshot> getEventDataStreamSnapshots(BuildContext context) async* {
    yield* Firestore.instance.collection('Events').snapshots();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
        stream: getEventDataStreamSnapshots(context),
        builder: (context, snapshot) {
          print("Snapshothasdata " + snapshot.hasData.toString());
          if (!snapshot.hasData) return Center(
            child: JumpingDotsProgressIndicator(
              fontSize: 40.0,
            ),
          );
          return new ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildCardItem(context, snapshot.data.documents[snapshot.data.documents.length - index - 1])
          );
        }
    );
  }

  Widget buildCardItem(BuildContext context, DocumentSnapshot info){
    print("aaaaaaaaaaaaa");
    print("bbbbbbbbbbbbb");
    var ft = Firestore.instance.collection('Events').document(info.documentID).collection("info").snapshots();
    return StreamBuilder(
        stream: ft,
        builder: (context, snapshot){
          if (!snapshot.hasData) return Center(
            child: JumpingDotsProgressIndicator(
              fontSize: 40.0,
            ),
          );
          return buildCard(context, snapshot.data.documents[0]);
        }
    );
  }

  Future<Widget> _getImage(BuildContext context, String image) async {
    Image m;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.cover,
      );
    });
    return m;
  }

  Widget buildCard(BuildContext context, DocumentSnapshot snapshot) {
    String image = snapshot['eventPic'];
    print("EventPic is "+ image);
    return InkWell(
      child: Card(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
          child:Container(
              height: 350.0,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(backgroundImage: AssetImage('assets/default_pro_pic.png'),),
                    title: Text(snapshot['title']),
                    subtitle: Text(snapshot['startDate'] + " to " + snapshot['endDate']),
                  ),
                  Expanded(
                    child: Container(
                      child: FutureBuilder(
                          future: _getImage(context, image),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                return Container(
                                  child: snapshot.data,
                                );
                              }
                            }
                            return Container(
                              decoration: BoxDecoration(
                                  image:  new DecorationImage(
                                    fit: BoxFit.fill,
                                    image:AssetImage('default_pro_pic.png'),
                                  )
                              ),
                            );
                          }
                      ),
                    ),
                  ),
                  SizedBox(height: 14.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.favorite_border, color: Colors.black,),
                            onPressed: (){
                              //toggle like
                            },),
                          // SizedBox(width: 5.0),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.pan_tool, color: Colors.black,),
                            onPressed: (){
                              //toggle like
                            },),
                          //SizedBox(width: 5.0),
                          Container(
                              width: 85,
                              child: FlatButton(
                                child: Text("Volunteer", style: TextStyle(fontSize: 12,color: Colors.black),),
                                onPressed: (){
                                  //toggle like
                                },
                              )
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.person_pin_circle, color: Colors.black,),
                            onPressed: (){
                              //toggle like
                            },),
                          //SizedBox(width: 5.0),
                          Container(
                              width: 93,
                              child: FlatButton(
                                child: Text("Participate", style: TextStyle(fontSize: 12,color: Colors.black),),
                                onPressed: (){
                                  //toggle like
                                },
                              )
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.comment, color: Colors.black,),
                            onPressed: (){
                              //toggle like
                            },),
                          // SizedBox(width: 5.0),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 14.0),

                ],
              )
          )
      ),onTap: (){},
    );
  }

}
