import 'package:flutter/material.dart';
import 'package:yoega/pages/edit_event.dart';

import 'manage_event.dart';
//import 'package:yoega/bloc/navigation_bloc/navigation_bloc.dart';

class EventDashboardPage extends StatefulWidget {
  @override
  _EventDashboardPageState createState() => new _EventDashboardPageState();
}
class _EventDashboardPageState extends State<EventDashboardPage>{
  @override
  Widget build(BuildContext context) {
     return ListView.builder(
       itemCount: 1,
       itemBuilder: (context, index)=>CardItem(),
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    title: Text("Event Title"),
                    subtitle: Text("Date"),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage("https://cdn.arstechnica.net/wp-content/uploads/2013/05/donate_blood_rotator.jpg"),
                            fit: BoxFit.cover,
                          )
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
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditEventPage()));
                            },
                          ),
                          SizedBox(width: 5.0),
                          FlatButton(
                            child:Text("Edit Info", style: TextStyle(color: Colors.black)),
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditEventPage()));
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