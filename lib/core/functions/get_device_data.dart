

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youth_power/core/constants/enums.dart';
import 'package:youth_power/core/functions/global_variable.dart';

DeviceType getDeviceType(MediaQueryData mediaQueryData) {
  Orientation orientation = mediaQueryData.orientation;
  double width = 0;
  if(!kIsWeb){
    if (orientation == Orientation.landscape) {
      width = mediaQueryData.size.height;
    }
    else {
      width = mediaQueryData.size.width;
    }
  }
  else {
    width = mediaQueryData.size.width;
  }
  if (width >= 950) {
    return DeviceType.desktop;
  }
  if (width >= 600) {
    return DeviceType.tablet;
  }
  return DeviceType.mobile;
}