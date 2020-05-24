import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yoega/common/fire_storage_service.dart';
import 'package:yoega/common/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:progress_indicators/progress_indicators.dart';


class CommentPage extends StatefulWidget{
  DocumentSnapshot snapshot;
  String eventID;
  CommentPage({Key key, @required this.eventID, this.snapshot}):super(key:key);
  @override
  _CommentPageState createState()=> new _CommentPageState();
}

Future<Widget> _getImage(BuildContext context, String image) async {
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

class _CommentPageState extends State<CommentPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
        //Title should the users Name
        backgroundColor: Colors.teal,
        title: Text("Comment on "+ widget.snapshot['title'], style: TextStyle(color: Colors.white),),
    leading: new IconButton(
    icon: new Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () {
    Navigator.pop(context);
    },
    ),
    ),
    body: new Container(
    color: Colors.white,
        child:ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            DescriptionCard(snapshot: widget.snapshot,eventID: widget.eventID,),
            buildComments(context),
          ],
        ),
      ),
      bottomSheet: Container(height:63,child: AddCommentCard(eventID: widget.eventID, snapshot: widget.snapshot,),),
    );
  }
  Widget buildComments(BuildContext context){

    return Container(child:StreamBuilder(
      stream: Firestore.instance.collection("Events").document(widget.eventID).collection("comments").orderBy("postDate").snapshots(),
      builder: (context, snap){
        if (!snap.hasData) return Center(
          child: JumpingDotsProgressIndicator(
            fontSize: 40.0,
          ),
        );
        if(snap!=null) {
          return new ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snap.data.documents.length,
              itemBuilder: (context, index) {
                if(snap.data.documents[index]!=null) {
                  return CommentCard(
                    eventSnapshot: widget.snapshot,
                    commentSnapshot: snap.data.documents[index],
                    eventID: widget.eventID,);
                }
                return Container();
              }
          );
        }
        return Container();
      },
    ));
  }
}

class DescriptionCard extends StatefulWidget {
  DocumentSnapshot snapshot;
  String eventID;
  DescriptionCard({Key key, this.snapshot, this.eventID}):super(key:key);
  @override
  _DescriptionCardState createState() => new _DescriptionCardState();
}
class _DescriptionCardState extends State<DescriptionCard> {
  bool init = true;
  String propic;
  String username;
  void getPropic(BuildContext context) async {
    Firestore.instance.collection("UserData").document(
        widget.snapshot['organizerUID']).collection("info")
        .getDocuments()
        .then((query) {
      query.documents.forEach((f) {
        setState(() {
          propic = f['propic'];
          username = f['username'];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(init){
      getPropic(context);
      init = false;
    }
    String description = widget.snapshot['description'];
    return InkWell(
        child: Card(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
            child: Container(
              height:100,
                color: Colors.white,
                child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Container(
                            height: 50,
                            width: 50,
                            child: FutureBuilder(
                                future: _getImage(context, propic),
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
                        title:Text(username==null?"":username,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        subtitle: Column(children: <Widget>[
                          AutoSizeText(
                              (description==null?"":description),
                              style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.left,
                            maxLines: 1000,
                          ),
                          Text(widget.snapshot['postDate']==null?"":widget.snapshot['postDate'], textAlign: TextAlign.left,),
                        ],),
                      )
                    ]
                )
            )
        )
    );
  }
}

class CommentCard extends StatefulWidget{
  DocumentSnapshot eventSnapshot;
  DocumentSnapshot commentSnapshot;
  String eventID;
  CommentCard({Key key, @required this.eventID, this.commentSnapshot, this.eventSnapshot}):super(key:key);
  @override
  _CommentCardState createState() => new _CommentCardState();
}

class _CommentCardState extends State<CommentCard>{
  String username;
  String propic;
  String comment;
  bool init = true;
  bool isOwnerOfComment = false;
  String commentID;

  void getData(BuildContext context) async {
    String uid = await Provider.of(context).auth.getCurrentUID();
    Firestore.instance.collection("UserData").document(widget.commentSnapshot['commentedByUID']).collection("info")
        .getDocuments()
        .then((query) {
      query.documents.forEach((f) {
        setState(() {
          commentID = widget.commentSnapshot.documentID;
          username = f['username'];
          propic = f['propic'];
          if(widget.commentSnapshot['commentedByUID'] == uid){
            isOwnerOfComment=true;
          }else{
            isOwnerOfComment=false;
          }
        });
      });
    });
  }

  void deleteComment(BuildContext context) async{
    Firestore.instance.collection("Events").document(widget.eventID).collection("comments").document(commentID).delete();
    print(commentID + " deleted");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CommentPage(eventID: widget.eventID, snapshot: widget.eventSnapshot,)));
  }

  @override
  Widget build(BuildContext context) {
    if(init){
      getData(context);
      init = false;
    }
    comment = widget.commentSnapshot['comment'];
    // TODO: implement build
    return InkWell(
            child: Container(
                color: Colors.white,
                child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Container(
                            height: 50,
                            width: 50,
                            child: FutureBuilder(
                                future: _getImage(context, propic),
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
                        title:Text(username==null?"":username,style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(width:MediaQuery.of(context).size.width/1.6 +5,child:Column(
                              children: <Widget>[
                              AutoSizeText(
                                (comment==null?"":comment),
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.left,
                                maxLines: 1000,
                              ),
                              Text(widget.commentSnapshot['postDate'], textAlign: TextAlign.left,),
                            ],)
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: isOwnerOfComment==true?IconButton(icon: Icon(Icons.delete, color: Colors.redAccent,), onPressed: (){deleteComment(context);},):Container(),
                            )
                          ],
                        )
                      )
                    ]
                )
            )
    );
  }
}

class AddCommentCard extends StatefulWidget{
  String eventID;
  DocumentSnapshot snapshot;
  AddCommentCard({Key key, @required this.eventID, this.snapshot}):super(key:key);
  @override
  _AddCommentCardState createState()=> new _AddCommentCardState();
}

class _AddCommentCardState extends State<AddCommentCard>{

  bool isButtonDisabled = true;
  TextEditingController commentController = new TextEditingController();
  String propic;
  bool init = true;
  void getData(BuildContext context) async {
    String uid = await Provider.of(context).auth.getCurrentUID();
    Firestore.instance.collection("UserData").document(uid).collection("info")
        .getDocuments()
        .then((query) {
      query.documents.forEach((f) {
        setState(() {
          propic = f['propic'];
        });
      });
    });
  }
  void seeChanges(String string){
    if(string.isNotEmpty){
      setState(() {
        isButtonDisabled=false;
      });
    }else {
      setState(() {
        isButtonDisabled = true;
      });
    }
  }
  void addComment(BuildContext context) async{
    var now = new DateTime.now().toString();
    print("now is" + now);
    String uid = await Provider.of(context).auth.getCurrentUID();
      Firestore.instance.collection("Events").document(widget.eventID)
          .collection("comments").add({
        "commentedByUID": uid,
        "comment": commentController.text,
        "postDate": now
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CommentPage(eventID: widget.eventID,snapshot: widget.snapshot,)));
  }
  @override
  Widget build(BuildContext context) {
    if(init){
      getData(context);
      init = false;
    }

    // TODO: implement build
    return InkWell(
            child: Container(
                color: Colors.white,
                child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Container(
                            height: 50,
                            width: 50,
                            child: FutureBuilder(
                                future: _getImage(context, propic),
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
                        subtitle: Row(children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/1.8 +22,
                            child:
                          TextFormField(
                            onChanged: seeChanges,
                            controller: commentController,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Add a comment...',
                            ),
                          )),
                          isButtonDisabled?Text("Comment", style: TextStyle(color:Colors.black12)):FlatButton(child:Text("Comment", style: TextStyle(color:Colors.tealAccent),), onPressed: (){addComment(context);},),
                        ],),
                      )
                    ]
                )
            )
    );
  }
}
