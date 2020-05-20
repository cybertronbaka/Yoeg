
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoega/common/AuthService.dart';
import 'package:yoega/common/provider.dart';
import 'package:yoega/pages/login.dart';
import 'package:yoega/widgets/StretchedButton.dart';
import 'package:yoega/widgets/TextFieldWidget.dart';

class ForgotPasswordPage extends StatefulWidget{
  @override
  _ForgotPasswordPageState createState()=> new _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>{
 String _email, _warning;
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.teal,
        body: Container(
      color: Colors.teal,
      child: Padding(
        padding: EdgeInsets.all(0),
        child:Form(
        key: _formkey,
        child: ListView(
          children: <Widget>[
            showAlert(),
            Center(child:Text("Reset Password", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))),
            Padding(
              padding: EdgeInsets.all(23),
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

            Padding(
                padding: EdgeInsets.all(25),
                child: StretchedButton(label:"Submit", minWidth: 300, textColor: Colors.teal,color: Colors.white, onPressed: (){submit();},)
            )
          ],
        )
      ),),
    ));
  }

 Widget showAlert(){
   if(_warning != null){
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
                 Expanded(child: Text(_warning,maxLines: 3,),),
                 Padding(
                     padding: const EdgeInsets.only(left:8.0),
                     child: IconButton(
                       icon: Icon(Icons.close),
                       onPressed: (){
                         setState(() {
                           _warning = null;
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
 Future submit() async{
    AuthService auth = Provider.of(context).auth;
   final formState = _formkey.currentState;
   if(formState.validate()){
     try{
       formState.save();
       String uid = await auth.sendPasswordResetEmail(_email);
       setState(() {
         _warning = "Password reset link has been sent to $_email";
       });
     }catch(e){
       setState(() {
         _warning = e.message;
       });
     }
   }
 }

}