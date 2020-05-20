import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  double _width, _height, _margin_top;
  ImageProvider image;

  CircularImage(ImageProvider image, {double width = 40, double height = 40, double margin_top = 40}) {
    this.image = image;
    _width = width;
    _height = height;
    _margin_top = margin_top;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      margin: EdgeInsets.only(top: _margin_top),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: image,
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter
          )
      ),
    );
  }
}