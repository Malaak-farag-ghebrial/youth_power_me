
import 'package:flutter/material.dart';
import 'package:youth_power/core/constants/enums.dart';

class DeviceInfo {
  final Orientation? orientation;
  final DeviceType deviceType;
  final double? screenWidth;
  final double? screenHeight;
  final double? localWidth;
  final double? localHeight;

  DeviceInfo({
    this.orientation,
    this.deviceType = DeviceType.mobile,
    this.screenWidth,
    this.screenHeight,
    this.localWidth,
    this.localHeight,
  });
}