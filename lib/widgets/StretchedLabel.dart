import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StretchedLabel extends StatelessWidget{
  @override
  String label, fontFamily; double fontSize; Color color; Function onPressed;
  StretchedLabel({String label = "", String fontFamily = 'SFUIDisplay', double fontSize = 15, Color color = Colors.black, this.onPressed})
  {
    this.label = label; this.fontFamily = fontFamily; this.fontSize = fontSize; this.color = color;
  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      child: Text(
        label,
        style: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            color: color
        ),
      ),
      onPressed: onPressed, //put here
    );
  }
}