import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoega/common/AuthService.dart';
import 'package:yoega/common/provider.dart';
import 'package:yoega/pages/forgot_password.dart';
import 'package:yoega/pages/home.dart';
import 'package:yoega/pages/signup.dart';
import 'package:yoega/utilities/CircularImage.dart';
import 'package:yoega/widgets/StretchedButton.dart';
import 'package:yoega/widgets/StretchedLabel.dart';
import 'package:yoega/widgets/TextFieldWidget.dart';

// ignore: must_be_immutable
class HomeController extends StatelessWidget{
  String uid;
  HomeController({Key key, this.uid}):super(key:key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          final bool signedIn = snapshot.hasData;
          return signedIn ? HomePage(uid: uid): LoginPage();
        }
        return CircularProgressIndicator();
      },
    );
  }
}




class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState()=> new _LoginPageState();
}


class _LoginPageState extends State<LoginPage>{
  String _email, _password, _error;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    // TODO: implement build
    return  Scaffold(
      appBar: AppBar(
        //Title should the users Name
        backgroundColor: Colors.teal,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.teal,
      body: Stack(
        children: <Widget>[
          showAlert(),
           Center(
              child: CircularImage(AssetImage('./assets/logo.png'), width: 200)
           ),
          Container(
            height: MediaQuery.of(context).size.height/1.5,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 240),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.teal,
            ),
            child: Padding(
              padding: EdgeInsets.all(23),
              child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Container(
                      color: Color(0xfdfdfdff),
                      child: TextFieldWidget(
                        "Email",
                        TextInputType.emailAddress,
                        Icon(Icons.email),
                        validator: (input){
                          if(input.length<=0){
                            return "Please enter a text";
                          }
                          String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp = new RegExp(p);
                          if(!regExp.hasMatch(input)){
                            return "Please enter a Valid Email";
                          }
                          return null;
                        },
                        onSaved: (input)=>_email=input,
                      ),
                    ),
                  ),
                  Container(
                    color: Color(0xfdfdfdff),
                    child: TextFieldWidget(
                        "Password"
                        ,TextInputType.visiblePassword,
                        Icon(Icons.lock_outline),
                        obscure: true,
                        validator: (input){
                          if(input.length==0){
                            return "Please enter your Password";
                          }
                          return null;
                        },
                      onSaved: (input)=>_password=input,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: StretchedButton(label:"Log in", minWidth: 300, textColor: Colors.teal,color: Colors.white, onPressed: (){login(auth);},)
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                        child: StretchedLabel(label: "Forgot your password?",color: Colors.white,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPasswordPage()));
                          },
                        )
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Center(
                        child: StretchedLabel(label: "Don't have an Account? Create one.",color: Colors.white,
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupPage(authFormType: AuthFormType.signUp,)));
                          },)
                    ),
                  ),
                ],
              ),
            ),
          )
        )],
      ),
    );
  }

  Widget showAlert(){
    if(_error != null){
      return Container(
        child:Row(children: <Widget>[
        SizedBox(height:8.0),
        Container(
          color: Colors.amberAccent,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
            Icon(Icons.error_outline),
            Expanded(child: Text(_error,maxLines: 3,),),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: (){
                  setState(() {
                    _error = null;
                  });
                },
              )
            )
          ],
        ),
      ),
        SizedBox(height: 8.0,),
      ],)
      );
    }
    return SizedBox(height: 16,);
  }

  Future login(AuthService auth) async{
    final formState = _formKey.currentState;
    if(formState.validate()){
      try{
        formState.save();
        String uid = await auth.signInWithEmailAndPassWord(_email, _password);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      }catch(e){
        setState(() {
          _error = e.message;
        });
      }
    }
  }
}
