import "package:flutter/material.dart";
import 'package:yoega/common/AuthService.dart';
import 'package:yoega/common/provider.dart';
import 'package:yoega/models/user_info.dart';
import 'package:yoega/pages/login.dart';
import 'package:yoega/utilities/CircularImage.dart';
import 'package:yoega/widgets/StretchedLabel.dart';
import "package:yoega/widgets/TextFieldWidget.dart";
import 'package:yoega/widgets/StretchedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthFormType{signIn, signUp}


class SignupPage extends StatefulWidget{
  final AuthFormType authFormType;
  SignupPage({Key key, @required this.authFormType}):super(key: key);
  @override
  _SignupPageState createState()=> new _SignupPageState();
}
class _SignupPageState extends State<SignupPage>{
  String _error;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthFormType authFormType;
  _SignupPageState({this.authFormType});
  TextEditingController nameController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController cfmController = new TextEditingController();
  TextEditingController genderController = new TextEditingController();

  String  _name, _username, _email, _phone, _password, _cfmPass,_gender;
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Stack(
        children: <Widget>[
          showAlert(),
          Center(
              child: CircularImage(AssetImage('./assets/logo.png'), width: 100)
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 145),
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
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Container(
                        color: Color(0xfdfdfdff),
                        child: TextFieldWidget(
                          "Name",
                          TextInputType.text,
                          Icon(Icons.person),
                          validator: (input){
                            if(input.length<=0){
                              return "Please enter a name";
                            }else if(input.length>256){
                              return "Name cannot be more than 255 characters";
                            }

                            return null;
                          },
                          controller:nameController,
                          onSaved: (input)=>_name=input,
                        ),
                      ),
                    ),


                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Container(
                        color: Color(0xfdfdfdff),
                        child: TextFieldWidget(
                          "Username",
                          TextInputType.text,
                          Icon(Icons.person_outline),
                          validator: (input){
                            if(input.length<=0){
                              return "Please enter a text";
                            }
                            //validate

                            return null;
                          },
                          controller:usernameController,
                          onSaved: (input)=>_username=input,
                        ),
                      ),
                    ),

              Container(
                color: Colors.white,
                child: DropdownButton<String>(
                      hint: Text("Gender"),
                      value: _gender,
                      onChanged: (String newValue) {
                        setState(() {
                          _gender = newValue;
                        });
                      },
                      items: <String>['Male', 'Female', 'Others']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )),
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
                          controller:emailController,
                        ),
                      ),
                    ),


                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: Container(
                        color: Color(0xfdfdfdff),
                        child: TextFieldWidget(
                          "Phone Number",
                          TextInputType.number,
                          Icon(Icons.phone),
                          validator: (input){
                            if(input.length<=0){
                              return "Please enter a number";
                            }

                            return null;
                          },
                          controller:phoneController,
                          onSaved: (input)=>_phone=input,
                        ),
                      ),
                    ),


              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                child:Container(
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
                          if(input.length < 8){
                            return "Password should have atleast 8 characters";
                          }
                          return null;
                        },
                        onSaved: (input)=>_password=input,
                        controller:passwordController,

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
                          if(input != passwordController.text){
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        onSaved: (input)=>_cfmPass=input,
                        controller:cfmController,

                      ),
                    ),

                   Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: StretchedButton(label:"Sign up", minWidth: 300, textColor: Colors.teal,color: Colors.white, onPressed:()=>signup(auth),)
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                          child: StretchedLabel(label: "Already have an account? Login.",color: Colors.tealAccent,onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));},)
                      ),
                    )
                  ],
                ),
            )
            ),
          )
        ],
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

Future signup(AuthService auth) async{
    UsersInfo usersInfo = new UsersInfo(usernameController.text, nameController.text, emailController.text, phoneController.text, _gender);
  final db = Firestore.instance.collection("UserData");
  final formState = _formKey.currentState;
  formState.save();
  if(formState.validate()){
    try{
      String uid = await auth.createUserWithEmailAndPassword(_email, _password, _name);
     var ref = db.document(uid);
     ref.setData({"here":true});
     ref.collection("info").document("info").setData(usersInfo.toJson());
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeController(uid: uid)));
    }catch(e){
      print("Error"+e);
      setState(() {
        _error = e.message;
      });
    }
  }
}
}