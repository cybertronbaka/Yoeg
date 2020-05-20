import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldWidget extends StatelessWidget{
  @override
  String text,fontFam;
  TextInputType keyboardType;
  bool obs; Color fontColor;
  Widget ic; double fSize;
  Function(String) validator;
  Function onSaved, onChanged;
  TextEditingController controller;
  TextFieldWidget(String label,TextInputType inputType, Widget icon,
      {bool obscure=false, Color textColor = Colors.black, String fontFamily = "SFUIDisplay", double fontSize = 15,this.validator,this.onSaved, this.onChanged,this.controller}){
    text = label; keyboardType = inputType;
    obs = obscure; fontColor = textColor;
    fontFam = fontFamily; ic = icon;
    fSize = fontSize;
  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obs,
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
      style: TextStyle(
          color: fontColor,
          fontFamily: fontFam
      ),
      decoration: InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(10.0),
          ),
        ),
        labelText: text,
        prefixIcon: ic,
        labelStyle: TextStyle(
            fontSize: fSize,
        ),
      ),
    );
  }

}
// ignore: must_be_immutable
class TextFieldLabel extends StatelessWidget{
  String label; Color color;
  TextFieldLabel(this.label,{this.color});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.only(
            left: 25.0, right: 25.0, top: 25.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  label,
                  style: TextStyle(
                      color: color,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ));
  }
}

// ignore: must_be_immutable
class TextFieldForm extends StatelessWidget{
  bool _status;
  final FocusNode myFocusNode;
  String hintText;
  bool expands;
  int maxLines, minLines;
  TextEditingController controller;
  TextInputType keyboardType;
  TextFieldForm(this.hintText,this._status, this.myFocusNode,{bool expands:false, TextInputType keyboardType:TextInputType.text,int maxLines: 1, int minLines:1, this.controller}){
    this.expands = expands;
    this.keyboardType = keyboardType;
    this.maxLines = maxLines; this.minLines = minLines;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.only(
            left: 25.0, right: 25.0, top: 2.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: controller,
                expands:expands,
                keyboardType: keyboardType,
                minLines: minLines,
                maxLines: maxLines,
                decoration:  InputDecoration(
                  hintText: hintText,
                ),
                enabled: !_status,
                autofocus: !_status,
              ),
            ),
          ],
        ));
  }

}
// ignore: must_be_immutable
class TextFieldFormNonEdit extends StatelessWidget {
  String hintText;
  bool obs;
  TextFieldFormNonEdit(this.hintText,{this.obs}){obs = false;}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
        padding: EdgeInsets.only(
            left: 25.0, right: 25.0, top: 2.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Flexible(
              child: new TextField(
                obscureText: obs,
                decoration: InputDecoration(
                  hintText: hintText,
                ),
              ),
            ),
          ],
        ));
  }
}
