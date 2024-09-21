

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:youth_power/core/functions/global_variable.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void getToken()async{
    String? token = await FirebaseMessaging.instance.getToken();
    GlobalFunction.print('token : $token');
  }


  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: ListView.builder(
          itemCount: 100,
          itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            child: Center(
              child: Text('Hello! I am a Flutter developer from Egypt. ya ya Egypt is a great country it has Pyramids temples and so much much thing you may like $index'),
            ),
          ),
        );
      }),
    );
  }
}
