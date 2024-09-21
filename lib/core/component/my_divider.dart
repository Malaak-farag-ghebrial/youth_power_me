
import 'package:flutter/material.dart';
import 'package:youth_power/core/constants/app_colors.dart';

class MyDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final Color color;
  final bool vAxis;

  const MyDivider({super.key, this.height = 1, this.thickness = 1,this.color = AppColors.black12,this.vAxis = false});

  @override
  Widget build(BuildContext context) {
    return vAxis ?  VerticalDivider(
      width: height,
      color: color,
      thickness: thickness,
    ) : Divider(
      height: height,
      thickness: thickness,
      color: color,
    );
  }
}
