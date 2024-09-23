


import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

String? fcmToken;
String? apiId;
Database? database ;
Size size(context) => MediaQuery.of(context).size;
TextTheme style(context) => Theme.of(context).textTheme;

class GlobalFunction{

  static errorPrint(error,String msg){
    debugPrint('\x1B[33m${msg.toUpperCase()} ${error.toString()}\x1B[0m');
  }

  static print(String msg, {String name = ''}){
    debugPrint('\x1B[33m$msg -- ${name.toUpperCase()}\x1B[0m');
  }



}