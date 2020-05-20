import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  final double iconSize, boxSize, fontSize;
  final Color fontColor;
  const MenuItem({Key key, this.icon, this.title, this.onTap, this.iconSize, this.boxSize, this.fontSize,this.fontColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        leading: Icon(
                icon,
                color: Colors.teal,
                size: iconSize,
              ),
         title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: fontSize, color: fontColor),
              )
      );
    }
  }