
import 'package:flutter/foundation.dart';

class MyUser{
  MyUser({@required this.name, @required this.email});
  String name;
  String email;

  Map<String,String> toMap(){
    return {
      'Name':name,
      'Email':email
    };
  }

}