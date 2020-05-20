import 'package:flutter/material.dart';
import 'package:yoega/common/AuthService.dart';
import 'package:yoega/pages/login.dart';
import 'package:yoega/pages/splashscreen.dart';

import 'common/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        auth: AuthService(),
        child: MaterialApp(
          title: 'YOEGA',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Nunito',
            primarySwatch: Colors.cyan,
          ),
          home: HomeController(),
      )
    );
  }
}
