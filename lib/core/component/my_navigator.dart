import 'package:flutter/material.dart';


navigateTo(
  BuildContext context,
  Widget route,
) =>
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => route),
    );

navigatorBackless(
  BuildContext context,
  Widget route,
) =>
    Navigator.pushAndRemoveUntil(
        context, PageRouteBuilder(
        transitionsBuilder: (context,animation,animation2,child){
          return FadeTransition(opacity: animation,child: child,);
        },
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context,animation,animation2){
          return route;
        }), (route) => false);

navigateReplace(
    BuildContext context,
    Widget route,
    )=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => route));

pop(BuildContext context) => Navigator.pop(context);


