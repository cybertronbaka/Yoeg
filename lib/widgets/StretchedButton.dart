import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StretchedButton extends StatelessWidget{
  @override
  String label, fontFamily;  FontWeight fontWeight; Color color, textColor;
  double elevation, minWidth, height, fontSize, borderRadius;
  Function onPressed;
  StretchedButton(
      {String label = "", double fontSize=15, String fontFamily = "SFUIDisplay", FontWeight fontWeight = FontWeight.bold,
        Color color = Colors.blueAccent, double elevation = 0, double minWidth = 400, double height = 50, Color textColor = Colors.white, double borderRadius = 10,
      this.onPressed}){
    this.label = label; this.fontSize = fontSize; this.fontFamily = fontFamily; this.fontWeight = fontWeight;
    this.color = color; this.elevation = elevation; this.minWidth = minWidth; this.height = height;
    this.textColor = textColor; this.borderRadius = borderRadius;

  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialButton(
      onPressed: onPressed,//since this is only a UI app
      child: Text(label,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
        ),
      ),
      color: color,
      elevation: elevation,
      minWidth: minWidth,
      height: height,
      textColor: textColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)
      ),
    );
  }
}