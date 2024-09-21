
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:youth_power/core/constants/app_colors.dart';

Future<Future<bool?>> MyToast({
  required String msg,
  required state,
}) async {
  return Fluttertoast.showToast(
    msg: msg.tr(),
    textColor: AppColors.black,
    fontSize: 16,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 5,
    webBgColor: 'linear-gradient(to right, #FFFFFF, #FFFFFF)',
    webShowClose: true,
    backgroundColor: chooseToastColor(state)
);
}

enum ToastStates{SUCCESS,WARNING, FAILED}

Color chooseToastColor(ToastStates state){
  Color color;
  switch(state){
    case ToastStates.SUCCESS :
      color = AppColors.green;
      break;
    case ToastStates.WARNING:
      color = AppColors.amber;
      break;
    case ToastStates.FAILED:
      color = AppColors.red;
      break;
  }
  return color;
}