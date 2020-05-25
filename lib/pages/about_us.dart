import 'package:flutter/material.dart';

//import 'package:yoega/bloc/navigation_bloc/navigation_bloc.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //Title should the users Name
          backgroundColor: Colors.teal,
          title: Text("About Us", style: TextStyle(color: Colors.white),),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height/2 - 40,
                  child:Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('./assets/aboutus.png'),
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.topCenter
                        )
                    ),
                  )

              ),
              SizedBox(height: 40,),
              Center(child:Text("Yoega", textAlign: TextAlign.left, style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold,fontSize:40),)),
              SizedBox(height: 30,),
              Padding(padding: EdgeInsets.fromLTRB(30, 0, 30, 0),child:Text("Yoega is an Event Organizing app. With this App, one can post and maanage real world events that they organize. Users can participate in these events too.",textAlign: TextAlign.left, style: TextStyle(color: Colors.black87,fontSize: 17,))),
              SizedBox(height: 30,),
              Center(child:Text("The Team", style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold,fontSize:40))),
              SizedBox(height: 40,),
              Row(children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height/4 +10,
                    width: MediaQuery.of(context).size.width/3,
                    child: Card(
                      color: Colors.teal,
                      margin: EdgeInsets.all(4.0),
                      child: Column(
                          children: <Widget>[
                            SizedBox(height: 30,),
                            Container(
                              height:100,
                              width: 100,
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.0,
                                    color: Colors.teal,
                                  ),
                                  shape: BoxShape.circle,
                                  image:  new DecorationImage(
                                    fit: BoxFit.fill,
                                    image:AssetImage('assets/chimi.jpg'),
                                  )
                              ),
                            ),
                            SizedBox(height: 10,),
                        Text("Chimmi Yangden", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:13))
                  ]
                  )
                )
                ),
                Container(
                    height: MediaQuery.of(context).size.height/4 +10,
                    width: MediaQuery.of(context).size.width/3,
                    child: Card(
                        color: Colors.teal,
                        margin: EdgeInsets.all(4.0),
                        child: Column(
                            children: <Widget>[
                              SizedBox(height: 30,),
                              Container(
                                height:100,
                                width: 100,
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.0,
                                      color: Colors.teal,
                                    ),
                                    shape: BoxShape.circle,
                                    image:  new DecorationImage(
                                      fit: BoxFit.fill,
                                      image:AssetImage('assets/dorji.png'),
                                    )
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text("Dorji Gyeltshen", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:13))
                            ]
                        )
                    )
                ),
                Container(
                    height: MediaQuery.of(context).size.height/4 +10,
                    width: MediaQuery.of(context).size.width/3,
                    child: Card(
                        color: Colors.teal,
                        margin: EdgeInsets.all(4.0),
                        child: Column(
                            children: <Widget>[
                              SizedBox(height: 30,),
                              Container(
                                height:100,
                                width: 100,
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1.0,
                                      color: Colors.teal,
                                    ),
                                    shape: BoxShape.circle,
                                    image:  new DecorationImage(
                                      fit: BoxFit.fill,
                                      image:AssetImage('assets/lekpa.jpg'),
                                    )
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text("Lekpa Tenzin", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:13))
                            ]
                        )
                    )
                ),
              ],),

             Row(children: <Widget>[
               Container(
                   height: MediaQuery.of(context).size.height/4 +10,
                   width: MediaQuery.of(context).size.width/3,
                   child: Card(
                       color: Colors.teal,
                       margin: EdgeInsets.all(4.0),
                       child: Column(
                           children: <Widget>[
                             SizedBox(height: 30,),
                             Container(
                               height:100,
                               width: 100,
                               margin: EdgeInsets.only(top: 20),
                               decoration: BoxDecoration(
                                   border: Border.all(
                                     width: 1.0,
                                     color: Colors.teal,
                                   ),
                                   shape: BoxShape.circle,
                                   image:  new DecorationImage(
                                     fit: BoxFit.fill,
                                     image:AssetImage('assets/sonam.jpg'),
                                   )
                               ),
                             ),
                             SizedBox(height: 10,),
                             Center(child:Text("Sonam Chimi Dolkar",softWrap: true,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:13)))
                           ]
                       )
                   )
               ),
               Container(
                   height: MediaQuery.of(context).size.height/4 +10,
                   width: MediaQuery.of(context).size.width/3,
                   child: Card(
                       color: Colors.teal,
                       margin: EdgeInsets.all(4.0),
                       child: Column(
                           children: <Widget>[
                             SizedBox(height: 30,),
                             Container(
                               height:100,
                               width: 100,
                               margin: EdgeInsets.only(top: 20),
                               decoration: BoxDecoration(
                                   border: Border.all(
                                     width: 1.0,
                                     color: Colors.teal,
                                   ),
                                   shape: BoxShape.circle,
                                   image:  new DecorationImage(
                                     fit: BoxFit.fill,
                                     image:AssetImage('assets/lhazom.jpg'),
                                   )
                               ),
                             ),
                             SizedBox(height: 10,),
                             Text("Tshering Lhazom", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:13))
                           ]
                       )
                   )
               ),
               Container(
                   height: MediaQuery.of(context).size.height/4 +10,
                   width: MediaQuery.of(context).size.width/3,
                   child: Card(
                       color: Colors.teal,
                       margin: EdgeInsets.all(4.0),
                       child: Column(
                           children: <Widget>[
                             SizedBox(height: 30,),
                             Container(
                               height:100,
                               width: 100,
                               margin: EdgeInsets.only(top: 20),
                               decoration: BoxDecoration(
                                   border: Border.all(
                                     width: 1.0,
                                     color: Colors.teal,
                                   ),
                                   shape: BoxShape.circle,
                                   image:  new DecorationImage(
                                     fit: BoxFit.fill,
                                     image:AssetImage('assets/yangku.jpg'),
                                   )
                               ),
                             ),
                             SizedBox(height: 10,),
                             Text("Yangku Dorji", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:13))
                           ]
                       )
                   )
               ),
            ],
          ),
              SizedBox(height: 100,),
        ])
    ));
  }
}

