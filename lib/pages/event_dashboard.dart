import 'package:flutter/material.dart';
import 'package:yoega/common/fire_storage_service.dart';
import 'package:yoega/common/provider.dart';
import 'package:yoega/pages/edit_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_indicators/progress_indicators.dart';

import 'manage_event.dart';
//import 'package:yoega/bloc/navigation_bloc/navigation_bloc.dart';

class EventDashboardPage extends StatefulWidget {
  @override
  _EventDashboardPageState createState() => new _EventDashboardPageState();
}
class _EventDashboardPageState extends State<EventDashboardPage>{
  Stream<QuerySnapshot> getEventsOrganized(BuildContext context, DocumentSnapshot snapshot) async* {
    String uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection("Events").document(snapshot.documentID).collection("info").where("organizerUID", isEqualTo: uid).snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
    stream: Firestore.instance.collection('Events').snapshots(),
    builder: (context, snapshot) {
      if(!snapshot.hasData) return Center(
        child: JumpingDotsProgressIndicator(
          fontSize: 40.0,
        ),
      );
      return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (BuildContext context, int index)
           {
             if(!snapshot.hasData) {
               return Container();
             }
             if(snapshot != null) {
                var q = getEventsOrganized(context, snapshot.data.documents[index]);
                if (q != null) {
               return StreamBuilder(
                   stream: q,
                   builder: (context, snap) {
                     if (!snap.hasData) {
                       return Container();
                     }
                      if(snap != null) {
                        if (snap.data.documents.length != 0) {
                          print("Xyzworks" + snap.data.documents[0]['title']);
                          return CardItem(snapshot: snap.data.documents[0],
                            eventID: snapshot.data.documents[index]
                                .documentID,);
                        }
                      }
                     return Container();
                   }
               );
             }
           }
              return Container();
            }
        );
    }
    );
  }
}

class CardItem extends StatefulWidget {
  DocumentSnapshot snapshot;
  String eventID;
  CardItem({
    Key key, @required this.snapshot, this.eventID
  }) : super(key: key);
  _CardItemState createState()=> new _CardItemState();
}
class _CardItemState extends State<CardItem>{
  String propic;
  bool init = true;
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

  Future<Widget> _getImagePropic(BuildContext context, String image) async {
    Image m;
    await FireStorageService.loadFromStorage(context, image)
        .then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        height: 50,
        width: 50,
        fit: BoxFit.cover,
      );
    });
    return m;
  }

  void getPropic(BuildContext context)async{
    String uid = await Provider.of(context).auth.getCurrentUID();
    Firestore.instance.collection("UserData").document(widget.snapshot['organizerUID']).collection("info").getDocuments().then((query){
      query.documents.forEach((f){
        setState(() {
          propic = f['propic'];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(init) {
      getPropic(context);
      init = false;
    }
    print("Event ID in Event dashboard " + widget.eventID);
    String image = widget.snapshot['eventPic'];
    return InkWell(
      child: Card(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
          child:Container(
              height: 350.0,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: Container(
                  height:50,
                  width:50,
                  child:FutureBuilder(
                      future: _getImagePropic(context, propic),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: Colors.teal,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                  radius:50,
                                  child: ClipOval(
                                    child: snapshot.data,
                                  )
                              ),
                            );
                          }
                        }
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: Colors.teal,
                              ),
                            shape: BoxShape.circle,
                              image:  new DecorationImage(
                                fit: BoxFit.fill,
                                image:AssetImage('assets/default_pro_pic.png'),
                              )
                          ),
                        );
                      }
                  )),
                    title: Text(widget.snapshot['title']),
                    subtitle: Text(widget.snapshot['startDate'] + " to " + widget.snapshot['endDate']),
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
                            icon: Icon(Icons.edit, color: Colors.black,),
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditEventPage(eventID: widget.eventID,snapshot: widget.snapshot)));
                            },
                          ),
                          SizedBox(width: 5.0),
                          FlatButton(
                            child:Text("Edit Info", style: TextStyle(color: Colors.black)),
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditEventPage(eventID: widget.eventID,snapshot: widget.snapshot,)));
                            },
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.settings, color: Colors.black,),
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManageEventPage()));
                            },
                          ),
                          SizedBox(width: 5.0),
                          FlatButton(
                            child:Text("Manage", style: TextStyle(color: Colors.black)),
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManageEventPage()));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 14.0),

                ],
              )
          )
      ),onTap: (){
        //make this dynamic


    },
    );
  }
}