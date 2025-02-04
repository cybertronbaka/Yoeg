
import 'package:flutter/cupertino.dart';

import 'AuthService.dart';

class Provider extends InheritedWidget{
  final AuthService auth;
  Provider({Key key, Widget child, this.auth,}):super(key:key, child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget){
    return true;
  }

  static Provider of(BuildContext context)=>(context.inheritFromWidgetOfExactType(Provider) as Provider);
}